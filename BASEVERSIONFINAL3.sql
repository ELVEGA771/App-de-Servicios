CREATE DATABASE  IF NOT EXISTS `app_servicios` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `app_servicios`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: app_servicios
-- ------------------------------------------------------
-- Server version	8.4.6

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
  `id_contratacion` int NOT NULL,
  `calificacion` tinyint NOT NULL,
  `comentario` text COLLATE utf8mb4_unicode_ci,
  `fecha_calificacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `tipo` enum('cliente_a_empresa','empresa_a_cliente') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_calificacion`),
  KEY `idx_contratacion` (`id_contratacion`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_calificacion` (`calificacion`),
  CONSTRAINT `calificacion_ibfk_1` FOREIGN KEY (`id_contratacion`) REFERENCES `contratacion` (`id_contratacion`) ON DELETE CASCADE
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
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `icono_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (5,26,NULL),(6,27,NULL),(7,32,NULL);
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
  `estado` enum('pendiente','confirmado','en_proceso','completado','cancelado','rechazado') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `notas_cliente` text COLLATE utf8mb4_unicode_ci,
  `notas_empresa` text COLLATE utf8mb4_unicode_ci,
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contratacion`
--

LOCK TABLES `contratacion` WRITE;
/*!40000 ALTER TABLE `contratacion` DISABLE KEYS */;
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
  `estado` enum('abierta','cerrada','archivada') COLLATE utf8mb4_unicode_ci DEFAULT 'abierta',
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
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_descuento` enum('porcentaje','monto_fijo') COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_descuento` decimal(10,2) NOT NULL,
  `monto_minimo_compra` decimal(10,2) DEFAULT '0.00',
  `cantidad_disponible` int DEFAULT NULL,
  `cantidad_usada` int DEFAULT '0',
  `fecha_inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_expiracion` datetime DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `aplicable_a` enum('todos','categoria','servicio_especifico') COLLATE utf8mb4_unicode_ci DEFAULT 'todos',
  PRIMARY KEY (`id_cupon`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `idx_codigo` (`codigo`),
  KEY `idx_empresa` (`id_empresa`),
  KEY `idx_activo` (`activo`),
  KEY `idx_fecha_expiracion` (`fecha_expiracion`),
  CONSTRAINT `cupon_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupon`
--

LOCK TABLES `cupon` WRITE;
/*!40000 ALTER TABLE `cupon` DISABLE KEYS */;
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
  `calle_principal` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `calle_secundaria` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ciudad` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provincia_estado` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_postal` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pais` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Ecuador',
  `latitud` decimal(10,8) DEFAULT NULL,
  `longitud` decimal(11,8) DEFAULT NULL,
  `referencia` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_direccion`),
  KEY `idx_ciudad` (`ciudad`),
  KEY `idx_coordenadas` (`latitud`,`longitud`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direccion`
--

LOCK TABLES `direccion` WRITE;
/*!40000 ALTER TABLE `direccion` DISABLE KEYS */;
INSERT INTO `direccion` VALUES (5,'Av.10 de Agosto','y 6 de Diciembre',NULL,'Quito','Pichincha',NULL,'Ecuador',NULL,NULL,NULL),(6,'Av.Eloy Alfaro','y De los Guayacanes','E13-135','Quito','Pichicnha',NULL,'Ecuador',NULL,NULL,NULL),(7,'Calle Principal','Calle Secundaria','32','Quito','Pichincha',NULL,'Ecuador',NULL,NULL,'Casa Cafe'),(8,'Calle Principal','Calle Secundaria','N34-123','Cuenca','Azuay','127389','Ecuador',NULL,NULL,NULL),(9,'Calle Principal','Calle Secundaria','E13-135','Guayaquil','Guayas',NULL,'Ecuador',NULL,NULL,NULL),(10,'Calle china 1','Calle china 2','N54-16','Zhengen','Chang',NULL,'Ecuador',NULL,NULL,NULL);
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
  `alias` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
INSERT INTO `direcciones_del_cliente` VALUES (6,7,'Casa',0);
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
  `razon_social` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruc_nit` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `logo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `calificacion_promedio` decimal(3,2) DEFAULT '0.00',
  `fecha_verificacion` datetime DEFAULT NULL,
  `pais` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_empresa`),
  UNIQUE KEY `ruc_nit` (`ruc_nit`),
  KEY `idx_calificacion` (`calificacion_promedio`),
  KEY `fk_empresa_usuario1_idx` (`id_usuario`),
  CONSTRAINT `fk_empresa_usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresa`
--

