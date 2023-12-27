-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: littlelemon_db
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `BookingID` int NOT NULL,
  `CustomerID` int NOT NULL,
  `Date` date DEFAULT NULL,
  `TableNumber` int DEFAULT NULL,
  `PartySize` int DEFAULT NULL,
  PRIMARY KEY (`BookingID`,`CustomerID`),
  KEY `CustomerID_fk_idx` (`CustomerID`),
  CONSTRAINT `CustomerID_fk` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (2001,1006,'2023-10-25',1,4),(2002,1009,'2023-10-25',2,1),(2003,1001,'2023-10-25',3,1),(2004,1003,'2023-10-25',4,4),(2005,1007,'2023-10-25',5,1),(2006,1010,'2023-10-25',6,2),(2007,1008,'2023-10-26',1,4),(2008,1002,'2023-10-26',2,1),(2009,1004,'2023-10-26',3,2),(2010,1005,'2023-10-26',4,4),(2011,1006,'2023-10-26',5,1),(2012,1001,'2023-10-26',6,3),(2013,1009,'2023-10-27',1,2),(2014,1008,'2023-10-27',2,4),(2015,1005,'2023-10-27',3,1),(2016,1003,'2023-10-27',4,2),(2017,1001,'2023-10-27',5,4),(2018,1007,'2023-10-27',6,3);
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `CustomerID` int NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `Phone` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`CustomerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1001,'John McDouglas','john.mcdouglas@gmail.com','+44-20-7499-6996'),(1002,'Sam Davis','sam_davis@gmail.com','+1-202-997-2356'),(1003,'Nathan Jones','nathan.jones@gmail.com','+1-804-872-9265'),(1004,'Micheal Adams','micheal.adams@gmail.com','+1-202-783-0923'),(1005,'Anthony Rodriguez','anthony_rodriguez@gmail.com','+34-911-23-33-13'),(1006,'Tim Wilson','tim_wilson@gmail.com','+33-1-42-60-08-83'),(1007,'Joe Brown','joe.brown@gmail.com','+1-202-546-2813'),(1008,'Thomas Williams','thomas.williams@gmail.com','+1-212-708-9400'),(1009,'Bill Smith','bill.smith@gmail.com','+1-202-546-9921'),(1010,'Lucas Anderson','lucas.anderson@gmail.com','+1-202-432-9134');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `ItemID` int NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Type` varchar(45) DEFAULT NULL,
  `Price` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`ItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (4001,'Pinot Noir 75cl','Drink',25.00),(4002,'Heineken 50cl','Drink',5.50),(4003,'Albariño 75cl','Drink',20.75),(4004,'Prawn Cocktail','Starter',17.50),(4005,'Escargot','Starter',14.99),(4006,'Carpaccio','Starter',15.50),(4007,'Steak and Kidney Pie','Main',25.00),(4008,'Coq au Vin','Main',28.00),(4009,'Boeuf Bourguignon','Main',27.00),(4010,'Sticky Toffee Pudding','Dessert',6.50),(4011,'Bread and Butter Pudding','Dessert',6.50),(4012,'Lemon-Ricotta Soufflé','Dessert',6.50);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderlines`
--

