CREATE DATABASE  IF NOT EXISTS `procurement` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `procurement`;
-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: procurement
-- ------------------------------------------------------
-- Server version	8.0.22

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
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `dep_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `dep_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `emp_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `emp_fname` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `emp_lname` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `emp_phone` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `emp_email` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `dep_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`emp_id`),
  UNIQUE KEY `emp_id` (`emp_id`),
  KEY `FK_EmpDep` (`dep_id`),
  CONSTRAINT `FK_EmpDep` FOREIGN KEY (`dep_id`) REFERENCES `department` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goods` (
  `prod_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `g_price` decimal(12,2) NOT NULL,
  `g_unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`prod_id`),
  CONSTRAINT `FK_ProdGoods` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods`
--

LOCK TABLES `goods` WRITE;
/*!40000 ALTER TABLE `goods` DISABLE KEYS */;
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `prod_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `prod_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `prod_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `prod_description` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`prod_id`),
  UNIQUE KEY `prod_id` (`prod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_order`
--

DROP TABLE IF EXISTS `purchase_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order` (
  `po_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `po_date` date NOT NULL,
  `po_shipaddress` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `po_note` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `po_discount` decimal(5,2) DEFAULT NULL,
  `po_deldate` date NOT NULL,
  `po_shipcost` decimal(12,2) DEFAULT NULL,
  `po_tax` decimal(5,2) DEFAULT NULL,
  `emp_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `sup_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`po_id`),
  UNIQUE KEY `po_id` (`po_id`),
  KEY `FK_PoEmp` (`emp_id`),
  KEY `FK_PoSup` (`sup_id`),
  CONSTRAINT `FK_PoEmp` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_PoSup` FOREIGN KEY (`sup_id`) REFERENCES `supplier` (`sup_id`),
  CONSTRAINT `chk_po_discount` CHECK (((`po_discount` >= 0.00) and (`po_discount` <= 100.00))),
  CONSTRAINT `chk_po_tax` CHECK (((`po_tax` >= 0.00) and (`po_tax` <= 100.00)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order`
--

LOCK TABLES `purchase_order` WRITE;
/*!40000 ALTER TABLE `purchase_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_order_detail`
--

DROP TABLE IF EXISTS `purchase_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order_detail` (
  `po_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `pod_num` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `pod_quantity` int NOT NULL,
  `pod_price` decimal(12,2) NOT NULL,
  `pr_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `prd_num` int DEFAULT NULL,
  PRIMARY KEY (`po_id`,`pod_num`),
  KEY `FK_PodPrd` (`pr_id`,`prd_num`),
  CONSTRAINT `FK_PodPo` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`),
  CONSTRAINT `FK_PodPr` FOREIGN KEY (`pr_id`) REFERENCES `purchase_requisition` (`pr_id`),
  CONSTRAINT `FK_PodPrd` FOREIGN KEY (`pr_id`, `prd_num`) REFERENCES `purchase_requisition_detail` (`pr_id`, `prd_num`),
  CONSTRAINT `CHK_Pod_quantity` CHECK (((`pod_quantity` >= 1) and (`pod_quantity` <= 50)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order_detail`
--

LOCK TABLES `purchase_order_detail` WRITE;
/*!40000 ALTER TABLE `purchase_order_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_requisition`
--

DROP TABLE IF EXISTS `purchase_requisition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_requisition` (
  `pr_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `pr_date` date NOT NULL,
  `pr_duedate` date NOT NULL,
  `pr_shipaddress` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `pr_note` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `pr_discount` decimal(5,2) DEFAULT NULL,
  `pr_shipcost` decimal(12,2) DEFAULT NULL,
  `pr_tax` decimal(5,2) DEFAULT NULL,
  `emp_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`pr_id`),
  UNIQUE KEY `pr_id` (`pr_id`),
  KEY `FK_PrEmp` (`emp_id`),
  CONSTRAINT `FK_PrEmp` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `chk_pr_tax` CHECK (((`pr_tax` >= 0.00) and (`pr_tax` <= 100.00)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_requisition`
--

LOCK TABLES `purchase_requisition` WRITE;
/*!40000 ALTER TABLE `purchase_requisition` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_requisition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_requisition_detail`
--

DROP TABLE IF EXISTS `purchase_requisition_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_requisition_detail` (
  `pr_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `prd_num` int NOT NULL,
  `prd_budget` decimal(12,2) NOT NULL,
  `prd_quantity` int NOT NULL,
  `prd_category` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `prod_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`pr_id`,`prd_num`),
  KEY `FK_PrdProd` (`prod_id`),
  CONSTRAINT `FK_PrdPr` FOREIGN KEY (`pr_id`) REFERENCES `purchase_requisition` (`pr_id`),
  CONSTRAINT `FK_PrdProd` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`),
  CONSTRAINT `CHK_quantity` CHECK (((`prd_quantity` >= 1) and (`prd_quantity` <= 50)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_requisition_detail`
--

LOCK TABLES `purchase_requisition_detail` WRITE;
/*!40000 ALTER TABLE `purchase_requisition_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_requisition_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `prod_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `s_wage` decimal(12,2) NOT NULL,
  `s_startdate` date NOT NULL,
  `s_enddate` date NOT NULL,
  `s_hour` datetime DEFAULT NULL,
  `s_reqprops` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`prod_id`),
  CONSTRAINT `FK_ProdService` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `sup_id` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sup_rep` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `sup_comname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sup_typobus` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sup_typoprod` char(1) COLLATE utf8_unicode_ci NOT NULL,
  `sup_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sup_description` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sup_status` char(1) COLLATE utf8_unicode_ci NOT NULL,
  `sup_email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `sup_phone` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `sup_rating` int NOT NULL,
  PRIMARY KEY (`sup_id`),
  UNIQUE KEY `sup_id` (`sup_id`),
  CONSTRAINT `CHK_rating` CHECK (((`sup_rating` >= 1) and (`sup_rating` <= 5))),
  CONSTRAINT `CHK_status` CHECK ((`sup_status` in (_utf8mb3'S',_utf8mb3'U'))),
  CONSTRAINT `CHK_type` CHECK ((`sup_typoprod` in (_utf8mb3'G',_utf8mb3'S')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-12-05 19:18:52
