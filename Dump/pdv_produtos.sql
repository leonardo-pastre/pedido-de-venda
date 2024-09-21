-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: pdv
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `CODIGO` int NOT NULL AUTO_INCREMENT,
  `DESCRICAO` varchar(100) NOT NULL,
  `PRECO_VENDA` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`CODIGO`),
  UNIQUE KEY `UN_DESCRICAO` (`DESCRICAO`),
  KEY `IDX_DESCRICAO_PRODUTO` (`DESCRICAO`),
  CONSTRAINT `CHK_PRECO_VENDA` CHECK ((`PRECO_VENDA` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Arroz 5kg',4.99),(2,'Feijão 1kg',9.99),(3,'Açucar 1kg',8.99),(4,'Sal 500g',3.99),(5,'Farinha 500g',6.99),(6,'Fubá 500g',5.99),(7,'Farofa 500g',5.99),(8,'Milho para pipoca 500g',3.99),(9,'Leite Integral 1L',5.99),(10,'Refrigerante 2L',7.99),(11,'Macarrão parafuso 500g',8.99),(12,'Margarina 1kg',10.99),(13,'Requeijão 300g',11.99),(14,'Extrato de tomate 200g',4.99),(15,'Queijo ralado 100g',2.99),(16,'Massa para lasanha 500g',12.99),(17,'Pão de forma 500g',9.99),(18,'Café extra forte',19.99),(19,'Achocolatado 750g',22.99),(20,'Creme de leite 300g',4.99);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-21  1:23:06