LOCK TABLES `empresa` WRITE;
/*!40000 ALTER TABLE `empresa` DISABLE KEYS */;
INSERT INTO `empresa` VALUES (3,28,'Empresa1',NULL,NULL,NULL,0.00,NULL,'Ecuador'),(5,30,'Empresa 2',NULL,NULL,NULL,0.00,NULL,'Mexico'),(6,33,'Empresa 3',NULL,NULL,NULL,0.00,NULL,'China');
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
  `estado_anterior` enum('pendiente','confirmado','en_proceso','completado','cancelado','rechazado') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_nuevo` enum('pendiente','confirmado','en_proceso','completado','cancelado','rechazado') COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_cambio` datetime DEFAULT CURRENT_TIMESTAMP,
  `notas` text COLLATE utf8mb4_unicode_ci,
  `id_usuario_responsable` int DEFAULT NULL,
  PRIMARY KEY (`id_historial`),
  KEY `idx_hist_contratacion` (`id_contratacion`),
  CONSTRAINT `fk_historial_contratacion` FOREIGN KEY (`id_contratacion`) REFERENCES `contratacion` (`id_contratacion`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_estado_contratacion`
--

LOCK TABLES `historial_estado_contratacion` WRITE;
/*!40000 ALTER TABLE `historial_estado_contratacion` DISABLE KEYS */;
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
  `contenido` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_mensaje` enum('texto','imagen','archivo','audio') COLLATE utf8mb4_unicode_ci DEFAULT 'texto',
  `archivo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contenido` text COLLATE utf8mb4_unicode_ci,
  `tipo` enum('nuevo_mensaje','cambio_estado','nuevo_cupon','calificacion','pago','sistema') COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia_id` int DEFAULT NULL COMMENT 'ID de la entidad relacionada',
  `referencia_tipo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de entidad (mensaje, contratacion, cupon, etc)',
  `leida` tinyint(1) DEFAULT '0',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_lectura` datetime DEFAULT NULL,
  PRIMARY KEY (`id_notificacion`),
  KEY `idx_usuario` (`id_usuario`),
  KEY `idx_leida` (`leida`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_fecha_creacion` (`fecha_creacion`),
  CONSTRAINT `notificacion_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacion`
--

LOCK TABLES `notificacion` WRITE;
/*!40000 ALTER TABLE `notificacion` DISABLE KEYS */;
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
  `metodo_pago` enum('tarjeta_credito','tarjeta_debito','efectivo','transferencia','paypal','otro') COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_pago` enum('pendiente','completado','fallido','reembolsado') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `fecha_pago` datetime DEFAULT CURRENT_TIMESTAMP,
  `referencia_transaccion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `idx_contratacion` (`id_contratacion`),
  KEY `idx_estado_pago` (`estado_pago`),
  KEY `idx_referencia` (`referencia_transaccion`),
  CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`id_contratacion`) REFERENCES `contratacion` (`id_contratacion`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pago`
--

LOCK TABLES `pago` WRITE;
/*!40000 ALTER TABLE `pago` DISABLE KEYS */;
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
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `precio_base` decimal(10,2) NOT NULL,
  `duracion_estimada` int DEFAULT NULL COMMENT 'Duración en minutos',
  `imagen_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('disponible','no_disponible','agotado') COLLATE utf8mb4_unicode_ci DEFAULT 'disponible',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_servicio`),
  KEY `idx_empresa` (`id_empresa`),
  KEY `idx_categoria` (`id_categoria`),
  KEY `idx_estado` (`estado`),
  KEY `idx_servicio_empresa_estado` (`id_empresa`,`estado`),
  CONSTRAINT `servicio_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE,
  CONSTRAINT `servicio_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categoria_servicio` (`id_categoria`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio`
--

LOCK TABLES `servicio` WRITE;
/*!40000 ALTER TABLE `servicio` DISABLE KEYS */;
INSERT INTO `servicio` VALUES (7,3,4,'Limpieza de autos','Limpieza profesional de autos a domicilio.',50.00,2,NULL,'disponible','2025-11-24 20:12:22'),(8,3,4,'Limpieza de vehiculos','Limpieza de alta calidad de vehiculos a domicilio',40.00,2,'http://localhost:5001/uploads/1764036204942-486800943.png','disponible','2025-11-24 21:06:05'),(9,6,12,'Venta de ninios inteligentes','venden ninios inteligentes para uso domestico',300.00,24,'http://localhost:5001/uploads/1764089453020-295311864.png','disponible','2025-11-25 11:50:57');
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
  `notas_cliente` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
INSERT INTO `servicio_favorito` VALUES (7,6,'2025-11-24 20:23:34',NULL);
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
INSERT INTO `servicio_sucursal` VALUES (9,7,1,NULL);
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
  `nombre_sucursal` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `piso` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Piso específico dentro del edificio',
  `numero_local` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Número de local/oficina',
  `referencias_especificas` text COLLATE utf8mb4_unicode_ci COMMENT 'Referencias únicas para esta sucursal',
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `horario_apertura` time DEFAULT NULL,
  `horario_cierre` time DEFAULT NULL,
  `dias_laborales` char(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('activa','inactiva','temporal') COLLATE utf8mb4_unicode_ci DEFAULT 'activa',
  PRIMARY KEY (`id_sucursal`),
  KEY `idx_empresa` (`id_empresa`),
  KEY `idx_direccion` (`id_direccion`),
  KEY `idx_estado` (`estado`),
  CONSTRAINT `sucursal_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE,
  CONSTRAINT `sucursal_ibfk_2` FOREIGN KEY (`id_direccion`) REFERENCES `direccion` (`id_direccion`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sucursal`
--

LOCK TABLES `sucursal` WRITE;
/*!40000 ALTER TABLE `sucursal` DISABLE KEYS */;
INSERT INTO `sucursal` VALUES (6,3,9,'Sucursal Guayakill',NULL,NULL,NULL,'0987654321','09:50:00','20:00:00','1101100','activa'),(7,6,10,'cursal Zhengen',NULL,NULL,NULL,'0987654321','11:00:00','18:00:00','1101101','activa');
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
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_usuario` enum('cliente','empresa','empleado','admin') COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto_perfil_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` enum('activo','inactivo','suspendido') COLLATE utf8mb4_unicode_ci DEFAULT 'activo',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_tipo_usuario` (`tipo_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (26,'test@ejemplo.com','$2b$10$v8ypl8XzdbgRn4YN6NQ4Nuh/ZWL2ye4Lx3UDfBSH83D5cQBMzhv8W','Usuario','Prueba','0999999999','cliente',NULL,'2025-11-22 18:02:55','activo'),(27,'andyvega77@hotmail.com','$2b$10$Rv7yw9ZWLiCZLp5OvWC2r.wXdBGlerOpWASOqYPm/dE8SwxoBzjEC','Andres','Vega','0994367670','cliente',NULL,'2025-11-22 19:07:49','activo'),(28,'empresa1@empresa.com','$2b$10$mi96yOt9LmYm0EdZgTKOM.2yoGmAvrBIMul2ccv7u0FFjTDutHTfG','Empresa1','Xd',NULL,'empresa',NULL,'2025-11-24 19:37:45','activo'),(30,'empresa2@empresa.com','$2b$10$2/zdTR7tVvv1sY/yCBLIluktRgpVPGDXX3WEBb7e4zhZZESOl.CPO','Julio','Ibarra',NULL,'empresa',NULL,'2025-11-24 22:16:09','activo'),(32,'cliente01@gmail.com','$2b$10$Ii2QSnCcmZomedY2wjJOX.sN2ilavYW1xLnbasdt/Dz/MqWYQ52ZS','Jarod','Tierra','0987654321','cliente',NULL,'2025-11-24 22:22:37','activo'),(33,'empresa3@empresa.com','$2b$10$zXTqDjznA/Mgkfi3JVH1out9ziRNyQRGRBQtq2DO6LLOsxkiusxs6','Pepito','Vargas','0987654321','empresa',NULL,'2025-11-25 11:48:16','activo');
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
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_estadisticas_empresa` AS select `e`.`id_empresa` AS `id_empresa`,`e`.`razon_social` AS `razon_social`,`e`.`calificacion_promedio` AS `calificacion_promedio`,count(distinct `s`.`id_servicio`) AS `total_servicios`,count(distinct `suc`.`id_sucursal`) AS `total_sucursales`,count(distinct `con`.`id_contratacion`) AS `total_contrataciones`,sum((case when (`con`.`estado` = 'completado') then `con`.`precio_total` else 0 end)) AS `ingresos_totales`,count(distinct `cup`.`id_cupon`) AS `cupones_activos` from ((((`empresa` `e` left join `servicio` `s` on((`e`.`id_empresa` = `s`.`id_empresa`))) left join `sucursal` `suc` on((`e`.`id_empresa` = `suc`.`id_empresa`))) left join `contratacion` `con` on((`s`.`id_servicio` = `con`.`id_servicio`))) left join `cupon` `cup` on(((`e`.`id_empresa` = `cup`.`id_empresa`) and (`cup`.`activo` = true)))) group by `e`.`id_empresa`,`e`.`razon_social`,`e`.`calificacion_promedio` */;
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

-- Dump completed on 2025-11-25 12:49:31
