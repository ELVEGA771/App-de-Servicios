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
  `id_contratacion` int DEFAULT NULL,
  `id_servicio` int NOT NULL,
  `calificacion` tinyint NOT NULL,
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_calificacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_calificacion`),
  UNIQUE KEY `uq_calificacion_contratacion` (`id_contratacion`),
  KEY `idx_calificacion` (`calificacion`),
  KEY `calificacion_ibfk_1_idx` (`id_servicio`),
  CONSTRAINT `calificacion_ibfk_1` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id_servicio`) ON DELETE CASCADE,
  CONSTRAINT `fk_calificacion_contratacion` FOREIGN KEY (`id_contratacion`) REFERENCES `contratacion` (`id_contratacion`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calificacion`
--

LOCK TABLES `calificacion` WRITE;
/*!40000 ALTER TABLE `calificacion` DISABLE KEYS */;
INSERT INTO `calificacion` VALUES (3,17,18,5,'Excelente','2025-11-30 19:39:24'),(4,16,26,4,'Excelente','2025-11-30 19:39:51'),(5,21,30,3,'fhggf','2025-11-30 22:32:12'),(6,22,26,5,'excelente','2025-11-30 23:19:17');
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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria_servicio`
--

LOCK TABLES `categoria_servicio` WRITE;
/*!40000 ALTER TABLE `categoria_servicio` DISABLE KEYS */;
INSERT INTO `categoria_servicio` VALUES (14,'Hogar','Servicios generales para mantenimiento y mejora del hogar.','https://img.icons8.com/ios-filled/100/home.png'),(15,'Limpieza','Servicios de limpieza residencial, profunda o especializada.','https://img.icons8.com/ios-filled/100/cleaning.png'),(16,'Electricidad','Instalaciones, reparación y mantenimiento eléctrico.','https://img.icons8.com/ios-filled/100/electricity.png'),(17,'Plomería','Reparación de fugas, tuberías y mantenimiento de agua.','https://img.icons8.com/ios-filled/100/plumbing.png'),(18,'Carpintería','Muebles, reparaciones, instalaciones y estructuras de madera.','https://img.icons8.com/ios-filled/100/wood.png'),(19,'Pintura','Pintado interior y exterior, acabados y retoques.','https://img.icons8.com/ios-filled/100/paint.png'),(20,'Jardinería','Cuidado de césped, poda, paisajismo y diseño exterior.','https://img.icons8.com/ios-filled/100/gardener.png'),(21,'Construcción','Obras civiles, remodelaciones y ampliaciones.','https://img.icons8.com/ios-filled/100/brick-wall.png'),(22,'Mudanzas','Servicio de transporte y embalaje para traslado de vivienda.','https://img.icons8.com/ios-filled/100/packing.png'),(23,'Mecánica','Reparación y mantenimiento vehicular a domicilio.','https://img.icons8.com/ios-filled/100/car-service.png'),(24,'Belleza y Cuidado Personal','Servicios de barbería, manicure, masajes y estética.','https://img.icons8.com/ios-filled/100/spa.png'),(25,'Tecnología','Instalación, soporte y configuración de equipos y redes.','https://img.icons8.com/ios-filled/100/computer.png'),(26,'Mascotas','Baño, paseo, cuidado y adiestramiento para animales.','https://img.icons8.com/ios-filled/100/pet.png'),(27,'Climatización','Instalación y mantenimiento de aires acondicionados.','https://img.icons8.com/ios-filled/100/air-conditioner.png'),(28,'Eventos','Montaje, alquiler de equipos, decoración y logística.','https://img.icons8.com/ios-filled/100/event.png'),(29,'Automotriz','Servicios mecánicos y técnicos a domicilio para vehículos.','/assets/icons/automotriz.png');
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
  `foto_perfil_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  KEY `fk_cliente_usuario1_idx` (`id_usuario`),
  CONSTRAINT `fk_cliente_usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (13,43,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contratacion`
--

LOCK TABLES `contratacion` WRITE;
/*!40000 ALTER TABLE `contratacion` DISABLE KEYS */;
INSERT INTO `contratacion` VALUES (14,13,29,17,18,12,'2025-11-30 17:34:38','2025-12-23 00:00:00',NULL,90.00,27.00,63.00,'pendiente',NULL,NULL,15.00,9.45,53.55),(15,13,19,12,18,NULL,'2025-11-30 17:35:58','2025-12-24 00:00:00',NULL,14.00,0.00,14.00,'cancelado',NULL,NULL,15.00,2.10,11.90),(16,13,26,17,18,NULL,'2025-11-30 17:37:02','2025-12-08 00:00:00','2025-11-30 17:45:26',100.00,0.00,100.00,'completado',NULL,'Finaliza traslado en Grua, sin novedad',15.00,15.00,85.00),(17,13,18,12,20,5,'2025-11-30 17:38:22','2025-12-05 00:00:00','2025-11-30 18:38:27',15.00,1.50,13.50,'completado',NULL,'',15.00,2.03,11.48),(18,13,24,12,19,NULL,'2025-11-30 17:38:58','2025-12-07 00:00:00',NULL,25.00,0.00,25.00,'pendiente',NULL,NULL,15.00,3.75,21.25),(19,13,30,17,18,NULL,'2025-11-30 22:19:23','2025-12-10 00:00:00',NULL,70.00,0.00,70.00,'pendiente',NULL,NULL,15.00,10.50,59.50),(20,13,20,12,18,NULL,'2025-11-30 22:22:35','2025-12-10 00:00:00',NULL,40.00,0.00,40.00,'pendiente',NULL,NULL,15.00,6.00,34.00),(21,13,30,17,18,12,'2025-11-30 22:25:20','2025-12-17 00:00:00','2025-11-30 22:30:19',70.00,21.00,49.00,'completado',NULL,'svdhdv',15.00,7.35,41.65),(22,13,26,17,20,NULL,'2025-11-30 23:14:48','2025-12-19 00:00:00','2025-11-30 23:17:56',100.00,0.00,100.00,'completado',NULL,'',15.00,15.00,85.00);
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conversacion`
--

LOCK TABLES `conversacion` WRITE;
/*!40000 ALTER TABLE `conversacion` DISABLE KEYS */;
INSERT INTO `conversacion` VALUES (4,13,10,18,'2025-11-30 18:17:46','2025-11-30 18:35:40','abierta'),(5,13,10,17,'2025-11-30 18:22:54','2025-11-30 18:24:10','abierta'),(6,13,11,19,'2025-11-30 22:19:26','2025-12-01 16:39:24','abierta'),(7,13,11,21,'2025-11-30 22:25:33','2025-11-30 22:29:37','abierta'),(8,13,11,22,'2025-11-30 23:15:04','2025-11-30 23:15:10','abierta'),(9,13,10,20,'2025-12-01 16:40:25',NULL,'abierta');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupon`
--

LOCK TABLES `cupon` WRITE;
/*!40000 ALTER TABLE `cupon` DISABLE KEYS */;
INSERT INTO `cupon` VALUES (5,10,'BIENVENIDA10','Descuento para nuevos usuarios en su primer servicio.','porcentaje',10.00,15.00,100,1,'2025-11-30 13:33:40','2025-12-30 00:00:00',1,'todos'),(6,10,'LIMPIEZAPRO20','Ideal para limpieza profunda o mudanza.','porcentaje',20.00,30.00,60,0,'2025-11-30 13:37:38','2026-01-15 00:00:00',1,'todos'),(7,10,'OFICINAFRESH15','Cupón exclusivo para servicios de limpieza de oficina.','porcentaje',15.00,25.00,40,0,'2025-11-30 13:38:14','2026-01-30 00:00:00',1,'todos'),(8,10,'TAPICERIA25','Descuento especial para lavado de muebles, sillas y colchones.','porcentaje',25.00,20.00,30,0,'2025-11-30 13:39:11','2026-01-10 00:00:00',1,'todos'),(9,10,'REYES2026','Promoción por temporada de año nuevo.','porcentaje',18.00,18.00,80,0,'2025-11-30 13:39:45','2026-02-10 00:00:00',1,'todos'),(10,11,'SCANNER10','10% de descuento en diagnóstico OBD-II.','porcentaje',10.00,10.00,50,0,'2025-11-30 14:41:22','2025-12-30 00:00:00',1,'todos'),(11,11,'RESCATE15','15% off en servicios de emergencia (batería/llanta).','porcentaje',15.00,20.00,40,0,'2025-11-30 14:41:54','2025-12-23 00:00:00',1,'todos'),(12,11,'DETAIL30','30% descuento en Detailing Profesional.','porcentaje',30.00,50.00,25,2,'2025-11-30 14:42:25','2025-12-18 00:00:00',1,'todos');
/*!40000 ALTER TABLE `cupon` ENABLE KEYS */;
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
  `referencia` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_direccion`),
  KEY `idx_ciudad` (`ciudad`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direccion`
--

LOCK TABLES `direccion` WRITE;
/*!40000 ALTER TABLE `direccion` DISABLE KEYS */;
INSERT INTO `direccion` VALUES (18,'Diego de robles','Av. Pampite','0','Quito','Pichincha','170144','Ecuador','Entrada principal USFQ'),(19,'Shyris','Naciones Unidas','M34-34','Quito','Pichincha','173201','Ecuador','Frente al Quicentro Norte'),(20,'Eloy Alfaro','Alamos','O43-21','Quito','Pichincha','160232','Ecuador','Frente a papa johns'),(21,'García Moreno','Sucre','102','Quito','Pichincha','170401','Ecuador','Frente a la Plaza Grande'),(22,'Av. Amazonas','República','355','Quito','Pichincha','170518','Ecuador','Cerca del parque La Carolina'),(23,'Av. Interoceánica','Av. Pampite','28B','Quito','Pichincha','170157','Ecuador','Cerca del Paseo San Francisco'),(24,'Av. Condor Ñan','Av. Quitumbe Ñan','420','Quito','Pichincha','170801','Ecuador','Junto al Quicentro Sur'),(25,'Av. El Inca','6 de Diciembre','221','Quito','Pichincha','170503','Ecuador','Cerca de la estación ECO Via'),(26,'Av. 6 de Diciembre','Portugal','N34-180','Quito','Pichincha','170135','Ecuador','Diagonal al CCI (Centro Comercial Iñaquito)');
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
INSERT INTO `direcciones_del_cliente` VALUES (13,18,'Universidad',1),(13,19,'Oficina',0),(13,20,'Casa',0);
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
  `pais` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_empresa`),
  UNIQUE KEY `ruc_nit` (`ruc_nit`),
  KEY `idx_calificacion` (`calificacion_promedio`),
  KEY `fk_empresa_usuario1_idx` (`id_usuario`),
  CONSTRAINT `fk_empresa_usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresa`
--

LOCK TABLES `empresa` WRITE;
/*!40000 ALTER TABLE `empresa` DISABLE KEYS */;
INSERT INTO `empresa` VALUES (10,44,'CleanHome',NULL,'Somos una empresa de servicios de limpieza a domicilio que transforma la forma en que las personas cuidan sus espacios. A través de nuestra app, los clientes pueden agendar limpiezas profesionales con un solo toque, elegir el tipo de servicio que necesitan y recibir atención confiable, rápida y eficiente sin complicaciones.\n\nNos destacamos por combinar tecnología y talento humano para ofrecer ambientes más limpios, saludables y cómodos. Simplificamos la experiencia, optimizamos el tiempo de nuestros usuarios y brindamos soluciones inteligentes para hogares y negocios. Creemos en la innovación aplicada al bienestar —tú solicitas, nosotros nos encargamos del resto.','https://res.cloudinary.com/dzoptmnx0/image/upload/v1764524571/app_servicios/l8wvwwxzh6zxqvzie8wu.jpg',5.00,'Ecuador'),(11,45,'MotorGo',NULL,'Somos una empresa especializada en servicios automotrices y técnicos a domicilio, diseñada para brindar soluciones rápidas, confiables y profesionales sin necesidad de que el cliente se traslade. Nuestro objetivo es ofrecer un servicio eficiente, seguro y transparente, llevando atención técnica directamente al lugar donde el vehículo o el equipo lo necesite.\n\nContamos con personal capacitado en mecánica automotriz, mantenimiento preventivo, asistencia en carretera, diagnóstico electrónico, revisión de sistemas eléctricos, así como soporte técnico para equipos y herramientas. Nos enfocamos en comodidad, rapidez y calidad, asegurando una experiencia práctica y sin complicaciones para nuestros usuarios.\n\nLlevamos el taller y el soporte técnico hasta tu puerta. Tú solicitas, nosotros resolvemos.','https://res.cloudinary.com/dzoptmnx0/image/upload/v1764529080/app_servicios/wtef99ixrudw0hjmpmnr.jpg',4.00,'Ecuador');
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
  PRIMARY KEY (`id_historial`),
  KEY `idx_hist_contratacion` (`id_contratacion`),
  CONSTRAINT `fk_historial_contratacion` FOREIGN KEY (`id_contratacion`) REFERENCES `contratacion` (`id_contratacion`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_estado_contratacion`
--

LOCK TABLES `historial_estado_contratacion` WRITE;
/*!40000 ALTER TABLE `historial_estado_contratacion` DISABLE KEYS */;
INSERT INTO `historial_estado_contratacion` VALUES (36,14,NULL,'pendiente','2025-11-30 17:34:38','Contratación creada'),(37,15,NULL,'pendiente','2025-11-30 17:35:58','Contratación creada'),(38,16,NULL,'pendiente','2025-11-30 17:37:02','Contratación creada'),(39,17,NULL,'pendiente','2025-11-30 17:38:22','Contratación creada'),(40,18,NULL,'pendiente','2025-11-30 17:38:58','Contratación creada'),(41,16,'pendiente','confirmado','2025-11-30 17:45:02','Ahi estaremos.'),(42,16,'confirmado','en_proceso','2025-11-30 17:45:15','Empieza traslado en Grúa'),(43,16,'en_proceso','completado','2025-11-30 17:45:26','Finaliza traslado en Grua, sin novedad'),(44,17,'pendiente','confirmado','2025-11-30 18:38:21',''),(45,17,'confirmado','en_proceso','2025-11-30 18:38:23',''),(46,17,'en_proceso','completado','2025-11-30 18:38:27',''),(47,19,NULL,'pendiente','2025-11-30 22:19:23','Contratación creada'),(48,20,NULL,'pendiente','2025-11-30 22:22:35','Contratación creada'),(49,21,NULL,'pendiente','2025-11-30 22:25:21','Contratación creada'),(50,21,'pendiente','confirmado','2025-11-30 22:29:43','djdhsgg'),(51,21,'confirmado','en_proceso','2025-11-30 22:30:05','sgdv'),(52,21,'en_proceso','completado','2025-11-30 22:30:19','svdhdv'),(53,22,NULL,'pendiente','2025-11-30 23:14:48','Contratación creada'),(54,22,'pendiente','confirmado','2025-11-30 23:17:51',''),(55,22,'confirmado','en_proceso','2025-11-30 23:17:54',''),(56,22,'en_proceso','completado','2025-11-30 23:17:56','');
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
  `fecha_envio` datetime DEFAULT CURRENT_TIMESTAMP,
  `leido` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_mensaje`),
  KEY `idx_conversacion` (`id_conversacion`),
  KEY `idx_remitente` (`id_remitente`),
  KEY `idx_leido` (`leido`),
  KEY `idx_fecha_envio` (`fecha_envio`),
  KEY `idx_mensaje_conversacion_fecha` (`id_conversacion`,`fecha_envio`),
  CONSTRAINT `mensaje_ibfk_1` FOREIGN KEY (`id_conversacion`) REFERENCES `conversacion` (`id_conversacion`) ON DELETE CASCADE,
  CONSTRAINT `mensaje_ibfk_2` FOREIGN KEY (`id_remitente`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mensaje`
--

LOCK TABLES `mensaje` WRITE;
/*!40000 ALTER TABLE `mensaje` DISABLE KEYS */;
INSERT INTO `mensaje` VALUES (6,5,43,'Buenas tardes, por favor comenteme a que hora vendra?','texto','2025-11-30 18:23:13',0),(7,5,43,'hey','texto','2025-11-30 18:24:10',0),(8,4,43,'Buenas tardes','texto','2025-11-30 18:35:40',0),(9,6,43,'hola nenorra','texto','2025-11-30 22:19:36',0),(10,6,45,'hola guapo','texto','2025-11-30 22:20:30',0),(11,7,43,'hola','texto','2025-11-30 22:25:54',0),(12,7,45,'v','texto','2025-11-30 22:29:37',0),(13,8,43,'hola buenas tardes ','texto','2025-11-30 23:15:10',0),(14,6,45,'sexo','texto','2025-12-01 16:39:24',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacion`
--

LOCK TABLES `notificacion` WRITE;
/*!40000 ALTER TABLE `notificacion` DISABLE KEYS */;
INSERT INTO `notificacion` VALUES (31,45,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de Pablo Jarrin. ID: 14','sistema',14,'contratacion',1,'2025-11-30 17:34:38','2025-11-30 22:21:14'),(32,44,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de Pablo Jarrin. ID: 15','sistema',15,'contratacion',1,'2025-11-30 17:35:58','2025-11-30 19:45:28'),(33,45,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de Pablo Jarrin. ID: 16','sistema',16,'contratacion',1,'2025-11-30 17:37:02','2025-11-30 22:21:14'),(34,44,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de Pablo Jarrin. ID: 17','sistema',17,'contratacion',1,'2025-11-30 17:38:22','2025-11-30 19:45:27'),(35,44,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de Pablo Jarrin. ID: 18','sistema',18,'contratacion',1,'2025-11-30 17:38:58','2025-11-30 19:45:27'),(36,43,'Orden Confirmada','¡Tu orden #16 ha sido confirmada por la empresa!\n\nNota de la empresa: Ahi estaremos.','cambio_estado',16,'contratacion',1,'2025-11-30 17:45:02','2025-11-30 17:46:23'),(37,43,'Servicio en Proceso','La empresa ha iniciado el servicio de la orden #16.\n\nNota de la empresa: Empieza traslado en Grúa','cambio_estado',16,'contratacion',1,'2025-11-30 17:45:15','2025-11-30 17:46:24'),(38,43,'Servicio Completado','El servicio de la orden #16 ha sido marcado como completado.\n\nNota de la empresa: Finaliza traslado en Grua, sin novedad','cambio_estado',16,'contratacion',1,'2025-11-30 17:45:26','2025-11-30 17:46:25'),(39,43,'Orden Confirmada','¡Tu orden #17 ha sido confirmada por la empresa!','cambio_estado',17,'contratacion',1,'2025-11-30 18:38:21','2025-11-30 22:24:02'),(40,43,'Servicio en Proceso','La empresa ha iniciado el servicio de la orden #17.','cambio_estado',17,'contratacion',1,'2025-11-30 18:38:23','2025-11-30 22:24:02'),(41,43,'Servicio Completado','El servicio de la orden #17 ha sido marcado como completado.','cambio_estado',17,'contratacion',1,'2025-11-30 18:38:27','2025-11-30 22:24:01'),(42,45,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de Pablo Jarrin. ID: 19','sistema',19,'contratacion',1,'2025-11-30 22:19:23','2025-11-30 22:21:14'),(43,44,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de Pablo Jarrin. ID: 20','sistema',20,'contratacion',0,'2025-11-30 22:22:35',NULL),(44,45,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de Pablo Jarrin. ID: 21','sistema',21,'contratacion',0,'2025-11-30 22:25:21',NULL),(45,43,'Orden Confirmada','¡Tu orden #21 ha sido confirmada por la empresa!\n\nNota de la empresa: djdhsgg','cambio_estado',21,'contratacion',1,'2025-11-30 22:29:43','2025-11-30 22:33:25'),(46,43,'Servicio en Proceso','La empresa ha iniciado el servicio de la orden #21.\n\nNota de la empresa: sgdv','cambio_estado',21,'contratacion',1,'2025-11-30 22:30:05','2025-11-30 22:33:25'),(47,43,'Servicio Completado','El servicio de la orden #21 ha sido marcado como completado.\n\nNota de la empresa: svdhdv','cambio_estado',21,'contratacion',1,'2025-11-30 22:30:19','2025-11-30 23:20:29'),(48,45,'Nueva Orden Recibida','Has recibido una nueva orden de servicio de Pablo Jarrin. ID: 22','sistema',22,'contratacion',0,'2025-11-30 23:14:48',NULL),(49,43,'Orden Confirmada','¡Tu orden #22 ha sido confirmada por la empresa!','cambio_estado',22,'contratacion',1,'2025-11-30 23:17:51','2025-11-30 23:20:30'),(50,43,'Servicio en Proceso','La empresa ha iniciado el servicio de la orden #22.','cambio_estado',22,'contratacion',1,'2025-11-30 23:17:54','2025-11-30 23:20:30'),(51,43,'Servicio Completado','El servicio de la orden #22 ha sido marcado como completado.','cambio_estado',22,'contratacion',1,'2025-11-30 23:17:56','2025-11-30 23:20:30');
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
  PRIMARY KEY (`id_pago`),
  KEY `idx_contratacion` (`id_contratacion`),
  KEY `idx_estado_pago` (`estado_pago`),
  CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`id_contratacion`) REFERENCES `contratacion` (`id_contratacion`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pago`
--

LOCK TABLES `pago` WRITE;
/*!40000 ALTER TABLE `pago` DISABLE KEYS */;
INSERT INTO `pago` VALUES (11,14,63.00,'tarjeta_credito','pendiente','2025-11-30 17:34:38'),(12,15,14.00,'tarjeta_credito','pendiente','2025-11-30 17:35:58'),(13,16,100.00,'paypal','completado','2025-11-30 17:37:02'),(14,17,13.50,'paypal','completado','2025-11-30 17:38:22'),(15,18,25.00,'efectivo','pendiente','2025-11-30 17:38:58'),(16,19,70.00,'transferencia','pendiente','2025-11-30 22:19:23'),(17,20,40.00,'transferencia','pendiente','2025-11-30 22:22:35'),(18,21,49.00,'transferencia','completado','2025-11-30 22:25:21'),(19,22,100.00,'efectivo','completado','2025-11-30 23:14:48');
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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio`
--

LOCK TABLES `servicio` WRITE;
/*!40000 ALTER TABLE `servicio` DISABLE KEYS */;
INSERT INTO `servicio` VALUES (15,10,15,'Limpieza General de Hogar','Limpieza básica de dormitorios, cocina, sala, baños y pisos.',18.00,2,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764526448/app_servicios/yraie4mwvbj8kcl3yl78.jpg','disponible','2025-11-30 13:01:07'),(16,10,15,'Limpieza Profunda Residencial','Limpieza con desinfección de puntos críticos, grasa, olores y manchas.',35.00,4,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764526603/app_servicios/hswawyxnfxp2ueeozedm.jpg','disponible','2025-11-30 13:02:22'),(17,10,15,'Limpieza de oficinas','Escritorios, vidrios internos, baños, áreas comunes y desinfección.',30.00,3,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764527578/app_servicios/fcg8lm82gsh0qfcizpdy.jpg','disponible','2025-11-30 13:03:06'),(18,10,14,'Lavado y Planchado de Ropa','Planchado, doblado y entrega ordenada de prendas.',15.00,2,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764526895/app_servicios/a6tglp2c0su9lxk3yx9t.jpg','disponible','2025-11-30 13:04:17'),(19,10,21,'Limpieza de Vidrios y Ventanales','Limpieza profesional interior/exterior con productos anti-manchas.',14.00,2,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764526996/app_servicios/izysbvauk9v7mvuudaao.jpg','disponible','2025-11-30 13:05:29'),(20,10,28,'Limpieza Post-Evento','Recolección de desechos, piso, baños, cocina, olores y desinfección.',40.00,3,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764526788/app_servicios/caqd7fvgji1imxff0tpr.jpg','disponible','2025-11-30 13:06:12'),(21,10,15,'Lavado de Tapicería (sofás, sillas, colchones)','Lavado con extracción, eliminación de olores y manchas.',32.00,3,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764526522/app_servicios/yvi6rrhxkfyhzmpiposy.jpg','disponible','2025-11-30 13:06:45'),(22,10,22,'Limpieza para Mudanzas','Limpieza total previo o posterior al cambio de vivienda.',50.00,5,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764526711/app_servicios/m8w84is8i20zxe84a3l7.jpg','disponible','2025-11-30 13:07:14'),(23,10,20,'Servicio de Jardinería Básica','Corte de césped, barrido, riego y mantenimiento ligero.',20.00,2,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764526665/app_servicios/plrefxuvyzv1zz4j955w.jpg','disponible','2025-11-30 13:08:04'),(24,10,15,'Desinfección y Sanitización Antibacterial','Nebulización y desinfección profesional anti-virus y bacterias.',25.00,2,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764527543/app_servicios/omxmpp24k5ug6qneezm6.jpg','disponible','2025-11-30 13:08:46'),(25,11,29,'Mantenimiento Preventivo Básico','Revisión de líquidos, filtros, estado de correas, llantas y diagnóstico rápido.',25.00,1,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764529967/app_servicios/qrthvaufpubdgnxo7dyo.jpg','disponible','2025-11-30 14:12:50'),(26,11,29,'Grúa 24/7 – Asistencia de Remolque','Servicio de grúa y remolque disponible las 24 horas del día, 7 días a la semana. Ideal para emergencias por falla mecánica, accidente o necesidad de traslado. Incluye asistencia hasta el punto solicitado dentro de la ciudad. Atención inmediata y segura para vehículos livianos.',100.00,2,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764530231/app_servicios/pqdtm9jnzkwssa4pvhnk.jpg','disponible','2025-11-30 14:17:15'),(27,11,29,'Asistencia de Batería / Encendido de Emergencia','Servicio de arranque de emergencia para vehículos que presentan batería descargada o fallas de encendido. Incluye conexión segura con cables profesionales, verificación de estado de la batería, prueba de voltaje y recomendación técnica si requiere reemplazo.\nAtención rápida a domicilio o en vía pública.',20.00,1,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764530509/app_servicios/doyuju5jhqernb2xbr2k.jpg','disponible','2025-11-30 14:21:52'),(28,11,29,'Diagnóstico con Scanner OBD-II','Lectura y análisis de fallos electrónicos mediante scanner OBD-II profesional.\nIncluye revisión de códigos de error, diagnóstico de sensores, fallas de encendido, mezcla, oxígeno, temperatura, transmisión y más. Al finalizar se entrega reporte con recomendaciones y posibles soluciones.\nServicio ideal cuando el vehículo presenta testigo encendido o comportamiento anómalo.',20.00,1,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764530787/app_servicios/vaqqjra75lo43sjctoel.jpg','disponible','2025-11-30 14:26:31'),(29,11,29,'Detailing Profesional – Interior & Exterior','Limpieza estética completa del vehículo, enfocada en restaurar brillo, eliminar suciedad profunda y mejorar la apariencia general. Incluye:\n\n✔ Lavado exterior con shampoo neutro\n✔ Descontaminación de pintura (clay bar)\n✔ Pulido ligero y sellado cerámico básico\n✔ Limpieza profunda de interiores\n✔ Tapicería con extracción de manchas\n✔ Tablero, vinilos y plásticos con protector UV\n✔ Vidrios internos y externos cristalinos\n\nUn servicio ideal para vehículos en venta, presentación especial o mantenimiento premium de imagen.',90.00,3,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764531193/app_servicios/tdpqllfyh16gwyg3aziw.jpg','disponible','2025-11-30 14:33:23'),(30,11,29,'Inspección Pre-Compra de Vehículo Usado','Revisión profesional para evaluar el estado real de un vehículo antes de comprarlo. Incluye análisis mecánico, estético y electrónico para identificar fallas ocultas y posibles costos futuros. Se entrega informe detallado para ayudar al cliente a tomar una decisión segura.',70.00,1,'https://res.cloudinary.com/dzoptmnx0/image/upload/v1764531657/app_servicios/qifexnfqfgls7d4dzrdp.jpg','disponible','2025-11-30 14:41:02');
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
INSERT INTO `servicio_favorito` VALUES (21,13,'2025-11-30 14:44:51'),(23,13,'2025-11-30 14:44:57'),(24,13,'2025-11-30 14:44:53'),(25,13,'2025-11-30 14:45:06'),(26,13,'2025-11-30 14:44:48'),(29,13,'2025-11-30 14:44:46');
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
INSERT INTO `servicio_sucursal` VALUES (20,13,0),(15,12,1),(15,13,1),(15,14,1),(15,15,1),(15,16,1),(16,12,1),(16,13,1),(16,15,1),(16,16,1),(17,12,1),(17,13,1),(17,14,1),(17,16,1),(18,12,1),(18,14,1),(18,15,1),(19,12,1),(19,13,1),(19,15,1),(20,12,1),(20,14,1),(20,16,1),(21,12,1),(21,13,1),(21,14,1),(21,15,1),(21,16,1),(22,12,1),(22,13,1),(22,15,1),(22,16,1),(23,13,1),(23,14,1),(23,16,1),(24,12,1),(24,13,1),(24,14,1),(24,15,1),(24,16,1),(25,17,1),(26,17,1),(27,17,1),(28,17,1),(29,17,1),(30,17,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sucursal`
--

LOCK TABLES `sucursal` WRITE;
/*!40000 ALTER TABLE `sucursal` DISABLE KEYS */;
INSERT INTO `sucursal` VALUES (12,10,21,'Sucursal 1 – Centro Histórico','0987654321','08:00:00','18:00:00','1111100','activa'),(13,10,22,'Sucursal 2 – La Carolina','0991122334','07:00:00','19:00:00','1111110','activa'),(14,10,23,'Sucursal 3 – Cumbayá','0984422113','08:00:00','16:00:00','1111100','activa'),(15,10,24,'Sucursal 4 – Quitumbe','0975566788','09:00:00','17:00:00','1111110','activa'),(16,10,25,'Sucursal 5 – El Inca','0983344556','08:00:00','18:00:00','1111111','activa'),(17,11,26,'MotorGo Quito','0994527810','08:00:00','19:00:00','1111111','activa');
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
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (42,'admin@app.com','$2b$10$rZX5bxG/9xWxSLbJdJUxJeF93so1jcTxpVqHcCtTyY9HWqbMD11Em','Admin','System',NULL,'admin',NULL,'2025-11-30 01:47:05','activo'),(43,'cliente@app.com','$2b$10$u2RO3NSKycnYaTRvXsW8M.qlcFysprntKvb1uRWpL4XWyy1Te1xHa','Pablo','Jarrin','0994460493','cliente','https://res.cloudinary.com/dzoptmnx0/image/upload/v1764524181/app_servicios/gdfueolesdmgphlsflqr.jpg','2025-11-30 02:06:38','activo'),(44,'empresa1@app.com','$2b$10$978VmiclvD.N706D.ohqnO.48u/n4Y1LaW7zDsfFMXzx2aKCXITO6','Jarod','Tierra','0994839432','empresa',NULL,'2025-11-30 02:08:01','activo'),(45,'empresa2@app.com','$2b$10$3LBzhQlln5EN4lNy7fwP1uaxYe9r0oRnovAo7nfQPMc/2zMDALicq','Andres','Vega','','empresa',NULL,'2025-11-30 02:08:59','activo');
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
 1 AS `fecha_completada`,
 1 AS `estado_contratacion`,
 1 AS `precio_total`,
 1 AS `precio_subtotal`,
 1 AS `cliente_nombre`,
 1 AS `cliente_email`,
 1 AS `cliente_foto`,
 1 AS `servicio_nombre`,
 1 AS `servicio_imagen`,
 1 AS `empresa_nombre`,
 1 AS `nombre_sucursal`,
 1 AS `direccion_entrega`,
 1 AS `cupon_codigo`,
 1 AS `descuento_aplicado`,
 1 AS `metodo_pago`,
 1 AS `estado_pago`,
 1 AS `calificacion`,
 1 AS `calificacion_comentario`,
 1 AS `id_empresa`*/;
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
 1 AS `subtotal_ventas`,
 1 AS `comision_app`,
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
 1 AS `imagen_url`,
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
 1 AS `direccion_completa`,
 1 AS `telefono`,
 1 AS `horario_apertura`,
 1 AS `horario_cierre`,
 1 AS `estado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_top_clientes`
--

DROP TABLE IF EXISTS `vista_top_clientes`;
/*!50001 DROP VIEW IF EXISTS `vista_top_clientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_top_clientes` AS SELECT 
 1 AS `id_cliente`,
 1 AS `nombre_completo`,
 1 AS `email`,
 1 AS `total_contrataciones`,
 1 AS `total_gastado`,
 1 AS `ultima_contratacion`*/;
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
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_calificacion`(
          IN p_id_contratacion INT,
          IN p_calificacion TINYINT,
          IN p_comentario TEXT,
          OUT p_out_id_calificacion INT,
          OUT p_out_mensaje VARCHAR(255)
      )
BEGIN
          DECLARE v_contratacion_estado VARCHAR(20);
          DECLARE v_calificacion_count INT DEFAULT 0;
          DECLARE v_id_empresa INT;
          DECLARE v_id_servicio INT;
          DECLARE v_nuevo_promedio DECIMAL(3,2);

          DECLARE EXIT HANDLER FOR SQLEXCEPTION
          BEGIN
              ROLLBACK;
              SET p_out_id_calificacion = NULL;
              SET p_out_mensaje = 'Error al crear calificación';
          END;

          START TRANSACTION;

          -- Validar contratación y obtener servicio/empresa
          SELECT c.estado, c.id_servicio, s.id_empresa 
          INTO v_contratacion_estado, v_id_servicio, v_id_empresa
          FROM contratacion c
          INNER JOIN servicio s ON c.id_servicio = s.id_servicio
          WHERE c.id_contratacion = p_id_contratacion;

          IF v_contratacion_estado IS NULL THEN
              SIGNAL SQLSTATE '45000'
                  SET MESSAGE_TEXT = 'La contratación no existe';
          END IF;

          IF v_contratacion_estado != 'completado' THEN
              SIGNAL SQLSTATE '45000'
                  SET MESSAGE_TEXT = 'Solo se pueden calificar contrataciones completadas';
          END IF;

          -- Validar duplicados
          SELECT COUNT(*) INTO v_calificacion_count
          FROM calificacion
          WHERE id_contratacion = p_id_contratacion;

          IF v_calificacion_count > 0 THEN
              SIGNAL SQLSTATE '45000'
                  SET MESSAGE_TEXT = 'Esta contratación ya fue calificada';
          END IF;

          -- Validar rango
          IF p_calificacion < 1 OR p_calificacion > 5 THEN
              SIGNAL SQLSTATE '45000'
                  SET MESSAGE_TEXT = 'La calificación debe estar entre 1 y 5';
          END IF;

          -- Insertar calificación
          INSERT INTO calificacion (id_contratacion, id_servicio, calificacion, comentario)
          VALUES (p_id_contratacion, v_id_servicio, p_calificacion, p_comentario);

          SET p_out_id_calificacion = LAST_INSERT_ID();

          -- Actualizar promedio empresa
          SELECT AVG(cal.calificacion) INTO v_nuevo_promedio
          FROM calificacion cal
          INNER JOIN servicio s ON cal.id_servicio = s.id_servicio
          WHERE s.id_empresa = v_id_empresa;

          UPDATE empresa
          SET calificacion_promedio = IFNULL(v_nuevo_promedio, 0)
          WHERE id_empresa = v_id_empresa;

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
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_contrataciones_detalle` AS select `con`.`id_contratacion` AS `id_contratacion`,`con`.`fecha_solicitud` AS `fecha_solicitud`,`con`.`fecha_programada` AS `fecha_programada`,`con`.`fecha_completada` AS `fecha_completada`,`con`.`estado` AS `estado_contratacion`,`con`.`precio_total` AS `precio_total`,`con`.`precio_subtotal` AS `precio_subtotal`,concat(`uc`.`nombre`,' ',`uc`.`apellido`) AS `cliente_nombre`,`uc`.`email` AS `cliente_email`,`uc`.`foto_perfil_url` AS `cliente_foto`,`s`.`nombre` AS `servicio_nombre`,`s`.`imagen_url` AS `servicio_imagen`,`e`.`razon_social` AS `empresa_nombre`,`suc`.`nombre_sucursal` AS `nombre_sucursal`,concat(`d`.`calle_principal`,', ',`d`.`ciudad`) AS `direccion_entrega`,`cup`.`codigo` AS `cupon_codigo`,`con`.`descuento_aplicado` AS `descuento_aplicado`,`p`.`metodo_pago` AS `metodo_pago`,`p`.`estado_pago` AS `estado_pago`,`cal`.`calificacion` AS `calificacion`,`cal`.`comentario` AS `calificacion_comentario`,`s`.`id_empresa` AS `id_empresa` from ((((((((((`contratacion` `con` join `cliente` `cli` on((`con`.`id_cliente` = `cli`.`id_cliente`))) join `usuario` `uc` on((`cli`.`id_usuario` = `uc`.`id_usuario`))) join `servicio` `s` on((`con`.`id_servicio` = `s`.`id_servicio`))) join `empresa` `e` on((`s`.`id_empresa` = `e`.`id_empresa`))) join `usuario` `ue` on((`e`.`id_usuario` = `ue`.`id_usuario`))) join `sucursal` `suc` on((`con`.`id_sucursal` = `suc`.`id_sucursal`))) join `direccion` `d` on((`con`.`id_direccion_entrega` = `d`.`id_direccion`))) left join `cupon` `cup` on((`con`.`id_cupon` = `cup`.`id_cupon`))) left join `pago` `p` on((`con`.`id_contratacion` = `p`.`id_contratacion`))) left join `calificacion` `cal` on((`con`.`id_contratacion` = `cal`.`id_contratacion`))) */;
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
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_estadisticas_empresa` AS select `e`.`id_empresa` AS `id_empresa`,`e`.`razon_social` AS `razon_social`,`e`.`logo_url` AS `logo_url`,`e`.`calificacion_promedio` AS `calificacion_promedio`,(select count(0) from `servicio` `s` where (`s`.`id_empresa` = `e`.`id_empresa`)) AS `total_servicios`,(select count(0) from `sucursal` `suc` where (`suc`.`id_empresa` = `e`.`id_empresa`)) AS `total_sucursales`,(select count(0) from (`contratacion` `c` join `servicio` `s` on((`c`.`id_servicio` = `s`.`id_servicio`))) where (`s`.`id_empresa` = `e`.`id_empresa`)) AS `total_contrataciones`,(select coalesce(sum(`c`.`ganancia_empresa`),0) from (`contratacion` `c` join `servicio` `s` on((`c`.`id_servicio` = `s`.`id_servicio`))) where ((`s`.`id_empresa` = `e`.`id_empresa`) and (`c`.`estado` = 'completado'))) AS `ingresos_totales`,(select coalesce(sum(`c`.`precio_total`),0) from (`contratacion` `c` join `servicio` `s` on((`c`.`id_servicio` = `s`.`id_servicio`))) where ((`s`.`id_empresa` = `e`.`id_empresa`) and (`c`.`estado` = 'completado'))) AS `subtotal_ventas`,(select coalesce(sum(`c`.`comision_plataforma`),0) from (`contratacion` `c` join `servicio` `s` on((`c`.`id_servicio` = `s`.`id_servicio`))) where ((`s`.`id_empresa` = `e`.`id_empresa`) and (`c`.`estado` = 'completado'))) AS `comision_app`,(select count(0) from `cupon` `cup` where ((`cup`.`id_empresa` = `e`.`id_empresa`) and (`cup`.`activo` = 1))) AS `cupones_activos` from `empresa` `e` */;
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
/*!50001 VIEW `vista_servicios_completos` AS select `s`.`id_servicio` AS `id_servicio`,`s`.`nombre` AS `servicio_nombre`,`s`.`descripcion` AS `descripcion`,`s`.`precio_base` AS `precio_base`,`s`.`duracion_estimada` AS `duracion_estimada`,`s`.`imagen_url` AS `imagen_url`,`s`.`estado` AS `servicio_estado`,`c`.`nombre` AS `categoria_nombre`,`e`.`razon_social` AS `empresa_nombre`,`e`.`calificacion_promedio` AS `empresa_calificacion`,`u`.`email` AS `empresa_email`,`u`.`telefono` AS `empresa_telefono` from (((`servicio` `s` join `categoria_servicio` `c` on((`s`.`id_categoria` = `c`.`id_categoria`))) join `empresa` `e` on((`s`.`id_empresa` = `e`.`id_empresa`))) join `usuario` `u` on((`e`.`id_usuario` = `u`.`id_usuario`))) where (`s`.`estado` = 'disponible') */;
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
/*!50001 VIEW `vista_sucursales_direccion_completa` AS select `suc`.`id_sucursal` AS `id_sucursal`,`suc`.`nombre_sucursal` AS `nombre_sucursal`,`e`.`razon_social` AS `empresa_nombre`,`d`.`calle_principal` AS `calle_principal`,`d`.`calle_secundaria` AS `calle_secundaria`,`d`.`numero` AS `numero`,`d`.`ciudad` AS `ciudad`,`d`.`provincia_estado` AS `provincia_estado`,`d`.`codigo_postal` AS `codigo_postal`,`d`.`pais` AS `pais`,concat(`d`.`calle_principal`,ifnull(concat(' y ',`d`.`calle_secundaria`),''),`d`.`ciudad`,', ',`d`.`provincia_estado`) AS `direccion_completa`,`suc`.`telefono` AS `telefono`,`suc`.`horario_apertura` AS `horario_apertura`,`suc`.`horario_cierre` AS `horario_cierre`,`suc`.`estado` AS `estado` from ((`sucursal` `suc` join `direccion` `d` on((`suc`.`id_direccion` = `d`.`id_direccion`))) join `empresa` `e` on((`suc`.`id_empresa` = `e`.`id_empresa`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_top_clientes`
--

/*!50001 DROP VIEW IF EXISTS `vista_top_clientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_top_clientes` AS select `c`.`id_cliente` AS `id_cliente`,concat(`u`.`nombre`,' ',`u`.`apellido`) AS `nombre_completo`,`u`.`email` AS `email`,count(`con`.`id_contratacion`) AS `total_contrataciones`,coalesce(sum(`con`.`precio_total`),0) AS `total_gastado`,max(`con`.`fecha_solicitud`) AS `ultima_contratacion` from ((`cliente` `c` join `usuario` `u` on((`c`.`id_usuario` = `u`.`id_usuario`))) left join `contratacion` `con` on((`c`.`id_cliente` = `con`.`id_cliente`))) group by `c`.`id_cliente`,`u`.`nombre`,`u`.`apellido`,`u`.`email` order by `total_gastado` desc */;
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

-- Dump completed on 2025-12-01 23:39:32
