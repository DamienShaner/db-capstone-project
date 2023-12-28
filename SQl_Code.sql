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