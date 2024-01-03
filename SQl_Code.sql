--create a virtual table called OrdersView that focuses on OrderID, Quantity and Cost columns within the Orders table for all orders with a quantity greater than 2.
DROP VIEW IF EXISTS ordersview;

CREATE VIEW ordersview AS
    SELECT 
        o.OrderID,
        i.Name,
        ol.Quantity,
        ol.SubTotal
    FROM
        orders o
    INNER JOIN 
        orderlines ol ON o.OrderID = ol.OrderID
    INNER JOIN 
        items i ON ol.ItemID = i.ItemID
    WHERE
        ol.Quantity > 2
    ORDER BY 
        ol.SubTotal DESC;


-- create a virtual table for all customers with orders that cost more than $150.
DROP VIEW IF EXISTS orders_more_than_150;

CREATE VIEW orders_more_than_150 AS
SELECT
    c.CustomerID,
    c.Name,
    o.OrderID,
    o.Total
FROM
    customers c
INNER JOIN
    bookings b ON c.CustomerID = b.CustomerID
INNER JOIN
    orders o ON b.BookingID = o.BookingID
WHERE
    o.Total > 150.00
ORDER BY
    c.CustomerID ASC;


/*
Little Lemon need to find all menu items for which more than 2 orders have been placed. 
Carry out this task by creating a subquery that lists the menu names from the menus table for any order quantity with more than 2.
*/
select 
	i.Name as "Menu Item", 
    sum(ol.Quantity) as "Number of Orders"
from 
	items i
inner join 
	orderlines ol on i.ItemID = ol.ItemID
where 
	i.ItemID = any (
		select ol.ItemID
		from orderlines ol
		where ol.Quantity > 2
)
group by 
    i.name
order by
    sum(ol.Quantity) desc;


-- create a procedure that displays the maximum ordered quantity in the Orders table
delimiter //

create procedure GetMaxQuantity()
begin
    declare max_quantity int;

    -- find the maximum ordered quantity
    select max(total_quantity) into max_quantity
    from (
        select OrderID, SUM(Quantity) as total_quantity
        from orderlines
        group by OrderID
    ) as order_totals;

    -- display the result
    select 'Maximum Ordered Quantity:' as Result, max_quantity as Quantity;
end //

delimiter ;


/*
create a prepared statement called GetOrderDetail. 
This prepared statement will help to reduce the parsing time of queries. 
It will also help to secure the database from SQL injections.
The prepared statement should accept one input argument, the CustomerID value, from a variable.
The statement should return the OrderID from the Orders table, the Quantity of all items from the orderlines table by OrderID, and the total cost from the Orders table. 
Once you create the prepared statement, you can create a variable called id and assign it a value of a customerid.

Then execute the GetOrderDetail prepared statement using the following syntax:
SET @id = 1001;
EXECUTE GetOrderDetail USING @id;
*/

PREPARE GetOrderDetail FROM '
    SELECT 
        o.OrderID, 
        SUM(ol.Quantity) AS TotalQuantity, 
        o.Total
    FROM 
        orders o
    JOIN 
        orderlines ol ON o.OrderID = ol.OrderID
    JOIN
        bookings b ON b.BookingID = o.BookingID
    JOIN
        customers c ON c.CustomerID = b.CustomerID
    WHERE 
        c.CustomerID = ?
    GROUP BY o.OrderID';

SET @id = 1001;

EXECUTE GetOrderDetail USING @id;


/*
Create a stored procedure called CancelOrder. This stored procedure can then be used to delete an order record based on the user input of the order id. 
Creating this procedure will allow Little Lemon to cancel any order by specifying the order id value in the procedure parameter without typing the entire SQL delete statement.   
*/
DELIMITER //

CREATE PROCEDURE CancelOrder(IN p_OrderID INT)
BEGIN
    DECLARE v_OrderCount INT;

    -- Check if the order exists
    SELECT COUNT(*) INTO v_OrderCount
    FROM orders
    WHERE OrderID = p_OrderID;

    -- If the order exists, delete it
    IF v_OrderCount > 0 THEN
        DELETE FROM orders WHERE OrderID = p_OrderID;
        SELECT 'Order canceled successfully.' AS Message;
    ELSE
        SELECT 'Order not found.' AS Message;
    END IF;
