CREATE DATABASE  IF NOT EXISTS `app_servicios` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `app_servicios`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: app_servicios
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `calificacion`
--

DROP TABLE IF EXISTS `calificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `calificacion` (
  `id_calificacion` int NOT NULL AUTO_INCREMENT,
  `id_servicio` int NOT NULL,
  `calificacion` tinyint NOT NULL,
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_calificacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `tipo` enum('cliente_a_empresa','empresa_a_cliente') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_calificacion`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_calificacion` (`calificacion`),
  KEY `calificacion_ibfk_1_idx` (`id_servicio`),
  CONSTRAINT `calificacion_ibfk_1` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id_servicio`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calificacion`
--

LOCK TABLES `calificacion` WRITE;
/*!40000 ALTER TABLE `calificacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `calificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoria_servicio`
--

DROP TABLE IF EXISTS `categoria_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria_servicio` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icono_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `idx_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria_servicio`
--

LOCK TABLES `categoria_servicio` WRITE;
/*!40000 ALTER TABLE `categoria_servicio` DISABLE KEYS */;
INSERT INTO `categoria_servicio` VALUES (4,'Limpieza','Servicios de limpieza residencial y comercial','https://cdn-icons-png.flaticon.com/512/995/995016.png'),(5,'Plomería','Reparación e instalación de tuberías y grifos','https://cdn-icons-png.flaticon.com/512/307/307826.png'),(6,'Electricidad','Instalaciones eléctricas y reparaciones','https://cdn-icons-png.flaticon.com/512/2933/2933861.png'),(7,'Jardinería','Mantenimiento de jardines y paisajismo','https://cdn-icons-png.flaticon.com/512/1518/1518963.png'),(8,'Carpintería','Fabricación y reparación de muebles de madera','https://cdn-icons-png.flaticon.com/512/2061/2061964.png'),(9,'Pintura','Servicios de pintura interior y exterior','https://cdn-icons-png.flaticon.com/512/2972/2972199.png'),(10,'Mudanza','Servicios de transporte y mudanzas','https://cdn-icons-png.flaticon.com/512/713/713311.png'),(11,'Mecánica','Reparación y mantenimiento automotriz','https://cdn-icons-png.flaticon.com/512/1995/1995470.png'),(12,'Tecnología','Soporte técnico y reparación de computadoras','https://cdn-icons-png.flaticon.com/512/2888/2888702.png'),(13,'Belleza','Servicios de peluquería, maquillaje y estética','https://cdn-icons-png.flaticon.com/512/3252/3252124.png');
/*!40000 ALTER TABLE `categoria_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `calificacion_promedio` decimal(3,2) DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  KEY `fk_cliente_usuario1_idx` (`id_usuario`),
  CONSTRAINT `fk_cliente_usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (5,26,NULL),(6,27,NULL),(7,32,NULL),(8,34,NULL),(9,35,NULL),(10,36,NULL),(11,38,NULL);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contratacion`
--

DROP TABLE IF EXISTS `contratacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contratacion` (
  `id_contratacion` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `id_servicio` int NOT NULL,
  `id_sucursal` int NOT NULL,
  `id_direccion_entrega` int NOT NULL,
  `id_cupon` int DEFAULT NULL,
  `fecha_solicitud` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_programada` datetime DEFAULT NULL,
  `fecha_completada` datetime DEFAULT NULL,
  `precio_subtotal` decimal(10,2) NOT NULL,
  `descuento_aplicado` decimal(10,2) DEFAULT '0.00',
  `precio_total` decimal(10,2) NOT NULL,
  `estado` enum('pendiente','confirmado','en_proceso','completado','cancelado','rechazado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `notas_cliente` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `notas_empresa` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `porcentaje_comision` decimal(5,2) NOT NULL DEFAULT '15.00',
  `comision_plataforma` decimal(10,2) NOT NULL DEFAULT '0.00',
  `ganancia_empresa` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_contratacion`),
  KEY `id_sucursal` (`id_sucursal`),
  KEY `id_direccion_entrega` (`id_direccion_entrega`),
  KEY `id_cupon` (`id_cupon`),
  KEY `idx_cliente` (`id_cliente`),
  KEY `idx_servicio` (`id_servicio`),
  KEY `idx_estado` (`estado`),
  KEY `idx_fecha_solicitud` (`fecha_solicitud`),
  KEY `idx_fecha_programada` (`fecha_programada`),
  KEY `idx_contratacion_cliente_estado` (`id_cliente`,`estado`),
  CONSTRAINT `contratacion_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`) ON DELETE RESTRICT,
  CONSTRAINT `contratacion_ibfk_2` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id_servicio`) ON DELETE RESTRICT,
  CONSTRAINT `contratacion_ibfk_3` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursal` (`id_sucursal`) ON DELETE RESTRICT,
  CONSTRAINT `contratacion_ibfk_4` FOREIGN KEY (`id_direccion_entrega`) REFERENCES `direccion` (`id_direccion`) ON DELETE RESTRICT,
  CONSTRAINT `contratacion_ibfk_5` FOREIGN KEY (`id_cupon`) REFERENCES `cupon` (`id_cupon`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contratacion`
--

LOCK TABLES `contratacion` WRITE;
/*!40000 ALTER TABLE `contratacion` DISABLE KEYS */;
INSERT INTO `contratacion` VALUES (4,10,10,8,13,NULL,'2025-11-26 01:32:45','2025-11-28 00:00:00','2025-11-26 03:21:52',40.00,0.00,40.00,'completado','lol','adgagdadg',15.00,0.00,0.00),(5,10,10,8,13,NULL,'2025-11-26 01:33:56','2025-11-28 00:00:00','2025-11-26 03:35:09',40.00,0.00,40.00,'completado','lol','gg',15.00,0.00,0.00),(6,10,10,8,14,NULL,'2025-11-26 02:04:39',NULL,'2025-11-26 03:18:37',40.00,0.00,40.00,'completado',NULL,'adadhahadh',15.00,0.00,0.00),(7,10,10,8,14,NULL,'2025-11-26 02:13:37',NULL,'2025-11-26 02:48:11',40.00,0.00,40.00,'completado','akjsfkagkahsgjkas','dagadgadg',15.00,0.00,0.00),(8,10,11,10,14,NULL,'2025-11-26 10:29:17','2025-11-28 00:00:00','2025-11-26 10:31:55',460.00,0.00,460.00,'completado','Por fabor con apol pei','hlkfjalsks',15.00,0.00,0.00),(9,10,10,8,13,NULL,'2025-11-26 15:23:46',NULL,'2025-11-26 15:25:54',40.00,0.00,40.00,'completado','asfasfasaaaaaaaaaaaaaaaaaaa','hgrhgf',15.00,0.00,0.00);
/*!40000 ALTER TABLE `contratacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conversacion`
--

DROP TABLE IF EXISTS `conversacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conversacion` (
  `id_conversacion` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `id_empresa` int NOT NULL,
  `id_contratacion` int DEFAULT NULL COMMENT 'Puede ser NULL si es una consulta general',
  `fecha_inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_ultimo_mensaje` datetime DEFAULT NULL,
  `estado` enum('abierta','cerrada','archivada') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'abierta',
  PRIMARY KEY (`id_conversacion`),
  KEY `id_contratacion` (`id_contratacion`),
  KEY `idx_cliente` (`id_cliente`),
  KEY `idx_empresa` (`id_empresa`),
  KEY `idx_estado` (`estado`),
  CONSTRAINT `conversacion_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`) ON DELETE CASCADE,
  CONSTRAINT `conversacion_ibfk_2` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE,
  CONSTRAINT `conversacion_ibfk_3` FOREIGN KEY (`id_contratacion`) REFERENCES `contratacion` (`id_contratacion`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conversacion`
--

LOCK TABLES `conversacion` WRITE;
/*!40000 ALTER TABLE `conversacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `conversacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cupon`
--

DROP TABLE IF EXISTS `cupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cupon` (
  `id_cupon` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_descuento` enum('porcentaje','monto_fijo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_descuento` decimal(10,2) NOT NULL,
  `monto_minimo_compra` decimal(10,2) DEFAULT '0.00',
  `cantidad_disponible` int DEFAULT NULL,
  `cantidad_usada` int DEFAULT '0',
  `fecha_inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_expiracion` datetime DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `aplicable_a` enum('todos','categoria','servicio_especifico') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'todos',
  PRIMARY KEY (`id_cupon`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `idx_codigo` (`codigo`),
  KEY `idx_empresa` (`id_empresa`),
  KEY `idx_activo` (`activo`),
  KEY `idx_fecha_expiracion` (`fecha_expiracion`),
  CONSTRAINT `cupon_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupon`
--

LOCK TABLES `cupon` WRITE;
/*!40000 ALTER TABLE `cupon` DISABLE KEYS */;
INSERT INTO `cupon` VALUES (3,7,'PENE67','El  cupon sirve para comer pene mas abarato','porcentaje',20.00,20.00,20,0,'2025-11-28 00:00:00','2025-12-30 00:00:00',1,'todos'),(4,7,'VERANOAZUL','aagahkjghakjhgkjadhgkjadhg','monto_fijo',2.00,13.00,20,0,'2025-11-27 00:00:00','2025-12-19 00:00:00',1,'todos');
/*!40000 ALTER TABLE `cupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cupon_categoria`
--

DROP TABLE IF EXISTS `cupon_categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cupon_categoria` (
  `id_cupon` int NOT NULL,
  `id_categoria` int NOT NULL,
  PRIMARY KEY (`id_cupon`,`id_categoria`),
  KEY `fk_cupon_categoria_cupon1_idx` (`id_cupon`),
  KEY `fk_cupon_categoria_categoria_servicio1_idx` (`id_categoria`),
  CONSTRAINT `fk_cupon_categoria_categoria_servicio1` FOREIGN KEY (`id_categoria`) REFERENCES `categoria_servicio` (`id_categoria`),
  CONSTRAINT `fk_cupon_categoria_cupon1` FOREIGN KEY (`id_cupon`) REFERENCES `cupon` (`id_cupon`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupon_categoria`
--

LOCK TABLES `cupon_categoria` WRITE;
/*!40000 ALTER TABLE `cupon_categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `cupon_categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cupon_servicio`
--

DROP TABLE IF EXISTS `cupon_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cupon_servicio` (
  `id_cupon` int NOT NULL,
  `id_servicio` int NOT NULL,
  PRIMARY KEY (`id_cupon`,`id_servicio`),
  KEY `id_servicio` (`id_servicio`),
  CONSTRAINT `cupon_servicio_ibfk_1` FOREIGN KEY (`id_cupon`) REFERENCES `cupon` (`id_cupon`) ON DELETE CASCADE,
  CONSTRAINT `cupon_servicio_ibfk_2` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id_servicio`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupon_servicio`
--

LOCK TABLES `cupon_servicio` WRITE;
/*!40000 ALTER TABLE `cupon_servicio` DISABLE KEYS */;
/*!40000 ALTER TABLE `cupon_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direccion`
--

DROP TABLE IF EXISTS `direccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `direccion` (
  `id_direccion` int NOT NULL AUTO_INCREMENT,
  `calle_principal` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `calle_secundaria` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ciudad` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `provincia_estado` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_postal` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pais` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Ecuador',
  `latitud` decimal(10,8) DEFAULT NULL,
  `longitud` decimal(11,8) DEFAULT NULL,
  `referencia` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_direccion`),
  KEY `idx_ciudad` (`ciudad`),
  KEY `idx_coordenadas` (`latitud`,`longitud`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direccion`
--

LOCK TABLES `direccion` WRITE;
/*!40000 ALTER TABLE `direccion` DISABLE KEYS */;
INSERT INTO `direccion` VALUES (5,'Av.10 de Agosto','y 6 de Diciembre',NULL,'Quito','Pichincha',NULL,'Ecuador',NULL,NULL,NULL),(6,'Av.Eloy Alfaro','y De los Guayacanes','E13-135','Quito','Pichicnha',NULL,'Ecuador',NULL,NULL,NULL),(7,'Calle Principal','Calle Secundaria','32','Quito','Pichincha',NULL,'Ecuador',NULL,NULL,'Casa Cafe'),(8,'Calle Principal','Calle Secundaria','N34-123','Cuenca','Azuay','127389','Ecuador',NULL,NULL,NULL),(9,'Calle Principal','Calle Secundaria','E13-135','Guayaquil','Guayas',NULL,'Ecuador',NULL,NULL,NULL),(10,'Calle china 1','Calle china 2','N54-16','Zhengen','Chang',NULL,'Ecuador',NULL,NULL,NULL),(11,'Av 10 de agosto','Av amazonas','M2431','Quito','Pichincha','170361124','Ecuador',NULL,NULL,'falfkahgljkadgha'),(12,'lasljahf','afhfklagsfk',NULL,'jkfakgfkjasa','asfjahsfasg',NULL,'Ecuador',NULL,NULL,NULL),(13,'Calle','lol','lol Int lol','pablo','palbo','98765','Ecuador',NULL,NULL,'aslfkalsf'),(14,'LAKSFJALKJF',NULL,'12','qUITO','PICHINCHA','170144','Ecuador',NULL,NULL,'ASFGA'),(15,'Sergio Jativa','Jose Bosmediano','N33-42','Quito','Pichincha','170144','Ecuador',NULL,NULL,'Edificio torre de bellavista');
/*!40000 ALTER TABLE `direccion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direcciones_del_cliente`
--

DROP TABLE IF EXISTS `direcciones_del_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `direcciones_del_cliente` (
  `id_cliente` int NOT NULL,
  `id_direccion` int NOT NULL,
  `alias` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `es_principal` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_cliente`,`id_direccion`),
  KEY `fk_cliente_has_direccion_direccion1_idx` (`id_direccion`),
  KEY `fk_cliente_has_direccion_cliente1_idx` (`id_cliente`),
  CONSTRAINT `fk_cliente_has_direccion_cliente1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `fk_cliente_has_direccion_direccion1` FOREIGN KEY (`id_direccion`) REFERENCES `direccion` (`id_direccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direcciones_del_cliente`
--

LOCK TABLES `direcciones_del_cliente` WRITE;
/*!40000 ALTER TABLE `direcciones_del_cliente` DISABLE KEYS */;
INSERT INTO `direcciones_del_cliente` VALUES (6,7,'Casa',0),(10,13,'Casa',1),(10,14,'JOAJFOJFALKAJ',0);
/*!40000 ALTER TABLE `direcciones_del_cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresa`
--

DROP TABLE IF EXISTS `empresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresa` (
  `id_empresa` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `razon_social` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruc_nit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `logo_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `calificacion_promedio` decimal(3,2) DEFAULT '0.00',
  `fecha_verificacion` datetime DEFAULT NULL,
  `pais` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_empresa`),
  UNIQUE KEY `ruc_nit` (`ruc_nit`),
  KEY `idx_calificacion` (`calificacion_promedio`),
  KEY `fk_empresa_usuario1_idx` (`id_usuario`),
  CONSTRAINT `fk_empresa_usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresa`
--

LOCK TABLES `empresa` WRITE;
/*!40000 ALTER TABLE `empresa` DISABLE KEYS */;
INSERT INTO `empresa` VALUES (3,28,'Empresa1',NULL,NULL,NULL,0.00,NULL,'Ecuador'),(5,30,'Empresa 2',NULL,NULL,NULL,0.00,NULL,'Mexico'),(6,33,'Empresa 3',NULL,NULL,NULL,0.00,NULL,'China'),(7,37,'EmpresasJaimito',NULL,'','https://res.cloudinary.com/dzoptmnx0/image/upload/v1764297401/app_servicios/ebpsuskhms18jb6qsqyu.png',0.00,NULL,'Ecuador'),(8,39,'Oniria',NULL,NULL,NULL,0.00,NULL,'Ecuador');
/*!40000 ALTER TABLE `empresa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_estado_contratacion`
--

DROP TABLE IF EXISTS `historial_estado_contratacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_estado_contratacion` (
  `id_historial` int NOT NULL AUTO_INCREMENT,
  `id_contratacion` int NOT NULL,
  `estado_anterior` enum('pendiente','confirmado','en_proceso','completado','cancelado','rechazado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_nuevo` enum('pendiente','confirmado','en_proceso','completado','cancelado','rechazado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_cambio` datetime DEFAULT CURRENT_TIMESTAMP,
  `notas` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `id_usuario_responsable` int DEFAULT NULL,
  PRIMARY KEY (`id_historial`),
  KEY `idx_hist_contratacion` (`id_contratacion`),
  CONSTRAINT `fk_historial_contratacion` FOREIGN KEY (`id_contratacion`) REFERENCES `contratacion` (`id_contratacion`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_estado_contratacion`
--

LOCK TABLES `historial_estado_contratacion` WRITE;
/*!40000 ALTER TABLE `historial_estado_contratacion` DISABLE KEYS */;
INSERT INTO `historial_estado_contratacion` VALUES (1,4,NULL,'pendiente','2025-11-26 01:32:45','Contratación creada',NULL),(2,5,NULL,'pendiente','2025-11-26 01:33:56','Contratación creada',NULL),(3,6,NULL,'pendiente','2025-11-26 02:04:39','Contratación creada',NULL),(4,7,NULL,'pendiente','2025-11-26 02:13:37','Contratación creada',NULL),(5,7,'pendiente','confirmado','2025-11-26 02:44:56','Iremos a las 10 am',NULL),(6,7,'confirmado','confirmado','2025-11-26 02:47:23','asfgagdh',NULL),(7,7,'confirmado','en_proceso','2025-11-26 02:48:03','vxvzczfh',NULL),(8,7,'en_proceso','completado','2025-11-26 02:48:11','dagadgadg',NULL),(9,6,'pendiente','confirmado','2025-11-26 03:16:23','Se realizara la orden mañana',NULL),(10,6,'confirmado','en_proceso','2025-11-26 03:18:23','asfagad',NULL),(11,6,'en_proceso','completado','2025-11-26 03:18:37','adadhahadh',NULL),(12,4,'pendiente','confirmado','2025-11-26 03:21:38','aaadgagdag',NULL),(13,4,'confirmado','en_proceso','2025-11-26 03:21:46','adgadgadg',NULL),(14,4,'en_proceso','completado','2025-11-26 03:21:52','adgagdadg',NULL),(15,5,'pendiente','confirmado','2025-11-26 03:22:08','adgadg',NULL),(16,5,'confirmado','en_proceso','2025-11-26 03:22:16','a',NULL),(17,5,'en_proceso','completado','2025-11-26 03:35:09','gg',NULL),(18,8,NULL,'pendiente','2025-11-26 10:29:17','Contratación creada',NULL),(19,8,'pendiente','confirmado','2025-11-26 10:31:12','Un  gusto atenderle',NULL),(20,8,'confirmado','en_proceso','2025-11-26 10:31:46','aslklfjlaskf',NULL),(21,8,'en_proceso','completado','2025-11-26 10:31:55','hlkfjalsks',NULL),(22,9,NULL,'pendiente','2025-11-26 15:23:46','Contratación creada',NULL),(23,9,'pendiente','confirmado','2025-11-26 15:25:16','ngfng',NULL),(24,9,'confirmado','en_proceso','2025-11-26 15:25:20','ge',NULL),(25,9,'en_proceso','completado','2025-11-26 15:25:54','hgrhgf',NULL);
/*!40000 ALTER TABLE `historial_estado_contratacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mensaje`
--

DROP TABLE IF EXISTS `mensaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mensaje` (
  `id_mensaje` int NOT NULL AUTO_INCREMENT,
  `id_conversacion` int NOT NULL,
  `id_remitente` int NOT NULL,
  `contenido` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_mensaje` enum('texto','imagen','archivo','audio') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'texto',
  `archivo_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_envio` datetime DEFAULT CURRENT_TIMESTAMP,
  `leido` tinyint(1) DEFAULT '0',
  `fecha_lectura` datetime DEFAULT NULL,
  PRIMARY KEY (`id_mensaje`),
  KEY `idx_conversacion` (`id_conversacion`),
  KEY `idx_remitente` (`id_remitente`),
  KEY `idx_leido` (`leido`),
  KEY `idx_fecha_envio` (`fecha_envio`),
  KEY `idx_mensaje_conversacion_fecha` (`id_conversacion`,`fecha_envio`),
  CONSTRAINT `mensaje_ibfk_1` FOREIGN KEY (`id_conversacion`) REFERENCES `conversacion` (`id_conversacion`) ON DELETE CASCADE,
  CONSTRAINT `mensaje_ibfk_2` FOREIGN KEY (`id_remitente`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mensaje`
--

LOCK TABLES `mensaje` WRITE;
/*!40000 ALTER TABLE `mensaje` DISABLE KEYS */;
/*!40000 ALTER TABLE `mensaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificacion`
--

DROP TABLE IF EXISTS `notificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacion` (
  `id_notificacion` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contenido` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo` enum('nuevo_mensaje','cambio_estado','nuevo_cupon','calificacion','pago','sistema') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia_id` int DEFAULT NULL COMMENT 'ID de la entidad relacionada',
  `referencia_tipo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de entidad (mensaje, contratacion, cupon, etc)',
  `leida` tinyint(1) DEFAULT '0',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_lectura` datetime DEFAULT NULL,
  PRIMARY KEY (`id_notificacion`),
  KEY `idx_usuario` (`id_usuario`),
  KEY `idx_leida` (`leida`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_fecha_creacion` (`fecha_creacion`),
  CONSTRAINT `notificacion_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacion`
--

LOCK TABLES `notificacion` WRITE;
/*!40000 ALTER TABLE `notificacion` DISABLE KEYS */;
INSERT INTO `notificacion` VALUES (5,37,'Nueva Orden Recibida','Has recibido una nueva orden de servicio. ID: 6','sistema',6,'contratacion',1,'2025-11-26 02:04:39','2025-11-26 02:26:45'),(6,37,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de usuario1 usuario1. ID: 7','sistema',7,'contratacion',1,'2025-11-26 02:13:38','2025-11-26 03:35:16'),(7,36,'Orden Confirmada','¡Tu orden #4 ha sido confirmada por la empresa!\n\nNota de la empresa: aaadgagdag','cambio_estado',4,'contratacion',1,'2025-11-26 03:21:38','2025-11-26 03:22:48'),(8,36,'Servicio en Proceso','La empresa ha iniciado el servicio de la orden #4.\n\nNota de la empresa: adgadgadg','cambio_estado',4,'contratacion',1,'2025-11-26 03:21:46','2025-11-26 03:22:49'),(9,36,'Servicio Completado','El servicio de la orden #4 ha sido marcado como completado.\n\nNota de la empresa: adgagdadg','cambio_estado',4,'contratacion',1,'2025-11-26 03:21:52','2025-11-26 03:22:49'),(10,36,'Orden Confirmada','¡Tu orden #5 ha sido confirmada por la empresa!\n\nNota de la empresa: adgadg','cambio_estado',5,'contratacion',1,'2025-11-26 03:22:08','2025-11-26 03:22:52'),(11,36,'Servicio en Proceso','La empresa ha iniciado el servicio de la orden #5.\n\nNota de la empresa: a','cambio_estado',5,'contratacion',1,'2025-11-26 03:22:16','2025-11-26 03:22:54'),(12,36,'Servicio Completado','El servicio de la orden #5 ha sido marcado como completado.\n\nNota de la empresa: gg','cambio_estado',5,'contratacion',1,'2025-11-26 03:35:09','2025-11-26 10:02:13'),(13,39,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de usuario1 usuario1. ID: 8','sistema',8,'contratacion',1,'2025-11-26 10:29:17','2025-11-26 10:30:15'),(14,36,'Orden Confirmada','¡Tu orden #8 ha sido confirmada por la empresa!\n\nNota de la empresa: Un  gusto atenderle','cambio_estado',8,'contratacion',1,'2025-11-26 10:31:12','2025-11-26 23:16:59'),(15,36,'Servicio en Proceso','La empresa ha iniciado el servicio de la orden #8.\n\nNota de la empresa: aslklfjlaskf','cambio_estado',8,'contratacion',1,'2025-11-26 10:31:46','2025-11-26 23:16:59'),(16,36,'Servicio Completado','El servicio de la orden #8 ha sido marcado como completado.\n\nNota de la empresa: hlkfjalsks','cambio_estado',8,'contratacion',1,'2025-11-26 10:31:55','2025-11-26 23:16:59'),(17,37,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de usuario1 usuario1. ID: 9','sistema',9,'contratacion',1,'2025-11-26 15:23:46','2025-11-27 00:11:46'),(18,36,'Orden Confirmada','¡Tu orden #9 ha sido confirmada por la empresa!\n\nNota de la empresa: ngfng','cambio_estado',9,'contratacion',1,'2025-11-26 15:25:16','2025-11-26 23:16:59'),(19,36,'Servicio en Proceso','La empresa ha iniciado el servicio de la orden #9.\n\nNota de la empresa: ge','cambio_estado',9,'contratacion',1,'2025-11-26 15:25:20','2025-11-26 23:16:59'),(20,36,'Servicio Completado','El servicio de la orden #9 ha sido marcado como completado.\n\nNota de la empresa: hgrhgf','cambio_estado',9,'contratacion',1,'2025-11-26 15:25:54','2025-11-26 23:16:59');
/*!40000 ALTER TABLE `notificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pago`
--

DROP TABLE IF EXISTS `pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pago` (
  `id_pago` int NOT NULL AUTO_INCREMENT,
  `id_contratacion` int NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `metodo_pago` enum('tarjeta_credito','tarjeta_debito','efectivo','transferencia','paypal','otro') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_pago` enum('pendiente','completado','fallido','reembolsado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `fecha_pago` datetime DEFAULT CURRENT_TIMESTAMP,
  `referencia_transaccion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `idx_contratacion` (`id_contratacion`),
  KEY `idx_estado_pago` (`estado_pago`),
  KEY `idx_referencia` (`referencia_transaccion`),
  CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`id_contratacion`) REFERENCES `contratacion` (`id_contratacion`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pago`
--

LOCK TABLES `pago` WRITE;
/*!40000 ALTER TABLE `pago` DISABLE KEYS */;
INSERT INTO `pago` VALUES (3,6,40.00,'efectivo','completado','2025-11-26 02:04:39',NULL),(4,7,40.00,'paypal','completado','2025-11-26 02:13:37',NULL),(5,8,460.00,'tarjeta_credito','completado','2025-11-26 10:29:17',NULL),(6,9,40.00,'efectivo','completado','2025-11-26 15:23:46',NULL);
/*!40000 ALTER TABLE `pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicio`
--

DROP TABLE IF EXISTS `servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio` (
  `id_servicio` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_categoria` int NOT NULL,
  `nombre` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `precio_base` decimal(10,2) NOT NULL,
  `duracion_estimada` int DEFAULT NULL COMMENT 'Duración en minutos',
  `imagen_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('disponible','no_disponible','agotado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'disponible',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_servicio`),
  KEY `idx_empresa` (`id_empresa`),
  KEY `idx_categoria` (`id_categoria`),
  KEY `idx_estado` (`estado`),
  KEY `idx_servicio_empresa_estado` (`id_empresa`,`estado`),
  CONSTRAINT `servicio_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE,
  CONSTRAINT `servicio_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categoria_servicio` (`id_categoria`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio`
--

LOCK TABLES `servicio` WRITE;
/*!40000 ALTER TABLE `servicio` DISABLE KEYS */;
INSERT INTO `servicio` VALUES (7,3,4,'Limpieza de autos','Limpieza profesional de autos a domicilio.',50.00,2,NULL,'disponible','2025-11-24 20:12:22'),(8,3,4,'Limpieza de vehiculos','Limpieza de alta calidad de vehiculos a domicilio',40.00,2,'http://localhost:5001/uploads/1764036204942-486800943.png','disponible','2025-11-24 21:06:05'),(9,6,12,'Venta de ninios inteligentes','venden ninios inteligentes para uso domestico',300.00,24,'http://localhost:5001/uploads/1764089453020-295311864.png','disponible','2025-11-25 11:50:57'),(10,7,8,'serviciopruebacontratacion','esto es prueba',40.00,2,NULL,'disponible','2025-11-26 01:31:50'),(11,8,12,'Implementacion de chatbots','Lo lograremos',460.00,15,NULL,'disponible','2025-11-26 10:22:55'),(12,7,4,'Penes2','agfagasfasfasfaasfasf',35.00,3,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764301689/app_servicios/nbz5ykcgwlfo0cvqoq7q.jpg','disponible','2025-11-27 22:19:27'),(13,7,7,'ola','sagahadhdfjdfgkf',114.00,2,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764301079/app_servicios/ceh5lcj1co6yhc8ihzln.jpg','disponible','2025-11-27 22:38:03');
/*!40000 ALTER TABLE `servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicio_favorito`
--

DROP TABLE IF EXISTS `servicio_favorito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio_favorito` (
  `id_servicio` int NOT NULL,
  `id_cliente` int NOT NULL,
  `fecha_agregado` datetime DEFAULT NULL,
  `notas_cliente` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_servicio`,`id_cliente`),
  KEY `fk_servicio_has_cliente_cliente1_idx` (`id_cliente`),
  KEY `fk_servicio_has_cliente_servicio1_idx` (`id_servicio`),
  CONSTRAINT `fk_servicio_has_cliente_cliente1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `fk_servicio_has_cliente_servicio1` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id_servicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio_favorito`
--

LOCK TABLES `servicio_favorito` WRITE;
/*!40000 ALTER TABLE `servicio_favorito` DISABLE KEYS */;
INSERT INTO `servicio_favorito` VALUES (7,6,'2025-11-24 20:23:34',NULL),(7,10,'2025-11-27 00:07:55',NULL),(10,10,'2025-11-27 00:25:44',NULL),(11,10,'2025-11-27 21:31:18',NULL);
/*!40000 ALTER TABLE `servicio_favorito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicio_sucursal`
--

DROP TABLE IF EXISTS `servicio_sucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio_sucursal` (
  `id_servicio` int NOT NULL,
  `id_sucursal` int NOT NULL,
  `disponible` tinyint(1) DEFAULT '1',
  `precio_sucursal` decimal(10,2) DEFAULT NULL COMMENT 'Precio específico de la sucursal (si difiere del base)',
  PRIMARY KEY (`id_servicio`,`id_sucursal`),
  KEY `id_sucursal` (`id_sucursal`),
  KEY `idx_disponible` (`disponible`),
  CONSTRAINT `servicio_sucursal_ibfk_1` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id_servicio`) ON DELETE CASCADE,
  CONSTRAINT `servicio_sucursal_ibfk_2` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursal` (`id_sucursal`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio_sucursal`
--

LOCK TABLES `servicio_sucursal` WRITE;
/*!40000 ALTER TABLE `servicio_sucursal` DISABLE KEYS */;
INSERT INTO `servicio_sucursal` VALUES (9,7,1,NULL),(10,8,1,NULL),(11,10,1,NULL),(12,9,1,NULL),(13,8,1,NULL);
/*!40000 ALTER TABLE `servicio_sucursal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sucursal`
--

DROP TABLE IF EXISTS `sucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sucursal` (
  `id_sucursal` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_direccion` int NOT NULL COMMENT 'Dirección base reutilizable',
  `nombre_sucursal` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `piso` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Piso específico dentro del edificio',
  `numero_local` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Número de local/oficina',
  `referencias_especificas` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Referencias únicas para esta sucursal',
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `horario_apertura` time DEFAULT NULL,
  `horario_cierre` time DEFAULT NULL,
  `dias_laborales` char(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('activa','inactiva','temporal') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'activa',
  PRIMARY KEY (`id_sucursal`),
  KEY `idx_empresa` (`id_empresa`),
  KEY `idx_direccion` (`id_direccion`),
  KEY `idx_estado` (`estado`),
  CONSTRAINT `sucursal_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE,
  CONSTRAINT `sucursal_ibfk_2` FOREIGN KEY (`id_direccion`) REFERENCES `direccion` (`id_direccion`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sucursal`
--

LOCK TABLES `sucursal` WRITE;
/*!40000 ALTER TABLE `sucursal` DISABLE KEYS */;
INSERT INTO `sucursal` VALUES (6,3,9,'Sucursal Guayakill',NULL,NULL,NULL,'0987654321','09:50:00','20:00:00','1101100','activa'),(7,6,10,'cursal Zhengen',NULL,NULL,NULL,'0987654321','11:00:00','18:00:00','1101101','activa'),(8,7,11,'Sucursal principal',NULL,NULL,NULL,'0987654321','09:00:00','18:00:00','1111100','activa'),(9,7,12,'Sucursal Centro',NULL,NULL,NULL,'0987654321','11:00:00','17:00:00','1111100','activa'),(10,8,15,'Casa chikit',NULL,NULL,NULL,'0982134','08:30:00','18:30:00','1111100','activa');
/*!40000 ALTER TABLE `sucursal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_usuario` enum('cliente','empresa','empleado','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto_perfil_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` enum('activo','inactivo','suspendido') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'activo',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_tipo_usuario` (`tipo_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (26,'test@ejemplo.com','$2b$10$v8ypl8XzdbgRn4YN6NQ4Nuh/ZWL2ye4Lx3UDfBSH83D5cQBMzhv8W','Usuario','Prueba','0999999999','cliente',NULL,'2025-11-22 18:02:55','activo'),(27,'andyvega77@hotmail.com','$2b$10$Rv7yw9ZWLiCZLp5OvWC2r.wXdBGlerOpWASOqYPm/dE8SwxoBzjEC','Andres','Vega','0994367670','cliente',NULL,'2025-11-22 19:07:49','activo'),(28,'empresa1@empresa.com','$2b$10$mi96yOt9LmYm0EdZgTKOM.2yoGmAvrBIMul2ccv7u0FFjTDutHTfG','Empresa1','Xd',NULL,'empresa',NULL,'2025-11-24 19:37:45','activo'),(30,'empresa2@empresa.com','$2b$10$2/zdTR7tVvv1sY/yCBLIluktRgpVPGDXX3WEBb7e4zhZZESOl.CPO','Julio','Ibarra',NULL,'empresa',NULL,'2025-11-24 22:16:09','activo'),(32,'cliente01@gmail.com','$2b$10$Ii2QSnCcmZomedY2wjJOX.sN2ilavYW1xLnbasdt/Dz/MqWYQ52ZS','Jarod','Tierra','0987654321','cliente',NULL,'2025-11-24 22:22:37','activo'),(33,'empresa3@empresa.com','$2b$10$zXTqDjznA/Mgkfi3JVH1out9ziRNyQRGRBQtq2DO6LLOsxkiusxs6','Pepito','Vargas','0987654321','empresa',NULL,'2025-11-25 11:48:16','activo'),(34,'pablitoks@yopmail.comm','$2b$10$gcwVCre1BeKke6hgtrZA6eOKtuQXT9c2FnWq.lSlX9nWnQTQcWXUq','pablou','jarroun','0987654321','cliente',NULL,'2025-11-25 22:48:47','activo'),(35,'paja@pj.com','$2b$10$z2K5uvloA65l0MkKKflGwues3GndO6bOHCz2mp/su4kBvxUbsN7IG','paja','pajon','0987654321','cliente',NULL,'2025-11-25 22:56:40','activo'),(36,'usuario1@usuario1.com','$2b$10$DkKpZBUG/BGY1iIH0zmTduNLz9xIc5F6AvUC3icrPKKaQOdJM3nMy','usuario1','usuario1','098765321','cliente','https://res.cloudinary.com/dzoptmnx0/image/upload/v1764297741/app_servicios/klhtltdrofrgbz84tczo.jpg','2025-11-25 23:13:19','activo'),(37,'usuario2@usuario2.com','$2b$10$6./OD3IVpd6kCrKNKMpksOIsV74VYHWK8bWeEdPP4XhZzWML57JRu','Pablo','Jarrin','0987654321','empresa',NULL,'2025-11-25 23:38:01','activo'),(38,'lauvalemp@gmail.com','$2b$10$q6lERst0SdPCebBeN197/.IulI8clQdIO6ZuGPBIFRgkWqvkj9tRK','Laura','Muñoz','0989352134','cliente',NULL,'2025-11-26 10:14:51','activo'),(39,'klovit@gmail.com','$2b$10$GPew/nQPUDcOAfaWTU4qmuFSj9b7dsb0ovzaNYBump8xSQYdWRFKC','Klovit','Jarrin','0989352134','empresa',NULL,'2025-11-26 10:17:48','activo');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vista_contrataciones_detalle`
--

DROP TABLE IF EXISTS `vista_contrataciones_detalle`;
/*!50001 DROP VIEW IF EXISTS `vista_contrataciones_detalle`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_contrataciones_detalle` AS SELECT 
 1 AS `id_contratacion`,
 1 AS `fecha_solicitud`,
 1 AS `fecha_programada`,
 1 AS `estado_contratacion`,
 1 AS `precio_total`,
 1 AS `cliente_nombre`,
 1 AS `cliente_email`,
 1 AS `servicio_nombre`,
 1 AS `empresa_nombre`,
 1 AS `nombre_sucursal`,
 1 AS `direccion_entrega`,
 1 AS `cupon_codigo`,
 1 AS `descuento_aplicado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_estadisticas_empresa`
--

DROP TABLE IF EXISTS `vista_estadisticas_empresa`;
/*!50001 DROP VIEW IF EXISTS `vista_estadisticas_empresa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_estadisticas_empresa` AS SELECT 
 1 AS `id_empresa`,
 1 AS `razon_social`,
 1 AS `logo_url`,
 1 AS `calificacion_promedio`,
 1 AS `total_servicios`,
 1 AS `total_sucursales`,
 1 AS `total_contrataciones`,
 1 AS `ingresos_totales`,
 1 AS `cupones_activos`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_servicios_completos`
--

DROP TABLE IF EXISTS `vista_servicios_completos`;
/*!50001 DROP VIEW IF EXISTS `vista_servicios_completos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_servicios_completos` AS SELECT 
 1 AS `id_servicio`,
 1 AS `servicio_nombre`,
 1 AS `descripcion`,
 1 AS `precio_base`,
 1 AS `duracion_estimada`,
 1 AS `servicio_estado`,
 1 AS `categoria_nombre`,
 1 AS `empresa_nombre`,
 1 AS `empresa_calificacion`,
 1 AS `empresa_email`,
 1 AS `empresa_telefono`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_sucursales_direccion_completa`
--

DROP TABLE IF EXISTS `vista_sucursales_direccion_completa`;
/*!50001 DROP VIEW IF EXISTS `vista_sucursales_direccion_completa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_sucursales_direccion_completa` AS SELECT 
 1 AS `id_sucursal`,
 1 AS `nombre_sucursal`,
 1 AS `empresa_nombre`,
 1 AS `calle_principal`,
 1 AS `calle_secundaria`,
 1 AS `numero`,
 1 AS `ciudad`,
 1 AS `provincia_estado`,
 1 AS `codigo_postal`,
 1 AS `pais`,
 1 AS `latitud`,
 1 AS `longitud`,
 1 AS `piso`,
 1 AS `numero_local`,
 1 AS `referencias_especificas`,
 1 AS `direccion_completa`,
 1 AS `telefono`,
 1 AS `horario_apertura`,
 1 AS `horario_cierre`,
 1 AS `estado`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'app_servicios'
--

--
-- Dumping routines for database 'app_servicios'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_actualizar_estado_contratacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_estado_contratacion`(
    IN p_id_contratacion INT,
    IN p_nuevo_estado ENUM('pendiente', 'confirmado', 'en_proceso', 'completado', 'cancelado', 'rechazado'),
    IN p_notas TEXT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_estado_actual VARCHAR(20);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_mensaje = 'Error al actualizar estado de contratación';
    END;

    START TRANSACTION;

    -- Obtener estado actual
    SELECT estado INTO v_estado_actual
    FROM contratacion
    WHERE id_contratacion = p_id_contratacion;

    IF v_estado_actual IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La contratación no existe';
    END IF;

    -- Validar transiciones de estado permitidas
    IF v_estado_actual IN ('cancelado', 'completado', 'rechazado') AND v_estado_actual != p_nuevo_estado THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede modificar una contratación cancelada, completada o rechazada';
    END IF;

    -- *** REGISTRAR EN HISTORIAL (Nueva funcionalidad) ***
    INSERT INTO historial_estado_contratacion (
        id_contratacion, estado_anterior, estado_nuevo, notas
    ) VALUES (
        p_id_contratacion, v_estado_actual, p_nuevo_estado, p_notas
    );

    -- Actualizar estado en tabla contratacion
    IF p_nuevo_estado = 'completado' THEN
        UPDATE contratacion
        SET estado = p_nuevo_estado,
            notas_empresa = IFNULL(p_notas, notas_empresa),
            fecha_completada = NOW()
        WHERE id_contratacion = p_id_contratacion;
    ELSE
        UPDATE contratacion
        SET estado = p_nuevo_estado,
            notas_empresa = IFNULL(p_notas, notas_empresa)
        WHERE id_contratacion = p_id_contratacion;
    END IF;

    SET p_out_mensaje = CONCAT('Estado actualizado a: ', p_nuevo_estado);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_asociar_servicio_sucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_asociar_servicio_sucursal`(
    IN p_id_servicio INT,
    IN p_id_sucursal INT,
    IN p_precio_sucursal DECIMAL(10,2),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_servicio_count INT DEFAULT 0;
    DECLARE v_sucursal_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_mensaje = 'Error al asociar servicio a sucursal';
    END;

    START TRANSACTION;

    -- Validar que el servicio exista
    SELECT COUNT(*) INTO v_servicio_count FROM servicio WHERE id_servicio = p_id_servicio;
    IF v_servicio_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El servicio no existe';
    END IF;

    -- Validar que la sucursal exista
    SELECT COUNT(*) INTO v_sucursal_count FROM sucursal WHERE id_sucursal = p_id_sucursal;
    IF v_sucursal_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sucursal no existe';
    END IF;

    -- Insertar o actualizar la relación
    INSERT INTO servicio_sucursal (id_servicio, id_sucursal, disponible, precio_sucursal)
    VALUES (p_id_servicio, p_id_sucursal, 1, p_precio_sucursal)
    ON DUPLICATE KEY UPDATE
        disponible = 1,
        precio_sucursal = p_precio_sucursal;

    SET p_out_mensaje = 'Servicio asociado a sucursal exitosamente';

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_crear_calificacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_calificacion`(
    IN p_id_contratacion INT,
    IN p_calificacion TINYINT,
    IN p_comentario TEXT,
    IN p_tipo ENUM('cliente_a_empresa', 'empresa_a_cliente'),
    OUT p_out_id_calificacion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_contratacion_estado VARCHAR(20);
    DECLARE v_calificacion_count INT DEFAULT 0;
    DECLARE v_id_empresa INT;
    DECLARE v_nuevo_promedio DECIMAL(3,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_id_calificacion = NULL;
        SET p_out_mensaje = 'Error al crear calificación';
    END;

    START TRANSACTION;

    -- Validar que la contratación exista y esté completada
    SELECT estado INTO v_contratacion_estado
    FROM contratacion
    WHERE id_contratacion = p_id_contratacion;

    IF v_contratacion_estado IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La contratación no existe';
    END IF;

    IF v_contratacion_estado != 'completado' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Solo se pueden calificar contrataciones completadas';
    END IF;

    -- Validar que no exista calificación previa del mismo tipo
    SELECT COUNT(*) INTO v_calificacion_count
    FROM calificacion
    WHERE id_contratacion = p_id_contratacion AND tipo = p_tipo;

    IF v_calificacion_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Esta contratación ya fue calificada';
    END IF;

    -- Validar rango de calificación
    IF p_calificacion < 1 OR p_calificacion > 5 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La calificación debe estar entre 1 y 5';
    END IF;

    -- Crear calificación
    INSERT INTO calificacion (id_contratacion, calificacion, comentario, tipo)
    VALUES (p_id_contratacion, p_calificacion, p_comentario, p_tipo);

    SET p_out_id_calificacion = LAST_INSERT_ID();

    -- *** LÓGICA DEL TRIGGER IMPLEMENTADA AQUÍ ***
    -- Si es calificación de cliente a empresa, actualizar promedio de la empresa
    IF p_tipo = 'cliente_a_empresa' THEN
        -- Obtener el ID de la empresa
        SELECT s.id_empresa INTO v_id_empresa
        FROM contratacion c
        INNER JOIN servicio s ON c.id_servicio = s.id_servicio
        WHERE c.id_contratacion = p_id_contratacion;

        -- Calcular nuevo promedio
        SELECT AVG(cal.calificacion) INTO v_nuevo_promedio
        FROM calificacion cal
        INNER JOIN contratacion c ON cal.id_contratacion = c.id_contratacion
        INNER JOIN servicio s ON c.id_servicio = s.id_servicio
        WHERE s.id_empresa = v_id_empresa
        AND cal.tipo = 'cliente_a_empresa';

        -- Actualizar promedio en tabla empresa
        UPDATE empresa
        SET calificacion_promedio = IFNULL(v_nuevo_promedio, 0)
        WHERE id_empresa = v_id_empresa;
    END IF;

    SET p_out_mensaje = 'Calificación creada exitosamente';

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_crear_contratacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_contratacion`(
    IN p_id_cliente INT,
    IN p_id_servicio INT,
    IN p_id_sucursal INT,
    IN p_id_direccion_entrega INT,
    IN p_id_cupon INT,
    IN p_fecha_programada DATETIME,
    IN p_precio_subtotal DECIMAL(10,2),
    IN p_descuento_aplicado DECIMAL(10,2),
    IN p_precio_total DECIMAL(10,2),
    IN p_porcentaje_comision DECIMAL(5,2),
    IN p_notas_cliente TEXT,
    OUT p_out_id_contratacion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_cupon_valido INT DEFAULT 0;
    DECLARE v_cupon_disponible INT;
    DECLARE v_cupon_usado INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_id_contratacion = NULL;
        SET p_out_mensaje = 'Error al crear contratación';
    END;

    START TRANSACTION;

    -- Validar que el cliente exista
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;

    -- Validar que el servicio exista
    IF NOT EXISTS (SELECT 1 FROM servicio WHERE id_servicio = p_id_servicio) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El servicio no existe';
    END IF;

    -- Validar cupón si se proporciona
    IF p_id_cupon IS NOT NULL THEN
        SELECT
            CASE
                WHEN activo = 1
                AND (fecha_expiracion IS NULL OR fecha_expiracion > NOW())
                AND (cantidad_disponible IS NULL OR cantidad_usada < cantidad_disponible)
                THEN 1
                ELSE 0
            END,
            cantidad_disponible,
            cantidad_usada
        INTO v_cupon_valido, v_cupon_disponible, v_cupon_usado
        FROM cupon
        WHERE id_cupon = p_id_cupon;

        IF v_cupon_valido = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'El cupón no es válido o está agotado';
        END IF;
    END IF;

    -- Crear contratación
    INSERT INTO contratacion (
        id_cliente, id_servicio, id_sucursal, id_direccion_entrega, id_cupon,
        fecha_programada, precio_subtotal, descuento_aplicado, precio_total,
        porcentaje_comision, estado, notas_cliente
    ) VALUES (
        p_id_cliente, p_id_servicio, p_id_sucursal, p_id_direccion_entrega, p_id_cupon,
        p_fecha_programada, p_precio_subtotal, IFNULL(p_descuento_aplicado, 0),
        p_precio_total, IFNULL(p_porcentaje_comision, 15.00), 'pendiente', p_notas_cliente
    );

    SET p_out_id_contratacion = LAST_INSERT_ID();

    -- *** LÓGICA DEL TRIGGER IMPLEMENTADA AQUÍ ***
    -- Incrementar uso del cupón si se usó uno
    IF p_id_cupon IS NOT NULL THEN
        UPDATE cupon
        SET cantidad_usada = cantidad_usada + 1
        WHERE id_cupon = p_id_cupon;
    END IF;

    -- *** REGISTRAR EN HISTORIAL ***
    INSERT INTO historial_estado_contratacion (
        id_contratacion, estado_anterior, estado_nuevo, notas
    ) VALUES (
        p_out_id_contratacion, NULL, 'pendiente', 'Contratación creada'
    );

    SET p_out_mensaje = 'Contratación creada exitosamente';

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_crear_cupon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_cupon`(
    IN p_codigo VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_tipo_descuento ENUM('porcentaje', 'monto_fijo'),
    IN p_valor_descuento DECIMAL(10,2),
    IN p_monto_minimo DECIMAL(10,2),
    IN p_cantidad_disponible INT,
    IN p_fecha_inicio DATETIME,
    IN p_fecha_expiracion DATETIME,
    IN p_id_empresa INT,
    OUT p_id_cupon INT,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_id_cupon = NULL;
        SET p_mensaje = 'Error al crear el cupón. El código podría estar duplicado.';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar si el código ya existe
    IF EXISTS (SELECT 1 FROM cupon WHERE codigo = p_codigo) THEN
        SET p_id_cupon = NULL;
        SET p_mensaje = 'El código del cupón ya existe.';
    ELSE
        INSERT INTO cupon (
            codigo, 
            descripcion,
            tipo_descuento, 
            valor_descuento, 
            monto_minimo_compra, 
            cantidad_disponible, 
            cantidad_usada, 
            fecha_inicio,
            fecha_expiracion, 
            activo, 
            aplicable_a, -- Por defecto 'todos' los servicios de la empresa para simplificar
            id_empresa
        ) VALUES (
            UPPER(p_codigo),
            p_descripcion, 
            p_tipo_descuento, 
            p_valor_descuento, 
            p_monto_minimo, 
            p_cantidad_disponible, 
            0, -- Cantidad usada inicia en 0
            p_fecha_inicio,
            p_fecha_expiracion, 
            1, -- Activo por defecto
            'todos', 
            p_id_empresa
        );
        
        SET p_id_cupon = LAST_INSERT_ID();
        SET p_mensaje = 'Cupón creado exitosamente.';
    END IF;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_crear_mensaje` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_mensaje`(
    IN p_id_conversacion INT,
    IN p_id_remitente INT,
    IN p_contenido TEXT,
    IN p_tipo_mensaje ENUM('texto', 'imagen', 'archivo'),
    IN p_archivo_url VARCHAR(500),
    OUT p_out_id_mensaje INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_id_mensaje = NULL;
        SET p_out_mensaje = 'Error al crear mensaje';
    END;

    START TRANSACTION;

    -- Validar que la conversación exista
    IF NOT EXISTS (SELECT 1 FROM conversacion WHERE id_conversacion = p_id_conversacion) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La conversación no existe';
    END IF;

    -- Validar que el contenido no esté vacío (solo para mensajes de texto)
    IF (p_tipo_mensaje = 'texto' OR p_tipo_mensaje IS NULL) AND (p_contenido IS NULL OR TRIM(p_contenido) = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El contenido del mensaje no puede estar vacío';
    END IF;

    -- Crear mensaje
    INSERT INTO mensaje (id_conversacion, id_remitente, contenido, tipo_mensaje, archivo_url)
    VALUES (
        p_id_conversacion,
        p_id_remitente,
        p_contenido,
        IFNULL(p_tipo_mensaje, 'texto'),
        p_archivo_url
    );

    SET p_out_id_mensaje = LAST_INSERT_ID();

    -- *** LÓGICA DEL TRIGGER IMPLEMENTADA AQUÍ ***
    -- Actualizar fecha del último mensaje en la conversación
    UPDATE conversacion
    SET fecha_ultimo_mensaje = NOW()
    WHERE id_conversacion = p_id_conversacion;

    SET p_out_mensaje = 'Mensaje creado exitosamente';

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_crear_sucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_sucursal`(
    -- Datos de la sucursal
    IN p_id_empresa INT,
    IN p_nombre_sucursal VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_horario_apertura TIME,
    IN p_horario_cierre TIME,
    IN p_dias_laborales VARCHAR(7),
    IN p_estado ENUM('activa', 'inactiva'),
    -- Datos de la dirección
    IN p_calle_principal VARCHAR(255),
    IN p_calle_secundaria VARCHAR(255),
    IN p_numero VARCHAR(20),
    IN p_ciudad VARCHAR(100),
    IN p_provincia_estado VARCHAR(100),
    IN p_codigo_postal VARCHAR(20),
    IN p_pais VARCHAR(100),
    IN p_latitud DECIMAL(10,8),
    IN p_longitud DECIMAL(11,8),
    IN p_referencia TEXT,
    -- Parámetros de salida
    OUT p_out_id_sucursal INT,
    OUT p_out_id_direccion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_empresa_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_id_sucursal = NULL;
        SET p_out_id_direccion = NULL;
        SET p_out_mensaje = 'Error al crear sucursal';
    END;

    START TRANSACTION;

    -- Validar que la empresa exista
    SELECT COUNT(*) INTO v_empresa_count FROM empresa WHERE id_empresa = p_id_empresa;
    IF v_empresa_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La empresa no existe';
    END IF;

    -- Validar datos obligatorios
    IF p_calle_principal IS NULL OR p_ciudad IS NULL OR p_provincia_estado IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Calle principal, ciudad y provincia son obligatorios';
    END IF;

    IF p_nombre_sucursal IS NULL OR p_nombre_sucursal = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nombre de sucursal es obligatorio';
    END IF;

    -- Crear dirección
    INSERT INTO direccion (
        calle_principal, calle_secundaria, numero, ciudad, provincia_estado,
        codigo_postal, pais, latitud, longitud, referencia
    ) VALUES (
        p_calle_principal, p_calle_secundaria, p_numero, p_ciudad, p_provincia_estado,
        p_codigo_postal, IFNULL(p_pais, 'Ecuador'), p_latitud, p_longitud, p_referencia
    );

    SET p_out_id_direccion = LAST_INSERT_ID();

    -- Crear sucursal
    INSERT INTO sucursal (
        id_empresa, id_direccion, nombre_sucursal, telefono,
        horario_apertura, horario_cierre, dias_laborales, estado
    ) VALUES (
        p_id_empresa, p_out_id_direccion, p_nombre_sucursal, p_telefono,
        p_horario_apertura, p_horario_cierre, IFNULL(p_dias_laborales, '1111100'),
        IFNULL(p_estado, 'activa')
    );

    SET p_out_id_sucursal = LAST_INSERT_ID();
    SET p_out_mensaje = 'Sucursal creada exitosamente';

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_editar_cupon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_editar_cupon`(
    IN p_id_cupon INT,
    IN p_codigo VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_tipo_descuento ENUM('porcentaje', 'monto_fijo'),
    IN p_valor_descuento DECIMAL(10,2),
    IN p_monto_minimo DECIMAL(10,2),
    IN p_cantidad_disponible INT,
    IN p_fecha_inicio DATETIME,
    IN p_fecha_expiracion DATETIME,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_mensaje = 'Error al actualizar el cupón.';
        ROLLBACK;
    END;

    START TRANSACTION;
    
    -- Verificar si existe otro cupón con el mismo código (excluyendo el actual)
    IF EXISTS (SELECT 1 FROM cupon WHERE codigo = p_codigo AND id_cupon != p_id_cupon) THEN
        SET p_mensaje = 'El código ya está en uso por otro cupón.';
    ELSE
        UPDATE cupon SET 
            codigo = UPPER(p_codigo),
            descripcion = p_descripcion,
            tipo_descuento = p_tipo_descuento,
            valor_descuento = p_valor_descuento,
            monto_minimo_compra = p_monto_minimo,
            cantidad_disponible = p_cantidad_disponible,
            fecha_inicio = p_fecha_inicio,
            fecha_expiracion = p_fecha_expiracion
        WHERE id_cupon = p_id_cupon;
        
        SET p_mensaje = 'Cupón actualizado correctamente.';
    END IF;
    
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_eliminar_cupon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_cupon`(
    IN p_id_cupon INT,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DELETE FROM cupon WHERE id_cupon = p_id_cupon;
    SET p_mensaje = 'Cupón eliminado correctamente.';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_establecer_direccion_principal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_establecer_direccion_principal`(
    IN p_id_cliente INT,
    IN p_id_direccion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_direccion_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_mensaje = 'Error al establecer dirección principal';
    END;

    START TRANSACTION;

    -- Validar que la relación cliente-dirección exista
    SELECT COUNT(*) INTO v_direccion_count
    FROM direcciones_del_cliente
    WHERE id_cliente = p_id_cliente AND id_direccion = p_id_direccion;

    IF v_direccion_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La dirección no pertenece al cliente';
    END IF;

    -- Desmarcar todas las direcciones principales del cliente
    UPDATE direcciones_del_cliente
    SET es_principal = 0
    WHERE id_cliente = p_id_cliente;

    -- Marcar la nueva dirección como principal
    UPDATE direcciones_del_cliente
    SET es_principal = 1
    WHERE id_cliente = p_id_cliente AND id_direccion = p_id_direccion;

    SET p_out_mensaje = 'Dirección principal establecida exitosamente';

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_cupones_empresa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_cupones_empresa`(
    IN p_id_empresa INT
)
BEGIN
    SELECT 
        id_cupon, 
        codigo, 
        tipo_descuento, 
        valor_descuento, 
        monto_minimo_compra, 
        cantidad_disponible, 
        cantidad_usada, 
        fecha_expiracion, 
        activo
    FROM cupon
    WHERE id_empresa = p_id_empresa
    ORDER BY fecha_expiracion DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_usuario`(
    -- Datos del usuario
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255),
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_tipo_usuario ENUM('cliente', 'empresa'),
    -- Datos específicos de empresa (opcionales)
    IN p_razon_social VARCHAR(255),
    IN p_ruc_nit VARCHAR(50),
    IN p_pais VARCHAR(100),
    -- Parámetros de salida
    OUT p_out_id_usuario INT,
    OUT p_out_id_entidad INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_email_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_id_usuario = NULL;
        SET p_out_id_entidad = NULL;
        SET p_out_mensaje = 'Error al registrar usuario';
    END;

    START TRANSACTION;

    -- Validar que el email no exista
    SELECT COUNT(*) INTO v_email_count FROM usuario WHERE email = p_email;
    IF v_email_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El email ya está registrado';
    END IF;

    -- Validar tipo de usuario
    IF p_tipo_usuario NOT IN ('cliente', 'empresa') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Tipo de usuario inválido';
    END IF;

    -- Validar datos de empresa si es tipo empresa
    IF p_tipo_usuario = 'empresa' AND (p_razon_social IS NULL OR p_razon_social = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Razón social es requerida para empresas';
    END IF;

    -- Crear usuario
    INSERT INTO usuario (email, password_hash, nombre, apellido, telefono, tipo_usuario)
    VALUES (p_email, p_password_hash, p_nombre, p_apellido, p_telefono, p_tipo_usuario);

    SET p_out_id_usuario = LAST_INSERT_ID();

    -- Crear entidad según tipo
    IF p_tipo_usuario = 'cliente' THEN
        INSERT INTO cliente (id_usuario) VALUES (p_out_id_usuario);
        SET p_out_id_entidad = LAST_INSERT_ID();
        SET p_out_mensaje = 'Cliente registrado exitosamente';
    ELSE
        INSERT INTO empresa (id_usuario, razon_social, ruc_nit, pais)
        VALUES (p_out_id_usuario, p_razon_social, p_ruc_nit, p_pais);
        SET p_out_id_entidad = LAST_INSERT_ID();
        SET p_out_mensaje = 'Empresa registrada exitosamente';
    END IF;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_servicios_por_ubicacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_servicios_por_ubicacion`(
    IN p_ciudad VARCHAR(100),
    IN p_id_categoria INT
)
BEGIN
    SELECT DISTINCT
        s.id_servicio,
        s.nombre,
        s.descripcion,
        s.precio_base,
        s.imagen_url,
        e.razon_social,
        e.calificacion_promedio,
        suc.nombre_sucursal,
        d.ciudad,
        -- ⭐ Incluir detalles específicos del enfoque híbrido
        suc.piso,
        suc.numero_local,
        CONCAT(
            d.calle_principal,
            IFNULL(CONCAT(', Piso ', suc.piso), ''),
            IFNULL(CONCAT(', Local ', suc.numero_local), '')
        ) AS direccion_formateada
    FROM servicio s
    INNER JOIN servicio_sucursal ss ON s.id_servicio = ss.id_servicio
    INNER JOIN sucursal suc ON ss.id_sucursal = suc.id_sucursal
    INNER JOIN direccion d ON suc.id_direccion = d.id_direccion
    INNER JOIN empresa e ON s.id_empresa = e.id_empresa
    WHERE d.ciudad = p_ciudad
    AND s.estado = 'disponible'
    AND ss.disponible = TRUE
    AND suc.estado = 'activa'
    AND (p_id_categoria IS NULL OR s.id_categoria = p_id_categoria)
    ORDER BY e.calificacion_promedio DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_validar_cupon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validar_cupon`(
    IN p_codigo VARCHAR(50),
    IN p_id_servicio INT,
    IN p_monto_compra DECIMAL(10,2),
    OUT p_valido TINYINT, -- 1 = true, 0 = false
    OUT p_descuento DECIMAL(10,2),
    OUT p_precio_final DECIMAL(10,2),
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_id_cupon INT;
    DECLARE v_tipo_descuento ENUM('porcentaje', 'monto_fijo');
    DECLARE v_valor_descuento DECIMAL(10,2);
    DECLARE v_monto_minimo DECIMAL(10,2);
    DECLARE v_cantidad_disponible INT;
    DECLARE v_cantidad_usada INT;
    DECLARE v_fecha_expiracion DATETIME;
    DECLARE v_activo TINYINT;
    DECLARE v_aplicable_a VARCHAR(50);
    DECLARE v_empresa_cupon INT;
    DECLARE v_empresa_servicio INT;

    -- Inicializar valores por defecto
    SET p_valido = 0;
    SET p_descuento = 0.00;
    SET p_precio_final = p_monto_compra;
    SET p_mensaje = '';

    -- 1. Buscar el cupón
    SELECT 
        id_cupon, tipo_descuento, valor_descuento, monto_minimo_compra,
        cantidad_disponible, cantidad_usada, fecha_expiracion, activo,
        aplicable_a, id_empresa
    INTO 
        v_id_cupon, v_tipo_descuento, v_valor_descuento, v_monto_minimo,
        v_cantidad_disponible, v_cantidad_usada, v_fecha_expiracion, v_activo,
        v_aplicable_a, v_empresa_cupon
    FROM cupon 
    WHERE codigo = p_codigo;

    -- 2. Validaciones
    IF v_id_cupon IS NULL THEN
        SET p_mensaje = 'Cupón no encontrado';
    ELSEIF v_activo = 0 THEN
        SET p_mensaje = 'El cupón está inactivo';
    ELSEIF v_fecha_expiracion IS NOT NULL AND v_fecha_expiracion < NOW() THEN
        SET p_mensaje = 'El cupón ha expirado';
    ELSEIF v_cantidad_disponible IS NOT NULL AND v_cantidad_usada >= v_cantidad_disponible THEN
        SET p_mensaje = 'El cupón se ha agotado';
    ELSEIF p_monto_compra < v_monto_minimo THEN
        SET p_mensaje = CONCAT('El monto mínimo de compra es $', v_monto_minimo);
    ELSE
        -- Validar que el cupón pertenezca a la misma empresa del servicio
        SELECT id_empresa INTO v_empresa_servicio FROM servicio WHERE id_servicio = p_id_servicio;
        
        IF v_empresa_cupon != v_empresa_servicio THEN
            SET p_mensaje = 'Este cupón no es válido para este servicio (diferente empresa)';
        ELSE
            -- 3. Calcular Descuento
            IF v_tipo_descuento = 'porcentaje' THEN
                SET p_descuento = (p_monto_compra * v_valor_descuento) / 100;
            ELSE
                SET p_descuento = v_valor_descuento;
            END IF;

            -- Ajustar si el descuento es mayor al total (no dar dinero, solo gratis)
            IF p_descuento > p_monto_compra THEN
                SET p_descuento = p_monto_compra;
            END IF;

            SET p_precio_final = p_monto_compra - p_descuento;
            SET p_valido = 1;
            SET p_mensaje = 'Cupón aplicado correctamente';
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vista_contrataciones_detalle`
--

/*!50001 DROP VIEW IF EXISTS `vista_contrataciones_detalle`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_contrataciones_detalle` AS select `con`.`id_contratacion` AS `id_contratacion`,`con`.`fecha_solicitud` AS `fecha_solicitud`,`con`.`fecha_programada` AS `fecha_programada`,`con`.`estado` AS `estado_contratacion`,`con`.`precio_total` AS `precio_total`,concat(`uc`.`nombre`,' ',`uc`.`apellido`) AS `cliente_nombre`,`uc`.`email` AS `cliente_email`,`s`.`nombre` AS `servicio_nombre`,`e`.`razon_social` AS `empresa_nombre`,`suc`.`nombre_sucursal` AS `nombre_sucursal`,concat(`d`.`calle_principal`,', ',`d`.`ciudad`) AS `direccion_entrega`,`cup`.`codigo` AS `cupon_codigo`,`con`.`descuento_aplicado` AS `descuento_aplicado` from ((((((((`contratacion` `con` join `cliente` `cli` on((`con`.`id_cliente` = `cli`.`id_cliente`))) join `usuario` `uc` on((`cli`.`id_usuario` = `uc`.`id_usuario`))) join `servicio` `s` on((`con`.`id_servicio` = `s`.`id_servicio`))) join `empresa` `e` on((`s`.`id_empresa` = `e`.`id_empresa`))) join `usuario` `ue` on((`e`.`id_usuario` = `ue`.`id_usuario`))) join `sucursal` `suc` on((`con`.`id_sucursal` = `suc`.`id_sucursal`))) join `direccion` `d` on((`con`.`id_direccion_entrega` = `d`.`id_direccion`))) left join `cupon` `cup` on((`con`.`id_cupon` = `cup`.`id_cupon`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_estadisticas_empresa`
--

/*!50001 DROP VIEW IF EXISTS `vista_estadisticas_empresa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_estadisticas_empresa` AS select `e`.`id_empresa` AS `id_empresa`,`e`.`razon_social` AS `razon_social`,`e`.`logo_url` AS `logo_url`,`e`.`calificacion_promedio` AS `calificacion_promedio`,count(distinct `s`.`id_servicio`) AS `total_servicios`,count(distinct `suc`.`id_sucursal`) AS `total_sucursales`,count(distinct `con`.`id_contratacion`) AS `total_contrataciones`,sum((case when (`con`.`estado` = 'completado') then `con`.`precio_total` else 0 end)) AS `ingresos_totales`,count(distinct `cup`.`id_cupon`) AS `cupones_activos` from ((((`empresa` `e` left join `servicio` `s` on((`e`.`id_empresa` = `s`.`id_empresa`))) left join `sucursal` `suc` on((`e`.`id_empresa` = `suc`.`id_empresa`))) left join `contratacion` `con` on((`s`.`id_servicio` = `con`.`id_servicio`))) left join `cupon` `cup` on(((`e`.`id_empresa` = `cup`.`id_empresa`) and (`cup`.`activo` = true)))) group by `e`.`id_empresa`,`e`.`razon_social`,`e`.`logo_url`,`e`.`calificacion_promedio` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_servicios_completos`
--

/*!50001 DROP VIEW IF EXISTS `vista_servicios_completos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_servicios_completos` AS select `s`.`id_servicio` AS `id_servicio`,`s`.`nombre` AS `servicio_nombre`,`s`.`descripcion` AS `descripcion`,`s`.`precio_base` AS `precio_base`,`s`.`duracion_estimada` AS `duracion_estimada`,`s`.`estado` AS `servicio_estado`,`c`.`nombre` AS `categoria_nombre`,`e`.`razon_social` AS `empresa_nombre`,`e`.`calificacion_promedio` AS `empresa_calificacion`,`u`.`email` AS `empresa_email`,`u`.`telefono` AS `empresa_telefono` from (((`servicio` `s` join `categoria_servicio` `c` on((`s`.`id_categoria` = `c`.`id_categoria`))) join `empresa` `e` on((`s`.`id_empresa` = `e`.`id_empresa`))) join `usuario` `u` on((`e`.`id_usuario` = `u`.`id_usuario`))) where (`s`.`estado` = 'disponible') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_sucursales_direccion_completa`
--

/*!50001 DROP VIEW IF EXISTS `vista_sucursales_direccion_completa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_sucursales_direccion_completa` AS select `suc`.`id_sucursal` AS `id_sucursal`,`suc`.`nombre_sucursal` AS `nombre_sucursal`,`e`.`razon_social` AS `empresa_nombre`,`d`.`calle_principal` AS `calle_principal`,`d`.`calle_secundaria` AS `calle_secundaria`,`d`.`numero` AS `numero`,`d`.`ciudad` AS `ciudad`,`d`.`provincia_estado` AS `provincia_estado`,`d`.`codigo_postal` AS `codigo_postal`,`d`.`pais` AS `pais`,`d`.`latitud` AS `latitud`,`d`.`longitud` AS `longitud`,`suc`.`piso` AS `piso`,`suc`.`numero_local` AS `numero_local`,`suc`.`referencias_especificas` AS `referencias_especificas`,concat(`d`.`calle_principal`,ifnull(concat(' y ',`d`.`calle_secundaria`),''),ifnull(concat(' N°',`d`.`numero`),''),ifnull(concat(', Piso ',`suc`.`piso`),''),ifnull(concat(', Local ',`suc`.`numero_local`),''),', ',`d`.`ciudad`,', ',`d`.`provincia_estado`) AS `direccion_completa`,`suc`.`telefono` AS `telefono`,`suc`.`horario_apertura` AS `horario_apertura`,`suc`.`horario_cierre` AS `horario_cierre`,`suc`.`estado` AS `estado` from ((`sucursal` `suc` join `direccion` `d` on((`suc`.`id_direccion` = `d`.`id_direccion`))) join `empresa` `e` on((`suc`.`id_empresa` = `e`.`id_empresa`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-27 23:01:30
