-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-09-2024 a las 01:59:00
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `elmensual`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulos`
--

CREATE TABLE `articulos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `numero` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `costo_original` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `articulos`
--

INSERT INTO `articulos` (`id`, `numero`, `nombre`, `precio`, `costo_original`) VALUES
(1, 1450, 'Bombachas de grafa de mujer 32-50', 25000.00, 14445.00),
(2, 111, 'Bombachas de grafa de hombre 36-54', 25000.00, 14445.00),
(3, 155, 'Bombachas de grafil/poplin 38-54', 27000.00, 16285.00),
(4, 107, 'Bombachas de grafa largo especial 36-54', 28000.00, 16265.00),
(5, 116, 'Bombachas de grafa corto especial 36-54', 28000.00, 14420.00),
(6, 118, 'Bombachas de grafa niños 0-8', 20000.00, 10785.00),
(7, 119, 'Bombachas de grafa niños 8-16', 20000.00, 10965.00),
(8, 112, 'Bombachas de corderoy 36-54', 48000.00, 31060.00),
(11, 1, 'Bombachas de campo de prueba 36-44', 10000.00, 1.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cuit` varchar(20) DEFAULT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `cbu` varchar(22) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `cuit`, `nombre`, `apellido`, `cbu`, `created_at`, `updated_at`) VALUES
(15, NULL, 'Gustavo', 'Jurado', NULL, '2024-09-08 18:53:37', '2024-09-08 18:53:37'),
(16, NULL, 'Maida', 'Irazoqui', '0140189503520652479694', '2024-09-08 19:28:31', '2024-09-08 19:28:31'),
(17, NULL, 'Gabriela', 'Salinas', '0110030330003027148297', '2024-09-08 19:35:58', '2024-09-08 19:35:58'),
(18, '30728890', 'Julian Hipolito Raul', 'Coralli', NULL, '2024-09-08 19:38:30', '2024-09-08 19:38:30'),
(19, NULL, 'Mariano Ivan', 'Rusnak', '0140121503690350985488', '2024-09-08 19:40:40', '2024-09-08 19:40:40'),
(20, NULL, 'Luciana', 'Satriano', NULL, '2024-09-08 19:43:13', '2024-09-08 19:43:13'),
(21, NULL, 'Gladys Veronica', 'Dell', '0140084703503052635491', '2024-09-08 19:44:42', '2024-09-08 19:44:42'),
(22, NULL, 'Rocio Aylen', 'Buceta Orellano', '0140344003690052688771', '2024-09-08 19:48:13', '2024-09-08 19:48:13'),
(23, NULL, 'Rosario', 'Zabala', '0140445003690550346128', '2024-09-08 19:49:34', '2024-09-08 19:49:34'),
(24, NULL, 'Rafael', 'Terron', NULL, '2024-09-08 19:57:28', '2024-09-08 19:57:28'),
(25, NULL, 'Sabrina Ester', 'Affronte', '0140999803200061814142', '2024-09-08 20:01:16', '2024-09-08 20:01:16'),
(26, '20412549970', 'Laura Valeria', 'Cornejo', '0000003100028656232347', '2024-09-09 17:42:53', '2024-09-09 17:42:53'),
(27, '20422942980', 'Benjamin Andrada', 'Barrone', '0000003100073384560770', '2024-09-10 00:41:57', '2024-09-10 00:41:57'),
(28, '20209145368', 'Andres Juan', 'Saggese', '0140306803644351096559', '2024-09-10 01:08:40', '2024-09-10 01:08:40'),
(29, NULL, 'Yamila Ester', 'Hours Santero', '4530000800018714974096', '2024-09-10 17:28:37', '2024-09-10 17:28:37'),
(34, NULL, 'Mariana', 'Caporossi', '0140306803644352387735', '2024-09-10 19:40:13', '2024-09-10 19:40:13'),
(35, NULL, 'Clara', 'Bormape', NULL, '2024-09-12 19:36:05', '2024-09-12 19:36:05'),
(39, NULL, 'Agustina', 'Caballero', '0140000703100090261938', '2024-09-13 23:02:18', '2024-09-13 23:02:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('5w4NR8HQzAFP3NMAp4oO544hj2jliZ2wbuUX7ClR', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoid1VGOGxDOGREYzl4OFlOMTl4M25WQmg5UDVueEZZR0xpT25hTW5BVCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1726334976),
('owpQtyc30HXm4zdhUSsuAmyxv2cJoFICck5jbwJg', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaGttdjdHMHY1NEFPN0oyUFpnenVTZVhVeUxUaW5LaDBuUEkxTDRzWSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcnRpY3Vsby9saXN0YXIvdGFsbGVzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1726356048),
('rXl1zMutQmE9LZ8bAxAyypFQKpGLGsahFDPBJ0dp', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUGJacHFWVGFQMllhdmUxeU5wNzc4M2RVQWptWTZjMGVsNElxS3BwayI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcnRpY3Vsby9saXN0YXIvdGFsbGVzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1726340865),
('uzpsVmqhUdTzSlYSve5YVCuVpkIgwzHgHxXjwVNF', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQnNLY0lVNm0wd2drNWtDSUp3V01IZjI1VGtzajJkcVhuZzAyemZkMCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1726334976);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `talles`
--

CREATE TABLE `talles` (
  `id` int(11) NOT NULL,
  `articulo_id` bigint(20) UNSIGNED DEFAULT NULL,
  `talle` int(11) NOT NULL,
  `marron` int(11) DEFAULT 0,
  `negro` int(11) DEFAULT 0,
  `verde` int(11) DEFAULT 0,
  `azul` int(11) DEFAULT 0,
  `celeste` int(11) DEFAULT 0,
  `blancobeige` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `talles`
--

INSERT INTO `talles` (`id`, `articulo_id`, `talle`, `marron`, `negro`, `verde`, `azul`, `celeste`, `blancobeige`) VALUES
(1, 1, 32, 2, 0, 1, 1, 0, 0),
(2, 1, 34, 1, 2, 2, 0, 0, 0),
(3, 1, 36, 2, 2, 1, 0, 0, 0),
(4, 1, 38, 2, 1, 2, 0, 0, 0),
(5, 1, 40, 2, 0, 1, 1, 0, 0),
(6, 1, 42, 1, 0, 1, 1, 0, 0),
(7, 1, 44, 1, 1, 1, 1, 0, 0),
(8, 2, 36, 6, 1, 2, 0, 0, 0),
(9, 2, 38, 0, 2, 3, 2, 0, 0),
(10, 2, 40, 4, 1, 2, 1, 0, 0),
(11, 2, 42, 3, 2, 3, 1, 0, 0),
(12, 2, 44, 4, 2, 4, 2, 0, 0),
(13, 2, 46, 3, 2, 4, 1, 0, 0),
(14, 2, 48, 4, 3, 2, 0, 0, 0),
(15, 2, 50, 3, 2, 0, 3, 0, 0),
(16, 2, 52, 3, 1, 1, 1, 0, 0),
(17, 2, 54, 3, 0, 2, 1, 0, 0),
(18, 3, 36, 0, 2, 2, 0, 1, 0),
(19, 3, 38, 1, 2, 1, 2, 2, 1),
(20, 3, 40, 1, 1, 2, 2, 2, 0),
(21, 3, 42, 2, 2, 2, 1, 2, 1),
(22, 3, 44, 2, 2, 2, 2, 2, 2),
(23, 3, 46, 2, 2, 2, 2, 2, 2),
(24, 3, 48, 2, 2, 2, 2, 2, 2),
(25, 3, 50, 1, 1, 2, 2, 0, 1),
(26, 3, 52, 1, 1, 1, 1, 2, 1),
(27, 3, 54, 1, 1, 1, 2, 0, 1),
(28, 6, 0, 2, 1, 1, 0, 0, 0),
(29, 6, 2, 0, 1, 1, 1, 0, 0),
(30, 6, 4, 2, 1, 2, 1, 0, 0),
(31, 6, 6, 2, 1, 2, 1, 0, 0),
(32, 6, 8, 2, 1, 2, 1, 0, 0),
(33, 7, 10, 2, 1, 2, 1, 0, 0),
(34, 7, 12, 2, 1, 1, 1, 0, 0),
(35, 7, 14, 2, 1, 2, 1, 0, 0),
(36, 7, 16, 2, 1, 2, 0, 0, 0),
(47, 11, 36, 2, 1, 3, 3, 0, 2),
(48, 11, 38, 3, 1, 3, 3, 0, 0),
(49, 11, 40, 3, 1, 2, 1, 0, 0),
(50, 11, 42, 3, 2, 3, 2, 0, 0),
(51, 11, 46, 3, 2, 3, 3, 0, 0),
(52, 11, 44, 3, 2, 3, 3, 0, 0),
(53, 1, 50, 0, 0, 0, 0, 0, 0),
(54, 8, 52, 0, 0, 0, 0, 0, 0),
(55, 8, 50, 0, 0, 0, 0, 0, 0),
(56, 4, 40, 1, 0, 1, 0, 0, 0),
(57, 4, 42, 1, 0, 1, 0, 0, 0),
(58, 4, 44, 2, 0, 0, 0, 0, 0),
(59, 4, 46, 1, 0, 1, 0, 0, 0),
(60, 4, 48, 1, 0, 1, 0, 0, 0),
(61, 4, 50, 1, 0, 1, 0, 0, 0),
(62, 4, 52, 1, 0, 1, 0, 0, 0),
(63, 5, 40, 1, 0, 1, 0, 0, 0),
(64, 5, 42, 1, 0, 1, 0, 0, 0),
(65, 5, 44, 1, 0, 1, 0, 0, 0),
(66, 5, 46, 1, 0, 1, 0, 0, 0),
(67, 5, 48, 2, 0, 0, 0, 0, 0),
(68, 5, 50, 2, 0, 0, 0, 0, 0),
(69, 5, 52, 2, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `articulo_id` bigint(20) UNSIGNED NOT NULL,
  `talle` int(11) NOT NULL,
  `color` varchar(50) NOT NULL,
  `cliente_id` bigint(20) UNSIGNED DEFAULT NULL,
  `fecha` date NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `forma_pago` enum('efectivo','transferencia') NOT NULL,
  `costo_original` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id`, `articulo_id`, `talle`, `color`, `cliente_id`, `fecha`, `precio`, `forma_pago`, `costo_original`, `created_at`, `updated_at`) VALUES