END //

DELIMITER ;

CALL CancelOrder(123); -- Replace 123 with the actual OrderID you want to cancel

-- Replace Order 6018:
INSERT INTO 
    orders 
VALUES
    (6018,2018,3001,5001,'21:37:45',209.49);


-- add bookings to the Little Lemon booking table
INSERT INTO 
    bookings
VALUES
    (2019,1001,'2022-10-10',5,4),
    (2020,1003,'2022-11-12',3,2),
    (2021,1002,'2022-10-11',2,2),
    (2022,1001,'2022-10-13',2,2);


/*
Little Lemon needs to create a stored procedure called CheckBooking to check whether a table in the 
restaurant is already booked. Creating this procedure helps to minimize the effort involved in 
repeatedly coding the same SQL statements.

The procedure should have two input parameters in the form of booking date and table number. 
You can also create a variable in the procedure to check the status of each table.
*/
DELIMITER //

CREATE PROCEDURE CheckBooking(IN p_BookingDate DATE, IN p_TableNumber INT)
BEGIN
    DECLARE v_TableStatus VARCHAR(50);

    -- Check if the table is booked on the given date
    SELECT
        CONCAT('Table ', p_TableNumber, ' is ', 
            CASE
                WHEN EXISTS (
                    SELECT 1
                    FROM bookings
                    WHERE TableNumber = p_TableNumber
                    AND Date = p_BookingDate
                ) THEN 'already booked'
                ELSE 'available'
            END
        ) INTO v_TableStatus;

    SELECT v_TableStatus AS TableStatus;
END //

DELIMITER ;

/*
This stored procedure takes two input parameters, p_BookingDate (date of the booking) 
and p_TableNumber (table number), and checks if the specified table is booked on 
the given date. The result is stored in the variable v_TableStatus, which is then 
returned as the output of the procedure.

You can call this stored procedure like this:
*/
CALL CheckBooking('2022-11-12', 3); -- Replace with the desired booking date and table number


/*
Little Lemon need to verify a booking, and decline any reservations for tables that are already booked under another name. 

Since integrity is not optional, Little Lemon need to ensure that every booking attempt includes these verification and decline steps. However, implementing these steps requires a stored procedure and a transaction. 

To implement these steps, you need to create a new procedure called AddValidBooking. This procedure must use a transaction statement to perform a rollback if a customer reserves a table that’s already booked under another name.  

Use the following guidelines to complete this task:

The procedure should include two input parameters in the form of booking date and table number.

It also requires at least one variable and should begin with a START TRANSACTION statement.

Your INSERT statement must add a new booking record using the input parameter's values.

Use an IF ELSE statement to check if a table is already booked on the given date. 
*/
-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS AddValidBooking;

-- Create the AddValidBooking procedure
DELIMITER //

CREATE PROCEDURE AddValidBooking(
    IN p_BookingDate DATE,
    IN p_TableNumber INT,
    IN p_CustomerID INT,
    IN p_PartySize INT
)
BEGIN
    DECLARE v_TableStatus VARCHAR(20);

    -- Start the transaction
    START TRANSACTION;

    -- Check if the table is booked on the given date
    SELECT
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM bookings
                WHERE TableNumber = p_TableNumber
                AND Date = p_BookingDate
            ) THEN 'Booked'
            ELSE 'Available'
        END INTO v_TableStatus;

    -- If the table is already booked, output the response and rollback the transaction
    IF v_TableStatus = 'Booked' THEN
        SELECT CONCAT('Table ', p_TableNumber, ' is already booked - booking cancelled') AS Response;
        ROLLBACK;
    ELSE
        -- If the table is available, insert the new booking record
        INSERT INTO bookings (Date, TableNumber, CustomerID, PartySize)
        VALUES (p_BookingDate, p_TableNumber, p_CustomerID, p_PartySize);

        -- Output the success response
        SELECT CONCAT('Table ', p_TableNumber, ' booked successfully') AS Response;

        -- Commit the transaction
        COMMIT;
    END IF;