DROP TABLE IF EXISTS `orderlines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderlines` (
  `LineID` int NOT NULL,
  `OrderID` int NOT NULL,
  `ItemID` int NOT NULL,
  `Quantity` int DEFAULT NULL,
  `SubTotal` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`LineID`,`OrderID`),
  KEY `ItemID_fk_idx` (`ItemID`),
  KEY `OrderID_fk_idx` (`OrderID`),
  CONSTRAINT `ItemID_fk` FOREIGN KEY (`ItemID`) REFERENCES `items` (`ItemID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `OrderID_fk` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderlines`
--

LOCK TABLES `orderlines` WRITE;
/*!40000 ALTER TABLE `orderlines` DISABLE KEYS */;
INSERT INTO `orderlines` VALUES (7001,6001,4001,2,50.00),(7002,6001,4004,2,35.00),(7003,6001,4006,2,31.00),(7004,6001,4008,3,84.00),(7005,6001,4009,1,27.00),(7006,6001,4010,2,13.00),(7007,6001,4012,2,13.00),(7008,6002,4002,3,16.50),(7009,6002,4007,1,25.00),(7010,6002,4010,1,6.50),(7011,6003,4003,1,20.75),(7012,6003,4005,1,14.99),(7013,6003,4008,1,28.00),(7014,6003,4012,1,6.50),(7015,6004,4001,4,100.00),(7016,6004,4004,4,70.00),(7017,6004,4005,4,59.96),(7018,6004,4008,2,56.00),(7019,6004,4009,2,54.00),(7020,6004,4011,4,26.00),(7021,6005,4003,1,20.75),(7022,6005,4006,1,15.50),(7023,6005,4008,1,28.00),(7024,6005,4011,1,6.50),(7025,6006,4001,1,25.00),(7026,6006,4004,1,17.50),(7027,6006,4008,1,28.00),(7028,6006,4009,1,27.00),(7029,6006,4010,1,6.50),(7030,6007,4002,12,66.00),(7031,6007,4007,3,75.00),(7032,6007,4008,1,28.00),(7033,6007,4010,4,26.00),(7034,6008,4002,2,11.00),(7035,6008,4009,1,27.00),(7036,6009,4003,1,20.75),(7037,6009,4004,1,17.50),(7038,6009,4005,1,14.99),(7039,6009,4007,1,25.00),(7040,6009,4008,1,28.00),(7041,6009,4010,1,6.50),(7042,6010,4001,3,75.00),(7043,6010,4005,2,29.98),(7044,6010,4009,4,108.00),(7045,6010,4011,2,13.00),(7046,6010,4012,2,13.00),(7047,6011,4003,1,20.75),(7048,6011,4004,1,17.50),(7049,6011,4008,1,28.00),(7050,6011,4012,1,6.50),(7051,6012,4001,2,50.00),(7052,6012,4004,1,17.50),(7053,6012,4005,1,14.99),(7054,6012,4006,1,15.50),(7055,6012,4007,1,25.00),(7056,6012,4008,1,28.00),(7057,6012,4009,1,27.00),(7058,6012,4010,1,6.50),(7059,6012,4011,1,6.50),(7060,6012,4012,1,6.50),(7061,6013,4003,1,20.75),(7062,6013,4005,1,14.99),(7063,6013,4008,1,28.00),(7064,6013,4009,1,27.00),(7065,6014,4001,1,25.00),(7066,6014,4008,4,112.00),(7067,6014,4010,4,26.00),(7068,6015,4002,1,5.50),(7069,6015,4005,1,14.99),(7070,6015,4009,1,27.00),(7071,6015,4010,1,6.50),(7072,6016,4003,1,20.75),(7073,6016,4004,1,17.50),(7074,6016,4006,1,15.50),(7075,6016,4008,1,28.00),(7076,6016,4009,1,27.00),(7077,6016,4011,2,13.00),(7078,6017,4003,2,41.50),(7079,6017,4006,4,62.00),(7080,6017,4008,4,112.00),(7081,6017,4012,4,26.00),(7082,6018,4002,3,16.50),(7083,6018,4003,2,41.50),(7084,6018,4004,1,17.50),(7085,6018,4005,1,14.99),(7086,6018,4006,1,15.50),(7087,6018,4008,3,84.00),(7088,6018,4010,1,6.50),(7089,6018,4011,1,6.50),(7090,6018,4012,1,6.50);
/*!40000 ALTER TABLE `orderlines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `OrderID` int NOT NULL,
  `BookingID` int NOT NULL,
  `StaffID` int NOT NULL,
  `StatusID` int NOT NULL,
  `Time` time DEFAULT NULL,
  `Total` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`OrderID`),
  KEY `StatusID_fk_idx` (`StatusID`),
  KEY `StaffID_fk_idx` (`StaffID`),
  KEY `BookingID_fk_idx` (`BookingID`),
  CONSTRAINT `BookingID_fk` FOREIGN KEY (`BookingID`) REFERENCES `bookings` (`BookingID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `StaffID_fk` FOREIGN KEY (`StaffID`) REFERENCES `waiters` (`StaffID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `StatusID_fk` FOREIGN KEY (`StatusID`) REFERENCES `statuses` (`StatusID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (6001,2001,3001,5005,'20:05:15',253.00),(6002,2002,3002,5005,'20:14:23',48.00),(6003,2003,3005,5005,'20:33:56',70.24),(6004,2004,3003,5005,'20:36:26',365.96),(6005,2005,3006,5005,'21:41:55',70.75),(6006,2006,3004,5005,'21:43:16',104.00),(6007,2007,3001,5005,'20:09:34',195.00),(6008,2008,3002,5005,'20:27:13',38.00),(6009,2009,3003,5005,'20:48:05',112.74),(6010,2010,3004,5005,'21:33:27',238.98),(6011,2011,3005,5005,'21:35:39',72.75),(6012,2012,3006,5005,'21:45:24',197.49),(6013,2013,3003,5004,'20:15:34',90.74),(6014,2014,3004,5004,'20:46:23',163.00),(6015,2015,3005,5003,'20:55:23',53.99),(6016,2016,3006,5003,'21:13:45',108.75),(6017,2017,3002,5002,'21:16:27',241.50),(6018,2018,3001,5001,'21:37:45',209.49);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statuses`
--

DROP TABLE IF EXISTS `statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `statuses` (
  `StatusID` int NOT NULL,
  `StatusName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`StatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statuses`
--

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
INSERT INTO `statuses` VALUES (5001,'Drinks Served'),(5002,'Starters Served'),(5003,'Mains Served'),(5004,'Desserts Served'),(5005,'Customer Paid');
/*!40000 ALTER TABLE `statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waiters`
--

DROP TABLE IF EXISTS `waiters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `waiters` (
  `StaffID` int NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Position` varchar(45) DEFAULT NULL,
  `Salary` decimal(5,0) DEFAULT NULL,
  PRIMARY KEY (`StaffID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waiters`
--

LOCK TABLES `waiters` WRITE;
/*!40000 ALTER TABLE `waiters` DISABLE KEYS */;
INSERT INTO `waiters` VALUES (3001,'John Beckham','Waiter',65000),(3002,'Lucas Colson','Junior Waiter',55000),(3003,'Liam Taylor','Head Waiter',70000),(3004,'Abbott','Waiter',60000),(3005,'Henry Miller','Junior Waiter',50000),(3006,'Oliver Banks','Waiter',60000);
/*!40000 ALTER TABLE `waiters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-26 16:32:16
