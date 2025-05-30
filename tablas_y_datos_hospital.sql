CREATE DATABASE  IF NOT EXISTS `hospital_profe` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hospital_profe`;
-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: hospital_profe
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.24.04.1

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
-- Table structure for table `admisiones`
--

DROP TABLE IF EXISTS `admisiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admisiones` (
  `admisiones_id` int NOT NULL AUTO_INCREMENT,
  `fecha_admision` datetime DEFAULT NULL,
  `fecha_alta` datetime DEFAULT NULL,
  `diagnostico` varchar(50) DEFAULT NULL,
  `paciente_id` int NOT NULL,
  `doctor_id` int DEFAULT NULL,
  PRIMARY KEY (`admisiones_id`),
  KEY `paciente_id` (`paciente_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `admisiones_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `pacientes` (`paciente_id`),
  CONSTRAINT `admisiones_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctores` (`doctor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admisiones`
--

LOCK TABLES `admisiones` WRITE;
/*!40000 ALTER TABLE `admisiones` DISABLE KEYS */;
INSERT INTO `admisiones` VALUES (1,'2025-05-01 10:00:00','2025-05-03 14:00:00','Gripe común',1,2),(2,'2025-05-04 09:30:00',NULL,'Dolor abdominal',2,4),(3,'2025-05-06 15:20:00','2025-05-08 11:00:00','Infarto leve',3,1),(4,'2025-05-10 08:00:00','2025-05-12 10:30:00','Migraña',4,5),(5,'2025-05-15 14:10:00',NULL,'Alergia alimentaria',5,3),(6,'2025-05-18 12:00:00',NULL,'Bronquitis',6,2),(7,'2025-05-21 11:00:00',NULL,'Asma crónica',7,6),(8,'2025-05-22 09:30:00','2025-05-23 13:00:00','Fractura de brazo',8,8),(9,'2025-05-24 16:00:00',NULL,'Depresión severa',9,9),(10,'2025-05-25 08:30:00',NULL,'Diabetes tipo 2',10,10),(11,'2025-05-26 10:00:00','2025-05-28 10:00:00','Cáncer de piel',11,7),(12,'2025-05-27 14:15:00',NULL,'Migraña aguda',12,5);
/*!40000 ALTER TABLE `admisiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alergias`
--

DROP TABLE IF EXISTS `alergias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alergias` (
  `alergia_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`alergia_id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alergias`
--

