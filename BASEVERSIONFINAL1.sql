-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema app_servicios
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `app_servicios` ;

-- -----------------------------------------------------
-- Schema app_servicios
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `app_servicios` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `app_servicios` ;

-- -----------------------------------------------------
-- Table `app_servicios`.`usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`usuario` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `apellido` VARCHAR(100) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `tipo_usuario` ENUM('cliente', 'empresa', 'empleado', 'admin') NOT NULL,
  `foto_perfil_url` VARCHAR(500) NULL DEFAULT NULL,
  `fecha_registro` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` ENUM('activo', 'inactivo', 'suspendido') NULL DEFAULT 'activo',
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE,
  INDEX `idx_email` (`email` ASC) VISIBLE,
  INDEX `idx_tipo_usuario` (`tipo_usuario` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 26
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`cliente` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`cliente` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `fecha_nacimiento` DATE NULL DEFAULT NULL,
  `calificacion_promedio` DECIMAL(3,2) NULL DEFAULT NULL,
  `clientecol` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  INDEX `fk_cliente_usuario1_idx` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_cliente_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `app_servicios`.`usuario` (`id_usuario`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`empresa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`empresa` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`empresa` (
  `id_empresa` INT NOT NULL AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `razon_social` VARCHAR(255) NOT NULL,
  `ruc_nit` VARCHAR(50) NULL DEFAULT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `logo_url` VARCHAR(500) NULL DEFAULT NULL,
  `calificacion_promedio` DECIMAL(3,2) NULL DEFAULT '0.00',
  `fecha_verificacion` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id_empresa`),
  UNIQUE INDEX `ruc_nit` (`ruc_nit` ASC) VISIBLE,
  INDEX `idx_calificacion` (`calificacion_promedio` ASC) VISIBLE,
  INDEX `fk_empresa_usuario1_idx` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_empresa_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `app_servicios`.`usuario` (`id_usuario`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`categoria_servicio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`categoria_servicio` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`categoria_servicio` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `icono_url` VARCHAR(500) NULL DEFAULT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE INDEX `nombre` (`nombre` ASC) VISIBLE,
  INDEX `idx_nombre` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`servicio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`servicio` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`servicio` (
  `id_servicio` INT NOT NULL AUTO_INCREMENT,
  `id_empresa` INT NOT NULL,
  `id_categoria` INT NOT NULL,
  `nombre` VARCHAR(200) NOT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `precio_base` DECIMAL(10,2) NOT NULL,
  `duracion_estimada` INT NULL DEFAULT NULL COMMENT 'Duración en minutos',
  `imagen_url` VARCHAR(500) NULL DEFAULT NULL,
  `estado` ENUM('disponible', 'no_disponible', 'agotado') NULL DEFAULT 'disponible',
  `fecha_creacion` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_servicio`),
  INDEX `idx_empresa` (`id_empresa` ASC) VISIBLE,
  INDEX `idx_categoria` (`id_categoria` ASC) VISIBLE,
  INDEX `idx_estado` (`estado` ASC) VISIBLE,
  INDEX `idx_servicio_empresa_estado` (`id_empresa` ASC, `estado` ASC) VISIBLE,
  CONSTRAINT `servicio_ibfk_1`
    FOREIGN KEY (`id_empresa`)
    REFERENCES `app_servicios`.`empresa` (`id_empresa`)
    ON DELETE CASCADE,
  CONSTRAINT `servicio_ibfk_2`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `app_servicios`.`categoria_servicio` (`id_categoria`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`direccion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`direccion` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`direccion` (
  `id_direccion` INT NOT NULL AUTO_INCREMENT,
  `calle_principal` VARCHAR(255) NOT NULL,
  `calle_secundaria` VARCHAR(255) NULL DEFAULT NULL,
  `numero` VARCHAR(20) NULL DEFAULT NULL,
  `ciudad` VARCHAR(100) NOT NULL,
  `provincia_estado` VARCHAR(100) NOT NULL,
  `codigo_postal` VARCHAR(20) NULL DEFAULT NULL,
  `pais` VARCHAR(100) NOT NULL DEFAULT 'Ecuador',
  `latitud` DECIMAL(10,8) NULL DEFAULT NULL,
  `longitud` DECIMAL(11,8) NULL DEFAULT NULL,
  `referencia` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_direccion`),
  INDEX `idx_ciudad` (`ciudad` ASC) VISIBLE,
  INDEX `idx_coordenadas` (`latitud` ASC, `longitud` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`sucursal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`sucursal` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`sucursal` (
  `id_sucursal` INT NOT NULL AUTO_INCREMENT,
  `id_empresa` INT NOT NULL,
  `id_direccion` INT NOT NULL COMMENT 'Dirección base reutilizable',
  `nombre_sucursal` VARCHAR(200) NOT NULL,
  `piso` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Piso específico dentro del edificio',
  `numero_local` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Número de local/oficina',
  `referencias_especificas` TEXT NULL DEFAULT NULL COMMENT 'Referencias únicas para esta sucursal',
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `horario_apertura` TIME NULL DEFAULT NULL,
  `horario_cierre` TIME NULL DEFAULT NULL,
  `dias_laborales` VARCHAR(100) NULL DEFAULT 'Lunes a Viernes',
  `estado` ENUM('activa', 'inactiva', 'temporal') NULL DEFAULT 'activa',
  PRIMARY KEY (`id_sucursal`),
  INDEX `idx_empresa` (`id_empresa` ASC) VISIBLE,
  INDEX `idx_direccion` (`id_direccion` ASC) VISIBLE,
  INDEX `idx_estado` (`estado` ASC) VISIBLE,
  CONSTRAINT `sucursal_ibfk_1`
    FOREIGN KEY (`id_empresa`)
    REFERENCES `app_servicios`.`empresa` (`id_empresa`)
    ON DELETE CASCADE,
  CONSTRAINT `sucursal_ibfk_2`
    FOREIGN KEY (`id_direccion`)
    REFERENCES `app_servicios`.`direccion` (`id_direccion`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`cupon`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`cupon` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`cupon` (
  `id_cupon` INT NOT NULL AUTO_INCREMENT,
  `id_empresa` INT NOT NULL,
  `codigo` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  `tipo_descuento` ENUM('porcentaje', 'monto_fijo') NOT NULL,
  `valor_descuento` DECIMAL(10,2) NOT NULL,
  `monto_minimo_compra` DECIMAL(10,2) NULL DEFAULT '0.00',
  `cantidad_disponible` INT NULL DEFAULT NULL,
  `cantidad_usada` INT NULL DEFAULT '0',
  `fecha_inicio` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_expiracion` DATETIME NULL DEFAULT NULL,
  `activo` TINYINT(1) NULL DEFAULT '1',
  `aplicable_a` ENUM('todos', 'categoria', 'servicio_especifico') NULL DEFAULT 'todos',
  PRIMARY KEY (`id_cupon`),
  UNIQUE INDEX `codigo` (`codigo` ASC) VISIBLE,
  INDEX `idx_codigo` (`codigo` ASC) VISIBLE,
  INDEX `idx_empresa` (`id_empresa` ASC) VISIBLE,
  INDEX `idx_activo` (`activo` ASC) VISIBLE,
  INDEX `idx_fecha_expiracion` (`fecha_expiracion` ASC) VISIBLE,
  CONSTRAINT `cupon_ibfk_1`
    FOREIGN KEY (`id_empresa`)
    REFERENCES `app_servicios`.`empresa` (`id_empresa`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`contratacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`contratacion` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`contratacion` (
  `id_contratacion` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `id_servicio` INT NOT NULL,
  `id_sucursal` INT NOT NULL,
  `id_direccion_entrega` INT NOT NULL,
  `id_cupon` INT NULL DEFAULT NULL,
  `fecha_solicitud` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_programada` DATETIME NULL DEFAULT NULL,
  `fecha_completada` DATETIME NULL DEFAULT NULL,
  `precio_subtotal` DECIMAL(10,2) NOT NULL,
  `descuento_aplicado` DECIMAL(10,2) NULL DEFAULT '0.00',
  `precio_total` DECIMAL(10,2) NOT NULL,
  `estado` ENUM('pendiente', 'confirmado', 'en_proceso', 'completado', 'cancelado', 'rechazado') NULL DEFAULT 'pendiente',
  `notas_cliente` TEXT NULL DEFAULT NULL,
  `notas_empresa` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id_contratacion`),
  INDEX `id_sucursal` (`id_sucursal` ASC) VISIBLE,
  INDEX `id_direccion_entrega` (`id_direccion_entrega` ASC) VISIBLE,
  INDEX `id_cupon` (`id_cupon` ASC) VISIBLE,
  INDEX `idx_cliente` (`id_cliente` ASC) VISIBLE,
  INDEX `idx_servicio` (`id_servicio` ASC) VISIBLE,
  INDEX `idx_estado` (`estado` ASC) VISIBLE,
  INDEX `idx_fecha_solicitud` (`fecha_solicitud` ASC) VISIBLE,
  INDEX `idx_fecha_programada` (`fecha_programada` ASC) VISIBLE,
  INDEX `idx_contratacion_cliente_estado` (`id_cliente` ASC, `estado` ASC) VISIBLE,
  CONSTRAINT `contratacion_ibfk_1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `app_servicios`.`cliente` (`id_cliente`)
    ON DELETE RESTRICT,
  CONSTRAINT `contratacion_ibfk_2`
    FOREIGN KEY (`id_servicio`)
    REFERENCES `app_servicios`.`servicio` (`id_servicio`)
    ON DELETE RESTRICT,
  CONSTRAINT `contratacion_ibfk_3`
    FOREIGN KEY (`id_sucursal`)
    REFERENCES `app_servicios`.`sucursal` (`id_sucursal`)
    ON DELETE RESTRICT,
  CONSTRAINT `contratacion_ibfk_4`
    FOREIGN KEY (`id_direccion_entrega`)
    REFERENCES `app_servicios`.`direccion` (`id_direccion`)
    ON DELETE RESTRICT,
  CONSTRAINT `contratacion_ibfk_5`
    FOREIGN KEY (`id_cupon`)
    REFERENCES `app_servicios`.`cupon` (`id_cupon`)
    ON DELETE SET NULL)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`calificacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`calificacion` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`calificacion` (
  `id_calificacion` INT NOT NULL AUTO_INCREMENT,
  `id_contratacion` INT NOT NULL,
  `calificacion` TINYINT NOT NULL,
  `comentario` TEXT NULL DEFAULT NULL,
  `fecha_calificacion` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo` ENUM('cliente_a_empresa', 'empresa_a_cliente') NOT NULL,
  PRIMARY KEY (`id_calificacion`),
  INDEX `idx_contratacion` (`id_contratacion` ASC) VISIBLE,
  INDEX `idx_tipo` (`tipo` ASC) VISIBLE,
  INDEX `idx_calificacion` (`calificacion` ASC) VISIBLE,
  CONSTRAINT `calificacion_ibfk_1`
    FOREIGN KEY (`id_contratacion`)
    REFERENCES `app_servicios`.`contratacion` (`id_contratacion`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`conversacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`conversacion` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`conversacion` (
  `id_conversacion` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `id_empresa` INT NOT NULL,
  `id_contratacion` INT NULL DEFAULT NULL COMMENT 'Puede ser NULL si es una consulta general',
  `fecha_inicio` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_ultimo_mensaje` DATETIME NULL DEFAULT NULL,
  `estado` ENUM('abierta', 'cerrada', 'archivada') NULL DEFAULT 'abierta',
  PRIMARY KEY (`id_conversacion`),
  INDEX `id_contratacion` (`id_contratacion` ASC) VISIBLE,
  INDEX `idx_cliente` (`id_cliente` ASC) VISIBLE,
  INDEX `idx_empresa` (`id_empresa` ASC) VISIBLE,
  INDEX `idx_estado` (`estado` ASC) VISIBLE,
  CONSTRAINT `conversacion_ibfk_1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `app_servicios`.`cliente` (`id_cliente`)
    ON DELETE CASCADE,
  CONSTRAINT `conversacion_ibfk_2`
    FOREIGN KEY (`id_empresa`)
    REFERENCES `app_servicios`.`empresa` (`id_empresa`)
    ON DELETE CASCADE,
  CONSTRAINT `conversacion_ibfk_3`
    FOREIGN KEY (`id_contratacion`)
    REFERENCES `app_servicios`.`contratacion` (`id_contratacion`)
    ON DELETE SET NULL)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`cupon_categoria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`cupon_categoria` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`cupon_categoria` (
  `id_cupon` INT NOT NULL,
  `id_categoria` INT NOT NULL,
  PRIMARY KEY (`id_cupon`, `id_categoria`),
  INDEX `fk_cupon_categoria_cupon1_idx` (`id_cupon` ASC) VISIBLE,
  INDEX `fk_cupon_categoria_categoria_servicio1_idx` (`id_categoria` ASC) VISIBLE,
  CONSTRAINT `fk_cupon_categoria_categoria_servicio1`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `app_servicios`.`categoria_servicio` (`id_categoria`),
  CONSTRAINT `fk_cupon_categoria_cupon1`
    FOREIGN KEY (`id_cupon`)
    REFERENCES `app_servicios`.`cupon` (`id_cupon`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`cupon_servicio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`cupon_servicio` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`cupon_servicio` (
  `id_cupon` INT NOT NULL,
  `id_servicio` INT NOT NULL,
  PRIMARY KEY (`id_cupon`, `id_servicio`),
  INDEX `id_servicio` (`id_servicio` ASC) VISIBLE,
  CONSTRAINT `cupon_servicio_ibfk_1`
    FOREIGN KEY (`id_cupon`)
    REFERENCES `app_servicios`.`cupon` (`id_cupon`)
    ON DELETE CASCADE,
  CONSTRAINT `cupon_servicio_ibfk_2`
    FOREIGN KEY (`id_servicio`)
    REFERENCES `app_servicios`.`servicio` (`id_servicio`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`direcciones_del_cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`direcciones_del_cliente` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`direcciones_del_cliente` (
  `id_cliente` INT NOT NULL,
  `id_direccion` INT NOT NULL,
  `alias` VARCHAR(45) NULL DEFAULT NULL,
  `es_principal` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id_cliente`, `id_direccion`),
  INDEX `fk_cliente_has_direccion_direccion1_idx` (`id_direccion` ASC) VISIBLE,
  INDEX `fk_cliente_has_direccion_cliente1_idx` (`id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_cliente_has_direccion_cliente1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `app_servicios`.`cliente` (`id_cliente`),
  CONSTRAINT `fk_cliente_has_direccion_direccion1`
    FOREIGN KEY (`id_direccion`)
    REFERENCES `app_servicios`.`direccion` (`id_direccion`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`mensaje`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`mensaje` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`mensaje` (
  `id_mensaje` INT NOT NULL AUTO_INCREMENT,
  `id_conversacion` INT NOT NULL,
  `id_remitente` INT NOT NULL,
  `contenido` TEXT NOT NULL,
  `tipo_mensaje` ENUM('texto', 'imagen', 'archivo', 'audio') NULL DEFAULT 'texto',
  `archivo_url` VARCHAR(500) NULL DEFAULT NULL,
  `fecha_envio` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `leido` TINYINT(1) NULL DEFAULT '0',
  `fecha_lectura` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id_mensaje`),
  INDEX `idx_conversacion` (`id_conversacion` ASC) VISIBLE,
  INDEX `idx_remitente` (`id_remitente` ASC) VISIBLE,
  INDEX `idx_leido` (`leido` ASC) VISIBLE,
  INDEX `idx_fecha_envio` (`fecha_envio` ASC) VISIBLE,
  INDEX `idx_mensaje_conversacion_fecha` (`id_conversacion` ASC, `fecha_envio` ASC) VISIBLE,
  CONSTRAINT `mensaje_ibfk_1`
    FOREIGN KEY (`id_conversacion`)
    REFERENCES `app_servicios`.`conversacion` (`id_conversacion`)
    ON DELETE CASCADE,
  CONSTRAINT `mensaje_ibfk_2`
    FOREIGN KEY (`id_remitente`)
    REFERENCES `app_servicios`.`usuario` (`id_usuario`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`notificacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`notificacion` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`notificacion` (
  `id_notificacion` INT NOT NULL AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `titulo` VARCHAR(255) NOT NULL,
  `contenido` TEXT NULL DEFAULT NULL,
  `tipo` ENUM('nuevo_mensaje', 'cambio_estado', 'nuevo_cupon', 'calificacion', 'pago', 'sistema') NOT NULL,
  `referencia_id` INT NULL DEFAULT NULL COMMENT 'ID de la entidad relacionada',
  `referencia_tipo` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Tipo de entidad (mensaje, contratacion, cupon, etc)',
  `leida` TINYINT(1) NULL DEFAULT '0',
  `fecha_creacion` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_lectura` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id_notificacion`),
  INDEX `idx_usuario` (`id_usuario` ASC) VISIBLE,
  INDEX `idx_leida` (`leida` ASC) VISIBLE,
  INDEX `idx_tipo` (`tipo` ASC) VISIBLE,
  INDEX `idx_fecha_creacion` (`fecha_creacion` ASC) VISIBLE,
  CONSTRAINT `notificacion_ibfk_1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `app_servicios`.`usuario` (`id_usuario`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`pago`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`pago` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`pago` (
  `id_pago` INT NOT NULL AUTO_INCREMENT,
  `id_contratacion` INT NOT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `metodo_pago` ENUM('tarjeta_credito', 'tarjeta_debito', 'efectivo', 'transferencia', 'paypal', 'otro') NOT NULL,
  `estado_pago` ENUM('pendiente', 'completado', 'fallido', 'reembolsado') NULL DEFAULT 'pendiente',
  `fecha_pago` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `referencia_transaccion` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  INDEX `idx_contratacion` (`id_contratacion` ASC) VISIBLE,
  INDEX `idx_estado_pago` (`estado_pago` ASC) VISIBLE,
  INDEX `idx_referencia` (`referencia_transaccion` ASC) VISIBLE,
  CONSTRAINT `pago_ibfk_1`
    FOREIGN KEY (`id_contratacion`)
    REFERENCES `app_servicios`.`contratacion` (`id_contratacion`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`servicio_favorito`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`servicio_favorito` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`servicio_favorito` (
  `id_servicio` INT NOT NULL,
  `id_cliente` INT NOT NULL,
  `fecha_agregado` DATETIME NULL DEFAULT NULL,
  `notas_cliente` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_servicio`, `id_cliente`),
  INDEX `fk_servicio_has_cliente_cliente1_idx` (`id_cliente` ASC) VISIBLE,
  INDEX `fk_servicio_has_cliente_servicio1_idx` (`id_servicio` ASC) VISIBLE,
  CONSTRAINT `fk_servicio_has_cliente_cliente1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `app_servicios`.`cliente` (`id_cliente`),
  CONSTRAINT `fk_servicio_has_cliente_servicio1`
    FOREIGN KEY (`id_servicio`)
    REFERENCES `app_servicios`.`servicio` (`id_servicio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `app_servicios`.`servicio_sucursal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`servicio_sucursal` ;

CREATE TABLE IF NOT EXISTS `app_servicios`.`servicio_sucursal` (
  `id_servicio` INT NOT NULL,
  `id_sucursal` INT NOT NULL,
  `disponible` TINYINT(1) NULL DEFAULT '1',
  `precio_sucursal` DECIMAL(10,2) NULL DEFAULT NULL COMMENT 'Precio específico de la sucursal (si difiere del base)',
  PRIMARY KEY (`id_servicio`, `id_sucursal`),
  INDEX `id_sucursal` (`id_sucursal` ASC) VISIBLE,
  INDEX `idx_disponible` (`disponible` ASC) VISIBLE,
  CONSTRAINT `servicio_sucursal_ibfk_1`
    FOREIGN KEY (`id_servicio`)
    REFERENCES `app_servicios`.`servicio` (`id_servicio`)
    ON DELETE CASCADE,
  CONSTRAINT `servicio_sucursal_ibfk_2`
    FOREIGN KEY (`id_sucursal`)
    REFERENCES `app_servicios`.`sucursal` (`id_sucursal`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

USE `app_servicios` ;

-- -----------------------------------------------------
-- Placeholder table for view `app_servicios`.`vista_contrataciones_detalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_servicios`.`vista_contrataciones_detalle` (`id_contratacion` INT, `fecha_solicitud` INT, `fecha_programada` INT, `estado_contratacion` INT, `precio_total` INT, `cliente_nombre` INT, `cliente_email` INT, `servicio_nombre` INT, `empresa_nombre` INT, `nombre_sucursal` INT, `direccion_entrega` INT, `cupon_codigo` INT, `descuento_aplicado` INT);

-- -----------------------------------------------------
-- Placeholder table for view `app_servicios`.`vista_estadisticas_empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_servicios`.`vista_estadisticas_empresa` (`id_empresa` INT, `razon_social` INT, `calificacion_promedio` INT, `total_servicios` INT, `total_sucursales` INT, `total_contrataciones` INT, `ingresos_totales` INT, `cupones_activos` INT);

-- -----------------------------------------------------
-- Placeholder table for view `app_servicios`.`vista_servicios_completos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_servicios`.`vista_servicios_completos` (`id_servicio` INT, `servicio_nombre` INT, `descripcion` INT, `precio_base` INT, `duracion_estimada` INT, `servicio_estado` INT, `categoria_nombre` INT, `empresa_nombre` INT, `empresa_calificacion` INT, `empresa_email` INT, `empresa_telefono` INT);

-- -----------------------------------------------------
-- Placeholder table for view `app_servicios`.`vista_sucursales_direccion_completa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_servicios`.`vista_sucursales_direccion_completa` (`id_sucursal` INT, `nombre_sucursal` INT, `empresa_nombre` INT, `calle_principal` INT, `calle_secundaria` INT, `numero` INT, `ciudad` INT, `provincia_estado` INT, `codigo_postal` INT, `pais` INT, `latitud` INT, `longitud` INT, `piso` INT, `numero_local` INT, `referencias_especificas` INT, `direccion_completa` INT, `telefono` INT, `horario_apertura` INT, `horario_cierre` INT, `estado` INT);

-- -----------------------------------------------------
-- procedure sp_servicios_por_ubicacion
-- -----------------------------------------------------

USE `app_servicios`;
DROP procedure IF EXISTS `app_servicios`.`sp_servicios_por_ubicacion`;

DELIMITER $$
USE `app_servicios`$$
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `app_servicios`.`vista_contrataciones_detalle`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`vista_contrataciones_detalle`;
DROP VIEW IF EXISTS `app_servicios`.`vista_contrataciones_detalle` ;
USE `app_servicios`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `app_servicios`.`vista_contrataciones_detalle` AS select `con`.`id_contratacion` AS `id_contratacion`,`con`.`fecha_solicitud` AS `fecha_solicitud`,`con`.`fecha_programada` AS `fecha_programada`,`con`.`estado` AS `estado_contratacion`,`con`.`precio_total` AS `precio_total`,concat(`uc`.`nombre`,' ',`uc`.`apellido`) AS `cliente_nombre`,`uc`.`email` AS `cliente_email`,`s`.`nombre` AS `servicio_nombre`,`e`.`razon_social` AS `empresa_nombre`,`suc`.`nombre_sucursal` AS `nombre_sucursal`,concat(`d`.`calle_principal`,', ',`d`.`ciudad`) AS `direccion_entrega`,`cup`.`codigo` AS `cupon_codigo`,`con`.`descuento_aplicado` AS `descuento_aplicado` from ((((((((`app_servicios`.`contratacion` `con` join `app_servicios`.`cliente` `cli` on((`con`.`id_cliente` = `cli`.`id_cliente`))) join `app_servicios`.`usuario` `uc` on((`cli`.`id_usuario` = `uc`.`id_usuario`))) join `app_servicios`.`servicio` `s` on((`con`.`id_servicio` = `s`.`id_servicio`))) join `app_servicios`.`empresa` `e` on((`s`.`id_empresa` = `e`.`id_empresa`))) join `app_servicios`.`usuario` `ue` on((`e`.`id_usuario` = `ue`.`id_usuario`))) join `app_servicios`.`sucursal` `suc` on((`con`.`id_sucursal` = `suc`.`id_sucursal`))) join `app_servicios`.`direccion` `d` on((`con`.`id_direccion_entrega` = `d`.`id_direccion`))) left join `app_servicios`.`cupon` `cup` on((`con`.`id_cupon` = `cup`.`id_cupon`)));

-- -----------------------------------------------------
-- View `app_servicios`.`vista_estadisticas_empresa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`vista_estadisticas_empresa`;
DROP VIEW IF EXISTS `app_servicios`.`vista_estadisticas_empresa` ;
USE `app_servicios`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `app_servicios`.`vista_estadisticas_empresa` AS select `e`.`id_empresa` AS `id_empresa`,`e`.`razon_social` AS `razon_social`,`e`.`calificacion_promedio` AS `calificacion_promedio`,count(distinct `s`.`id_servicio`) AS `total_servicios`,count(distinct `suc`.`id_sucursal`) AS `total_sucursales`,count(distinct `con`.`id_contratacion`) AS `total_contrataciones`,sum((case when (`con`.`estado` = 'completado') then `con`.`precio_total` else 0 end)) AS `ingresos_totales`,count(distinct `cup`.`id_cupon`) AS `cupones_activos` from ((((`app_servicios`.`empresa` `e` left join `app_servicios`.`servicio` `s` on((`e`.`id_empresa` = `s`.`id_empresa`))) left join `app_servicios`.`sucursal` `suc` on((`e`.`id_empresa` = `suc`.`id_empresa`))) left join `app_servicios`.`contratacion` `con` on((`s`.`id_servicio` = `con`.`id_servicio`))) left join `app_servicios`.`cupon` `cup` on(((`e`.`id_empresa` = `cup`.`id_empresa`) and (`cup`.`activo` = true)))) group by `e`.`id_empresa`,`e`.`razon_social`,`e`.`calificacion_promedio`;

-- -----------------------------------------------------
-- View `app_servicios`.`vista_servicios_completos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`vista_servicios_completos`;
DROP VIEW IF EXISTS `app_servicios`.`vista_servicios_completos` ;
USE `app_servicios`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `app_servicios`.`vista_servicios_completos` AS select `s`.`id_servicio` AS `id_servicio`,`s`.`nombre` AS `servicio_nombre`,`s`.`descripcion` AS `descripcion`,`s`.`precio_base` AS `precio_base`,`s`.`duracion_estimada` AS `duracion_estimada`,`s`.`estado` AS `servicio_estado`,`c`.`nombre` AS `categoria_nombre`,`e`.`razon_social` AS `empresa_nombre`,`e`.`calificacion_promedio` AS `empresa_calificacion`,`u`.`email` AS `empresa_email`,`u`.`telefono` AS `empresa_telefono` from (((`app_servicios`.`servicio` `s` join `app_servicios`.`categoria_servicio` `c` on((`s`.`id_categoria` = `c`.`id_categoria`))) join `app_servicios`.`empresa` `e` on((`s`.`id_empresa` = `e`.`id_empresa`))) join `app_servicios`.`usuario` `u` on((`e`.`id_usuario` = `u`.`id_usuario`))) where (`s`.`estado` = 'disponible');

-- -----------------------------------------------------
-- View `app_servicios`.`vista_sucursales_direccion_completa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `app_servicios`.`vista_sucursales_direccion_completa`;
DROP VIEW IF EXISTS `app_servicios`.`vista_sucursales_direccion_completa` ;
USE `app_servicios`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `app_servicios`.`vista_sucursales_direccion_completa` AS select `suc`.`id_sucursal` AS `id_sucursal`,`suc`.`nombre_sucursal` AS `nombre_sucursal`,`e`.`razon_social` AS `empresa_nombre`,`d`.`calle_principal` AS `calle_principal`,`d`.`calle_secundaria` AS `calle_secundaria`,`d`.`numero` AS `numero`,`d`.`ciudad` AS `ciudad`,`d`.`provincia_estado` AS `provincia_estado`,`d`.`codigo_postal` AS `codigo_postal`,`d`.`pais` AS `pais`,`d`.`latitud` AS `latitud`,`d`.`longitud` AS `longitud`,`suc`.`piso` AS `piso`,`suc`.`numero_local` AS `numero_local`,`suc`.`referencias_especificas` AS `referencias_especificas`,concat(`d`.`calle_principal`,ifnull(concat(' y ',`d`.`calle_secundaria`),''),ifnull(concat(' N°',`d`.`numero`),''),ifnull(concat(', Piso ',`suc`.`piso`),''),ifnull(concat(', Local ',`suc`.`numero_local`),''),', ',`d`.`ciudad`,', ',`d`.`provincia_estado`) AS `direccion_completa`,`suc`.`telefono` AS `telefono`,`suc`.`horario_apertura` AS `horario_apertura`,`suc`.`horario_cierre` AS `horario_cierre`,`suc`.`estado` AS `estado` from ((`app_servicios`.`sucursal` `suc` join `app_servicios`.`direccion` `d` on((`suc`.`id_direccion` = `d`.`id_direccion`))) join `app_servicios`.`empresa` `e` on((`suc`.`id_empresa` = `e`.`id_empresa`)));
USE `app_servicios`;

DELIMITER $$

USE `app_servicios`$$
DROP TRIGGER IF EXISTS `app_servicios`.`trg_incrementar_uso_cupon` $$
USE `app_servicios`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `app_servicios`.`trg_incrementar_uso_cupon`
AFTER INSERT ON `app_servicios`.`contratacion`
FOR EACH ROW
BEGIN
    IF NEW.id_cupon IS NOT NULL THEN
        UPDATE cupon
        SET cantidad_usada = cantidad_usada + 1
        WHERE id_cupon = NEW.id_cupon;
    END IF;
END$$


USE `app_servicios`$$
DROP TRIGGER IF EXISTS `app_servicios`.`trg_actualizar_calificacion_empresa` $$
USE `app_servicios`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `app_servicios`.`trg_actualizar_calificacion_empresa`
AFTER INSERT ON `app_servicios`.`calificacion`
FOR EACH ROW
BEGIN
    IF NEW.tipo = 'cliente_a_empresa' THEN
        UPDATE empresa e
        SET calificacion_promedio = (
            SELECT AVG(cal.calificacion)
            FROM calificacion cal
            INNER JOIN contratacion c ON cal.id_contratacion = c.id_contratacion
            INNER JOIN servicio s ON c.id_servicio = s.id_servicio
            WHERE s.id_empresa = e.id_empresa
            AND cal.tipo = 'cliente_a_empresa'
        )
        WHERE e.id_empresa = (
            SELECT s.id_empresa
            FROM contratacion c
            INNER JOIN servicio s ON c.id_servicio = s.id_servicio
            WHERE c.id_contratacion = NEW.id_contratacion
        );
    END IF;
END$$


USE `app_servicios`$$
DROP TRIGGER IF EXISTS `app_servicios`.`trg_actualizar_ultimo_mensaje` $$
USE `app_servicios`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `app_servicios`.`trg_actualizar_ultimo_mensaje`
AFTER INSERT ON `app_servicios`.`mensaje`
FOR EACH ROW
BEGIN
    UPDATE conversacion
    SET fecha_ultimo_mensaje = NEW.fecha_envio
    WHERE id_conversacion = NEW.id_conversacion;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
