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
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `CODIGO` int NOT NULL AUTO_INCREMENT,
  `NOME` varchar(100) NOT NULL,
  `CIDADE` varchar(100) DEFAULT NULL,
  `UF` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`CODIGO`),
  UNIQUE KEY `UN_NOME` (`NOME`),
  KEY `IDX_NOME_CLIENTE` (`NOME`),
  KEY `IDX_CIDADE_CLIENTE` (`CIDADE`),
  KEY `IDX_UF_CLIENTE` (`UF`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Felipe Bruno Silveira','Barueri','SP'),(2,'Luzia Sueli Aragão','Araçatuba','SP'),(3,'Lavínia Lorena Corte Real','Jaú','SP'),(4,'Evelyn Heloisa Moura','Itapetininga','SP'),(5,'Nicole Joana Moraes','Indaiatuba','SP'),(6,'Isadora Nicole Rezende','Duque de Caxias','RJ'),(7,'Raul Luís Antonio Campos','Rio das Ostras','RJ'),(8,'Mário Ricardo Pires','Barra do Piraí','RJ'),(9,'Davi Ryan Barros','Campos dos Goytacazes','RJ'),(10,'Vitória Marcela Duarte','Rio de Janeiro','RJ'),(11,'Sophia Valentina Isabel Vieira','São José','SC'),(12,'Marina Raquel Alícia Gonçalves','Jaraguá do Sul','SC'),(13,'Felipe Theo Thomas Almeida','Joinville','SC'),(14,'Stella Maria Peixoto','Rio do Sul','SC'),(15,'Jéssica Aline Duarte','Navegantes','SC'),(16,'Aurora Lívia Moraes','Ribeirão das Neves','MG'),(17,'Henrique Bernardo Jesus','Belo Horizonte','MG'),(18,'Fernando Augusto Benedito Martins','Bias Fortes','MG'),(19,'Emanuelly Aurora Rezende','Pará de Minas','MG'),(20,'Oliver Paulo Lucas Almada','Sabará','MG');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
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