LOCK TABLES `alergias` WRITE;
/*!40000 ALTER TABLE `alergias` DISABLE KEYS */;
INSERT INTO `alergias` VALUES (8,'Cacahuetes'),(3,'Frutos secos'),(5,'Gluten'),(4,'Lácteos'),(6,'Mariscos'),(1,'Penicilina'),(2,'Polen'),(7,'Polvo');
/*!40000 ALTER TABLE `alergias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctores`
--

DROP TABLE IF EXISTS `doctores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctores` (
  `doctor_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `apellido` varchar(30) DEFAULT NULL,
  `especialidad` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`doctor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctores`
--

LOCK TABLES `doctores` WRITE;
/*!40000 ALTER TABLE `doctores` DISABLE KEYS */;
INSERT INTO `doctores` VALUES (1,'Ana','Ramírez','Cardiología'),(2,'Carlos','López','Pediatría'),(3,'Elena','Moreno','Dermatología'),(4,'David','Fernández','Ginecología'),(5,'Lucía','Martín','Neurología'),(6,'Isabel','Nieto','Neumología'),(7,'Fernando','Serrano','Oncología'),(8,'Raquel','Cano','Traumatología'),(9,'Alberto','Muñoz','Psiquiatría'),(10,'Patricia','Herrera','Endocrinología');
/*!40000 ALTER TABLE `doctores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paciente_alergia`
--

DROP TABLE IF EXISTS `paciente_alergia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paciente_alergia` (
  `paciente_alergia_id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `alergia_id` int NOT NULL,
  PRIMARY KEY (`paciente_alergia_id`),
  KEY `paciente_id` (`paciente_id`),
  KEY `alergia_id` (`alergia_id`),
  CONSTRAINT `paciente_alergia_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `pacientes` (`paciente_id`),
  CONSTRAINT `paciente_alergia_ibfk_2` FOREIGN KEY (`alergia_id`) REFERENCES `alergias` (`alergia_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paciente_alergia`
--

LOCK TABLES `paciente_alergia` WRITE;
/*!40000 ALTER TABLE `paciente_alergia` DISABLE KEYS */;
INSERT INTO `paciente_alergia` VALUES (1,1,1),(2,2,2),(3,2,3),(4,3,5),(5,4,4),(6,5,2),(7,6,1),(8,7,6),(9,8,5),(10,9,1),(11,10,8),(12,11,2),(13,12,3),(14,12,7);
/*!40000 ALTER TABLE `paciente_alergia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacientes`
--

DROP TABLE IF EXISTS `pacientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacientes` (
  `paciente_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `apellido` varchar(30) DEFAULT NULL,
  `genero` varchar(1) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `peso` decimal(4,1) DEFAULT NULL,
  `altura` decimal(3,2) DEFAULT NULL,
  `poblacion_id` int DEFAULT NULL,
  PRIMARY KEY (`paciente_id`),
  KEY `poblacion_id` (`poblacion_id`),
  CONSTRAINT `pacientes_ibfk_1` FOREIGN KEY (`poblacion_id`) REFERENCES `poblaciones` (`poblacion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacientes`
--

LOCK TABLES `pacientes` WRITE;
/*!40000 ALTER TABLE `pacientes` DISABLE KEYS */;
INSERT INTO `pacientes` VALUES (1,'Juan','Pérez','M','1985-06-15',72.5,1.75,1),(2,'María','Gómez','F','1990-03-22',65.0,1.68,2),(3,'Luis','Martínez','M','1978-12-01',80.3,1.80,3),(4,'Laura','Sánchez','F','2000-07-10',55.0,1.60,4),(5,'Pedro','Ruiz','M','1995-04-19',90.0,1.85,5),(6,'Ana','López','F','1982-08-08',62.0,1.70,6),(7,'Jorge','Navarro','M','1980-02-10',84.0,1.78,7),(8,'Carmen','Delgado','F','1975-11-25',58.0,1.62,8),(9,'Andrés','Molina','M','1999-09-01',70.0,1.70,9),(10,'Beatriz','Ortiz','F','2003-03-15',52.0,1.65,10),(11,'Lucas','Gil','M','1992-12-30',76.5,1.79,7),(12,'Sara','Ibáñez','F','1987-04-17',60.0,1.67,9),(13,'Paco','Pil','M','1995-03-02',80.0,2.00,7);
/*!40000 ALTER TABLE `pacientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poblaciones`
--

DROP TABLE IF EXISTS `poblaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poblaciones` (
  `poblacion_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `provincia_id` int NOT NULL,
  PRIMARY KEY (`poblacion_id`),
  KEY `provincia_id` (`provincia_id`),
  CONSTRAINT `poblaciones_ibfk_1` FOREIGN KEY (`provincia_id`) REFERENCES `provincias` (`provincia_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poblaciones`
--

LOCK TABLES `poblaciones` WRITE;
/*!40000 ALTER TABLE `poblaciones` DISABLE KEYS */;
INSERT INTO `poblaciones` VALUES (1,'Alcalá de Henares',1),(2,'Hospitalet',2),(3,'Torrent',3),(4,'Dos Hermanas',4),(5,'Móstoles',1),(6,'Badalona',2),(7,'Zaragoza',5),(8,'Rincón de la Victoria',6),(9,'Getxo',7),(10,'Torremolinos',6);
/*!40000 ALTER TABLE `poblaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provincias`
--

DROP TABLE IF EXISTS `provincias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provincias` (
  `provincia_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`provincia_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provincias`
--

LOCK TABLES `provincias` WRITE;
/*!40000 ALTER TABLE `provincias` DISABLE KEYS */;
INSERT INTO `provincias` VALUES (1,'Madrid'),(2,'Barcelona'),(3,'Valencia'),(4,'Sevilla'),(5,'Zaragoza'),(6,'Málaga'),(7,'Bilbao');
/*!40000 ALTER TABLE `provincias` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-30  9:10:39