(6, 2, 42, 'azul', 15, '2024-08-25', 25000.00, 'efectivo', 13765.00, '2024-09-08 18:53:37', '2024-09-09 07:12:33'),
(7, 2, 44, 'marron', 16, '2024-08-26', 25000.00, 'transferencia', 13765.00, '2024-09-08 19:28:31', '2024-09-09 07:01:14'),
(8, 1, 42, 'negro', 17, '2024-08-31', 25000.00, 'transferencia', 13765.00, '2024-09-08 19:35:58', '2024-09-08 19:35:58'),
(9, 3, 42, 'azul', 17, '2024-08-31', 27000.00, 'transferencia', 15507.00, '2024-09-08 19:35:58', '2024-09-08 19:35:58'),
(10, 2, 46, 'azul', 18, '2024-08-29', 25000.00, 'transferencia', 13765.00, '2024-09-08 19:38:30', '2024-09-08 19:38:30'),
(11, 2, 42, 'marron', 19, '2024-08-30', 25000.00, 'transferencia', 13765.00, '2024-09-08 19:40:40', '2024-09-08 19:40:40'),
(12, 2, 42, 'verde', 19, '2024-08-30', 25000.00, 'transferencia', 13765.00, '2024-09-08 19:40:40', '2024-09-08 19:40:40'),
(13, 1, 38, 'azul', 20, '2024-08-17', 18000.00, 'transferencia', 13765.00, '2024-09-08 19:43:13', '2024-09-08 19:43:19'),
(14, 2, 46, 'marron', 21, '2024-09-02', 25000.00, 'transferencia', 13765.00, '2024-09-08 19:44:42', '2024-09-08 19:44:42'),
(15, 3, 36, 'azul', 22, '2024-09-02', 27000.00, 'transferencia', 15507.00, '2024-09-08 19:48:13', '2024-09-08 19:48:13'),
(16, 1, 34, 'marron', 23, '2024-09-03', 25000.00, 'transferencia', 13765.00, '2024-09-08 19:49:34', '2024-09-08 19:49:34'),
(17, 1, 36, 'marron', 24, '2024-09-04', 25000.00, 'efectivo', 13765.00, '2024-09-08 19:57:28', '2024-09-08 19:57:28'),
(18, 1, 40, 'negro', 25, '2024-09-04', 25000.00, 'transferencia', 13765.00, '2024-09-08 20:01:16', '2024-09-08 20:01:16'),
(19, 1, 50, 'negro', 25, '2024-09-04', 25000.00, 'transferencia', 13765.00, '2024-09-08 20:01:16', '2024-09-08 20:01:16'),
(20, 3, 40, 'marron', 26, '2024-09-09', 27000.00, 'transferencia', 15507.00, '2024-09-09 17:42:53', '2024-09-09 17:42:53'),
(21, 3, 40, 'negro', 26, '2024-09-09', 27000.00, 'transferencia', 15507.00, '2024-09-09 17:42:53', '2024-09-09 17:42:53'),
(22, 2, 46, 'azul', 27, '2024-09-09', 25000.00, 'transferencia', 13765.00, '2024-09-10 00:41:57', '2024-09-10 00:41:57'),
(23, 8, 52, 'azul', 28, '2024-09-09', 44000.00, 'transferencia', 31060.00, '2024-09-10 01:08:40', '2024-09-10 21:49:49'),
(24, 8, 50, 'marron', 28, '2024-09-09', 44000.00, 'transferencia', 31060.00, '2024-09-10 01:08:40', '2024-09-10 21:49:55'),
(25, 1, 36, 'verde', 29, '2024-09-10', 25000.00, 'transferencia', 13765.00, '2024-09-10 18:29:44', '2024-09-13 21:26:37'),
(28, 6, 2, 'marron', 34, '2024-09-10', 20000.00, 'transferencia', 10785.00, '2024-09-10 19:40:13', '2024-09-10 19:40:13'),
(29, 7, 12, 'verde', 34, '2024-09-10', 20000.00, 'transferencia', 10965.00, '2024-09-10 19:40:13', '2024-09-10 19:40:13'),
(30, 3, 38, 'verde', 35, '2024-09-12', 27000.00, 'efectivo', 15507.00, '2024-09-12 19:36:05', '2024-09-12 19:36:28'),
(34, 7, 16, 'azul', 39, '2024-09-13', 20000.00, 'transferencia', 10965.00, '2024-09-13 23:02:18', '2024-09-13 23:03:16');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `articulos`
--
ALTER TABLE `articulos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero` (`numero`);

--
-- Indices de la tabla `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indices de la tabla `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indices de la tabla `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indices de la tabla `talles`
--
ALTER TABLE `talles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `talles_ibfk_1` (`articulo_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `articulo_id` (`articulo_id`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `articulos`
--
ALTER TABLE `articulos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `talles`
--
ALTER TABLE `talles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `talles`
--
ALTER TABLE `talles`
  ADD CONSTRAINT `talles_ibfk_1` FOREIGN KEY (`articulo_id`) REFERENCES `articulos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`articulo_id`) REFERENCES `articulos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
