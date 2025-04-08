-- MySQL dump 10.13  Distrib 8.0.39, for Linux (x86_64)
--
-- Host: localhost    Database: elmensual
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `articulos`
--

DROP TABLE IF EXISTS `articulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articulos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `numero` int NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `costo_original` decimal(10,2) NOT NULL,
  `precio_efectivo` decimal(10,2) DEFAULT NULL,
  `precio_transferencia` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero` (`numero`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articulos`
--

LOCK TABLES `articulos` WRITE;
/*!40000 ALTER TABLE `articulos` DISABLE KEYS */;
INSERT INTO `articulos` VALUES (1,1450,'Bombachas de grafa pesada de mujer 32-50',27000.00,15033.00,27000.00,29500.00),(2,111,'Bombachas de grafa pesada 36-54',27000.00,15033.00,27000.00,29500.00),(3,155,'Bombachas de grafil/poplin 36-54',29000.00,16936.00,29500.00,32500.00),(4,107,'Bombachas de grafa pesada largo especial 36-54',31000.00,16915.00,29500.00,32500.00),(5,116,'Bombachas de grafa pesada corto especial 36-54',27000.00,14996.00,27000.00,29500.00),(6,118,'Bombachas de grafa pesada niños 0-8',22000.00,11216.00,20000.00,22000.00),(7,119,'Bombachas de grafa pesada niños 8-16',22000.00,11403.00,20500.00,22500.00),(8,112,'Bombachas de corderoy 36-54',55000.00,32302.00,56500.00,62000.00),(12,213,'Alpargata reforzada 34 al 45',7500.00,4235.00,7500.00,8500.00),(13,158,'Bombachas de grafil/poplin largo especial 38-52',33000.00,18746.00,33000.00,36000.00),(14,148,'Bombachas de grafil/poplin de dama 32-54',29000.00,16936.00,29500.00,32500.00),(15,140,'Bermuda poplin cargo 36-54',28000.00,16270.00,28500.00,31500.00),(16,135,'Bombachas de grafa liviana con cierre 36-54',25500.00,14100.00,25500.00,28000.00),(17,12508,'Bombachas de poplin de niños 0-8',23000.00,12828.00,23000.00,25500.00),(18,178,'Bombachas de grafil/poplin corto especial 36-54',29000.00,16900.00,29500.00,32500.00),(21,445,'Bombachas de grafa pesada extra super especial 68-70',38000.00,21632.00,38000.00,41500.00),(22,106,'Camisa de trabajo de grafa 38-50',27000.00,15033.00,27000.00,30000.00),(23,101,'Bombachas de grafa pesada 56-60',29000.00,16863.00,29500.00,32500.00),(24,113,'Bombachas de grafa pesada largo especial 56-60',33000.00,18829.00,33000.00,36000.00),(25,157,'Bombachas de grafa pesada corto especial 56-60',29000.00,16593.00,29000.00,32000.00),(28,110,'Bombachas de grafa liviana 56-60',29000.00,16473.00,29000.00,31500.00),(29,114,'Bombachas de grafa liviana 62-66',35000.00,19832.00,34500.00,38000.00),(30,121,'Bombachas de grafa liviana largo especial 36-54',29000.00,16733.00,29500.00,32000.00),(31,138,'Bombachas de grafa liviana corto especial 36-54',27000.00,14731.00,26500.00,29000.00),(32,145,'Bombachas de grafa liviana de dama 32-50',27000.00,14731.00,26500.00,29000.00),(33,102,'Bombachas alforzada pesada 36-56',29000.00,16338.00,28500.00,31500.00),(34,120,'Bombachas alforzada liviana 36-56',29000.00,16150.00,28500.00,31000.00),(35,103,'Bombachas bataraza niño 0-8',25000.00,13738.00,24500.00,27000.00),(36,104,'Bombachas batarazas niño 10-16',25000.00,13977.00,25000.00,27500.00),(37,133,'Bombachas bataraza 36-54',32000.00,18356.00,32000.00,35500.00),(38,125,'Bombachas de poplin de niño 10-16',25000.00,13748.00,24500.00,27000.00),(39,162,'Bombachas fantasia 38-54',33000.00,19120.00,33500.00,37000.00),(42,183,'Bombachas de grafa con espander talle 36-54',30000.00,16936.00,29500.00,32500.00),(43,126,'Bombachas de corderoy largo especial 36-54',64000.00,36400.00,63500.00,70000.00),(44,128,'Bombachas de corderoy niño 0-8',45000.00,25464.00,44500.00,49000.00),(45,129,'Bombachas de corderoy niños 10-16',45000.00,25750.00,45000.00,49500.00),(46,153,'Pantalon de corderoy 40-54',57000.00,32302.00,56500.00,62000.00),(47,154,'Bombachas de dama de corderoy 34-48',55000.00,32302.00,56500.00,62000.00),(48,180,'Bombachas de corderoy corto especial 36-54',55000.00,31603.00,55500.00,61000.00),(49,105,'Pantalon de trabajo 38-54',27000.00,15033.00,27000.00,30000.00),(50,141,'Pantalon Cargo 38-54',40000.00,22812.00,40000.00,44000.00),(51,201,'Pantalon de trabajo 62-66',32000.00,18236.00,32000.00,35000.00),(52,202,'Pantalon de trabajo 56-60',29000.00,16541.00,29000.00,32000.00),(53,108,'Camisa de trabajo 48-54',29000.00,16900.00,29500.00,32500.00),(54,147,'Camiseta Scout niño 30-36',26000.00,14398.00,26000.00,28500.00),(55,143,'Bermuda poplin 56-60',24000.00,13488.00,24500.00,26500.00),(56,411,'Bombachas de sarga pesada 36-54',24000.00,13199.00,24000.00,26000.00),(57,409,'Bombachas sarga liviana 36-54',24000.00,12979.00,23500.00,25500.00),(58,600,'Boinas de hilo',12000.00,6930.00,12500.00,13500.00),(59,149,'Jean Recto Rigido 38-54',28000.00,15360.00,27500.00,30500.00),(60,150,'Jean recto con espander 38-54',28000.00,15360.00,27500.00,30500.00);
/*!40000 ALTER TABLE `articulos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cuit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `apellido` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cbu` varchar(22) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (15,'23381453669','Gonzalo','Gurruchaga',NULL,'2024-09-08 18:53:37','2024-09-24 01:03:33'),(16,NULL,'Maida','Irazoqui','0140189503520652479694','2024-09-08 19:28:31','2024-09-08 19:28:31'),(17,NULL,'Gabriela','Salinas','0110030330003027148297','2024-09-08 19:35:58','2024-09-08 19:35:58'),(18,'30728890','Julian Hipolito Raul','Coralli',NULL,'2024-09-08 19:38:30','2024-09-08 19:38:30'),(19,NULL,'Mariano Ivan','Rusnak','0140121503690350985488','2024-09-08 19:40:40','2024-09-08 19:40:40'),(20,NULL,'Luciana','Satriano',NULL,'2024-09-08 19:43:13','2024-09-08 19:43:13'),(21,NULL,'Gladys Veronica','Dell','0140084703503052635491','2024-09-08 19:44:42','2024-09-08 19:44:42'),(22,NULL,'Rocio Aylen','Buceta Orellano','0140344003690052688771','2024-09-08 19:48:13','2024-09-08 19:48:13'),(23,NULL,'Rosario','Zabala','0140445003690550346128','2024-09-08 19:49:34','2024-09-08 19:49:34'),(24,NULL,'Rafael','Terron',NULL,'2024-09-08 19:57:28','2024-09-08 19:57:28'),(25,NULL,'Sabrina Ester','Affronte','0140999803200061814142','2024-09-08 20:01:16','2024-09-08 20:01:16'),(26,'20412549970','Laura Valeria','Cornejo','0000003100028656232347','2024-09-09 17:42:53','2024-09-09 17:42:53'),(27,'20422942980','Benjamin Andrada','Barrone','0000003100073384560770','2024-09-10 00:41:57','2024-09-10 00:41:57'),(28,'20209145368','Andres Juan','Saggese','0140306803644351096559','2024-09-10 01:08:40','2024-09-10 01:08:40'),(29,NULL,'Yamila Ester','Hours Santero','4530000800018714974096','2024-09-10 17:28:37','2024-09-10 17:28:37'),(34,NULL,'Mariana','Caporossi','0140306803644352387735','2024-09-10 19:40:13','2024-09-10 19:40:13'),(35,NULL,'Clara','Bormape',NULL,'2024-09-12 19:36:05','2024-09-12 19:36:05'),(39,NULL,'Agustina','Caballero','0140000703100090261938','2024-09-13 23:02:18','2024-09-13 23:02:18'),(40,'27433014796','Agustina Valeria','Ayala','0000003100009412016557','2024-09-17 17:33:56','2024-09-17 17:33:56'),(41,'20339550051','Miguel Angel','Copa',NULL,'2024-09-18 22:16:12','2024-09-18 22:16:12'),(42,NULL,'Ailen','Tornielli',NULL,'2024-09-18 22:33:05','2024-09-18 22:33:05'),(43,NULL,'Maximo Esteban','Garcia Wegner','0140121503690350718011','2024-09-19 00:32:15','2024-09-19 00:32:15'),(44,'20429417571','Sixto Antonio','Puppo','0000003100078825734330','2024-09-19 00:50:34','2024-09-19 00:50:34'),(46,NULL,'Lucas','Garcia',NULL,'2024-09-20 20:49:53','2024-09-20 20:49:53'),(53,'20383263272','Nahuel','Acosta',NULL,NULL,NULL),(54,NULL,'Flor','Velasquez',NULL,NULL,NULL),(58,'27452251391','Malena','Saggese',NULL,'2024-09-24 05:39:22','2024-09-24 05:39:22'),(59,'27180552672','Silvia Leonilda','Dominguez',NULL,'2024-09-27 21:41:06','2024-09-27 21:41:06'),(60,NULL,'Nahuel','Taylor',NULL,'2024-09-28 17:15:31','2024-09-28 17:15:31'),(61,NULL,'Evelin','Irazoqui','0140188803520052378742','2024-10-02 01:38:53','2024-10-02 01:38:53'),(62,NULL,'Andrea','Melgarejo',NULL,'2024-10-04 00:18:21','2024-10-04 00:18:21'),(63,'27428819670','Juana','Morales',NULL,'2024-10-06 14:04:42','2024-10-06 14:04:42'),(64,'27301320650','Maria Luciana','Traboni','0140402303707251474921','2024-10-07 19:04:28','2024-10-08 14:57:43'),(65,NULL,'Nacho','Gnavi',NULL,'2024-10-07 19:06:38','2024-10-07 19:06:38'),(66,NULL,'Sol Agustina','Sack','0140191803520851524885','2024-10-07 21:04:08','2024-10-07 21:04:08'),(67,NULL,'Facundo','Luna',NULL,'2024-10-07 21:18:33','2024-10-07 21:18:33'),(68,'27445196431','Catalina','Pachame',NULL,'2024-10-08 16:31:46','2024-10-08 16:31:46'),(69,NULL,'Lolo','Sarries',NULL,'2024-10-08 17:39:03','2024-10-08 17:39:03'),(70,NULL,'Cami','Figueroa',NULL,'2024-10-08 21:49:04','2024-10-08 21:49:04'),(71,'27420472507','Ailen','Ruth Gardella',NULL,'2024-10-08 21:50:37','2024-10-08 21:50:37'),(72,NULL,'Facundo Javier','Somma','0070172930004083118224','2024-10-09 15:51:24','2024-10-09 15:51:24'),(73,'27441677907','Guadalupe','Barontini','0000076500000002050522','2024-10-10 15:05:40','2024-10-10 16:46:29'),(74,NULL,'Yazmin','Longobardi',NULL,'2024-10-10 16:07:22','2024-10-10 16:07:22'),(75,'23481774594','Lourdes Morena','Correa',NULL,'2024-10-10 17:29:38','2024-10-10 17:29:38'),(76,'27389610602','Carol Irina','Lopez',NULL,'2024-10-10 21:44:21','2024-10-10 21:44:21'),(77,NULL,'Micaela','Sanchez',NULL,'2024-10-10 23:37:47','2024-10-10 23:37:47'),(78,'20331136612','Lucas Dario','Avenda??o',NULL,'2024-10-11 17:49:28','2024-10-11 17:49:28'),(79,'27449293458','Noelia Sofia','Belloni',NULL,'2024-10-13 01:49:01','2024-10-13 01:49:01'),(80,'20317298413','Eduardo','Irastorza',NULL,'2024-10-14 18:13:19','2024-10-14 18:13:19'),(81,NULL,'Lucrecia','Rivas','0140084703503051012390','2024-10-14 18:16:09','2024-10-24 17:55:34'),(82,NULL,'Anahi','Amarilla',NULL,'2024-10-17 13:59:37','2024-10-17 13:59:37'),(83,'20348003780','Diego Hernan','Lopez',NULL,'2024-10-17 18:28:10','2024-10-17 18:29:48'),(84,NULL,'Sofia','Heredia',NULL,'2024-10-17 22:38:06','2024-10-17 22:38:06'),(85,NULL,'Luciana','Lopez',NULL,'2024-10-18 14:47:38','2024-10-18 14:47:38'),(86,NULL,'Aien','Navarro',NULL,'2024-10-18 15:13:41','2024-10-18 15:13:41'),(87,NULL,'Valentin','Rabe',NULL,'2024-10-18 22:48:57','2024-10-18 22:48:57'),(88,NULL,'Matias','Aleman',NULL,'2024-10-18 22:50:44','2024-10-18 22:50:44'),(89,NULL,'Andres','Saggese',NULL,'2024-10-21 02:14:20','2024-10-21 02:14:20'),(90,'27265430681','Maria Laura','Bruzzone',NULL,'2024-10-21 14:29:41','2024-10-21 14:29:41'),(91,NULL,'Martina','Saggese',NULL,'2024-10-21 14:31:10','2024-10-21 14:31:10'),(92,NULL,'Gladys','Amador',NULL,'2024-10-22 21:37:42','2024-10-22 21:37:42'),(93,'20439802643','Guadalupe','Funes',NULL,'2024-10-22 21:40:54','2024-10-22 22:13:48'),(94,'20449346891','Juan Ignacio','Marruedo',NULL,'2024-10-22 21:42:32','2024-10-22 21:42:32'),(95,'20373220583','Santiago','Falco',NULL,'2024-10-22 21:45:01','2024-10-22 21:45:01'),(96,'27421542789','Agustina','Guazzi',NULL,'2024-10-22 21:53:33','2024-10-22 21:53:33'),(97,'20964174572','Fernando Valentin','Martinez',NULL,'2024-10-23 14:42:12','2024-10-23 14:42:12'),(98,NULL,'Tomy','Diniro',NULL,'2024-10-23 21:44:15','2024-10-23 21:44:15'),(99,'20390992875','Ramiro','Ventura',NULL,'2024-10-23 21:45:08','2024-10-23 21:45:08'),(100,'27410016686','Federica Agustina','Guardia',NULL,'2024-10-23 23:36:00','2024-10-23 23:36:00'),(101,'20439686562','Mariano Lopez','Seco',NULL,'2024-10-25 17:50:09','2024-10-25 17:50:09'),(102,'27455199358','Morena','Norry',NULL,'2024-10-26 22:50:25','2024-10-26 22:50:25'),(103,'20452963168','Gaston','De Barrio',NULL,'2024-10-30 22:48:15','2024-10-30 22:48:15'),(104,NULL,'Federico Claudio','Cejas',NULL,'2024-10-31 22:39:56','2024-10-31 22:39:56'),(105,'27349923152','Anabella','Moretti','0150803902000102152580','2024-11-04 22:02:33','2024-11-07 13:09:49'),(106,'20184088860','Daniel','Fernandez',NULL,'2024-11-04 22:05:14','2024-11-04 22:05:14'),(107,'27370211863','Belen Johanna','Asteazaran',NULL,'2024-11-06 00:01:56','2024-11-06 00:01:56'),(108,'27404428816','Sofia Mariel','Cia',NULL,'2024-11-06 00:35:58','2024-11-06 00:35:58'),(109,NULL,'Gonzalo','Juarez',NULL,'2024-11-07 17:15:09','2024-11-07 17:15:09'),(110,'20467427556','Axel Sebastian','Suarez',NULL,'2024-11-08 18:20:27','2024-11-08 18:20:27'),(111,'27437980107','Luisina','Cardoso Amador',NULL,'2024-11-08 18:21:45','2024-11-08 18:21:45'),(112,NULL,'Grego','Marinucci',NULL,'2024-11-15 22:31:08','2024-11-15 22:31:08'),(113,'20241892221','Elbio Daniel','Hock',NULL,'2024-11-21 18:14:50','2024-11-21 18:18:26'),(114,'20168183756','Juan Fabian','Traverso',NULL,'2024-11-21 18:17:13','2024-11-21 18:17:13'),(115,NULL,'Valentina','Beltrantalarico',NULL,'2024-11-21 18:20:30','2024-11-21 18:20:30'),(116,NULL,'Vir','Consentino',NULL,'2024-11-21 18:21:16','2024-11-21 18:21:16'),(117,NULL,'Valentina','Delia',NULL,'2024-11-23 23:53:21','2024-11-23 23:53:21'),(118,'27354087923','Susana','Araceli Bigres',NULL,'2024-11-23 23:56:10','2024-11-23 23:56:10'),(119,'27354175636','Maria Emilia','Bruno',NULL,'2024-12-04 12:53:30','2024-12-04 12:53:30'),(120,'20464497464','Francisco Agustin','Martires',NULL,'2024-12-04 12:55:54','2024-12-04 12:55:54'),(121,NULL,'Maria Emilia','Gonzalez','1910019355101902880353','2024-12-04 12:58:49','2024-12-04 12:58:49'),(122,'20415658347','Lautaro Ezequiel','Aria',NULL,'2024-12-04 13:00:32','2024-12-04 13:00:32'),(123,'20374444477','Reinaldo Sebastian','Ramirez',NULL,'2024-12-04 13:05:19','2024-12-04 13:05:19'),(124,'20445068757','Wilfredo','Ferreira',NULL,'2024-12-04 13:15:19','2024-12-04 13:15:19'),(125,NULL,'Ana','Aranda',NULL,'2024-12-04 13:21:22','2024-12-04 13:21:22'),(126,'23314184904','Laura Daniela','Berecoechea',NULL,'2024-12-04 17:28:02','2024-12-04 17:28:02'),(128,NULL,'Stella','Monte',NULL,'2024-12-05 22:20:27','2024-12-05 22:20:27'),(129,'27472028788','Maria Celina','Ijurado',NULL,'2024-12-05 22:33:40','2024-12-05 22:33:40'),(130,'20329924441','Mauro','Pas',NULL,'2024-12-05 22:34:58','2024-12-05 22:34:58'),(131,NULL,'Nico','Falon',NULL,'2024-12-06 22:06:36','2024-12-06 22:06:36'),(132,NULL,'Tomi','Baena',NULL,'2024-12-07 22:13:42','2024-12-07 22:13:42'),(133,NULL,'Ana','Di Greegori',NULL,'2024-12-11 00:33:55','2024-12-11 00:33:55'),(134,'27456157551','Sol Carina','Rios',NULL,'2024-12-11 00:36:18','2024-12-11 00:36:18'),(135,'23447355124','Magdalena','Farabello',NULL,'2024-12-11 21:53:36','2024-12-11 21:53:36'),(136,NULL,'Sheila','Abramchik',NULL,'2024-12-14 14:32:55','2024-12-14 14:32:55'),(137,NULL,'Carlos','Philipp',NULL,'2024-12-14 14:33:57','2024-12-14 14:33:57'),(138,'27278456663','Yesica Paola','Oliva',NULL,'2024-12-14 18:04:26','2024-12-14 18:04:26'),(139,'27455779915','Mora','Ismael',NULL,'2024-12-20 16:25:16','2024-12-20 16:25:16'),(141,'27342089157','Aldana Norali','Marconi',NULL,'2024-12-20 16:29:08','2024-12-20 16:29:08'),(142,NULL,'Bernardo','Lecce',NULL,'2024-12-20 18:10:36','2024-12-20 18:10:36'),(143,'23339855404','Cintia Antonela','Rodriguez',NULL,'2024-12-20 21:47:33','2024-12-20 21:47:33'),(144,'20444256924','Franco Joaquin','Puillandre',NULL,'2024-12-20 21:49:15','2024-12-20 21:49:15'),(146,NULL,'Daniel','Di Santo',NULL,'2025-01-15 23:10:29','2025-01-15 23:10:29'),(147,NULL,'Anabella','Qui??ones',NULL,'2025-01-15 23:35:31','2025-01-15 23:35:31'),(148,NULL,'Sabri','Qn',NULL,'2025-01-29 18:26:59','2025-01-29 18:26:59'),(149,NULL,'Magdalena','Costa',NULL,'2025-02-03 18:36:58','2025-02-03 18:36:58'),(150,NULL,'Magdalena','Ruth Vilta',NULL,'2025-02-03 23:06:54','2025-02-03 23:06:54'),(151,NULL,'Jaz','Guallarelo',NULL,'2025-02-04 22:48:25','2025-02-04 22:48:25'),(152,'27463295765','Mar??a Paz','Larrazabal',NULL,'2025-02-15 00:56:34','2025-02-15 00:56:34'),(153,NULL,'Tiziana Francesca','Tassone','0140152903700558340230','2025-02-15 00:59:27','2025-02-15 00:59:27'),(154,'27291493543','Rosana Elisabet','Trionfetti',NULL,'2025-02-15 01:00:34','2025-02-15 01:01:09'),(155,'27439473415','Lighuen Hilen','Castillo',NULL,'2025-02-15 01:25:28','2025-02-15 01:25:28'),(156,'27428085200','Milagros','M??rquez',NULL,'2025-02-15 13:31:36','2025-02-15 13:31:36'),(157,NULL,'Tomas','Zaton',NULL,'2025-02-16 19:34:14','2025-02-16 19:34:14'),(158,NULL,'Antonella','Garro',NULL,'2025-02-16 19:35:34','2025-02-16 19:35:34'),(159,NULL,'Alejandro','Juarez',NULL,'2025-02-16 19:37:17','2025-02-16 19:37:17'),(160,NULL,'Maga','Baena',NULL,'2025-02-17 17:16:43','2025-02-17 17:16:43'),(162,'27356820091','Rut Abigail','Merele',NULL,'2025-02-19 14:56:21','2025-02-19 14:56:56'),(163,NULL,'Joaco','Ubamba',NULL,'2025-02-19 21:50:50','2025-02-19 21:50:50'),(164,NULL,'Leandro','Vera',NULL,'2025-02-20 18:08:53','2025-02-20 18:08:53'),(165,NULL,'Pablo Martin','Rodriguez',NULL,'2025-02-22 17:27:53','2025-02-22 17:27:53'),(166,NULL,'Manuel','Nagore',NULL,'2025-02-22 17:29:09','2025-02-22 17:29:09'),(167,'27461861879','Paulina','Springer',NULL,'2025-02-24 16:13:59','2025-02-24 16:13:59'),(168,'27446050287','Sheila Evelyn','Quintana',NULL,'2025-02-24 16:15:32','2025-02-24 16:15:32'),(169,'20357206023','Bautista','Bottani',NULL,'2025-02-25 14:15:01','2025-02-25 14:15:01'),(170,'23340504364','Emilia','Perez',NULL,'2025-02-26 01:22:55','2025-02-26 01:22:55'),(171,NULL,'Zoe','Scumburdi',NULL,'2025-02-26 23:44:19','2025-02-26 23:44:19'),(172,'27470624812','Bianca','Marcilli',NULL,'2025-02-27 18:50:51','2025-02-27 18:50:51'),(173,'27366919568','Debora','Casalis','0200381611000001336658','2025-03-08 02:25:21','2025-03-12 18:43:11'),(174,NULL,'Maria Jose','Palazon','0200304511000083044258','2025-03-08 02:28:07','2025-03-08 02:28:07'),(175,NULL,'Agustina','Alesso',NULL,'2025-03-08 02:29:11','2025-03-08 02:29:11'),(176,'27282087699','Carina','Maqueira',NULL,'2025-03-09 00:50:15','2025-03-09 00:50:15'),(177,'20450749681','Mathias','Gottert',NULL,'2025-03-09 00:51:06','2025-03-09 00:51:06'),(178,'20380921898','Elio','Vilalta','0340250608122349304002','2025-03-10 14:20:27','2025-03-10 17:22:33'),(180,NULL,'Emi','Julien',NULL,'2025-03-11 20:28:11','2025-03-11 20:28:11'),(181,'27475548685','Maria','Iraola',NULL,'2025-03-11 20:29:34','2025-03-14 14:18:55'),(182,'20439302713','Ezequiel','Cohen',NULL,'2025-03-12 17:44:08','2025-03-12 17:44:08'),(183,NULL,'Camila','Contreras','0140187103520450559545','2025-03-12 17:54:35','2025-03-14 14:30:09'),(184,NULL,'Pedro','Cacciavillano',NULL,'2025-03-14 14:11:39','2025-03-14 14:11:39'),(185,NULL,'Lautaro','Padron','0140135203505954416253','2025-03-14 14:14:17','2025-03-14 14:30:36'),(186,'27430293554','Jessica','Olivieri',NULL,'2025-03-14 14:18:20','2025-03-14 14:18:20'),(187,'27386898524','Anabela Gisele','Garcia',NULL,'2025-03-14 21:04:23','2025-03-14 21:04:23'),(188,NULL,'Gustavo','Chiessa',NULL,'2025-03-15 02:48:50','2025-03-15 02:48:50'),(189,'27364792730','Paula','Furbatto','0200331111000011805612','2025-03-18 04:09:48','2025-03-18 04:09:48'),(190,NULL,'Ornella Eugenio','Moraga','0340252008122353493028','2025-03-18 04:11:42','2025-03-18 04:11:42'),(191,'23341392934','Maria','Freire',NULL,'2025-03-18 04:20:15','2025-03-18 04:20:15'),(192,NULL,'Fausto','Airoldi',NULL,'2025-03-19 16:50:22','2025-03-19 16:50:22'),(193,'27374232369','Rosario','Ivancich',NULL,'2025-03-20 02:10:19','2025-03-20 02:10:19'),(194,NULL,'Evelyn','-',NULL,'2025-03-20 02:11:42','2025-03-20 02:11:42'),(195,NULL,'Mateo','Guido',NULL,'2025-03-20 15:40:42','2025-03-20 15:40:42'),(196,'20402535564','Eugenio','Ulchak',NULL,'2025-03-21 21:00:21','2025-03-21 21:00:21'),(197,'20430902211','Kevin Gabriel','Sanchez',NULL,'2025-03-25 22:05:37','2025-03-25 22:05:37'),(198,NULL,'Ivan','Schaer','1910275555127500728017','2025-03-27 02:54:39','2025-03-27 02:54:39'),(199,'27463476506','Mia','Calabroni',NULL,'2025-03-27 02:57:43','2025-03-27 02:57:43'),(200,NULL,'Joaquin','Rodriguez',NULL,'2025-03-27 02:59:00','2025-03-27 02:59:00'),(201,'20444899175','Ignacio','Gnavi',NULL,'2025-03-27 03:01:59','2025-03-27 03:01:59'),(202,NULL,'Barbi','Riss',NULL,'2025-03-28 01:30:51','2025-03-28 01:30:51'),(203,'20329855830','Pablo','Bastarrica','0110521630052111999415','2025-03-30 21:31:54','2025-03-30 21:49:54'),(204,NULL,'Juli','Ramallo',NULL,'2025-04-01 17:17:33','2025-04-01 17:17:33'),(205,NULL,'Norma','Vega',NULL,'2025-04-05 14:29:46','2025-04-05 14:29:46'),(206,NULL,'Veronika','Pfeiffer','0110716830071606549397','2025-04-05 15:02:43','2025-04-05 15:02:43'),(207,NULL,'Maria Emilia','Skrt','0140135203505954026546','2025-04-05 15:03:54','2025-04-05 15:04:19'),(208,NULL,'Maria Soledad','Agosteguis','0140999803200073718537','2025-04-05 15:05:00','2025-04-05 15:05:00');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compras_calendario`
--

DROP TABLE IF EXISTS `compras_calendario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compras_calendario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre_persona` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras_calendario`
--

LOCK TABLES `compras_calendario` WRITE;
/*!40000 ALTER TABLE `compras_calendario` DISABLE KEYS */;
INSERT INTO `compras_calendario` VALUES (13,'Nahuel Acosta','2024-09-20','46 celeste poplin','19:30:00','20:00:00'),(14,'Maxi Garcia','2024-09-18','42 hombre grafa marron','17:30:00','19:00:00'),(15,'Ailen Tornieli','2024-09-18','36 grafa negra mujer ','17:00:00','19:00:00'),(16,'Sixto Puppo','2024-09-18','50 poplin azul y negra','17:30:00','19:00:00'),(17,'Lucas Garcia','2024-09-20','grafa hombre Marron talle 42','11:00:00','14:00:00'),(18,'Maria de los angeles Lucero','2024-09-22','hombre grafa talle 52 marron\n(NO VINO)','12:30:00','19:00:00'),(19,'Flor Velasquez','2024-09-22','40 o 42 de grafa mujer marron','17:30:00','19:00:00'),(20,'Gonzalo Gurruchaga','2024-09-22','48 grafil azul','18:30:00','19:00:00'),(34,'Andrea Melgarejo','2024-10-03','Beige 44 poplin','17:00:00','17:30:00'),(35,'Clari Bormape','2024-10-02','38 beige o marron poplin (NO PASO)','09:00:00','19:00:00'),(37,'Flor Paredes','2024-10-01','11 bombachas','18:00:00','20:00:00'),(38,'evelyn','2024-10-04','talle 42 hombre por 44 marron','17:30:00','20:00:00'),(39,'Yamila Hours','2024-10-04','bombacha grafa de dama talle 36','10:00:00','11:00:00'),(40,'Juani morales','2024-10-04','Talle 44 verde poplin','10:00:00','12:00:00'),(41,'Nahuel Taylor','2024-10-03','CAmbio bombacha 44 marron por 46 verde','19:00:00','20:00:00'),(42,'Juana Morales','2024-10-07','talle 52 de hombre marron y verde','12:00:00','14:30:00'),(43,'Cata','2024-10-08','talle 46 poplin verde','12:00:00','13:00:00'),(44,'Facundo','2024-10-08','grafa 38 azul hombre','18:00:00','20:00:00'),(45,'Sol Zack','2024-10-07','talle 42 poplin dama verde y 38 alpargatas bordo','17:30:00','19:00:00'),(46,'Facundo','2024-10-07','alpargatas talle 40 azul','17:30:00','19:00:00'),(47,'lolosarries','2024-10-08','bombacha 42 marron hombre','13:00:00','15:00:00'),(48,'ailen','2024-10-08','poplin talle 40 verde','18:00:00','19:30:00'),(49,'Cami Figueroa','2024-10-08','Grafa azul 44 mujer','18:00:00','20:00:00'),(50,'Irina Lopez','2024-10-10','38 poplin marron','14:00:00','15:00:00'),(51,'Facundo Somma','2024-10-10','Cambio por bombacha 40 corto especial','19:00:00','20:00:00'),(52,'Guada, yazmin y more correa (quiere cambio)','2024-10-10','vinieron 3 personas a comprar hace un rato','12:00:00','15:00:00'),(53,'Micaela Sanchez','2024-10-10','46 grafil','20:00:00','21:00:00'),(54,'Gladys','2024-10-21','Azul tiro alto poplin 44','18:00:00','20:00:00'),(55,'Anahi Amarilla','2024-10-21','38 poplin verde, 36 grafa marron y 36 alpargata bordo','18:00:00','20:00:00'),(56,'Andrea Melgarejo','2024-10-22','Gris 44 poplin','10:00:00','20:00:00'),(57,'More Correa','2024-10-21','Beige 44 cambio por 42 creo que era','12:00:00','20:00:00'),(58,'magabaena','2025-02-17','38 negra y marron grafa tiro bajo','13:30:00','14:15:00'),(59,'Tomas Zaton','2025-02-15','44 tiro alto poplin beige','16:00:00','16:30:00'),(60,'Gonzalo (garroantonella_)','2025-02-15','32 marron tiro bajo dama grafa','16:00:00','16:30:00');
/*!40000 ALTER TABLE `compras_calendario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facturaciones`
--

DROP TABLE IF EXISTS `facturaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturaciones` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `venta_id` bigint unsigned DEFAULT NULL,
  `fecha_facturacion` date DEFAULT (curdate()),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `venta_id` (`venta_id`),
  CONSTRAINT `facturaciones_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturaciones`
--

LOCK TABLES `facturaciones` WRITE;
/*!40000 ALTER TABLE `facturaciones` DISABLE KEYS */;
INSERT INTO `facturaciones` VALUES (1,127,'2024-10-24'),(2,129,'2024-10-24'),(3,130,'2024-10-24'),(4,131,'2024-10-24'),(5,111,'2024-10-24'),(6,107,'2024-10-24'),(7,113,'2024-10-24'),(8,114,'2024-10-24'),(9,115,'2024-10-24'),(10,116,'2024-10-24'),(11,117,'2024-10-24'),(12,118,'2024-10-24'),(13,119,'2024-10-24'),(14,120,'2024-10-24'),(15,121,'2024-10-24'),(16,122,'2024-10-24'),(17,123,'2024-10-24'),(18,124,'2024-10-24'),(19,125,'2024-10-24'),(20,97,'2024-10-24'),(21,98,'2024-10-24'),(22,91,'2024-10-24'),(23,92,'2024-10-24'),(24,89,'2024-10-24'),(25,90,'2024-10-24'),(26,88,'2024-10-24'),(27,86,'2024-10-24'),(28,87,'2024-10-24'),(29,78,'2024-10-24'),(30,80,'2024-10-24'),(31,83,'2024-10-24'),(32,132,'2024-10-25'),(33,133,'2024-10-25'),(34,134,'2024-10-25'),(35,135,'2024-10-25'),(36,136,'2024-10-25'),(37,137,'2024-10-25'),(38,151,'2024-11-07'),(39,155,'2024-11-07'),(40,145,'2024-11-07'),(41,146,'2024-11-07'),(42,147,'2024-11-07'),(43,148,'2024-11-07'),(44,149,'2024-11-07'),(45,150,'2024-11-07'),(46,142,'2024-11-07'),(47,143,'2024-11-07'),(48,139,'2024-11-07'),(49,132,'2024-11-07'),(50,133,'2024-11-07'),(51,134,'2024-11-07'),(52,135,'2024-11-07'),(53,136,'2024-11-07'),(54,137,'2024-11-07'),(55,187,'2024-12-04'),(56,176,'2024-12-04'),(57,179,'2024-12-04'),(58,181,'2024-12-04'),(59,182,'2024-12-04'),(60,183,'2024-12-04'),(61,184,'2024-12-04'),(62,180,'2024-12-04'),(63,185,'2024-12-04'),(64,177,'2024-12-04'),(65,178,'2024-12-04'),(66,173,'2024-12-04'),(67,174,'2024-12-04'),(68,175,'2024-12-04'),(69,163,'2024-12-04'),(70,164,'2024-12-04'),(71,165,'2024-12-04'),(72,166,'2024-12-04'),(73,167,'2024-12-04'),(74,168,'2024-12-04'),(75,169,'2024-12-04'),(76,159,'2024-12-04'),(77,160,'2024-12-04'),(78,151,'2024-12-04'),(79,155,'2024-12-04'),(80,230,'2025-02-06'),(81,211,'2025-02-06'),(82,213,'2025-02-06'),(83,214,'2025-02-06'),(84,219,'2025-02-06'),(85,220,'2025-02-06'),(86,208,'2025-02-06'),(87,209,'2025-02-06'),(88,210,'2025-02-06'),(89,202,'2025-02-06'),(90,203,'2025-02-06'),(91,200,'2025-02-06'),(92,192,'2025-02-06'),(93,193,'2025-02-06'),(94,194,'2025-02-06'),(95,195,'2025-02-06'),(96,196,'2025-02-06'),(97,187,'2025-02-06'),(98,176,'2025-02-06'),(99,179,'2025-02-06'),(100,181,'2025-02-06'),(101,182,'2025-02-06'),(102,183,'2025-02-06'),(103,184,'2025-02-06'),(104,180,'2025-02-06'),(105,185,'2025-02-06'),(106,177,'2025-02-06'),(107,178,'2025-02-06'),(108,173,'2025-02-06'),(109,174,'2025-02-06'),(110,175,'2025-02-06'),(111,163,'2025-02-06'),(112,164,'2025-02-06'),(113,165,'2025-02-06'),(114,166,'2025-02-06'),(115,167,'2025-02-06'),(116,168,'2025-02-06'),(117,169,'2025-02-06'),(118,263,'2025-02-17'),(119,245,'2025-02-17'),(120,247,'2025-02-17'),(121,248,'2025-02-17'),(122,249,'2025-02-17'),(123,250,'2025-02-17'),(124,251,'2025-02-17'),(125,252,'2025-02-17'),(126,253,'2025-02-17'),(127,254,'2025-02-17'),(128,255,'2025-02-17'),(129,256,'2025-02-17'),(130,246,'2025-02-17'),(131,257,'2025-02-17'),(132,258,'2025-02-17'),(133,259,'2025-02-17'),(134,260,'2025-02-17'),(135,243,'2025-02-17'),(136,244,'2025-02-17'),(137,230,'2025-02-17'),(138,313,'2025-03-14'),(139,311,'2025-03-14'),(140,312,'2025-03-14'),(141,305,'2025-03-14'),(142,306,'2025-03-14'),(143,307,'2025-03-14'),(144,308,'2025-03-14'),(145,309,'2025-03-14'),(146,299,'2025-03-14'),(147,300,'2025-03-14'),(148,295,'2025-03-14'),(149,296,'2025-03-14'),(150,297,'2025-03-14'),(151,298,'2025-03-14'),(152,293,'2025-03-14'),(153,285,'2025-03-14'),(154,286,'2025-03-14'),(155,287,'2025-03-14'),(156,288,'2025-03-14'),(157,289,'2025-03-14'),(158,290,'2025-03-14'),(159,291,'2025-03-14'),(160,292,'2025-03-14'),(161,284,'2025-03-14'),(162,278,'2025-03-14'),(163,279,'2025-03-14'),(164,280,'2025-03-14'),(165,281,'2025-03-14'),(166,277,'2025-03-14'),(167,276,'2025-03-14'),(168,268,'2025-03-14'),(169,317,'2025-03-18'),(170,318,'2025-03-18'),(171,319,'2025-03-18'),(172,320,'2025-03-18'),(173,321,'2025-03-18'),(174,322,'2025-03-18'),(175,323,'2025-03-18'),(176,324,'2025-03-18'),(177,325,'2025-03-18'),(178,326,'2025-03-18'),(179,327,'2025-03-18'),(180,328,'2025-03-18'),(181,329,'2025-03-18'),(182,330,'2025-03-18'),(183,313,'2025-03-18'),(184,314,'2025-03-18'),(185,317,'2025-03-18'),(186,318,'2025-03-18'),(187,319,'2025-03-18'),(188,320,'2025-03-18'),(189,321,'2025-03-18'),(190,322,'2025-03-18'),(191,323,'2025-03-18'),(192,324,'2025-03-18'),(193,325,'2025-03-18'),(194,326,'2025-03-18'),(195,327,'2025-03-18'),(196,328,'2025-03-18'),(197,329,'2025-03-18'),(198,330,'2025-03-18'),(199,313,'2025-03-18'),(200,314,'2025-03-18');
/*!40000 ALTER TABLE `facturaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `localidades`
--

DROP TABLE IF EXISTS `localidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `localidades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `disponibilidad` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=448 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `localidades`
--

LOCK TABLES `localidades` WRITE;
/*!40000 ALTER TABLE `localidades` DISABLE KEYS */;
INSERT INTO `localidades` VALUES (11,'LONCOPUE',1),(13,'ASUNCION',1),(14,'25 DE MAYO',0),(15,'30 DE AGOSTO',0),(16,'9 DE ABRIL',1),(17,'9 DE JULIO',1),(18,'ALBERTI',1),(19,'AMERICA',0),(20,'ARRECIFES',1),(21,'ARRIBE??OS',0),(22,'ARROYO GRANDE',1),(23,'ASUNCION',1),(24,'AYACUCHO',0),(25,'AZUL',0),(26,'BAHIA BLANCA',0),(27,'BAIGORRITA',1),(28,'BALCARCE',0),(29,'BARADERO',0),(30,'BARILOCHE',1),(31,'BARKER',0),(32,'BENITO JUAREZ',0),(33,'BOLIVAR',0),(34,'BONNNEMENT',1),(35,'BORDERNAVE',1),(36,'BOULONGE',1),(37,'BRAGADO',1),(38,'BRANDSEN',0),(39,'BURZACO',1),(40,'CABA',1),(41,'CABILDO',1),(42,'CACHARI',1),(43,'CAHUE',1),(44,'CAMPANA',1),(45,'CA??ADA SECA',1),(46,'CA??UELAS',0),(47,'CAPILLA DEL SE??OR',1),(48,'CAPITAN SARMIENTO',0),(49,'CARHUE',0),(50,'CARLOS',0),(51,'CARLOS CASARES',0),(52,'CARMEN DE ARECO',0),(53,'CASBAS',0),(54,'CASTELLI',0),(55,'CASTILLA',1),(56,'CAZON',0),(57,'CHACABUCO',0),(58,'CHAPADMALAL',1),(59,'CHILLAR',0),(60,'CHIVILCOY',0),(61,'CIUDAD EVITA',1),(62,'COLON (B)',0),(63,'COLONIA LA MERCED',0),(64,'COPETONAS',1),(65,'CORONEL BRANDSEN',0),(66,'CORONEL DORREGO',0),(67,'CORONEL PRINGLES',0),(68,'CORONEL SUAREZ',0),(69,'CORONEL VIDAL',0),(70,'DAIREAUX',0),(71,'DARREGUEIRA',0),(72,'DE LA GARMA',0),(73,'DEL CARRIL',0),(74,'DEL VALLE',1),(75,'DOBLAS',1),(76,'DOLORES',0),(77,'DOMSELAAR',1),(78,'DOYLE',1),(79,'DUGINAC',1),(80,'EL TALAR',0),(81,'FLORIDA',1),(82,'GONZALEZ CHAVEZ',0),(83,'GENERAL ALVEAR',0),(84,'GENERAL ARENALES',0),(85,'GENERAL BELGRANO',0),(86,'GENERAL CONESA',0),(87,'GENERAL LAMADRID',0),(88,'GENERAL LAS HERAS',0),(89,'GENERAL LAVALLE',0),(90,'GENERAL MADARIAGA',0),(91,'GENERAL MANSILLA',1),(92,'GENERAL PIRAN',0),(93,'GENERAL PAZ',1),(94,'GENERAL GUIDO',1),(95,'GUAMINI',0),(96,'HENDERSON',0),(97,'HILARIO ASCASUBI',1),(98,'HUANGUELEN',0),(99,'HURLINGHAM',1),(100,'ITUZAINGO',1),(101,'JUAN BAUTISTA ALBERDI',1),(102,'JUAN N. FERNANDEZ',1),(103,'JUAREGUI',1),(104,'JUNIN',0),(105,'LA MATANZA',1),(106,'LA PLATA',1),(107,'LAGUNA ALSINA',0),(108,'LANUS',1),(109,'LAPRIDA',0),(110,'LAS ARMAS',0),(111,'LAS FLORES',0),(112,'LAS TONINAS',1),(113,'LEZAMA',0),(114,'LIBANO',0),(115,'LINCOLN',0),(116,'LOBERIA',0),(117,'LOBOS',0),(118,'LOMA VERDE',1),(119,'LOMAS DE ZAMORA',1),(120,'LOMAS DEL MIRADOR',1),(121,'LOS CARDALES',0),(122,'LOS HORNOS',1),(123,'LOS TOLDOS',1),(124,'LUJAN',1),(125,'MAGDALENA',0),(126,'MAIPU',0),(127,'MAR DE AJO',0),(128,'MAR DEL PLATA',0),(129,'MAR DEL TUYU',0),(130,'MARCOS PAZ',0),(131,'MARTINEZ',1),(132,'MAYOR BURATOVICH',0),(133,'MECHONGUE',0),(134,'MEDANOS',0),(135,'MERCEDES (B)',0),(136,'MIRAMAR',0),(137,'MONTE GRANDE',1),(138,'MONTE HERMOSO',1),(139,'MOQUEHUA',0),(140,'MORENO',1),(141,'MUNRO',1),(142,'NAPALEUFU',0),(143,'NAVARRO',0),(144,'NECOCHEA',0),(145,'NICANOR OTAMENDI',0),(146,'NORBERTO DE LA RIESTRA',0),(147,'OLAVARRIA',0),(148,'OLIVOS',1),(149,'OLMOS',1),(150,'ORIENTE',1),(151,'OSTENDE',1),(152,'PABLO PODESTA',1),(153,'PARADA ROBLES',0),(154,'PEDERNALES',0),(155,'PEDRO LURO',0),(156,'PEHUAJO',0),(157,'PELLEGRINI',1),(158,'PIGUE',0),(159,'PILA',0),(160,'PINAMAR',0),(161,'PIROVANO',1),(162,'PLATANOS',1),(163,'POLVAREDAS',0),(164,'PUAN',0),(165,'PUNTA ALTA',0),(166,'QUEQUEN',1),(167,'QUILMES',1),(168,'QUIROGA',1),(169,'RAFAEL CALZADA',1),(170,'RAMOS MEJIA',1),(171,'RANCHOS',0),(172,'RANELAGH',1),(173,'RAUCH',0),(174,'ROJAS',0),(175,'ROQUE PEREZ',0),(176,'SAN MIGUEL DEL MONTE',0),(177,'SALADILLO',0),(178,'SALDUNGARAY',1),(179,'SALLIQUELO',1),(180,'SALTO',0),(181,'SALVADOR MARIA',1),(182,'SAN ANDRES DE GILES',0),(183,'SAN ANTONIO DE ARECO',0),(184,'SAN BERNARDO',0),(185,'SAN CAYETANO',0),(186,'SAN CLEMENTE DEL TUYU',0),(187,'SAN GERMAN',1),(188,'SAN ISIDRO',1),(189,'SAN JUSTO',1),(190,'SAN MARTIN',1),(191,'SAN MIGUEL',0),(192,'SAN MIGUEL DE MONTE',0),(193,'SAN MIGUEL DEL MONTE',0),(194,'SAN NICOLAS',1),(195,'SAN PEDRO (B)',0),(196,'SAN SALVADOR',1),(197,'SAN VICENTE',0),(198,'SANTA CLARA DE MAR',0),(199,'SANTA TERESITA',0),(200,'SUIPACHA',0),(201,'TANDIL',0),(202,'TAPALQUE',0),(203,'TAPIALES',1),(204,'TIGRE',1),(205,'TOAY',1),(206,'TOKIO',1),(207,'TORNQUIST',0),(208,'TRENQUE LAUQUEN',0),(209,'TRES ARROYOS',0),(210,'TRES LOMAS',0),(211,'URDAMPILLETA',1),(212,'URIBELARREA',0),(213,'URQUIZA',1),(214,'VALENTIN ALSIN',1),(215,'VALERIA DEL MAR',1),(216,'VEDIA',0),(217,'VERONICA',0),(218,'VILLA BALLESTER',1),(219,'VILLA DE MAYO',1),(220,'VILLA FLANDRIA',1),(221,'VILLA GESELL',0),(222,'VILLA IRIS',0),(223,'VILLA LYNCH',1),(224,'VILLA PRECEPTOR CRUZ',1),(225,'VI??A',1),(226,'VIVORATA',0),(227,'WILDE',1),(228,'ZARATE',0),(229,'COMODORO RIVADAVIA',1),(230,'EL CALAFATE',1),(231,'GAIMAN',0),(232,'SARMIENTO',1),(233,'TRELEW',1),(234,'TREVELIN',1),(235,'ALEJO LEDESMA',1),(236,'ARIAS',1),(237,'CANALS',1),(238,'CARPINTERIA',1),(239,'CORDOBA',1),(240,'CRUZ DEL EJE',1),(241,'ETRURIA',1),(242,'GENERAL CABRERA',1),(243,'JESUS MARIA',1),(244,'JOVITA',1),(245,'LA CARLOTA',1),(246,'LAS VARILLAS',1),(247,'RIO CUARTO',1),(248,'RIO TERCERO',1),(249,'SAMPACHO',1),(250,'SAN BASILIO',1),(251,'SINSACATE',1),(252,'VICU??A MACKENNA',1),(253,'VILLA HUIDOBRO',1),(254,'VILLA MARIA',1),(255,'VILLA RUMIPAL',1),(256,'VILLA VALERIA',1),(257,'MERCEDES (W)',0),(258,'SAN COSME',1),(259,'CEIBAS',1),(260,'COLON (E)',0),(261,'CONCEPCION DEL URUGUAY',1),(262,'CONCORDIA',1),(263,'CRESPO',1),(264,'DIAMANTE',1),(265,'FEDERAL',1),(266,'GENERAL RAMIREZ',1),(267,'GUALEGUAY',0),(268,'GUALEGUAYCHU',0),(269,'LA PAZ',1),(270,'LARROQUE',1),(271,'MARIA GRANDE',1),(272,'NOGOYA',1),(273,'ROSARIO DEL TALA',1),(274,'UBAJAY',1),(275,'URDINARRAIN',1),(276,'VICTORIA',1),(277,'VILLAGUAY',1),(278,'GENERAL PICO',0),(279,'GUATRECHE',0),(280,'INTENDENTE ALVEAR',0),(281,'QUEMU QUEMU',0),(282,'WINIFREDA',0),(283,'LA RIOJA',1),(284,'MENDOZA',1),(285,'SAN RAFAEL',1),(286,'ELDORADO',1),(287,'MONTECARLO',1),(288,'NEUQUEN',1),(289,'VILLA LA ANGOSTURA',1),(290,'VIEDMA',1),(291,'SALTA',1),(292,'VERA',1),(293,'CHIMBAS',1),(294,'SAN JUAN',1),(295,'JUSTO DARACT',1),(296,'SAN LUIS',1),(297,'UNION',1),(298,'VILLA MERCEDES',1),(299,'CALETA OLIVIA',1),(300,'PICO TRUNCADO',1),(301,'ARMSTRONG',1),(302,'CA??ADA DE GOMEZ',1),(303,'CASILDA',1),(304,'GENERAL LOPEZ',1),(305,'MARIA TERESA',1),(306,'PARANA',1),(307,'RECONQUISTA',1),(308,'ROSARIO',1),(309,'SAN GREGORIO',1),(310,'SAN JERONIMO NORTE',1),(311,'SAN JORGE',1),(312,'SAN MARTIN DE LAS ESCOBAS',1),(313,'SAN PEDRO (S)',1),(314,'SUNCHALES',1),(315,'TEODELINA',1),(316,'VENADO TUERTO',1),(317,'VILLA CA??AS',1),(318,'RIO GRANDE',1),(319,'VILLA DOLORES',1),(320,'SANTA FE',1),(321,'SAN CARLOS DE LA BUENA VISTA',1),(322,'SAAVEDRA',1),(323,'PUERTO MADRYN',1),(324,'HIPOLITO BOUCHARD',1),(325,'MONTE COMAN',1),(326,'ESQUEL',1),(327,'PILAR (S)',1),(328,'COLONIA 25 DE MAYO',1),(329,'COLONIA CATRIEL',1),(330,'JACINTO ARAUZ',1),(331,'BERISSO',1),(332,'LOS ALTARES',1),(333,'28 DE JULIO',1),(334,'ADELIA MARIA',1),(335,'CORTINES',1),(336,'JAUREGUI',1),(337,'RAMALLO',1),(338,'VILLA BOSCH',1),(339,'SARMIENTO (SF)',1),(340,'BARTOLOME BAVIO',0),(341,'CONCEPCION DE LA SIERRA',1),(342,'VELA',1),(343,'VILLANUEVA',1),(344,'RIO COLORADO',1),(345,'BERAZATEGUI BS AS',1),(346,'ABASTO',1),(347,'MORTEROS',1),(348,'ORENSE DEL SUR',1),(349,'CLAROMECO',1),(350,'VILLALONGA',0),(351,'VILLA MADERO',1),(352,'HUINCA RENANCO',1),(353,'TRENEL',1),(354,'BENAVIDEZ',1),(355,'JUAN JOSE CASTELLI',1),(356,'ALGARROBO',1),(357,'CALAFATE',1),(358,'IGNACIO COREEAS',0),(359,'VILLA LUZURIAGA',1),(360,'COBO',0),(361,'SANTA ROSA',0),(362,'COMODORO PY',1),(363,'CONESA PARTIDO DE SAN NICOLAS',0),(364,'SENILLOSA',1),(365,'FRANCISCO ALVAREZ',1),(366,'JUAN JOSE PASO',1),(367,'VILLA DEL DIQUE',1),(368,'GUERNICA',0),(369,'TREVELIN',0),(370,'AVELLANEDA',1),(371,'FRANCISCO MADERO',0),(372,'HAEDO',1),(373,'LA COLINA',1),(374,'LONGCHAMPS',1),(375,'HINOJO',1),(376,'DISTRICTO COSRA GRANDE',1),(377,'RAWSON',1),(378,'CHOS MALAL',1),(379,'ALTO RIO SENGUER',1),(380,'CORCOVADO',1),(381,'SAN ANTONIO OESTE',1),(382,'RIO MAYO',1),(383,'INGENIERO JACOBACCI',1),(384,'PUERTO SAN JULIAN',1),(385,'LOS MENUCOS',1),(386,'PICUN LEUFU',1),(387,'GUALJAINA',1),(388,'PILCANIYEU',1),(389,'ZAPALA',1),(390,'LOS ANTIGUOS',1),(391,'VILLA MAIPU',1),(392,'PASO DE INDIOS',1),(393,'CHOLILA',1),(394,'GOBERNADOR COSTA',1),(395,'RADA TILLY',1),(396,'TECKA',1),(397,'LAS HERAS',1),(398,'EL MAITEN',1),(399,'EL BOLSON',1),(400,'SAN MARTIN DE LOS ANDES',1),(401,'PUERTO DESEADO',1),(402,'CENTENARIO',1),(403,'28 DE NOVIEMBRE',1),(404,'GUANACO',1),(405,'COMODORO RIVADAVIA',1),(406,'LAS LAJAS',1),(407,'LAS COLORADAS',1),(408,'PICO TRUNCADO',1),(409,'RIO TALA',1),(410,'LAMARQUE',1),(411,'COMANDANTE LUIS PIEDRABUENA',1),(412,'RIO GALLEGO',1),(413,'GOBERNADOR GREGORES',1),(414,'JUNIN DE LOS ANDES',1),(415,'PIEDRA DEL AGUILA',1),(416,'ALUMINE',1),(417,'CARMEN DE PATAGONES',0),(418,'GENERAL CONESA',0),(419,'ORONO',1),(420,'URDINARRAIN',1),(421,'BARILOCHE RIO NEGRO',1),(422,'ALDEA BELEIRO',1),(423,'LAGO POSADAS',1),(424,'PUERTO SANTA CRUZ',1),(425,'SAN PATRICIO DE CHA??AR',1),(426,'LONCOPUE',1),(427,'LA ALDEA',1),(428,'EL CHALTEN',1),(429,'EL CHOLAR',1),(430,'CAMPO GRANDE',1),(431,'BAJO HONDO',1),(432,'GENERAL VILLEGAS',1),(433,'MARCOS JUAREZ',1),(434,'BERNASCONI',1),(435,'CATRILLO',1),(436,'JUAN A PRADERE',1),(437,'CASEROS URUGUAY',1),(438,'VILLA REGINA',1),(439,'JEPPENER',0),(440,'PILAS BS AS',1),(441,'GONNET',1),(442,'MACACHIN LA PAMPA',1),(443,'AGUAS VERDES PARTIDO DE LA COSTA',0),(444,'RANCUL',1),(445,'ALTA GRACIA',1),(446,'FORMOSA CAPITAL',1),(447,'SIERRA DE LA VENTANA',0);
/*!40000 ALTER TABLE `localidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('aV0YCChXLGowM2fxa0juLy05U5Rglw6YVgLzbNKk',NULL,'172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36','YToyOntzOjY6Il90b2tlbiI7czo0MDoieVdsVmJDVnJXTUdKeFhHSTRxamhLRDJBWUJxMHpRRDF6ampiM3lnRyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1743516358),('fx7WVDcHXouPJpbwNadCL5XviAUq64YfYRob4hu1',NULL,'172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiWGg3TFNjaXdxNE9TRzJ0ZThGM0owemFtM1l4UERFZ25oeUpkNXZNYyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC92ZW50YXMiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1743517949),('LvJ014SMlamUz2sQXLMUNb1IxBnxAMv6qH2OMOrK',NULL,'172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36','YToyOntzOjY6Il90b2tlbiI7czo0MDoieFpweFFuMkpHTkUzMEd0RThCMHRPZUtTUGYyR29IREtSeWhMUVJjSyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1743516355),('pCRaXGe6Y1BnNZc6mM0cogM0zNM14KxTN8ldIp7S',NULL,'172.18.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36','YToyOntzOjY6Il90b2tlbiI7czo0MDoiNHJuNnhuRnhKblVnazZBT0FVdEhqbE1kNHVVTTRjOVAzZThaTHdjYiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1743516357);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `talles`
--

DROP TABLE IF EXISTS `talles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `talles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articulo_id` bigint unsigned DEFAULT NULL,
  `talle` int NOT NULL,
  `marron` int DEFAULT '0',
  `negro` int DEFAULT '0',
  `verde` int DEFAULT '0',
  `azul` int DEFAULT '0',
  `celeste` int DEFAULT '0',
  `blancobeige` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `talles_ibfk_1` (`articulo_id`),
  CONSTRAINT `talles_ibfk_1` FOREIGN KEY (`articulo_id`) REFERENCES `articulos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `talles`
--

LOCK TABLES `talles` WRITE;
/*!40000 ALTER TABLE `talles` DISABLE KEYS */;
INSERT INTO `talles` VALUES (1,1,32,2,1,1,0,0,0),(2,1,34,0,2,2,0,0,0),(3,1,36,1,1,0,1,0,0),(4,1,38,1,1,2,2,0,0),(5,1,40,2,0,0,1,0,0),(6,1,42,0,0,0,1,0,0),(7,1,44,0,1,1,0,0,0),(8,2,36,6,0,1,0,0,0),(9,2,38,2,2,2,2,0,0),(10,2,40,0,2,3,0,0,0),(11,2,42,2,0,0,0,0,0),(12,2,44,1,0,1,1,0,0),(13,2,46,2,4,1,0,0,0),(14,2,48,2,0,1,2,0,0),(15,2,50,3,2,0,1,0,0),(16,2,52,1,1,1,1,0,0),(17,2,54,3,0,0,0,0,0),(18,3,36,1,1,1,1,1,0),(19,3,38,0,1,0,0,0,2),(20,3,40,0,0,1,1,0,1),(21,3,42,0,1,2,0,0,0),(22,3,44,0,0,0,1,0,0),(23,3,46,2,2,1,0,1,0),(24,3,48,0,1,1,0,2,2),(25,3,50,2,0,1,0,0,0),(26,3,52,1,0,0,2,0,0),(27,3,54,1,0,1,0,0,1),(28,6,0,1,0,1,0,0,0),(29,6,2,0,1,1,0,0,0),(30,6,4,1,1,1,1,0,0),(31,6,6,2,1,2,1,0,0),(32,6,8,1,1,2,1,0,0),(33,7,10,2,1,2,1,0,0),(34,7,12,1,1,2,1,0,0),(35,7,14,1,0,1,1,0,0),(36,7,16,1,1,0,0,0,0),(53,1,50,0,0,0,0,0,0),(54,8,52,0,0,0,0,0,0),(55,8,50,0,0,0,0,0,0),(56,4,40,1,0,1,0,0,0),(57,4,42,1,0,1,0,0,0),(58,4,44,1,0,0,0,0,0),(59,4,46,0,0,1,0,0,0),(60,4,48,1,0,1,0,0,0),(61,4,50,1,0,1,0,0,0),(62,4,52,0,0,1,0,0,0),(63,5,40,0,0,0,0,0,0),(64,5,42,0,0,0,0,0,0),(65,5,44,1,0,1,0,0,0),(66,5,46,1,0,1,0,0,0),(67,5,48,2,0,0,0,0,0),(68,5,50,2,0,0,0,0,0),(69,5,52,1,0,0,0,0,0),(72,12,36,0,0,0,0,1,1),(73,12,37,0,0,1,1,0,1),(74,12,38,0,0,1,1,0,1),(75,12,39,0,0,1,0,2,1),(76,12,40,0,0,1,0,0,1),(77,12,41,0,0,0,0,0,1),(78,12,42,0,0,0,0,0,1),(79,12,43,0,0,0,1,2,1),(80,12,44,0,0,0,0,1,0),(81,12,45,0,0,0,1,1,0),(82,13,40,0,0,0,0,0,0),(83,14,42,0,0,0,1,0,0),(84,14,46,0,0,0,0,0,0),(85,13,44,0,0,0,1,0,0),(86,13,46,0,0,0,0,0,1),(87,15,40,1,0,0,1,0,0),(88,15,42,1,0,0,1,0,0),(89,15,44,1,0,0,1,0,0),(90,15,46,1,0,0,1,0,1),(91,15,48,0,0,0,0,0,0),(92,15,52,0,0,0,0,1,0),(93,16,38,0,0,0,0,0,0),(94,17,6,0,0,0,0,0,0),(95,15,54,0,0,0,0,0,0),(96,18,42,0,0,0,0,0,0),(97,13,48,0,0,0,0,0,0),(98,12,35,0,0,0,0,2,0),(99,14,38,0,0,0,0,0,0),(100,8,48,0,0,0,0,0,0),(101,21,68,0,0,0,0,0,0),(102,22,46,0,0,0,0,0,0),(103,31,38,0,0,0,0,0,0),(104,31,40,0,0,0,0,0,0),(105,23,58,0,0,0,0,0,0),(106,18,36,0,0,0,0,0,0),(107,5,36,0,0,0,0,0,0);
/*!40000 ALTER TABLE `talles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (4,'Admin','admin@admin.com',NULL,'$2y$12$HiIZ2IJEx/v2wsBFHrzm1eq3Xuv7FGOzZSZ9wBa2F2rCqsklhOUuu',NULL,'2025-04-01 16:58:56','2025-04-01 16:58:56'),(6,'Admin','fermin.moreno99@hotmail.com',NULL,'$2y$12$hV2Nz4KratdooWDBrCEs.ezdSNGvVlg69zpWLP/MTqFNN02sPMUIe',NULL,'2025-04-01 17:01:20','2025-04-01 17:01:20');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `articulo_id` bigint unsigned NOT NULL,
  `talle` int NOT NULL,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `fecha` date NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `forma_pago` enum('efectivo','transferencia') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `costo_original` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `articulo_id` (`articulo_id`),
  KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`articulo_id`) REFERENCES `articulos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=365 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
INSERT INTO `ventas` VALUES (6,2,42,'azul',15,'2024-08-25',25000.00,'efectivo',13765.00,'2024-09-08 18:53:37','2024-09-09 07:12:33'),(7,2,44,'marron',16,'2024-08-26',25000.00,'transferencia',13765.00,'2024-09-08 19:28:31','2024-09-09 07:01:14'),(8,1,42,'negro',17,'2024-08-31',25000.00,'transferencia',13765.00,'2024-09-08 19:35:58','2024-09-08 19:35:58'),(9,3,42,'azul',17,'2024-08-31',27000.00,'transferencia',15507.00,'2024-09-08 19:35:58','2024-09-08 19:35:58'),(10,2,46,'azul',18,'2024-08-29',25000.00,'transferencia',13765.00,'2024-09-08 19:38:30','2024-09-08 19:38:30'),(11,2,42,'marron',19,'2024-08-30',25000.00,'transferencia',13765.00,'2024-09-08 19:40:40','2024-09-08 19:40:40'),(12,2,42,'verde',19,'2024-08-30',25000.00,'transferencia',13765.00,'2024-09-08 19:40:40','2024-09-08 19:40:40'),(13,1,38,'azul',20,'2024-08-17',18000.00,'transferencia',13765.00,'2024-09-08 19:43:13','2024-09-08 19:43:19'),(14,2,46,'marron',21,'2024-09-02',25000.00,'transferencia',13765.00,'2024-09-08 19:44:42','2024-09-08 19:44:42'),(15,3,36,'azul',22,'2024-09-02',27000.00,'transferencia',15507.00,'2024-09-08 19:48:13','2024-09-08 19:48:13'),(16,1,34,'marron',23,'2024-09-03',25000.00,'transferencia',13765.00,'2024-09-08 19:49:34','2024-09-08 19:49:34'),(17,1,36,'marron',24,'2024-09-04',25000.00,'efectivo',13765.00,'2024-09-08 19:57:28','2024-09-08 19:57:28'),(18,1,40,'negro',25,'2024-09-04',25000.00,'transferencia',13765.00,'2024-09-08 20:01:16','2024-09-08 20:01:16'),(19,1,50,'negro',25,'2024-09-04',25000.00,'transferencia',13765.00,'2024-09-08 20:01:16','2024-09-08 20:01:16'),(20,3,40,'marron',26,'2024-09-09',27000.00,'transferencia',15507.00,'2024-09-09 17:42:53','2024-09-09 17:42:53'),(21,3,40,'negro',26,'2024-09-09',27000.00,'transferencia',15507.00,'2024-09-09 17:42:53','2024-09-09 17:42:53'),(22,2,46,'azul',27,'2024-09-09',25000.00,'transferencia',13765.00,'2024-09-10 00:41:57','2024-09-10 00:41:57'),(23,8,52,'azul',28,'2024-09-09',44000.00,'transferencia',31060.00,'2024-09-10 01:08:40','2024-09-10 21:49:49'),(24,8,50,'marron',28,'2024-09-09',44000.00,'transferencia',31060.00,'2024-09-10 01:08:40','2024-09-10 21:49:55'),(25,1,36,'verde',29,'2024-09-10',25000.00,'transferencia',13765.00,'2024-09-10 18:29:44','2024-09-13 21:26:37'),(28,6,2,'marron',34,'2024-09-10',20000.00,'transferencia',10000.00,'2024-09-10 19:40:13','2024-09-20 21:12:46'),(29,7,14,'verde',34,'2024-09-10',20000.00,'transferencia',10000.00,'2024-09-10 19:40:13','2024-09-23 00:20:17'),(30,3,38,'verde',35,'2024-09-12',27000.00,'efectivo',15507.00,'2024-09-12 19:36:05','2024-09-12 19:36:28'),(34,7,16,'azul',39,'2024-09-13',20000.00,'transferencia',10000.00,'2024-09-13 23:02:18','2024-09-20 21:12:33'),(35,1,42,'marron',40,'2024-09-17',25000.00,'transferencia',13765.00,'2024-09-17 17:33:56','2024-09-17 17:34:10'),(36,5,40,'marron',41,'2024-09-17',25000.00,'transferencia',13765.00,'2024-09-18 22:16:12','2024-09-18 22:16:55'),(37,1,36,'negro',42,'2024-09-18',25000.00,'efectivo',13765.00,'2024-09-18 22:33:05','2024-09-18 22:33:16'),(38,2,42,'marron',43,'2024-09-18',25000.00,'transferencia',13765.00,'2024-09-19 00:32:15','2024-09-19 00:32:27'),(39,3,50,'negro',44,'2024-09-18',27000.00,'transferencia',16285.00,'2024-09-19 00:50:34','2024-09-21 01:46:32'),(40,3,50,'azul',44,'2024-09-18',27000.00,'transferencia',16285.00,'2024-09-19 00:50:34','2024-09-21 01:46:43'),(42,2,42,'marron',46,'2024-09-20',25000.00,'efectivo',13765.00,'2024-09-20 20:49:53','2024-09-20 20:50:03'),(50,3,46,'celeste',53,'2024-09-20',27000.00,'transferencia',16285.00,'2024-09-22 06:03:51','2024-09-24 01:22:26'),(51,1,44,'marron',54,'2024-09-23',25000.00,'efectivo',14445.00,'2024-09-24 00:39:37','2024-09-26 00:06:39'),(52,3,48,'azul',15,'2024-09-23',27000.00,'transferencia',16285.00,'2024-09-24 00:40:15','2024-09-24 00:40:15'),(57,1,34,'marron',58,'2024-09-23',25000.00,'transferencia',14445.00,'2024-09-24 05:39:22','2024-10-23 14:29:27'),(58,1,34,'marron',58,'2024-09-24',0.00,'efectivo',0.00,'2024-09-24 15:47:43','2024-10-07 20:21:18'),(59,3,46,'azul',59,'2024-09-27',27000.00,'transferencia',16285.00,'2024-09-27 21:41:06','2024-09-27 21:41:06'),(60,2,46,'verde',60,'2024-09-28',25000.00,'efectivo',14445.00,'2024-09-28 17:15:31','2024-10-04 01:45:48'),(61,2,44,'marron',61,'2024-10-01',25000.00,'transferencia',14445.00,'2024-10-02 01:38:53','2024-10-08 17:38:15'),(62,3,44,'blancobeige',62,'2024-10-03',27000.00,'efectivo',16285.00,'2024-10-04 00:18:21','2024-10-04 00:18:21'),(63,3,44,'verde',63,'2024-10-05',27000.00,'transferencia',16285.00,'2024-10-06 14:04:42','2024-10-06 14:04:42'),(64,13,40,'azul',64,'2024-10-07',29000.00,'transferencia',18025.00,'2024-10-07 19:04:28','2024-10-07 19:04:28'),(65,2,52,'marron',64,'2024-10-07',25000.00,'transferencia',14445.00,'2024-10-07 19:04:28','2024-10-07 19:04:28'),(66,3,52,'marron',63,'2024-10-07',27000.00,'transferencia',16285.00,'2024-10-07 19:05:11','2024-10-07 19:05:11'),(67,3,52,'verde',63,'2024-10-07',27000.00,'transferencia',16285.00,'2024-10-07 19:05:11','2024-10-07 19:05:11'),(68,12,44,'blancobeige',65,'2024-10-06',6900.00,'efectivo',3994.00,'2024-10-07 19:06:38','2024-10-07 19:06:48'),(69,3,42,'azul',66,'2024-10-07',27000.00,'transferencia',16285.00,'2024-10-07 21:04:08','2024-10-08 14:47:12'),(70,12,38,'celeste',66,'2024-10-07',6900.00,'transferencia',3994.00,'2024-10-07 21:04:08','2024-10-07 21:04:08'),(71,12,40,'azul',67,'2024-10-07',6900.00,'efectivo',3994.00,'2024-10-07 21:18:34','2024-10-07 21:18:34'),(72,3,46,'verde',68,'2024-10-08',27000.00,'transferencia',16285.00,'2024-10-08 16:31:46','2024-10-08 16:31:46'),(73,2,42,'marron',69,'2024-10-08',25000.00,'efectivo',14445.00,'2024-10-08 17:39:03','2024-10-08 17:39:03'),(74,1,44,'azul',70,'2024-10-08',25000.00,'efectivo',14445.00,'2024-10-08 21:49:04','2024-10-08 21:49:04'),(75,3,38,'verde',71,'2024-10-08',25000.00,'efectivo',16285.00,'2024-10-08 21:50:37','2024-10-09 15:49:37'),(76,3,44,'marron',71,'2024-10-08',29000.00,'transferencia',16285.00,'2024-10-08 21:51:23','2024-10-08 21:51:34'),(77,5,40,'verde',72,'2024-10-09',28000.00,'transferencia',14420.00,'2024-10-09 15:51:25','2024-10-09 15:51:25'),(78,3,44,'azul',73,'2024-10-10',27000.00,'transferencia',16285.00,'2024-10-10 15:05:40','2024-10-10 15:05:40'),(79,12,41,'blancobeige',74,'2024-10-10',6900.00,'efectivo',3994.00,'2024-10-10 16:07:22','2024-10-10 16:07:22'),(80,3,44,'blancobeige',75,'2024-10-10',27000.00,'transferencia',16285.00,'2024-10-10 17:29:39','2024-10-22 21:35:15'),(81,1,36,'marron',61,'2024-10-04',25000.00,'transferencia',14445.00,'2024-10-10 18:22:15','2024-10-10 18:22:15'),(82,1,36,'negro',29,'2024-10-10',25000.00,'efectivo',14445.00,'2024-10-10 18:24:27','2024-10-10 18:24:27'),(83,3,38,'marron',76,'2024-10-10',27000.00,'transferencia',16285.00,'2024-10-10 21:44:21','2024-10-10 21:44:21'),(84,3,46,'verde',77,'2024-10-10',27000.00,'efectivo',16285.00,'2024-10-10 23:37:47','2024-10-10 23:37:47'),(85,3,38,'azul',77,'2024-10-10',27000.00,'efectivo',16285.00,'2024-10-10 23:37:48','2024-10-11 15:10:30'),(86,3,44,'verde',78,'2024-10-11',27000.00,'transferencia',16285.00,'2024-10-11 17:49:28','2024-10-11 17:49:28'),(87,3,44,'marron',78,'2024-10-11',27000.00,'transferencia',16285.00,'2024-10-11 17:49:28','2024-10-11 17:49:28'),(88,3,44,'negro',79,'2024-10-12',27000.00,'transferencia',16285.00,'2024-10-13 01:49:01','2024-10-13 01:49:01'),(89,3,48,'azul',80,'2024-10-13',27000.00,'transferencia',16285.00,'2024-10-14 18:13:19','2024-10-14 18:13:19'),(90,3,48,'verde',80,'2024-10-13',27000.00,'transferencia',16285.00,'2024-10-14 18:13:19','2024-10-14 18:13:19'),(91,3,40,'celeste',81,'2024-10-14',27000.00,'transferencia',16285.00,'2024-10-14 18:16:09','2024-10-16 21:03:33'),(92,12,42,'verde',81,'2024-10-14',7000.00,'transferencia',3994.00,'2024-10-14 18:16:09','2024-10-14 18:16:24'),(93,3,42,'verde',73,'2024-10-16',27000.00,'efectivo',16285.00,'2024-10-16 22:27:32','2024-10-16 22:27:32'),(94,3,38,'blancobeige',82,'2024-10-17',27000.00,'efectivo',16285.00,'2024-10-17 13:59:38','2024-10-17 13:59:38'),(95,12,36,'celeste',82,'2024-10-17',5000.00,'efectivo',3994.00,'2024-10-17 13:59:38','2024-10-23 16:52:01'),(96,12,40,'blancobeige',74,'2024-10-17',6900.00,'efectivo',3994.00,'2024-10-17 18:26:56','2024-10-17 18:26:56'),(97,3,50,'azul',83,'2024-10-17',29500.00,'transferencia',16285.00,'2024-10-17 18:28:10','2024-10-17 18:28:22'),(98,3,50,'blancobeige',83,'2024-10-17',29500.00,'transferencia',16285.00,'2024-10-17 18:28:10','2024-10-17 18:28:30'),(99,1,40,'marron',84,'2024-10-17',27500.00,'efectivo',16285.00,'2024-10-17 22:38:06','2024-10-18 21:18:02'),(100,3,46,'azul',85,'2024-10-18',27000.00,'efectivo',14445.00,'2024-10-18 14:47:38','2024-10-21 13:43:28'),(101,12,38,'blancobeige',85,'2024-10-18',5000.00,'efectivo',3994.00,'2024-10-18 14:47:57','2024-10-18 14:48:05'),(102,12,39,'azul',86,'2024-10-18',6900.00,'efectivo',3994.00,'2024-10-18 15:13:42','2024-10-18 15:13:42'),(103,3,46,'negro',87,'2024-10-18',27000.00,'efectivo',16285.00,'2024-10-18 22:48:57','2024-10-18 22:48:57'),(104,12,37,'celeste',87,'2024-10-18',5000.00,'efectivo',3994.00,'2024-10-18 22:49:52','2024-10-18 22:50:01'),(105,3,42,'marron',88,'2024-10-18',27500.00,'efectivo',16285.00,'2024-10-18 22:50:44','2024-10-18 22:50:54'),(106,12,41,'verde',89,'2024-10-20',6900.00,'efectivo',3994.00,'2024-10-21 02:14:20','2024-10-21 02:14:20'),(107,14,46,'verde',90,'2024-10-21',29500.00,'transferencia',16285.00,'2024-10-21 14:29:41','2024-10-21 14:29:50'),(108,12,36,'blancobeige',91,'2024-10-21',6900.00,'efectivo',3994.00,'2024-10-21 14:31:10','2024-10-21 14:31:10'),(109,3,44,'marron',92,'2024-10-22',27000.00,'efectivo',16285.00,'2024-10-22 21:37:42','2024-10-22 21:37:42'),(110,3,44,'azul',92,'2024-10-22',27000.00,'efectivo',16285.00,'2024-10-22 21:37:42','2024-10-22 21:37:42'),(111,3,42,'blancobeige',93,'2024-10-22',29500.00,'transferencia',16285.00,'2024-10-22 21:40:54','2024-10-23 13:27:29'),(112,2,40,'marron',94,'2024-10-22',25500.00,'efectivo',14445.00,'2024-10-22 21:42:32','2024-10-22 21:42:44'),(113,3,44,'negro',95,'2024-10-21',29500.00,'transferencia',16285.00,'2024-10-22 21:45:01','2024-10-22 21:45:25'),(114,3,44,'azul',95,'2024-10-21',29500.00,'transferencia',16285.00,'2024-10-22 21:45:01','2024-10-22 21:45:15'),(115,2,42,'marron',96,'2024-10-21',20000.00,'transferencia',14445.00,'2024-10-22 21:53:33','2024-10-22 21:53:49'),(116,3,50,'verde',96,'2024-10-21',22000.00,'transferencia',16285.00,'2024-10-22 21:53:33','2024-10-22 21:53:56'),(117,3,50,'blancobeige',96,'2024-10-21',22000.00,'transferencia',16285.00,'2024-10-22 21:53:33','2024-10-22 21:54:02'),(118,3,42,'azul',96,'2024-10-21',22000.00,'transferencia',16285.00,'2024-10-22 21:53:33','2024-10-22 21:54:05'),(119,3,40,'verde',96,'2024-10-21',22000.00,'transferencia',16285.00,'2024-10-22 21:53:33','2024-10-22 21:54:12'),(120,3,40,'blancobeige',96,'2024-10-21',22000.00,'transferencia',16285.00,'2024-10-22 21:53:33','2024-10-22 21:54:20'),(121,3,40,'azul',96,'2024-10-21',22000.00,'transferencia',16285.00,'2024-10-22 21:53:33','2024-10-22 21:54:27'),(122,3,44,'verde',96,'2024-10-21',22000.00,'transferencia',16285.00,'2024-10-22 21:53:33','2024-10-22 21:54:37'),(123,3,44,'celeste',96,'2024-10-21',22000.00,'transferencia',16285.00,'2024-10-22 21:53:33','2024-10-22 21:54:54'),(124,3,44,'blancobeige',96,'2024-10-21',22000.00,'transferencia',16285.00,'2024-10-22 21:53:33','2024-10-22 21:54:42'),(125,3,42,'negro',96,'2024-10-21',22000.00,'transferencia',16285.00,'2024-10-22 21:53:33','2024-10-22 21:54:47'),(126,13,44,'blancobeige',91,'2024-10-23',29500.00,'efectivo',18025.00,'2024-10-23 14:39:42','2024-10-23 14:39:53'),(127,12,43,'blancobeige',97,'2024-10-23',7500.00,'transferencia',3994.00,'2024-10-23 14:42:12','2024-10-23 14:42:23'),(128,2,44,'marron',98,'2024-10-23',25000.00,'efectivo',14445.00,'2024-10-23 21:44:15','2024-10-23 21:44:15'),(129,2,44,'verde',99,'2024-10-23',27500.00,'transferencia',16265.00,'2024-10-23 21:45:08','2024-10-23 22:43:58'),(130,12,41,'blancobeige',99,'2024-10-23',7500.00,'transferencia',3994.00,'2024-10-23 21:45:08','2024-10-23 22:44:19'),(131,3,40,'verde',100,'2024-10-23',29500.00,'transferencia',16285.00,'2024-10-23 23:36:00','2024-10-23 23:36:14'),(132,2,40,'marron',101,'2024-10-24',27500.00,'transferencia',14445.00,'2024-10-25 17:50:10','2024-10-25 17:51:20'),(133,3,40,'blancobeige',101,'2024-10-24',29500.00,'transferencia',16285.00,'2024-10-25 17:50:10','2024-12-06 22:07:27'),(134,2,44,'marron',101,'2024-10-24',27500.00,'transferencia',14445.00,'2024-10-25 17:50:10','2024-10-25 17:51:08'),(135,3,40,'blancobeige',101,'2024-10-24',29500.00,'transferencia',16285.00,'2024-10-25 17:50:10','2024-10-25 17:50:58'),(136,12,41,'celeste',101,'2024-10-24',7500.00,'transferencia',3994.00,'2024-10-25 17:50:10','2024-10-25 17:50:28'),(137,12,41,'azul',101,'2024-10-24',7500.00,'transferencia',3994.00,'2024-10-25 17:50:10','2024-10-25 17:50:21'),(138,3,38,'azul',68,'2024-10-25',27500.00,'efectivo',16285.00,'2024-10-25 18:21:11','2024-10-25 18:21:11'),(139,3,38,'celeste',102,'2024-10-26',29500.00,'transferencia',16285.00,'2024-10-26 22:50:25','2024-10-28 18:44:05'),(140,12,44,'verde',65,'2024-10-29',0.00,'efectivo',0.00,'2024-10-30 02:19:51','2024-10-30 02:20:00'),(141,2,40,'azul',94,'2024-10-30',25500.00,'efectivo',14445.00,'2024-10-30 22:47:05','2024-10-30 22:47:05'),(142,2,44,'azul',103,'2024-10-29',27500.00,'transferencia',14445.00,'2024-10-30 22:48:15','2024-10-30 22:48:29'),(143,12,41,'celeste',103,'2024-10-29',7500.00,'transferencia',3994.00,'2024-10-30 22:48:15','2024-10-30 22:48:44'),(144,3,52,'celeste',104,'2024-10-31',27500.00,'efectivo',16285.00,'2024-10-31 22:39:56','2024-10-31 22:39:56'),(145,3,54,'marron',105,'2024-11-04',29500.00,'transferencia',16285.00,'2024-11-04 22:02:33','2024-11-04 22:04:36'),(146,3,54,'negro',105,'2024-11-04',29500.00,'transferencia',16285.00,'2024-11-04 22:02:33','2024-11-04 22:04:28'),(147,3,54,'azul',105,'2024-11-04',29500.00,'transferencia',16285.00,'2024-11-04 22:02:33','2024-11-04 22:04:22'),(148,3,48,'azul',105,'2024-11-04',29500.00,'transferencia',16285.00,'2024-11-04 22:02:33','2024-11-04 22:04:16'),(149,3,38,'negro',41,'2024-11-04',29500.00,'transferencia',16285.00,'2024-11-04 22:03:59','2024-11-04 22:04:09'),(150,3,44,'blancobeige',106,'2024-11-04',29500.00,'transferencia',16285.00,'2024-11-04 22:05:14','2024-11-04 22:05:23'),(151,6,0,'negro',107,'2024-11-05',22500.00,'transferencia',10785.00,'2024-11-06 00:01:56','2024-11-07 03:09:03'),(153,15,52,'azul',104,'2024-11-05',29000.00,'efectivo',15645.00,'2024-11-06 00:34:42','2024-11-06 00:34:42'),(154,3,50,'verde',104,'2024-11-05',27500.00,'efectivo',16285.00,'2024-11-06 00:34:42','2024-11-06 00:34:42'),(155,6,2,'azul',108,'2024-11-05',22500.00,'transferencia',10785.00,'2024-11-06 00:35:58','2024-11-15 22:29:06'),(156,3,38,'blancobeige',35,'2024-11-07',27500.00,'efectivo',16285.00,'2024-11-07 17:03:43','2024-11-07 17:03:43'),(157,12,36,'azul',35,'2024-11-07',6900.00,'efectivo',3994.00,'2024-11-07 17:03:44','2024-11-07 17:03:44'),(158,12,38,'celeste',109,'2024-11-07',6900.00,'efectivo',3994.00,'2024-11-07 17:15:09','2024-11-07 17:15:09'),(159,12,42,'azul',110,'2024-11-08',7500.00,'transferencia',3994.00,'2024-11-08 18:20:27','2024-11-08 18:20:35'),(160,3,44,'negro',111,'2024-11-08',29500.00,'transferencia',16285.00,'2024-11-08 18:21:46','2024-11-08 18:21:53'),(161,3,52,'azul',112,'2024-11-15',27500.00,'efectivo',16285.00,'2024-11-15 22:31:09','2024-11-15 22:31:09'),(162,3,52,'negro',112,'2024-11-15',27500.00,'efectivo',16285.00,'2024-11-15 22:31:09','2024-11-15 22:31:09'),(163,16,38,'marron',113,'2024-11-21',27500.00,'transferencia',14100.00,'2024-11-21 18:14:50','2024-11-21 18:15:13'),(164,16,38,'marron',113,'2024-11-21',27500.00,'transferencia',14100.00,'2024-11-21 18:14:50','2024-11-21 18:15:03'),(165,16,38,'marron',113,'2024-11-21',27500.00,'transferencia',14100.00,'2024-11-21 18:14:50','2024-11-21 18:15:08'),(166,16,38,'marron',113,'2024-11-21',27500.00,'transferencia',14100.00,'2024-11-21 18:14:50','2024-11-21 18:14:57'),(167,3,46,'negro',114,'2024-11-21',29500.00,'transferencia',16285.00,'2024-11-21 18:17:14','2024-11-21 18:17:31'),(168,3,46,'celeste',114,'2024-11-21',29500.00,'transferencia',16285.00,'2024-11-21 18:17:14','2024-11-21 18:17:26'),(169,3,46,'marron',114,'2024-11-21',29500.00,'transferencia',16285.00,'2024-11-21 18:17:14','2024-11-21 18:17:22'),(170,3,42,'azul',115,'2024-11-21',27500.00,'efectivo',16285.00,'2024-11-21 18:20:30','2024-11-21 18:20:30'),(171,2,44,'azul',116,'2024-11-21',25500.00,'efectivo',14445.00,'2024-11-21 18:21:16','2024-11-23 23:58:02'),(172,3,38,'blancobeige',117,'2024-11-22',27500.00,'efectivo',16285.00,'2024-11-23 23:53:21','2024-11-23 23:56:26'),(173,7,14,'negro',118,'2024-11-23',22500.00,'transferencia',10965.00,'2024-11-23 23:56:10','2024-11-23 23:56:10'),(174,7,14,'marron',118,'2024-11-23',22500.00,'transferencia',10965.00,'2024-11-23 23:56:10','2024-11-23 23:56:10'),(175,3,44,'celeste',118,'2024-11-23',29500.00,'transferencia',16285.00,'2024-11-23 23:56:10','2024-11-23 23:56:39'),(176,2,36,'negro',119,'2024-12-03',27500.00,'transferencia',14445.00,'2024-12-04 12:53:31','2024-12-04 12:59:07'),(177,3,40,'azul',120,'2024-11-27',29500.00,'transferencia',16285.00,'2024-12-04 12:55:54','2024-12-04 12:56:58'),(178,2,40,'marron',120,'2024-11-27',27500.00,'transferencia',14445.00,'2024-12-04 12:56:50','2024-12-04 12:57:03'),(179,3,42,'verde',121,'2024-12-03',29500.00,'transferencia',16285.00,'2024-12-04 12:58:49','2025-01-16 15:17:30'),(180,12,40,'celeste',122,'2024-12-01',7500.00,'transferencia',3994.00,'2024-12-04 13:00:32','2024-12-04 13:15:40'),(181,3,40,'celeste',123,'2024-12-03',29500.00,'transferencia',16285.00,'2024-12-04 13:05:19','2024-12-04 13:05:32'),(182,3,42,'celeste',123,'2024-12-03',29500.00,'transferencia',16285.00,'2024-12-04 13:05:19','2024-12-04 13:05:37'),(183,3,42,'blancobeige',123,'2024-12-03',29500.00,'transferencia',16285.00,'2024-12-04 13:05:19','2024-12-04 13:05:44'),(184,17,6,'celeste',123,'2024-12-03',24000.00,'transferencia',14030.00,'2024-12-04 13:05:19','2024-12-04 13:05:53'),(185,12,41,'blancobeige',124,'2024-11-30',7500.00,'transferencia',3994.00,'2024-12-04 13:15:19','2024-12-04 13:15:32'),(186,15,48,'azul',125,'2024-11-30',29500.00,'efectivo',15645.00,'2024-12-04 13:21:23','2025-01-16 01:30:25'),(187,3,38,'azul',126,'2024-12-04',29500.00,'transferencia',16285.00,'2024-12-04 17:28:02','2024-12-04 17:28:09'),(189,1,36,'marron',29,'2024-12-05',25500.00,'efectivo',14445.00,'2024-12-05 22:17:30','2024-12-05 22:17:30'),(190,2,44,'marron',128,'2024-12-05',25500.00,'efectivo',14445.00,'2024-12-05 22:20:28','2024-12-05 22:20:28'),(191,2,42,'azul',128,'2024-12-05',25500.00,'efectivo',14445.00,'2024-12-05 22:20:28','2024-12-05 22:20:28'),(192,1,40,'marron',129,'2024-12-05',27500.00,'transferencia',14445.00,'2024-12-05 22:33:40','2024-12-05 22:33:50'),(193,1,40,'verde',129,'2024-12-05',27500.00,'transferencia',14445.00,'2024-12-05 22:33:40','2024-12-05 22:33:56'),(194,1,40,'azul',129,'2024-12-05',27500.00,'transferencia',14445.00,'2024-12-05 22:33:40','2024-12-05 22:34:01'),(195,3,48,'marron',130,'2024-12-05',29500.00,'transferencia',16285.00,'2024-12-05 22:34:59','2024-12-05 22:35:13'),(196,3,48,'verde',130,'2024-12-05',29500.00,'transferencia',16285.00,'2024-12-05 22:34:59','2024-12-05 22:35:06'),(197,3,40,'azul',131,'2024-12-06',27500.00,'efectivo',16285.00,'2024-12-06 22:06:36','2024-12-06 22:06:36'),(198,1,38,'marron',132,'2024-12-07',25500.00,'efectivo',14445.00,'2024-12-07 22:13:42','2024-12-07 22:13:42'),(199,3,46,'negro',133,'2024-12-10',27500.00,'efectivo',16285.00,'2024-12-11 00:33:55','2024-12-11 00:33:55'),(200,3,48,'negro',134,'2024-12-09',29500.00,'transferencia',16285.00,'2024-12-11 00:36:18','2024-12-11 00:36:26'),(201,2,54,'azul',34,'2024-09-10',25500.00,'efectivo',14445.00,'2024-12-11 19:00:29','2024-12-11 19:00:57'),(202,2,54,'verde',135,'2024-12-11',27500.00,'transferencia',14445.00,'2024-12-11 21:53:36','2024-12-11 21:53:44'),(203,2,54,'verde',135,'2024-12-11',27500.00,'transferencia',14445.00,'2024-12-11 21:53:36','2024-12-11 21:53:48'),(204,1,36,'marron',136,'2024-12-12',25500.00,'efectivo',14445.00,'2024-12-14 14:32:55','2024-12-14 14:33:03'),(205,3,46,'blancobeige',137,'2024-12-14',27500.00,'efectivo',16285.00,'2024-12-14 14:33:57','2024-12-14 14:33:57'),(206,3,50,'celeste',137,'2024-12-14',27500.00,'efectivo',16285.00,'2024-12-14 14:33:57','2024-12-14 14:33:57'),(207,12,44,'azul',137,'2024-12-14',6900.00,'efectivo',3994.00,'2024-12-14 14:33:57','2024-12-14 14:33:57'),(208,3,38,'negro',138,'2024-12-14',29500.00,'transferencia',16285.00,'2024-12-14 18:04:26','2024-12-14 18:04:45'),(209,3,42,'marron',138,'2024-12-14',29500.00,'transferencia',16285.00,'2024-12-14 18:04:26','2024-12-14 18:04:51'),(210,15,48,'azul',138,'2024-12-14',31500.00,'transferencia',15645.00,'2024-12-14 18:04:26','2024-12-14 18:04:58'),(211,1,38,'marron',139,'2024-12-20',27500.00,'transferencia',14445.00,'2024-12-20 16:25:16','2024-12-20 16:25:24'),(213,3,40,'marron',120,'2024-12-20',29500.00,'transferencia',16285.00,'2024-12-20 16:26:45','2024-12-20 16:26:53'),(214,4,46,'marron',141,'2024-12-20',29500.00,'transferencia',16265.00,'2024-12-20 16:29:08','2024-12-20 16:29:19'),(217,3,52,'celeste',142,'2024-12-20',27500.00,'efectivo',16285.00,'2024-12-20 18:10:38','2024-12-20 18:10:38'),(218,3,52,'blancobeige',142,'2024-12-20',27500.00,'efectivo',16285.00,'2024-12-20 18:10:38','2024-12-20 18:10:38'),(219,3,42,'negro',143,'2024-12-20',29500.00,'transferencia',16285.00,'2024-12-20 21:47:33','2024-12-20 21:47:41'),(220,7,12,'marron',144,'2024-12-20',22500.00,'transferencia',10965.00,'2024-12-20 21:49:15','2024-12-20 21:49:15'),(223,3,46,'azul',137,'2024-12-20',27500.00,'efectivo',16285.00,'2024-12-20 22:03:51','2024-12-20 22:03:51'),(224,3,46,'azul',137,'2024-12-20',27500.00,'efectivo',16285.00,'2024-12-20 22:03:51','2024-12-20 22:03:51'),(225,15,46,'azul',89,'2024-12-20',29500.00,'efectivo',15645.00,'2024-12-21 00:35:00','2024-12-21 00:35:00'),(226,15,46,'blancobeige',89,'2024-12-20',29500.00,'efectivo',15645.00,'2024-12-21 00:35:00','2024-12-21 00:35:00'),(227,15,54,'verde',89,'2024-12-20',29500.00,'efectivo',15645.00,'2024-12-21 00:36:05','2025-01-16 01:29:47'),(228,3,48,'celeste',146,'2025-01-15',27500.00,'efectivo',16285.00,'2025-01-15 23:10:29','2025-01-15 23:10:29'),(229,14,42,'negro',147,'2024-12-23',27500.00,'efectivo',16285.00,'2025-01-15 23:35:31','2025-01-15 23:35:31'),(230,3,40,'negro',138,'2025-01-16',29500.00,'transferencia',16285.00,'2025-01-16 13:47:22','2025-01-16 13:47:30'),(231,3,40,'verde',131,'2025-01-16',27500.00,'efectivo',16285.00,'2025-01-16 15:21:58','2025-01-16 15:21:58'),(232,3,48,'celeste',148,'2025-01-29',29000.00,'efectivo',16285.00,'2025-01-29 18:26:59','2025-01-29 18:27:13'),(233,3,48,'blancobeige',148,'2025-01-29',29000.00,'efectivo',16285.00,'2025-01-29 18:26:59','2025-01-29 18:27:06'),(234,12,42,'celeste',149,'2025-02-03',7500.00,'efectivo',4235.00,'2025-02-03 18:36:58','2025-02-03 18:36:58'),(235,12,42,'celeste',149,'2025-02-03',7500.00,'efectivo',4235.00,'2025-02-03 18:36:58','2025-02-03 18:36:58'),(236,12,42,'blancobeige',149,'2025-02-03',7500.00,'efectivo',4235.00,'2025-02-03 18:36:58','2025-02-03 18:36:58'),(237,2,42,'verde',149,'2025-02-03',27000.00,'efectivo',15033.00,'2025-02-03 18:36:58','2025-02-04 22:47:38'),(238,12,36,'verde',149,'2025-02-03',7500.00,'efectivo',4235.00,'2025-02-03 18:36:58','2025-02-03 18:36:58'),(239,15,46,'marron',150,'2025-02-03',29500.00,'efectivo',16270.00,'2025-02-03 23:06:54','2025-02-03 23:06:54'),(240,12,36,'azul',151,'2025-02-04',7500.00,'efectivo',4235.00,'2025-02-04 22:48:26','2025-02-04 22:48:26'),(241,3,48,'negro',146,'2025-02-05',29000.00,'efectivo',16936.00,'2025-02-05 20:54:06','2025-02-05 20:54:06'),(242,3,44,'celeste',78,'2025-02-05',29000.00,'efectivo',16936.00,'2025-02-06 15:37:57','2025-02-06 15:38:08'),(243,18,42,'verde',152,'2025-02-07',31000.00,'transferencia',16900.00,'2025-02-15 00:56:34','2025-02-15 00:57:03'),(244,18,42,'blancobeige',152,'2025-02-07',31000.00,'transferencia',16900.00,'2025-02-15 00:56:34','2025-02-15 00:57:20'),(245,1,32,'azul',153,'2025-02-14',29000.00,'transferencia',15033.00,'2025-02-15 00:59:27','2025-02-15 00:59:34'),(246,3,44,'verde',154,'2025-02-13',31000.00,'transferencia',16936.00,'2025-02-15 01:00:34','2025-02-15 01:00:40'),(247,3,46,'negro',155,'2025-02-14',25500.00,'transferencia',16936.00,'2025-02-15 01:25:28','2025-02-15 01:25:54'),(248,2,40,'negro',155,'2025-02-14',23500.00,'transferencia',15033.00,'2025-02-15 01:25:28','2025-02-15 01:25:59'),(249,2,42,'verde',155,'2025-02-14',23500.00,'transferencia',15033.00,'2025-02-15 01:25:28','2025-02-15 01:26:04'),(250,2,42,'azul',155,'2025-02-14',23500.00,'transferencia',15033.00,'2025-02-15 01:25:28','2025-02-15 01:28:25'),(251,2,44,'marron',155,'2025-02-14',23500.00,'transferencia',15033.00,'2025-02-15 01:25:28','2025-02-15 01:28:31'),(252,2,44,'verde',155,'2025-02-14',23500.00,'transferencia',15033.00,'2025-02-15 01:25:28','2025-02-15 01:28:37'),(253,2,46,'negro',155,'2025-02-14',23500.00,'transferencia',15033.00,'2025-02-15 01:25:28','2025-02-15 01:28:42'),(254,2,46,'marron',155,'2025-02-14',23500.00,'transferencia',15033.00,'2025-02-15 01:25:28','2025-02-15 01:28:47'),(255,2,48,'negro',155,'2025-02-14',23500.00,'transferencia',15033.00,'2025-02-15 01:25:28','2025-02-15 01:28:51'),(256,2,48,'marron',155,'2025-02-14',23500.00,'transferencia',15033.00,'2025-02-15 01:25:28','2025-02-15 01:28:57'),(257,2,38,'azul',156,'2025-02-12',29000.00,'transferencia',15033.00,'2025-02-15 13:31:36','2025-02-15 13:31:51'),(258,2,40,'verde',156,'2025-02-12',29000.00,'transferencia',15033.00,'2025-02-15 13:31:36','2025-02-15 13:31:56'),(259,2,42,'negro',156,'2025-02-12',29000.00,'transferencia',15033.00,'2025-02-15 13:31:36','2025-02-15 13:32:01'),(260,2,44,'marron',156,'2025-02-12',29000.00,'transferencia',15033.00,'2025-02-15 13:31:36','2025-02-15 13:32:08'),(261,3,44,'blancobeige',157,'2025-02-15',29000.00,'efectivo',16936.00,'2025-02-16 19:34:15','2025-02-16 19:34:15'),(262,1,32,'marron',158,'2025-02-15',27000.00,'efectivo',15033.00,'2025-02-16 19:35:34','2025-02-16 19:35:34'),(263,2,38,'azul',159,'2025-02-16',29000.00,'transferencia',15033.00,'2025-02-16 19:37:17','2025-02-16 19:37:32'),(264,1,36,'marron',160,'2025-02-17',27000.00,'efectivo',15033.00,'2025-02-17 17:16:43','2025-02-18 21:37:53'),(265,1,38,'negro',160,'2025-02-17',27000.00,'efectivo',15033.00,'2025-02-17 17:16:44','2025-02-17 17:16:44'),(267,15,48,'marron',133,'2025-02-18',29500.00,'efectivo',16270.00,'2025-02-18 23:32:27','2025-02-18 23:32:27'),(268,12,37,'celeste',162,'2025-02-19',8000.00,'transferencia',4235.00,'2025-02-19 14:56:21','2025-02-19 14:56:38'),(269,2,44,'azul',163,'2025-02-19',27000.00,'efectivo',15033.00,'2025-02-19 21:50:50','2025-02-19 21:50:50'),(270,2,44,'verde',163,'2025-02-19',27000.00,'efectivo',15033.00,'2025-02-19 21:50:50','2025-02-19 21:50:50'),(271,2,42,'verde',164,'2025-02-20',27000.00,'efectivo',15033.00,'2025-02-20 18:08:54','2025-02-20 18:08:54'),(272,2,48,'verde',164,'2025-02-20',27000.00,'efectivo',15033.00,'2025-02-20 18:08:54','2025-02-20 18:08:54'),(273,2,46,'negro',165,'2025-02-22',27000.00,'efectivo',15033.00,'2025-02-22 17:27:53','2025-02-22 17:27:53'),(274,3,46,'blancobeige',165,'2025-02-22',29000.00,'efectivo',16936.00,'2025-02-22 17:27:53','2025-02-22 17:27:53'),(275,12,43,'verde',166,'2025-02-22',8000.00,'efectivo',4235.00,'2025-02-22 17:29:09','2025-02-22 17:29:21'),(276,13,48,'negro',167,'2025-02-23',33000.00,'transferencia',18746.00,'2025-02-24 16:13:59','2025-02-24 16:15:46'),(277,4,40,'negro',168,'2025-02-24',31000.00,'transferencia',18746.00,'2025-02-24 16:15:32','2025-02-24 16:15:32'),(278,6,0,'marron',169,'2025-02-25',24000.00,'transferencia',11216.00,'2025-02-25 14:15:01','2025-02-25 14:15:18'),(279,5,42,'marron',169,'2025-02-25',29000.00,'transferencia',14996.00,'2025-02-25 14:15:02','2025-02-25 14:15:27'),(280,5,42,'verde',169,'2025-02-25',29000.00,'transferencia',14996.00,'2025-02-25 14:15:02','2025-02-25 14:15:31'),(281,2,36,'verde',170,'2025-02-25',29000.00,'transferencia',15033.00,'2025-02-26 01:22:55','2025-02-26 01:23:04'),(282,1,38,'marron',171,'2025-02-26',27000.00,'efectivo',15033.00,'2025-02-26 23:44:19','2025-02-26 23:44:19'),(283,1,38,'negro',171,'2025-02-26',27000.00,'efectivo',15033.00,'2025-02-26 23:44:19','2025-02-26 23:44:19'),(284,1,36,'verde',172,'2025-02-27',29000.00,'transferencia',15033.00,'2025-02-27 18:50:51','2025-02-27 18:50:58'),(285,3,44,'negro',173,'2025-03-06',31000.00,'transferencia',16936.00,'2025-03-08 02:25:21','2025-03-08 02:26:01'),(286,3,44,'marron',173,'2025-03-06',31000.00,'transferencia',16936.00,'2025-03-08 02:25:21','2025-03-08 02:25:57'),(287,3,46,'negro',173,'2025-03-06',31000.00,'transferencia',16936.00,'2025-03-08 02:25:21','2025-03-08 02:25:53'),(288,3,46,'celeste',173,'2025-03-06',31000.00,'transferencia',16936.00,'2025-03-08 02:25:21','2025-03-08 02:25:49'),(289,3,46,'marron',173,'2025-03-06',31000.00,'transferencia',16936.00,'2025-03-08 02:25:21','2025-03-08 02:25:45'),(290,3,44,'verde',173,'2025-03-06',31000.00,'transferencia',16936.00,'2025-03-08 02:25:21','2025-03-08 02:25:40'),(291,3,50,'verde',173,'2025-03-06',31000.00,'transferencia',16936.00,'2025-03-08 02:25:21','2025-03-08 02:25:36'),(292,3,50,'celeste',173,'2025-03-06',31000.00,'transferencia',16936.00,'2025-03-08 02:25:21','2025-03-08 02:25:31'),(293,1,38,'azul',174,'2025-03-07',29000.00,'transferencia',15033.00,'2025-03-08 02:28:07','2025-03-08 02:28:15'),(294,2,38,'azul',175,'2025-03-07',27000.00,'efectivo',15033.00,'2025-03-08 02:29:11','2025-03-08 02:29:11'),(295,3,42,'celeste',176,'2025-03-08',31000.00,'transferencia',16936.00,'2025-03-09 00:50:15','2025-03-09 00:50:23'),(296,2,42,'celeste',176,'2025-03-08',29000.00,'transferencia',15033.00,'2025-03-09 00:50:15','2025-03-09 00:50:29'),(297,4,44,'marron',177,'2025-03-08',31000.00,'transferencia',18746.00,'2025-03-09 00:51:07','2025-03-09 00:51:22'),(298,4,52,'marron',177,'2025-03-08',31000.00,'transferencia',18746.00,'2025-03-09 00:51:07','2025-03-09 00:51:07'),(299,2,38,'verde',178,'2025-03-10',29000.00,'transferencia',15033.00,'2025-03-10 14:20:27','2025-03-10 14:20:35'),(300,2,48,'marron',178,'2025-03-10',29000.00,'transferencia',15033.00,'2025-03-10 14:20:27','2025-03-10 14:20:40'),(301,12,40,'celeste',133,'2025-03-11',7500.00,'efectivo',4235.00,'2025-03-11 17:31:35','2025-03-11 17:31:35'),(302,12,41,'verde',133,'2025-03-11',7500.00,'efectivo',4235.00,'2025-03-11 17:31:35','2025-03-11 17:31:35'),(303,3,50,'blancobeige',180,'2025-03-11',29000.00,'efectivo',16936.00,'2025-03-11 20:28:11','2025-03-11 20:28:11'),(304,14,38,'blancobeige',181,'2025-03-11',29000.00,'efectivo',16936.00,'2025-03-11 20:29:34','2025-03-11 20:29:34'),(305,3,40,'azul',182,'2025-03-12',31000.00,'transferencia',16936.00,'2025-03-12 17:44:08','2025-03-12 17:44:17'),(306,3,40,'azul',182,'2025-03-12',31000.00,'transferencia',16936.00,'2025-03-12 17:44:09','2025-03-12 17:44:26'),(307,8,48,'negro',183,'2025-03-12',53500.00,'transferencia',32302.00,'2025-03-12 17:54:36','2025-03-12 17:54:45'),(308,8,48,'verde',183,'2025-03-12',53500.00,'transferencia',32302.00,'2025-03-12 17:54:36','2025-03-12 17:54:51'),(309,12,41,'blancobeige',183,'2025-03-12',8000.00,'transferencia',4235.00,'2025-03-12 17:54:36','2025-03-12 17:54:58'),(310,3,42,'azul',184,'2025-03-13',29000.00,'efectivo',16936.00,'2025-03-14 14:11:39','2025-03-14 14:11:39'),(311,2,44,'marron',185,'2025-03-13',29000.00,'transferencia',15033.00,'2025-03-14 14:14:17','2025-03-14 14:15:57'),(312,1,42,'azul',181,'2025-03-13',29000.00,'transferencia',15033.00,'2025-03-14 14:15:49','2025-03-14 14:18:35'),(313,3,36,'negro',186,'2025-03-14',31000.00,'transferencia',16936.00,'2025-03-14 14:18:20','2025-03-14 14:18:27'),(314,2,42,'verde',187,'2025-03-14',29000.00,'transferencia',15033.00,'2025-03-14 21:04:23','2025-03-14 21:04:32'),(315,21,68,'verde',188,'2025-03-14',35000.00,'efectivo',21632.00,'2025-03-15 02:48:50','2025-03-15 02:48:50'),(316,21,68,'azul',188,'2025-03-14',35000.00,'efectivo',21632.00,'2025-03-15 02:48:50','2025-03-15 02:48:50'),(317,8,50,'marron',189,'2025-03-18',53500.00,'transferencia',32302.00,'2025-03-18 04:09:49','2025-03-18 04:09:56'),(318,8,50,'negro',189,'2025-03-18',53500.00,'transferencia',32302.00,'2025-03-18 04:09:49','2025-03-18 04:10:00'),(319,8,50,'azul',189,'2025-03-18',53500.00,'transferencia',32302.00,'2025-03-18 04:09:49','2025-03-18 04:10:05'),(320,2,38,'marron',190,'2025-03-18',29000.00,'transferencia',15033.00,'2025-03-18 04:11:43','2025-03-18 04:11:52'),(321,2,50,'marron',191,'2025-03-18',23500.00,'transferencia',15033.00,'2025-03-18 04:20:15','2025-03-18 04:27:58'),(322,2,50,'azul',191,'2025-03-18',23500.00,'transferencia',15033.00,'2025-03-18 04:20:15','2025-03-18 04:27:50'),(323,2,44,'negro',191,'2025-03-18',23500.00,'transferencia',15033.00,'2025-03-18 04:20:15','2025-03-18 04:27:43'),(324,2,44,'verde',191,'2025-03-18',23500.00,'transferencia',15033.00,'2025-03-18 04:20:15','2025-03-18 04:27:39'),(325,2,44,'marron',191,'2025-03-18',23500.00,'transferencia',15033.00,'2025-03-18 04:20:15','2025-03-18 04:27:35'),(326,2,42,'verde',191,'2025-03-18',23500.00,'transferencia',15033.00,'2025-03-18 04:20:15','2025-03-18 04:27:31'),(327,6,4,'verde',191,'2025-03-18',19000.00,'transferencia',11216.00,'2025-03-18 04:20:15','2025-03-18 04:27:17'),(328,7,16,'verde',191,'2025-03-18',19000.00,'transferencia',11403.00,'2025-03-18 04:20:15','2025-03-18 04:27:10'),(329,22,46,'verde',191,'2025-03-18',23500.00,'transferencia',15033.00,'2025-03-18 04:20:15','2025-03-18 04:25:05'),(330,22,46,'verde',191,'2025-03-18',23500.00,'transferencia',15033.00,'2025-03-18 04:20:15','2025-03-18 04:25:00'),(331,2,50,'marron',83,'2025-03-19',27000.00,'efectivo',15033.00,'2025-03-19 12:50:29','2025-03-19 12:50:29'),(332,3,50,'negro',83,'2025-03-19',29000.00,'efectivo',16936.00,'2025-03-19 12:50:29','2025-03-19 12:50:29'),(333,2,46,'negro',192,'2025-03-19',27000.00,'efectivo',15033.00,'2025-03-19 16:50:22','2025-03-19 16:50:22'),(334,2,46,'verde',192,'2025-03-19',27000.00,'efectivo',15033.00,'2025-03-19 16:50:22','2025-03-19 16:50:22'),(335,3,36,'celeste',193,'2025-03-19',31000.00,'transferencia',16936.00,'2025-03-20 02:10:19','2025-03-20 02:10:28'),(336,3,36,'blancobeige',194,'2025-03-19',29000.00,'efectivo',16936.00,'2025-03-20 02:11:42','2025-03-20 02:11:42'),(337,6,8,'marron',194,'2025-03-19',22000.00,'efectivo',11216.00,'2025-03-20 02:11:42','2025-03-20 02:11:42'),(338,2,36,'azul',195,'2025-03-20',27000.00,'efectivo',15033.00,'2025-03-20 15:40:42','2025-03-20 15:40:42'),(339,2,42,'marron',196,'2025-03-21',29000.00,'transferencia',15033.00,'2025-03-21 21:00:21','2025-03-21 21:01:09'),(340,2,44,'negro',196,'2025-03-21',29000.00,'transferencia',15033.00,'2025-03-21 21:00:21','2025-03-21 21:01:02'),(341,2,44,'marron',196,'2025-03-21',29000.00,'transferencia',15033.00,'2025-03-21 21:00:21','2025-03-21 21:00:52'),(342,2,46,'marron',196,'2025-03-21',29000.00,'transferencia',15033.00,'2025-03-21 21:00:21','2025-03-21 21:00:39'),(343,12,44,'celeste',196,'2025-03-21',8000.00,'transferencia',4235.00,'2025-03-21 21:00:21','2025-03-21 21:00:32'),(344,31,38,'marron',197,'2025-03-24',27000.00,'transferencia',14731.00,'2025-03-25 22:05:37','2025-03-25 22:05:37'),(345,31,40,'marron',197,'2025-03-24',27000.00,'transferencia',14731.00,'2025-03-25 22:05:37','2025-03-25 22:05:37'),(346,3,42,'azul',198,'2025-03-25',31000.00,'transferencia',16936.00,'2025-03-27 02:54:40','2025-03-27 02:54:50'),(347,2,42,'azul',198,'2025-03-25',29000.00,'transferencia',15033.00,'2025-03-27 02:54:40','2025-03-27 02:54:55'),(348,12,37,'blancobeige',199,'2025-03-26',8000.00,'transferencia',4235.00,'2025-03-27 02:57:44','2025-03-27 02:57:54'),(349,12,39,'blancobeige',199,'2025-03-26',8000.00,'transferencia',4235.00,'2025-03-27 02:57:44','2025-03-27 02:58:00'),(350,2,42,'azul',200,'2025-03-26',27000.00,'efectivo',15033.00,'2025-03-27 02:59:00','2025-03-27 02:59:00'),(351,12,44,'blancobeige',201,'2025-03-26',7500.00,'transferencia',4235.00,'2025-03-27 03:02:00','2025-03-28 01:31:03'),(352,1,36,'marron',202,'2025-03-27',27000.00,'efectivo',15033.00,'2025-03-28 01:30:51','2025-03-28 01:30:51'),(353,7,16,'marron',16,'2025-03-28',29000.00,'transferencia',15033.00,'2025-03-28 17:39:58','2025-04-01 14:06:21'),(354,6,4,'marron',16,'2025-03-28',24000.00,'transferencia',11216.00,'2025-03-28 17:39:59','2025-03-28 17:40:21'),(355,2,40,'marron',203,'2025-03-30',29000.00,'transferencia',15033.00,'2025-03-30 21:31:54','2025-03-30 21:32:01'),(356,2,40,'verde',203,'2025-03-30',29000.00,'transferencia',15033.00,'2025-03-30 21:31:54','2025-03-30 21:32:06'),(357,12,40,'negro',204,'2025-04-01',7500.00,'efectivo',4235.00,'2025-04-01 17:17:33','2025-04-01 17:17:33'),(358,23,58,'marron',205,'2025-04-01',31000.00,'efectivo',16863.00,'2025-04-05 14:29:46','2025-04-05 15:03:06'),(359,23,58,'verde',205,'2025-04-01',31000.00,'efectivo',16863.00,'2025-04-05 14:29:46','2025-04-05 15:02:59'),(360,23,58,'verde',205,'2025-04-01',31000.00,'efectivo',16863.00,'2025-04-05 14:29:46','2025-04-05 15:02:55'),(361,5,36,'verde',206,'2025-04-01',29000.00,'efectivo',14996.00,'2025-04-05 15:02:43','2025-04-05 15:03:21'),(362,18,36,'blancobeige',206,'2025-04-01',31000.00,'efectivo',16900.00,'2025-04-05 15:02:44','2025-04-05 15:03:27'),(363,3,38,'celeste',207,'2025-04-03',31000.00,'transferencia',16936.00,'2025-04-05 15:03:54','2025-04-05 15:05:15'),(364,5,52,'marron',208,'2025-04-04',29000.00,'transferencia',14996.00,'2025-04-05 15:05:00','2025-04-05 15:05:10');
/*!40000 ALTER TABLE `ventas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-08  2:01:36