END //

DELIMITER ;

/*
This stored procedure takes three input parameters: p_BookingDate (date of the booking), 
p_TableNumber (table number), and p_CustomerName (name of the customer making the reservation). 
It uses a transaction to ensure that the integrity of the data is maintained. 
If the specified table is already booked under another name on the given date, it rolls back 
the transaction and signals an error. Otherwise, it inserts the new booking record and commits 
the transaction.

You can call this stored procedure as follows:
*/

CALL AddValidBooking('2022-12-17', 6, 1011,4);


/*
Create a new procedure called AddBooking to add a new table booking record.

The procedure should include five input parameters in the form of the following bookings parameters:

booking id, customer id, booking date,table number, and party size.
*/
-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS AddBooking;

-- Create the AddBooking procedure
DELIMITER //

CREATE PROCEDURE AddBooking(
    IN p_BookingID INT,
    IN p_CustomerID INT,
    IN p_BookingDate DATE,
    IN p_TableNumber INT,
    IN p_PartySize INT
)
BEGIN
    -- Insert the new booking record
    INSERT INTO bookings (BookingID, CustomerID, Date, TableNumber, PartySize)
    VALUES (p_BookingID, p_CustomerID, p_BookingDate, p_TableNumber, p_PartySize);
    
    -- Output success message
    SELECT CONCAT('Booking ', p_BookingID, ' added successfully') AS Response;
END //

DELIMITER ;

CALL AddBooking(2023, 1005, '2022-12-30', 4, 4);

/*
Create a new procedure called UpdateBooking that they can use to update existing bookings in the 
booking table.
The procedure should have two input parameters in the form of booking id and booking date. 
You must also include an UPDATE statement inside the procedure. 
*/
-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS UpdateBooking;

-- Create the UpdateBooking procedure
DELIMITER //

CREATE PROCEDURE UpdateBooking(
    IN p_BookingID INT,
    IN p_BookingDate DATE
)
BEGIN
    -- Update the booking record based on the provided booking ID and date
    UPDATE bookings
    SET Date = p_BookingDate
    WHERE BookingID = p_BookingID;

    -- Check if any rows were affected
    IF ROW_COUNT() > 0 THEN
        SELECT CONCAT('Booking ', p_BookingID, ' updated successfully') AS Response;
    ELSE
        SELECT 'No booking found for the specified ID and date' AS Response;
    END IF;
END //

DELIMITER ;

-- Example usage
CALL UpdateBooking(2024, '2022-12-20');


/*
create a new procedure called CancelBooking that they can use to cancel or remove a booking.
The procedure should have one input parameter in the form of booking id. 
You must also write a DELETE statement inside the procedure. 
*/
-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS CancelBooking;

-- Create the CancelBooking procedure
DELIMITER //

CREATE PROCEDURE CancelBooking(
    IN p_BookingID INT
)
BEGIN
    -- Declare a variable to store the response message
    DECLARE v_Response VARCHAR(100);

    -- Start the transaction
    START TRANSACTION;

    -- Check if the booking exists
    IF EXISTS (
        SELECT 1
        FROM bookings
        WHERE BookingID = p_BookingID
    ) THEN
        -- Delete the booking record
        DELETE FROM bookings
        WHERE BookingID = p_BookingID;

        -- Set the response message
        SET v_Response = CONCAT('Booking ', p_BookingID, ' cancelled successfully');
        
        -- Commit the transaction
        COMMIT;
    ELSE
        -- Set the response message if no booking is found
        SET v_Response = CONCAT('No booking found for ID ', p_BookingID);
        
        -- Rollback the transaction
        ROLLBACK;
    END IF;

    -- Select the response message
    SELECT v_Response AS Response;
END //

DELIMITER ;

-- Example usage
CALL CancelBooking(2024);
