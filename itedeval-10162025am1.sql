-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 16, 2025 at 03:51 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `itedeval`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('admin@gmial.com|127.0.0.1', 'i:1;', 1759806427),
('admin@gmial.com|127.0.0.1:timer', 'i:1759806427;', 1759806427),
('carpio.melv@marsu.edu.ph|127.0.0.1', 'i:1;', 1759826239),
('carpio.melv@marsu.edu.ph|127.0.0.1:timer', 'i:1759826239;', 1759826239),
('isprogramhead@gmail.com|127.0.0.1', 'i:3;', 1760511789),
('isprogramhead@gmail.com|127.0.0.1:timer', 'i:1760511789;', 1760511789);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colleges`
--

CREATE TABLE `colleges` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `acronym` char(20) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `colleges`
--

INSERT INTO `colleges` (`id`, `name`, `acronym`, `status`, `created_at`, `updated_at`) VALUES
(1, 'College of Allied Health Sciences', 'CAHS', 1, '2024-11-23 17:35:29', NULL),
(2, 'College of Arts and Social Science', 'CASS', 1, '2024-11-23 17:35:29', NULL),
(3, 'College of Business and Accountancy', 'CBA', 1, '2023-02-04 10:53:14', '2024-11-07 04:25:32'),
(4, 'College of Criminal Justice Education', 'CCJE', 1, '2025-04-01 18:30:30', '2025-04-01 18:32:46'),
(5, 'College of Education', 'COED', 1, '2023-02-04 10:46:57', '2024-11-07 04:26:21'),
(6, 'College of Engineering ', 'CENG', 1, '2024-11-23 17:35:29', NULL),
(7, 'College of Environmental Studies', 'CES', 1, '2024-11-23 17:35:29', NULL),
(8, 'College of Governance', 'CGOV', 1, '2024-11-23 17:35:29', NULL),
(9, 'College of Industrial Technology', 'CIT', 1, '2024-11-23 17:35:29', NULL),
(10, 'College of Information and Computing Sciences', 'CICS', 1, '2024-11-23 17:35:29', '2025-04-01 17:58:28');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `college_id` int(11) NOT NULL,
  `course_name` varchar(200) NOT NULL,
  `course_code` char(20) NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `college_id`, `course_name`, `course_code`, `status`, `created_at`, `updated_at`) VALUES
(1, 10, 'Bachelor of Science in Information Technology', 'BSI/T', 'active', '2025-08-26 03:28:48', '2025-08-26 03:41:23'),
(2, 10, 'Bachelor of Science in Information System', 'BSIS', 'active', '2025-08-26 03:31:03', '2025-08-26 03:41:32');

-- --------------------------------------------------------

--
-- Table structure for table `course_majors`
--

CREATE TABLE `course_majors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `course_id` int(11) NOT NULL,
  `course_major` varchar(150) NOT NULL,
  `year_level` enum('first','second','third','fourth') DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `course_majors`
--

INSERT INTO `course_majors` (`id`, `course_id`, `course_major`, `year_level`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'Networking', 'third', 'active', '2025-08-27 04:03:18', '2025-08-27 05:29:11'),
(2, 2, 'Software Development', 'third', 'active', '2025-08-27 05:10:49', '2025-09-12 01:17:39');

-- --------------------------------------------------------

--
-- Table structure for table `course_outcomes`
--

CREATE TABLE `course_outcomes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `subject_id` int(11) NOT NULL,
  `version` tinyint(4) NOT NULL,
  `order_no` smallint(6) NOT NULL DEFAULT 1,
  `course_outcome` text NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `course_outcomes`
--

INSERT INTO `course_outcomes` (`id`, `subject_id`, `version`, `order_no`, `course_outcome`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 'Identified the importance of collecting information on the history of arts as well as applied the knowledge on newfound art movements', 'active', '2025-09-22 09:21:42', '2025-09-22 09:21:42'),
(2, 1, 1, 2, 'Understanding of the history and theory of digital arts, including key movements, figures, and technologies', 'active', '2025-09-22 09:22:05', '2025-09-22 09:22:05'),
(3, 1, 1, 3, 'Ability to create digital illustrations, graphics, and layouts using industry-standard software', 'active', '2025-09-22 09:22:56', '2025-09-22 09:22:56'),
(4, 1, 1, 4, 'Development of a personal artistic style and the ability to express ideas creatively through digital mediums.', 'active', '2025-09-22 09:23:11', '2025-09-22 09:23:11'),
(5, 1, 1, 5, 'Ability to learn and adapt to emerging digital tools and technologies.', 'active', '2025-09-22 09:23:56', '2025-09-22 09:23:56'),
(6, 1, 1, 6, 'Understanding of ethical issues in digital arts, including copyright, intellectual property, and responsible use of digital media', 'active', '2025-09-22 09:24:09', '2025-09-22 09:24:09'),
(7, 2, 1, 1, 'Identify the different possibilities of being in the field of Information Technology to know the intended paths.', 'active', '2025-09-22 09:24:49', '2025-09-22 09:24:49'),
(8, 2, 1, 2, 'Analyzed different solutions and applied an effective one to each problems encountered related to the program and beyond.', 'active', '2025-09-22 09:25:07', '2025-09-22 09:25:07'),
(9, 2, 1, 3, 'Familiarized with computers, including its internal and external parts, as well as their capabilities and limitations in every field possible.', 'active', '2025-09-22 09:25:20', '2025-09-22 09:25:20'),
(10, 3, 1, 1, 'Demonstrate logical and critical thinking', 'active', '2025-09-22 09:44:23', '2025-09-22 09:44:23'),
(11, 3, 1, 2, 'Recognize that logic can be applied and must be applied to every aspect and every element of human knowledge and human experience.', 'active', '2025-09-22 09:46:17', '2025-09-22 09:46:17'),
(12, 3, 1, 3, 'Illustrate their developed skills of reasoning in accordance with truth in both oral and written.', 'active', '2025-09-22 09:46:38', '2025-09-22 09:46:38'),
(13, 3, 1, 4, 'Develop decision making ability based on logical reasoning, which is crucial pre- requisite for successful professionals in the future.', 'active', '2025-09-22 09:46:57', '2025-09-22 09:46:57'),
(14, 26, 1, 1, 'Discuss the nature of Information Strategic Management and Acquisition.', 'active', '2025-10-07 23:34:49', '2025-10-15 05:44:44'),
(15, 26, 1, 2, 'Understand the establishment of the Information Strategic Management and Acquisition Business Terms of Reference.', 'active', '2025-10-08 00:31:38', '2025-10-15 05:45:07'),
(16, 26, 1, 3, 'Formulate the Information Strategic Management and Acquisition Strategies.', 'active', '2025-10-15 05:43:58', '2025-10-15 05:43:58'),
(17, 26, 1, 4, 'Frame the Information Management and Acquisition Investment Program.', 'active', '2025-10-15 05:45:24', '2025-10-15 05:45:24'),
(18, 25, 1, 1, 'Explain why important for IT professionals to keep abreast of evolving technologies.', 'active', '2025-10-15 06:03:29', '2025-10-15 06:03:29'),
(19, 25, 1, 2, 'Explain how innovation happens and new technology emerge.', 'active', '2025-10-15 06:03:42', '2025-10-15 06:03:42'),
(20, 25, 1, 3, 'Discuss the advantages, disadvantages, and prospects of some special topic in IT or current emerging technologies.', 'active', '2025-10-15 06:03:58', '2025-10-15 06:03:58'),
(21, 25, 1, 4, 'Demonstrate the research skills to identify and evaluate emerging technologies.', 'active', '2025-10-15 06:04:12', '2025-10-15 06:04:12'),
(22, 25, 1, 5, 'Discuss in depth a chosen special IT topic, based on independent research, learning experiences from attended both local and/or international IT-related seminars and/or conference/webinars/symposia/conventions.', 'active', '2025-10-15 06:04:38', '2025-10-15 06:04:38'),
(23, 27, 1, 1, 'Understand the meaning and scope of IT Audit and Control.', 'active', '2025-10-15 06:11:52', '2025-10-15 06:11:52'),
(24, 27, 1, 2, 'Learn the standard foundation of IT Audit and Control.', 'active', '2025-10-15 06:12:11', '2025-10-15 06:12:11'),
(25, 27, 1, 3, 'Frame and IT Audit and Control Methodology.', 'active', '2025-10-15 06:12:35', '2025-10-15 06:12:35'),
(26, 27, 1, 4, 'Establish baseline standards to pursue the IT Audit and Control process.', 'active', '2025-10-15 06:12:48', '2025-10-15 06:12:48'),
(27, 27, 1, 5, 'Learn the IT Audit and Control documentation and reporting process.', 'active', '2025-10-15 06:13:02', '2025-10-15 06:13:02');

-- --------------------------------------------------------

--
-- Table structure for table `curricula`
--

CREATE TABLE `curricula` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `course_id` int(11) NOT NULL,
  `curr_name` varchar(200) DEFAULT NULL,
  `curr_detail` text NOT NULL,
  `curr_stat` enum('active','inactive') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `curricula`
--

INSERT INTO `curricula` (`id`, `course_id`, `curr_name`, `curr_detail`, `curr_stat`, `created_at`, `updated_at`) VALUES
(1, 2, 'BSIS 2023-2024 Curriculum', 'per CHED Memorandum Order No. 25 series 2015, Approved by MSC Board of Trustees Resolution No. 22, series 2023, Effective First Semester Academic Year 2023-2024', 'active', '2025-09-14 03:51:28', '2025-10-07 09:49:42'),
(2, 1, 'BSI/T Curriculum 2018', 'per CHED Memorandum Order No. 25 series 2015, Approved by MSC Board of Trustees Resolution No. 20, series 2020, Effective First Semester Academic Year 2018-2019', 'active', '2025-10-07 03:07:28', '2025-10-07 03:07:28');

-- --------------------------------------------------------

--
-- Table structure for table `enrolled_subjects`
--

CREATE TABLE `enrolled_subjects` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `enrollment_id` int(11) NOT NULL,
  `faculty_subject_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `enrolled_subjects`
--

INSERT INTO `enrolled_subjects` (`id`, `enrollment_id`, `faculty_subject_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(2, 2, 1, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(3, 3, 1, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(4, 4, 1, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(5, 5, 1, '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(6, 6, 1, '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(7, 7, 1, '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(8, 8, 1, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(9, 9, 1, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(10, 10, 1, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(11, 11, 1, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(12, 12, 1, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(13, 13, 1, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(14, 14, 1, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(15, 15, 1, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(16, 16, 1, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(17, 17, 1, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(18, 18, 1, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(19, 19, 1, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(20, 20, 1, '2025-10-07 10:55:31', '2025-10-07 10:55:31'),
(21, 21, 3, '2025-10-07 10:56:02', '2025-10-07 10:56:02'),
(22, 22, 3, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(23, 23, 3, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(24, 24, 3, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(25, 25, 3, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(26, 26, 3, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(27, 27, 3, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(28, 28, 3, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(29, 29, 3, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(30, 30, 3, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(31, 31, 3, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(32, 32, 3, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(33, 33, 3, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(34, 34, 3, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(35, 35, 3, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(36, 36, 3, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(37, 37, 3, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(38, 38, 3, '2025-10-07 10:56:07', '2025-10-07 10:56:07'),
(39, 39, 3, '2025-10-07 10:56:07', '2025-10-07 10:56:07'),
(40, 40, 2, '2025-10-07 10:56:49', '2025-10-07 10:56:49'),
(41, 41, 2, '2025-10-07 10:56:49', '2025-10-07 10:56:49'),
(42, 42, 2, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(43, 43, 2, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(44, 44, 2, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(45, 45, 2, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(46, 46, 2, '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(47, 47, 2, '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(48, 48, 2, '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(49, 49, 2, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(50, 50, 2, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(51, 51, 2, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(52, 52, 2, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(53, 53, 2, '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(54, 54, 2, '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(55, 55, 2, '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(56, 1, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(57, 2, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(58, 56, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(59, 3, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(60, 4, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(61, 5, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(62, 6, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(63, 7, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(64, 8, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(65, 9, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(66, 10, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(67, 11, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(68, 12, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(69, 13, 4, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(70, 57, 4, '2025-10-07 10:58:59', '2025-10-07 10:58:59'),
(71, 14, 4, '2025-10-07 10:58:59', '2025-10-07 10:58:59'),
(72, 15, 4, '2025-10-07 10:58:59', '2025-10-07 10:58:59'),
(73, 16, 4, '2025-10-07 10:58:59', '2025-10-07 10:58:59'),
(74, 18, 4, '2025-10-07 10:58:59', '2025-10-07 10:58:59'),
(75, 19, 4, '2025-10-07 10:58:59', '2025-10-07 10:58:59'),
(76, 20, 4, '2025-10-07 10:58:59', '2025-10-07 10:58:59'),
(77, 21, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(78, 22, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(79, 23, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(80, 24, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(81, 25, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(82, 26, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(83, 27, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(84, 28, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(85, 29, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(86, 30, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(87, 31, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(88, 32, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(89, 33, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(90, 34, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(91, 35, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(92, 36, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(93, 37, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(94, 38, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(95, 39, 5, '2025-10-07 11:01:13', '2025-10-07 11:01:13'),
(96, 58, 5, '2025-10-07 11:01:21', '2025-10-07 11:01:21'),
(97, 59, 5, '2025-10-07 11:01:21', '2025-10-07 11:01:21'),
(98, 60, 5, '2025-10-07 11:01:21', '2025-10-07 11:01:21'),
(99, 61, 5, '2025-10-07 11:01:21', '2025-10-07 11:01:21'),
(100, 62, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(101, 63, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(102, 64, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(103, 65, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(104, 66, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(105, 67, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(106, 68, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(107, 69, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(108, 70, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(109, 71, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(110, 72, 5, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(111, 73, 5, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(112, 74, 5, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(113, 75, 5, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(114, 76, 5, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(115, 77, 5, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(116, 1, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(117, 2, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(118, 3, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(119, 4, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(120, 5, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(121, 6, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(122, 7, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(123, 8, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(124, 9, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(125, 10, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(126, 11, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(127, 12, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(128, 13, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(129, 57, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(130, 14, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(131, 15, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(132, 16, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(133, 17, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(134, 18, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(135, 19, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(136, 20, 7, '2025-10-07 11:02:38', '2025-10-07 11:02:38'),
(137, 21, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(138, 22, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(139, 23, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(140, 24, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(141, 25, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(142, 26, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(143, 78, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(144, 27, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(145, 28, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(146, 29, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(147, 30, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(148, 31, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(149, 79, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(150, 32, 8, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(151, 80, 8, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(152, 33, 8, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(153, 34, 8, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(154, 35, 8, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(155, 36, 8, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(156, 37, 8, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(157, 38, 8, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(158, 39, 8, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(159, 81, 8, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(160, 40, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(161, 41, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(162, 42, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(163, 43, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(164, 82, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(165, 83, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(166, 44, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(167, 84, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(168, 45, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(169, 46, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(170, 47, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(171, 49, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(172, 85, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(173, 50, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(174, 51, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(175, 86, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(176, 52, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(177, 53, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(178, 54, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(179, 55, 9, '2025-10-07 11:03:07', '2025-10-07 11:03:07');

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` int(11) NOT NULL,
  `semester_id` int(11) NOT NULL,
  `year_level` enum('first','second','third','fourth') NOT NULL,
  `section` char(10) NOT NULL,
  `course_major_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`id`, `student_id`, `semester_id`, `year_level`, `section`, `course_major_id`, `created_at`, `updated_at`) VALUES
(1, 1, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(2, 2, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(3, 3, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(4, 4, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(5, 5, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(6, 6, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(7, 7, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(8, 8, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(9, 9, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(10, 10, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(11, 11, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(12, 12, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(13, 13, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(14, 14, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(15, 15, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(16, 16, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(17, 17, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(18, 18, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(19, 19, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(20, 20, 3, 'fourth', '4A', NULL, '2025-10-07 10:55:31', '2025-10-07 10:55:31'),
(21, 21, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:02', '2025-10-07 10:56:02'),
(22, 22, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(23, 23, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(24, 24, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(25, 25, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(26, 26, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(27, 27, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(28, 28, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(29, 29, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(30, 30, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(31, 31, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(32, 32, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(33, 33, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(34, 34, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(35, 35, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(36, 36, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(37, 37, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(38, 38, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:07', '2025-10-07 10:56:07'),
(39, 39, 3, 'fourth', '4B', NULL, '2025-10-07 10:56:07', '2025-10-07 10:56:07'),
(40, 40, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:49', '2025-10-07 10:56:49'),
(41, 41, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:49', '2025-10-07 10:56:49'),
(42, 42, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(43, 43, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(44, 44, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(45, 45, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(46, 46, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(47, 47, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(48, 48, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(49, 49, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(50, 50, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(51, 51, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(52, 52, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(53, 53, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(54, 54, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(55, 55, 3, 'fourth', '4C', NULL, '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(56, 56, 3, 'fourth', '4A', NULL, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(57, 57, 3, 'fourth', '4A', NULL, '2025-10-07 10:58:59', '2025-10-07 10:58:59'),
(58, 40, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:21', '2025-10-07 11:01:21'),
(59, 41, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:21', '2025-10-07 11:01:21'),
(60, 42, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:21', '2025-10-07 11:01:21'),
(61, 43, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:21', '2025-10-07 11:01:21'),
(62, 58, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(63, 59, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(64, 44, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(65, 60, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(66, 45, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(67, 46, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(68, 47, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(69, 49, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(70, 61, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(71, 50, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(72, 51, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(73, 62, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(74, 52, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(75, 53, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(76, 54, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(77, 55, 3, 'fourth', '4B', NULL, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(78, 56, 3, 'fourth', '4B', NULL, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(79, 63, 3, 'fourth', '4B', NULL, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(80, 64, 3, 'fourth', '4B', NULL, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(81, 65, 3, 'fourth', '4B', NULL, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(82, 58, 3, 'fourth', '4C', NULL, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(83, 59, 3, 'fourth', '4C', NULL, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(84, 60, 3, 'fourth', '4C', NULL, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(85, 61, 3, 'fourth', '4C', NULL, '2025-10-07 11:03:07', '2025-10-07 11:03:07'),
(86, 62, 3, 'fourth', '4C', NULL, '2025-10-07 11:03:07', '2025-10-07 11:03:07');

-- --------------------------------------------------------

--
-- Table structure for table `evaluations`
--

CREATE TABLE `evaluations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `semester_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `course_outcome_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `enrolled_subject_id` int(11) NOT NULL,
  `rating_setting_id` int(11) NOT NULL,
  `rating` float NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `evaluation_comments`
--

CREATE TABLE `evaluation_comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `semester_id` bigint(20) UNSIGNED NOT NULL,
  `subject_id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `enrolled_subject_id` bigint(20) UNSIGNED NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `evaluation_schedules`
--

CREATE TABLE `evaluation_schedules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `semester_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `evaluation_schedules`
--

INSERT INTO `evaluation_schedules` (`id`, `semester_id`, `course_id`, `start_date`, `end_date`, `created_at`, `updated_at`) VALUES
(1, 3, 2, '2025-10-13', '2025-10-17', '2025-10-15 10:53:11', '2025-10-15 11:30:22');

-- --------------------------------------------------------

--
-- Table structure for table `faculties`
--

CREATE TABLE `faculties` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `college_id` int(11) NOT NULL,
  `semester_id` int(11) NOT NULL,
  `designation` enum('dean','faculty','program-head') NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `faculties`
--

INSERT INTO `faculties` (`id`, `user_id`, `college_id`, `semester_id`, `designation`, `course_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 10, 3, 'dean', NULL, 'active', '2025-09-11 12:54:24', '2025-09-11 12:54:24'),
(2, 3, 10, 3, 'program-head', 2, 'active', '2025-09-11 12:56:39', '2025-09-11 12:56:39'),
(3, 4, 10, 3, 'faculty', 2, 'active', '2025-09-11 12:59:11', '2025-09-11 12:59:11'),
(4, 5, 10, 3, 'faculty', 2, 'active', '2025-09-12 05:38:13', '2025-09-12 05:38:13'),
(5, 6, 10, 3, 'faculty', 2, 'active', '2025-09-12 08:31:23', '2025-09-15 11:13:57'),
(6, 7, 10, 3, 'faculty', 2, 'active', '2025-10-07 09:42:42', '2025-10-07 09:42:42');

-- --------------------------------------------------------

--
-- Table structure for table `faculty_subjects`
--

CREATE TABLE `faculty_subjects` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `faculty_id` int(11) NOT NULL,
  `semester_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `section` char(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `faculty_subjects`
--

INSERT INTO `faculty_subjects` (`id`, `faculty_id`, `semester_id`, `subject_id`, `section`, `created_at`, `updated_at`) VALUES
(1, 3, 3, 25, '4A', '2025-10-07 09:53:48', '2025-10-07 09:53:48'),
(2, 4, 3, 25, '4C', '2025-10-07 09:54:33', '2025-10-07 09:54:33'),
(3, 5, 3, 25, '4B', '2025-10-07 09:55:01', '2025-10-07 09:55:01'),
(4, 5, 3, 26, '4A', '2025-10-07 09:55:22', '2025-10-07 09:55:22'),
(5, 5, 3, 26, '4B', '2025-10-07 09:55:32', '2025-10-07 09:55:32'),
(6, 5, 3, 26, '4C', '2025-10-07 09:59:24', '2025-10-07 09:59:24'),
(7, 6, 3, 27, '4A', '2025-10-07 09:59:55', '2025-10-07 09:59:55'),
(8, 6, 3, 27, '4B', '2025-10-07 10:00:02', '2025-10-07 10:00:02'),
(9, 6, 3, 27, '4C', '2025-10-07 10:00:09', '2025-10-07 10:02:00');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
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
-- Table structure for table `jobs`
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
-- Table structure for table `job_batches`
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
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_08_11_214238_create_scales_table', 2),
(5, '2025_08_11_224758_create_courses_table', 2),
(6, '2025_08_11_224803_create_course_majors_table', 2),
(7, '2025_08_11_224808_create_program_outcomes_table', 2),
(8, '2025_08_11_224814_create_colleges_table', 2),
(9, '2025_08_11_224821_create_subjects_table', 2),
(10, '2025_08_11_225249_create_semesters_table', 2),
(11, '2025_08_13_215924_create_enrollments_table', 2),
(12, '2025_08_14_202027_create_students_table', 2),
(13, '2025_08_14_213836_create_enrolled_subjects_table', 2),
(14, '2025_08_14_221612_create_course_outcomes_table', 2),
(15, '2025_08_14_223925_create_faculties_table', 2),
(16, '2025_08_22_153021_create_rating_settings_table', 3),
(17, '2025_08_22_153512_create_evaluations_table', 3),
(18, '2025_08_27_162844_create_outcome_links_table', 3),
(19, '2025_08_30_195141_create_faculty_subjects_table', 4),
(20, '2025_09_13_172009_create_curricula_table', 5),
(21, '2025_10_05_100912_create_settings_table', 6),
(22, '2025_10_15_155436_create_evaluation_schedules_table', 7),
(23, '2025_10_16_072100_create_evaluation_comments_table', 8);

-- --------------------------------------------------------

--
-- Table structure for table `outcome_links`
--

CREATE TABLE `outcome_links` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `course_outcome_id` int(11) NOT NULL,
  `program_outcome_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `outcome_links`
--

INSERT INTO `outcome_links` (`id`, `course_outcome_id`, `program_outcome_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2025-09-22 09:21:42', '2025-09-22 09:21:42'),
(2, 2, 1, '2025-09-22 09:22:05', '2025-09-22 09:22:05'),
(3, 2, 9, '2025-09-22 09:22:05', '2025-09-22 09:22:05'),
(4, 3, 1, '2025-09-22 09:22:56', '2025-09-22 09:22:56'),
(5, 3, 6, '2025-09-22 09:22:56', '2025-09-22 09:22:56'),
(6, 4, 1, '2025-09-22 09:23:11', '2025-09-22 09:23:11'),
(7, 5, 1, '2025-09-22 09:23:56', '2025-09-22 09:23:56'),
(8, 5, 3, '2025-09-22 09:23:56', '2025-09-22 09:23:56'),
(9, 5, 6, '2025-09-22 09:23:56', '2025-09-22 09:23:56'),
(10, 6, 1, '2025-09-22 09:24:09', '2025-09-22 09:24:09'),
(11, 6, 9, '2025-09-22 09:24:09', '2025-09-22 09:24:09'),
(12, 7, 1, '2025-09-22 09:24:49', '2025-09-22 09:24:49'),
(13, 7, 6, '2025-09-22 09:24:49', '2025-09-22 09:24:49'),
(14, 8, 1, '2025-09-22 09:25:07', '2025-09-22 09:25:07'),
(15, 8, 6, '2025-09-22 09:25:07', '2025-09-22 09:25:07'),
(16, 8, 9, '2025-09-22 09:25:07', '2025-09-22 09:25:07'),
(17, 9, 1, '2025-09-22 09:25:20', '2025-09-22 09:25:20'),
(18, 10, 1, '2025-09-22 09:44:23', '2025-09-22 09:44:23'),
(19, 10, 3, '2025-09-22 09:44:23', '2025-09-22 09:44:23'),
(20, 11, 1, '2025-09-22 09:46:17', '2025-09-22 09:46:17'),
(21, 11, 9, '2025-09-22 09:46:17', '2025-09-22 09:46:17'),
(22, 12, 2, '2025-09-22 09:46:38', '2025-09-22 09:46:38'),
(23, 12, 4, '2025-09-22 09:46:38', '2025-09-22 09:46:38'),
(24, 12, 7, '2025-09-22 09:46:38', '2025-09-22 09:46:38'),
(25, 12, 9, '2025-09-22 09:46:38', '2025-09-22 09:46:38'),
(26, 13, 1, '2025-09-22 09:46:57', '2025-09-22 09:46:57'),
(27, 13, 2, '2025-09-22 09:46:57', '2025-09-22 09:46:57'),
(28, 13, 3, '2025-09-22 09:46:57', '2025-09-22 09:46:57'),
(33, 16, 4, '2025-10-15 05:43:58', '2025-10-15 05:43:58'),
(34, 16, 6, '2025-10-15 05:43:58', '2025-10-15 05:43:58'),
(35, 14, 10, '2025-10-15 05:44:44', '2025-10-15 05:44:44'),
(36, 14, 1, '2025-10-15 05:44:44', '2025-10-15 05:44:44'),
(37, 15, 9, '2025-10-15 05:45:07', '2025-10-15 05:45:07'),
(38, 15, 5, '2025-10-15 05:45:07', '2025-10-15 05:45:07'),
(39, 17, 8, '2025-10-15 05:45:24', '2025-10-15 05:45:24'),
(40, 17, 9, '2025-10-15 05:45:24', '2025-10-15 05:45:24'),
(41, 18, 9, '2025-10-15 06:03:29', '2025-10-15 06:03:29'),
(42, 18, 10, '2025-10-15 06:03:29', '2025-10-15 06:03:29'),
(43, 19, 9, '2025-10-15 06:03:42', '2025-10-15 06:03:42'),
(44, 19, 10, '2025-10-15 06:03:42', '2025-10-15 06:03:42'),
(45, 20, 8, '2025-10-15 06:03:58', '2025-10-15 06:03:58'),
(46, 21, 9, '2025-10-15 06:04:12', '2025-10-15 06:04:12'),
(47, 21, 10, '2025-10-15 06:04:12', '2025-10-15 06:04:12'),
(48, 22, 8, '2025-10-15 06:04:38', '2025-10-15 06:04:38'),
(49, 23, 1, '2025-10-15 06:11:52', '2025-10-15 06:11:52'),
(50, 23, 3, '2025-10-15 06:11:52', '2025-10-15 06:11:52'),
(51, 23, 6, '2025-10-15 06:11:52', '2025-10-15 06:11:52'),
(52, 23, 9, '2025-10-15 06:11:52', '2025-10-15 06:11:52'),
(53, 24, 1, '2025-10-15 06:12:11', '2025-10-15 06:12:11'),
(54, 24, 3, '2025-10-15 06:12:11', '2025-10-15 06:12:11'),
(55, 24, 6, '2025-10-15 06:12:11', '2025-10-15 06:12:11'),
(56, 24, 9, '2025-10-15 06:12:11', '2025-10-15 06:12:11'),
(57, 25, 1, '2025-10-15 06:12:35', '2025-10-15 06:12:35'),
(58, 25, 3, '2025-10-15 06:12:35', '2025-10-15 06:12:35'),
(59, 25, 6, '2025-10-15 06:12:35', '2025-10-15 06:12:35'),
(60, 25, 9, '2025-10-15 06:12:35', '2025-10-15 06:12:35'),
(61, 26, 1, '2025-10-15 06:12:48', '2025-10-15 06:12:48'),
(62, 26, 3, '2025-10-15 06:12:48', '2025-10-15 06:12:48'),
(63, 26, 6, '2025-10-15 06:12:48', '2025-10-15 06:12:48'),
(64, 26, 9, '2025-10-15 06:12:48', '2025-10-15 06:12:48'),
(65, 27, 1, '2025-10-15 06:13:02', '2025-10-15 06:13:02'),
(66, 27, 3, '2025-10-15 06:13:02', '2025-10-15 06:13:02'),
(67, 27, 6, '2025-10-15 06:13:02', '2025-10-15 06:13:02'),
(68, 27, 9, '2025-10-15 06:13:02', '2025-10-15 06:13:02');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `program_outcomes`
--

CREATE TABLE `program_outcomes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `course_id` int(11) NOT NULL,
  `version` tinyint(4) NOT NULL,
  `po_code` char(10) NOT NULL,
  `po_description` text NOT NULL,
  `order_number` tinyint(4) NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `program_outcomes`
--

INSERT INTO `program_outcomes` (`id`, `course_id`, `version`, `po_code`, `po_description`, `order_number`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 'ISPO1', 'Apply knowledge of business processes, computing, mathematics and social sciences appropriate to Information Systems.', 1, 'active', '2025-09-12 01:58:02', '2025-10-08 00:09:25'),
(2, 2, 1, 'ISPO2', 'Analyze a problem, identify and define the computing requirements with respect to organizational factors appropriate to its solution and plan strategies for their solution.', 2, 'active', '2025-09-12 01:59:25', '2025-10-08 00:09:29'),
(3, 2, 1, 'ISPO3', 'Evaluate information systems in terms of general quality attributes and possible trade-off presented within the given requirement.', 3, 'active', '2025-09-12 02:00:31', '2025-10-08 00:09:34'),
(4, 2, 1, 'ISPO4', 'Design, implement, and evaluate information systems, processes, components, or programs; and to source cost-benefit efficient alternatives to meet desired needs, goals and constraints.', 4, 'active', '2025-09-12 02:12:16', '2025-10-08 00:09:39'),
(5, 2, 1, 'ISPO5', 'Use knowledge and understanding of enterprises in modelling and design of information systems.', 5, 'active', '2025-09-12 02:18:55', '2025-10-08 00:09:44'),
(6, 2, 1, 'ISPO6', 'Deploy and use effective skills, tools and techniques necessary for information systems practice.', 6, 'active', '2025-09-12 02:27:58', '2025-10-08 00:09:48'),
(7, 2, 1, 'ISPO7', 'Function effectively on teams to accomplish a common goal.', 7, 'active', '2025-09-12 02:28:06', '2025-10-08 00:09:55'),
(8, 2, 1, 'ISPO8', 'Communicate effectively with a range of audiences.', 8, 'active', '2025-09-12 02:28:15', '2025-10-08 00:09:59'),
(9, 2, 1, 'ISPO9', 'Recognize the legal, social, ethical and professional issues involved in the exploitation of computer technology and be guided by the adoption of appropriate professional, ethical and legal practices both in the local and global community.', 9, 'active', '2025-09-12 02:28:25', '2025-10-08 00:10:03'),
(10, 2, 1, 'ISPO10', 'Recognize the need for and engage in an independent and life-long learning, planning self-learning and improving performance as the foundation for on-going professional.', 10, 'active', '2025-09-12 02:28:34', '2025-10-08 00:10:07');

-- --------------------------------------------------------

--
-- Table structure for table `rating_settings`
--

CREATE TABLE `rating_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `semester_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `scale_version` tinyint(4) NOT NULL,
  `co_version` tinyint(4) NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rating_settings`
--

INSERT INTO `rating_settings` (`id`, `semester_id`, `subject_id`, `scale_version`, `co_version`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, 1, 1, 1, 'active', '2025-09-22 09:50:04', '2025-09-22 09:50:04'),
(2, 3, 2, 1, 1, 'active', '2025-09-22 09:50:10', '2025-09-22 09:50:10'),
(3, 3, 3, 1, 1, 'active', '2025-09-22 09:50:15', '2025-09-22 09:50:15'),
(4, 3, 26, 1, 1, 'active', '2025-10-15 05:46:04', '2025-10-15 05:46:04'),
(5, 3, 25, 1, 1, 'active', '2025-10-15 06:04:55', '2025-10-15 06:04:55'),
(6, 3, 27, 1, 1, 'active', '2025-10-15 06:13:25', '2025-10-15 06:13:25');

-- --------------------------------------------------------

--
-- Table structure for table `scales`
--

CREATE TABLE `scales` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `version` tinyint(4) NOT NULL,
  `rating` smallint(6) NOT NULL,
  `descriptive_rating` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `scales`
--

INSERT INTO `scales` (`id`, `version`, `rating`, `descriptive_rating`, `created_at`, `updated_at`) VALUES
(1, 1, 5, 'Very Satisfied', '2025-09-11 15:03:58', '2025-09-22 09:26:01'),
(2, 1, 4, 'Satisfied', '2025-09-11 15:09:05', '2025-09-22 09:26:08'),
(3, 1, 3, 'Neutral', '2025-09-11 15:09:17', '2025-09-22 09:26:16'),
(4, 1, 2, 'Dissatisfied', '2025-09-11 15:13:19', '2025-09-22 09:26:22'),
(5, 1, 1, 'Very Dissatisfied', '2025-09-11 15:13:28', '2025-09-22 09:26:39');

-- --------------------------------------------------------

--
-- Table structure for table `semesters`
--

CREATE TABLE `semesters` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sem` varchar(20) NOT NULL,
  `acad_year` varchar(20) NOT NULL,
  `order_num` tinyint(4) NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `semesters`
--

INSERT INTO `semesters` (`id`, `sem`, `acad_year`, `order_num`, `status`, `created_at`, `updated_at`) VALUES
(1, '1st', '2024-2025', 1, 'inactive', '2025-08-26 01:17:52', '2025-09-03 02:56:08'),
(2, '2nd', '2024-2025', 2, 'inactive', '2025-09-02 07:58:42', '2025-09-11 13:10:50'),
(3, '1st', '2025-2026', 3, 'active', '2025-09-11 13:10:50', '2025-09-12 01:06:28');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
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
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('HVjkRPnTp6iY8RxAizKiyqkcELERIjs7RWm2uosq', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiSXFjOTllT0pDcEwybmVybUVDZm84R3B4WEI2UFNPaDNFRUdLQTBFeiI7czozOiJ1cmwiO2E6MDp7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjQyOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvZXZhbHVhdGlvbi9jcmVhdGUvMTAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=', 1760579423),
('HXW2btwvPQT8gAGLHP8fNQ5MBrnYo1Uk1BNox5vk', 17, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTmtZVmN5NGRIb3UyQjI3UXRVR3JZd2NwdWpyV0FXbkc3MnVURFlLOCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTc7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9ldmFsdWF0aW9uL3Nob3cvMTAiO319', 1760579476);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `semester_id` int(11) NOT NULL,
  `type` char(50) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `curriculum_id` int(11) DEFAULT NULL,
  `version` tinyint(4) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `semester_id`, `type`, `course_id`, `curriculum_id`, `version`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 3, 'curriculum', 2, 1, NULL, NULL, 2, '2025-10-14 12:36:34', '2025-10-15 03:28:32'),
(2, 3, 'program-outcome', 2, NULL, 1, NULL, 2, '2025-10-14 12:36:34', '2025-10-15 03:28:26'),
(3, 3, 'curriculum', 1, 2, NULL, 2, 2, '2025-10-15 03:41:01', '2025-10-15 03:44:53');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `id_number` varchar(20) NOT NULL,
  `college_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `user_id`, `id_number`, `college_id`, `course_id`, `created_at`, `updated_at`) VALUES
(1, 8, '22B1116', 10, NULL, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(2, 9, '22B1972', 10, NULL, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(3, 10, '21B2478', 10, NULL, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(4, 11, '20B1936', 10, NULL, '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(5, 12, '19B1653', 10, NULL, '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(6, 13, '22B2050', 10, NULL, '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(7, 14, '22B2179', 10, NULL, '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(8, 15, '22B2109', 10, NULL, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(9, 16, '22B2410', 10, NULL, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(10, 17, '21B1034', 10, 2, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(11, 18, '22B2106', 10, NULL, '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(12, 19, '20B0062', 10, NULL, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(13, 20, '22B2364', 10, NULL, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(14, 21, '22B1963', 10, NULL, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(15, 22, '22B1113', 10, NULL, '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(16, 23, '22B1108', 10, NULL, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(17, 24, '22B2099', 10, NULL, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(18, 25, '22B2432', 10, NULL, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(19, 26, '22B1922', 10, NULL, '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(20, 27, '19B1178', 10, NULL, '2025-10-07 10:55:31', '2025-10-07 10:55:31'),
(21, 28, '22B2391', 10, NULL, '2025-10-07 10:56:02', '2025-10-07 10:56:02'),
(22, 29, '22B2414', 10, NULL, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(23, 30, '22B1999', 10, NULL, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(24, 31, '22S0131', 10, NULL, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(25, 32, '20B0742', 10, NULL, '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(26, 33, '22B2065', 10, NULL, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(27, 34, '22B1990', 10, NULL, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(28, 35, '22B2088', 10, NULL, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(29, 36, '22B2068', 10, NULL, '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(30, 37, '22B2366', 10, NULL, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(31, 38, '22B2008', 10, NULL, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(32, 39, '20B0815', 10, NULL, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(33, 40, '22B2388', 10, NULL, '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(34, 41, '22B2048', 10, NULL, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(35, 42, '22B2058', 10, NULL, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(36, 43, '22S0112', 10, NULL, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(37, 44, '22B2178', 10, NULL, '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(38, 45, '20B0911', 10, NULL, '2025-10-07 10:56:07', '2025-10-07 10:56:07'),
(39, 46, '20B2117', 10, NULL, '2025-10-07 10:56:07', '2025-10-07 10:56:07'),
(40, 47, '22B2079', 10, NULL, '2025-10-07 10:56:49', '2025-10-07 10:56:49'),
(41, 48, '22B2186', 10, NULL, '2025-10-07 10:56:49', '2025-10-07 10:56:49'),
(42, 49, '22B1968', 10, NULL, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(43, 50, '21B1411', 10, NULL, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(44, 51, '22B1967', 10, NULL, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(45, 52, '19B1654', 10, NULL, '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(46, 53, '22B2125', 10, NULL, '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(47, 54, '20B0923', 10, NULL, '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(48, 55, '20B1045', 10, NULL, '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(49, 56, '22B2394', 10, NULL, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(50, 57, '22B2373', 10, NULL, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(51, 58, '21B1549', 10, NULL, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(52, 59, '21B1186', 10, NULL, '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(53, 60, '22B2108', 10, NULL, '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(54, 61, '20B0919', 10, NULL, '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(55, 62, '22B2196', 10, NULL, '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(56, 63, '23B2739', 10, NULL, '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(57, 64, '19B1484', 10, NULL, '2025-10-07 10:58:59', '2025-10-07 10:58:59'),
(58, 65, '21B1204', 10, NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(59, 66, '21B1502', 10, NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(60, 67, '19B1540', 10, NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(61, 68, '21B1280', 10, NULL, '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(62, 69, '18B2017', 10, NULL, '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(63, 70, '22B2104', 10, NULL, '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(64, 71, '22B1500', 10, NULL, '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(65, 72, '22B2808', 10, NULL, '2025-10-07 11:02:58', '2025-10-07 11:02:58');

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `course_id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL,
  `course_major_id` int(11) DEFAULT NULL,
  `subject_type` enum('major','gen-ed') DEFAULT NULL,
  `subject_code` char(20) NOT NULL,
  `subject_title` varchar(150) NOT NULL,
  `yr_level` enum('first','second','third','fourth') NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`id`, `course_id`, `curriculum_id`, `course_major_id`, `subject_type`, `subject_code`, `subject_title`, `yr_level`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 1, NULL, 'gen-ed', 'GE-ARTAPP', 'Arts Appreciation', 'first', 'active', '2025-09-12 01:21:18', '2025-10-07 05:39:35'),
(2, 2, 1, NULL, 'major', 'CC101', 'Introduction to Computing', 'first', 'active', '2025-09-12 01:28:42', '2025-10-07 05:39:54'),
(3, 2, 1, NULL, 'gen-ed', 'GEE101', 'Logic and Critical Thinking', 'first', 'active', '2025-09-12 01:29:04', '2025-10-07 05:55:35'),
(4, 2, 1, NULL, 'gen-ed', 'GE-MMW', 'Mathematics in the Modern World', 'first', 'active', '2025-09-12 01:29:38', '2025-10-07 08:21:43'),
(5, 2, 1, NULL, 'gen-ed', 'PATHFIT 1', 'Movement Competency Training', 'first', 'active', '2025-09-12 01:29:58', '2025-10-07 08:21:48'),
(6, 2, 1, NULL, 'gen-ed', 'GE-PURCOM', 'Purposive Communication', 'first', 'active', '2025-09-12 01:30:22', '2025-10-07 08:21:53'),
(7, 2, 1, NULL, 'gen-ed', 'GE-STS', 'Science, Technology and Society', 'first', 'active', '2025-09-12 01:30:39', '2025-10-07 08:21:57'),
(8, 2, 1, NULL, 'gen-ed', 'GE-UTS', 'Understanding the Self', 'first', 'active', '2025-09-12 01:31:01', '2025-10-07 08:22:02'),
(9, 2, 1, NULL, NULL, 'CC201', 'Computer Programming 2', 'second', 'active', '2025-09-12 01:43:28', '2025-09-12 01:43:28'),
(10, 2, 1, NULL, NULL, 'ISE201', 'Elective 1: Presentation Skills using Information Technology', 'second', 'active', '2025-09-12 01:47:03', '2025-09-12 01:47:03'),
(11, 2, 1, NULL, NULL, 'ISP202', 'Enterprise Architecture', 'second', 'active', '2025-09-12 01:48:08', '2025-09-12 01:48:08'),
(12, 2, 1, NULL, NULL, 'CC202', 'Information Management', 'second', 'active', '2025-09-12 01:50:30', '2025-09-12 01:50:30'),
(13, 2, 1, NULL, NULL, 'ISP203', 'Information Technology Infrastructure & Network Technology', 'second', 'active', '2025-09-12 01:50:48', '2025-09-12 01:50:48'),
(14, 2, 1, NULL, NULL, 'ISP201', 'Professional Issues in IS', 'second', 'active', '2025-09-12 01:51:29', '2025-09-12 01:51:29'),
(15, 2, 1, NULL, NULL, 'GE-RPH', 'Readings in Philippine History', 'second', 'active', '2025-09-12 01:51:50', '2025-09-12 01:51:50'),
(16, 2, 1, NULL, NULL, 'PATHFIT 3', 'Sports (Board Games)', 'second', 'active', '2025-09-12 01:52:10', '2025-09-12 01:52:10'),
(17, 2, 1, NULL, NULL, 'CC301', 'Application Development and Emerging Technologies', 'third', 'active', '2025-09-12 01:52:43', '2025-09-12 01:52:43'),
(18, 2, 1, NULL, NULL, 'ISP302', 'Business Intelligence', 'third', 'active', '2025-09-12 01:53:06', '2025-09-12 01:53:06'),
(19, 2, 1, NULL, NULL, 'ISE301', 'Elective 1: Web Systems and Technology', 'third', 'active', '2025-09-12 01:53:33', '2025-09-12 01:53:33'),
(20, 2, 1, NULL, NULL, 'ISE302', 'Elective 2: Advanced Database Systems', 'third', 'active', '2025-09-12 01:53:52', '2025-09-12 01:53:52'),
(21, 2, 1, NULL, NULL, 'ISP301', 'Financial Management', 'third', 'active', '2025-09-12 01:54:15', '2025-09-12 01:54:15'),
(22, 2, 1, NULL, NULL, 'ISP303', 'IS Project Management 1', 'third', 'active', '2025-09-12 01:54:38', '2025-09-12 01:54:38'),
(23, 2, 1, NULL, NULL, 'ISP304', 'Methods of Research in IS', 'third', 'active', '2025-09-12 01:54:56', '2025-09-12 01:54:56'),
(24, 2, 1, NULL, 'major', 'ISCAP102', 'Capstone Project 2', 'fourth', 'active', '2025-09-12 01:55:23', '2025-10-07 08:22:11'),
(25, 2, 1, NULL, 'major', 'ISE104', 'Elective 4', 'fourth', 'active', '2025-09-12 01:55:38', '2025-10-07 08:22:14'),
(26, 2, 1, NULL, 'major', 'ISP118', 'IS Strategy Management and Acquisition', 'fourth', 'active', '2025-09-12 01:55:53', '2025-10-07 08:22:20'),
(27, 2, 1, NULL, 'major', 'ISP119', 'IT Audit and Control', 'fourth', 'active', '2025-09-12 01:56:09', '2025-10-07 08:22:25'),
(28, 1, 2, NULL, NULL, 'CC101', 'Introduction to Computing', 'first', 'active', '2025-10-07 03:30:34', '2025-10-07 03:30:34');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `role` enum('admin','faculty','student') NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `mid_name` varchar(150) NOT NULL,
  `name_ext` varchar(20) DEFAULT NULL,
  `gender` enum('male','female') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `role`, `last_name`, `first_name`, `mid_name`, `name_ext`, `gender`, `created_at`, `updated_at`) VALUES
(1, 'Admin Lname', 'admin@gmail.com', '2025-09-03 01:06:29', '$2y$12$bQ2RLNpc4ujHDL3Nnl7pxOU/GgeuJNoBUZxyAwdZHKiy8DpAjg9Xy', NULL, 'admin', 'Lname', 'Admin', 'a', NULL, 'male', '2025-08-09 14:46:58', '2025-08-09 14:46:58'),
(2, 'Malinao, Ronjie Mar L', 'deancics@gmail.com', '2025-09-11 13:02:55', '$2y$12$bQ2RLNpc4ujHDL3Nnl7pxOU/GgeuJNoBUZxyAwdZHKiy8DpAjg9Xy', NULL, 'faculty', 'Malinao', 'Ronjie Mar', 'L', NULL, 'male', '2025-09-11 12:54:23', '2025-10-07 09:26:06'),
(3, 'Logmao, Beneden Morong', 'logmao.beneden@gmail.com', '2025-09-11 13:03:00', '$2y$12$bQ2RLNpc4ujHDL3Nnl7pxOU/GgeuJNoBUZxyAwdZHKiy8DpAjg9Xy', NULL, 'faculty', 'Logmao', 'Beneden', 'Morong', NULL, 'female', '2025-09-11 12:56:39', '2025-10-07 09:25:38'),
(4, 'Malino - De Luna, Eunice G', 'deluna.eunice@gmail.com', '2025-09-11 13:03:03', '$2y$12$bQ2RLNpc4ujHDL3Nnl7pxOU/GgeuJNoBUZxyAwdZHKiy8DpAjg9Xy', NULL, 'faculty', 'Malino - De Luna', 'Eunice', 'G', NULL, 'female', '2025-09-11 12:59:11', '2025-10-07 09:34:34'),
(5, 'Capistrano, Doreena Joy Borja', 'capistrano.doreenajoy@gmail.com', '2025-10-07 10:27:55', '$2y$12$bQ2RLNpc4ujHDL3Nnl7pxOU/GgeuJNoBUZxyAwdZHKiy8DpAjg9Xy', NULL, 'faculty', 'Capistrano', 'Doreena Joy', 'Borja', NULL, 'female', '2025-09-12 05:38:13', '2025-10-07 09:40:15'),
(6, 'Jasmin, Kevin H', 'jasmin.kevin@gmail.com', '2025-10-07 10:28:04', '$2y$12$bQ2RLNpc4ujHDL3Nnl7pxOU/GgeuJNoBUZxyAwdZHKiy8DpAjg9Xy', NULL, 'faculty', 'Jasmin', 'Kevin', 'H', NULL, 'male', '2025-09-12 08:31:23', '2025-10-07 09:41:41'),
(7, 'Ortega, Recalla M', 'ortega.recalla@gmail.com', '2025-10-07 10:28:09', '$2y$12$bQ2RLNpc4ujHDL3Nnl7pxOU/GgeuJNoBUZxyAwdZHKiy8DpAjg9Xy', NULL, 'faculty', 'Ortega', 'Recalla', 'M', NULL, 'female', '2025-10-07 09:42:42', '2025-10-07 09:42:42'),
(8, 'EMBING, Kristine Nelly L.', 'embing.kristinenelly@marsu.edu.ph', NULL, '$2y$12$jLVn1AbPR94p2UytYxcD9etueEpM0FX8WEpP4zBrXJkXqcTkZR7e6', NULL, 'student', 'EMBING', 'Kristine Nelly', 'L.', '', 'female', '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(9, 'EVIA, Charl Francine S.', 'evia.charlfrancine@marsu.edu.ph', NULL, '$2y$12$IFs0hGfSP.EzJhheSKPrk.mcz/xWv8hO1JOSTsVwrazCDN2Pa97ju', NULL, 'student', 'EVIA', 'Charl Francine', 'S.', '', 'female', '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(10, 'LAYAG, John Mark Respicio', 'layag.johnmark@marsu.edu.ph', NULL, '$2y$12$LjlYltXWmrfITuGH913IqeUdxGpo0JBGQBthTeefXCMeOAYWOAuGC', NULL, 'student', 'LAYAG', 'John Mark Respicio', '', '', 'male', '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(11, 'LIGTAS, Laurence Siena', 'ligtas.laurence@marsu.edu.ph', NULL, '$2y$12$PTn4JcvZMCENPe/v8E8pFehjdJB49vd20VM78IAxta5/l4WD6iayO', NULL, 'student', 'LIGTAS', 'Laurence Siena', '', '', 'male', '2025-10-07 10:55:26', '2025-10-07 10:55:26'),
(12, 'LOTO, Friscian Hintay', 'loto.friscian@marsu.edu.ph', NULL, '$2y$12$FZMLwJiRtvA9GhKM/uB0muNhtZydtfFJo5he/elxacn9I.m8jBIRW', NULL, 'student', 'LOTO', 'Friscian Hintay', '', '', 'male', '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(13, 'MALILOM, Ferleen Kaycee M.', 'malilom.ferleenkaycee@marsu.edu.ph', NULL, '$2y$12$/vazLAzrvVVm/CicH5puv.qpnyOlD676s6WXQEuyXG3.DLO30mmAG', NULL, 'student', 'MALILOM', 'Ferleen Kaycee', 'M.', '', 'female', '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(14, 'MAMING, Dave Martin P.', 'maming.davemartin@marsu.edu.ph', NULL, '$2y$12$7NOHbBnCr3MgO5.faN9kA.pEzSUsiqaUaYubas/9.Pp/s5e2kmYIq', NULL, 'student', 'MAMING', 'Dave Martin', 'P.', '', 'male', '2025-10-07 10:55:27', '2025-10-07 10:55:27'),
(15, 'MANDIA, Christian M.', 'mandia.christian@marsu.edu.ph', NULL, '$2y$12$1.7LpRJ3fW84xyoah9L7H.hz1cLt4rnnlz/Xq2A2NFjix9iTXLF3S', NULL, 'student', 'MANDIA', 'Christian', 'M.', '', 'male', '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(16, 'MANDIA, Kim L', 'mandia.kim@marsu.edu.ph', NULL, '$2y$12$5LcrPsCDnq1Xw6evHZGSYeBt9RveTMkJ.5EP5pyPqfoWYwnW0E1Du', NULL, 'student', 'MANDIA', 'Kim', 'L', '', 'female', '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(17, 'MERCADO, Karizza Marie Mercene', 'mercado.karizzamarie@marsu.edu.ph', '2025-10-07 11:03:53', '$2y$12$bQ2RLNpc4ujHDL3Nnl7pxOU/GgeuJNoBUZxyAwdZHKiy8DpAjg9Xy', NULL, 'student', 'MERCADO', 'Karizza Marie Mercene', '', '', 'female', '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(18, 'MIÃ±GA, Jennex A.', 'minga.jennex@marsu.edu.ph', NULL, '$2y$12$QBm7xc1KBqbWQj3fpYND4.0NxH.LK2bBtZHztgeIfsAsZ6.7o.5NS', NULL, 'student', 'MIÃ±GA', 'Jennex', 'A.', '', 'female', '2025-10-07 10:55:28', '2025-10-07 10:55:28'),
(19, 'MURILLO, Rohann Janda', 'murillo.rohann@marsu.edu.ph', NULL, '$2y$12$Goj.EqN/nw/W5f9dQHsZCekTdcH4OlNy1Gc33VxMYgT8./LwHdUv.', NULL, 'student', 'MURILLO', 'Rohann Janda', '', '', 'male', '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(20, 'PASOOT, John Denbert P.', 'pasoot.johndenbert@marsu.edu.ph', NULL, '$2y$12$oQDiBl5P7scPjiZwGxagKepcYv2b8vyaZfsBE9i76CJpBKehhQg0y', NULL, 'student', 'PASOOT', 'John Denbert', 'P.', '', 'male', '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(21, 'QUIZANA, Sheryn C.', 'quizana.sheryn@marsu.edu.ph', NULL, '$2y$12$Jhm3FPRJRdTnyc/tLhCqKO9/axtSCAE0m8s0DsLj6CCNRgmOAZSi.', NULL, 'student', 'QUIZANA', 'Sheryn', 'C.', '', 'female', '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(22, 'REJANO, Ailene P.', 'rejano.ailene@marsu.edu.ph', NULL, '$2y$12$6eij.beNSAxG.Y2ZapHo0.4ifXlMq8Xt1faM/qOx/ir0gQFU9iqvu', NULL, 'student', 'REJANO', 'Ailene', 'P.', '', 'female', '2025-10-07 10:55:29', '2025-10-07 10:55:29'),
(23, 'SAGUID, Alsharif  S.', 'saguid.alsharif@marsu.edu.ph', NULL, '$2y$12$lusuH0n.LixGrcz27OfrUOR4YUkh4xVAo9Zh0jgN0hQx4mtOvNrh6', NULL, 'student', 'SAGUID', 'Alsharif ', 'S.', '', 'male', '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(24, 'SALAZAR, Kian S.', 'salazar.kian@marsu.edu.ph', NULL, '$2y$12$nEeXulyibFsMix/ilLuBCeDQ4nFiW9pNyYgY5FNBUzdBcUnRyQ7hS', NULL, 'student', 'SALAZAR', 'Kian', 'S.', '', 'male', '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(25, 'SALVACION, Zyrine A.', 'salvacion.zyrine@marsu.edu.ph', NULL, '$2y$12$BA/1MFAllgvC1sXjjc0N/uUGl9qbdN133zjNzW0EV8QbnhlkjjmJW', NULL, 'student', 'SALVACION', 'Zyrine', 'A.', '', 'female', '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(26, 'SANTOS, John Lee O.', 'santos.johnlee@marsu.edu.ph', NULL, '$2y$12$e4UN6ognRc38gOOHbfGJTeTqWjvud1ByJAwRjZl0xGk9j7WYnJHae', NULL, 'student', 'SANTOS', 'John Lee', 'O.', '', 'male', '2025-10-07 10:55:30', '2025-10-07 10:55:30'),
(27, 'VALDEPEÃ‘A, Mark Neil Revilla', 'valdepena.markneil@marsu.edu.ph', NULL, '$2y$12$RZpFevV7UMvrqkOgb37K2uv7aPibcgYYhjIq/cUAU5v1VxUwv5FrO', NULL, 'student', 'VALDEPEÃ‘A', 'Mark Neil Revilla', '', '', 'male', '2025-10-07 10:55:31', '2025-10-07 10:55:31'),
(28, 'AMPARO, Carmelle N.', 'amparo.carmelle@marsu.edu.ph', NULL, '$2y$12$3UjjX245JGHJSGNDNm78DOOy7RU8NzBWItLVzkaLNjMRSZPEF.Ta6', NULL, 'student', 'AMPARO', 'Carmelle', 'N.', '', 'female', '2025-10-07 10:56:02', '2025-10-07 10:56:02'),
(29, 'ATIENZA, Jannelle D.', 'atienza.jannelle@marsu.edu.ph', NULL, '$2y$12$pzY/rsoNxy9B.kfx6BtSQ.vVLBzHJb2WSC4iYtJPVxeRc.aE/M9jO', NULL, 'student', 'ATIENZA', 'Jannelle', 'D.', '', 'female', '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(30, 'BARAYANG, Mark Daryll R.', 'barayang.markdaryll@marsu.edu.ph', NULL, '$2y$12$lwojZHnBPx5pfSH9Ky0ade7B.6J6lGThICK2AYuJi8Vo7o3A5NhuC', NULL, 'student', 'BARAYANG', 'Mark Daryll', 'R.', '', 'male', '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(31, 'CRUZADO, John Errold P.', 'cruzado.johnerrold@marsu.edu.ph', NULL, '$2y$12$1g/VXyrfdKxDvB1mthc5rO9RbUarTw/6dL7gw66nLFi9qnr9ttFOG', NULL, 'student', 'CRUZADO', 'John Errold', 'P.', '', 'male', '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(32, 'DE BELEN, Daisyre Paller', 'debelen.daisyre@marsu.edu.ph', NULL, '$2y$12$rAoIp7UMV0rtb65PRwvj7unjsGRbyOeYwMaKp.EI5iTWNEAlj2CSu', NULL, 'student', 'DE BELEN', 'Daisyre Paller', '', '', 'female', '2025-10-07 10:56:03', '2025-10-07 10:56:03'),
(33, 'HIZOLE, Mary Jermaine B.', 'hizole.maryjermaine@marsu.edu.ph', NULL, '$2y$12$awdKvUj5Tv2thdxYwRQ23O3EKh8F.nGDoFVIOuV2jo5hbn3ANrhbO', NULL, 'student', 'HIZOLE', 'Mary Jermaine', 'B.', '', 'female', '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(34, 'LANDIG, Vincent R.', 'landig.vincent@marsu.edu.ph', NULL, '$2y$12$7DCbh86samtLKKrM4TDbG.lFW5I3jXlxY/xgjGb7kQMsBniTvtBOG', NULL, 'student', 'LANDIG', 'Vincent', 'R.', '', 'male', '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(35, 'LECAROZ, Ahliah Von M.', 'lecaroz.ahliahvon@marsu.edu.ph', NULL, '$2y$12$35NxnDPmV3qSNZCuhSUxeuI5HMrRhxIy2R/UhJes13GL9ULYIXhaG', NULL, 'student', 'LECAROZ', 'Ahliah Von', 'M.', '', 'female', '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(36, 'LIMPIADA, John Ivann M.', 'limpiada.johnivann@marsu.edu.ph', NULL, '$2y$12$rDw8XDrxTtwkBe.2ahIlq.3DRFquiTvBzcmNBjxn7pDBSAK0kt14.', NULL, 'student', 'LIMPIADA', 'John Ivann', 'M.', '', 'male', '2025-10-07 10:56:04', '2025-10-07 10:56:04'),
(37, 'LIWANAGAN, Alliah Mae L.', 'liwanagan.alliahmae@marsu.edu.ph', NULL, '$2y$12$0v1Ib6MmZfyLC7kv2NzS2OJMjP3zwjWtfHriOmJvi3.Fg37bNCb/K', NULL, 'student', 'LIWANAGAN', 'Alliah Mae', 'L.', '', 'female', '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(38, 'MABUTOT, John Raven M.', 'mabutot.johnraven@marsu.edu.ph', NULL, '$2y$12$gKFbDxup.Zmk2UcE/kVMbeI1a7cklM/jealoxJi1WJulV5/ZuHL66', NULL, 'student', 'MABUTOT', 'John Raven', 'M.', '', 'male', '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(39, 'MAYORES, Love Joy Magparangalan', 'mayores.lovejoy@marsu.edu.ph', NULL, '$2y$12$i/iuK6NU4lpBwg8BspG9/eQB8Fp7593UqJm9lnMTzOMac9P16ikQ.', NULL, 'student', 'MAYORES', 'Love Joy Magparangalan', '', '', 'female', '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(40, 'MIRAMBIL, Mark Anthony A.', 'mirambil.markanthony@marsu.edu.ph', NULL, '$2y$12$pZNBn7oNT8DymL5t2Lc.W.mZLHulULuAIkzCc3ahI/cuBvXK7f2OO', NULL, 'student', 'MIRAMBIL', 'Mark Anthony', 'A.', '', 'male', '2025-10-07 10:56:05', '2025-10-07 10:56:05'),
(41, 'MONTA, Daniela Grace M.', 'monta.danielagrace@marsu.edu.ph', NULL, '$2y$12$/49OLgfwvN2C4C6n8rpLeu50KfH.LqgL9X4nr1Ac6rRmEWxQNcJty', NULL, 'student', 'MONTA', 'Daniela Grace', 'M.', '', 'female', '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(42, 'NAMBIO, Althea Mae M.', 'nambio.altheamae@marsu.edu.ph', NULL, '$2y$12$QHOZXq1LXSLSliE1GbRr4uFReFGGJHklro/mEcdFNYuveSHWUBZQq', NULL, 'student', 'NAMBIO', 'Althea Mae', 'M.', '', 'female', '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(43, 'REMENTILLA, Jay Mark R.', 'rementilla.jaymark@marsu.edu.ph', NULL, '$2y$12$QxSf1mEFoH3YnpO4PyiusOFzWxa5kJeVcppuCThGE2M/8dDG2WOJ.', NULL, 'student', 'REMENTILLA', 'Jay Mark', 'R.', '', 'male', '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(44, 'RODAS, Anna Joy M.', 'rodas.annajoy@marsu.edu.ph', NULL, '$2y$12$15GcqT6EmmVPe3y3VIL7QehG6U8JNv65PAIZvzXTTQAKA1Mnji.9.', NULL, 'student', 'RODAS', 'Anna Joy', 'M.', '', 'female', '2025-10-07 10:56:06', '2025-10-07 10:56:06'),
(45, 'SADIM, Sacha James Edward Ubalde', 'sadim.sachajamesedward@marsu.edu.ph', NULL, '$2y$12$.R/YJ13dt9Ca5HUhYda1huUvl59u8xWZdlLacfjf/NxXO/8VQCGCK', NULL, 'student', 'SADIM', 'Sacha James Edward Ubalde', '', '', 'male', '2025-10-07 10:56:07', '2025-10-07 10:56:07'),
(46, 'SAET, Lorenz Christopher R.', 'saet.lorenzchristopher@marsu.edu.ph', NULL, '$2y$12$UBJSn5V6D0JJSI8wGm/WGuQuQpQ75ENN347qYlokXtqwFYYBCNb1K', NULL, 'student', 'SAET', 'Lorenz Christopher', 'R.', '', 'male', '2025-10-07 10:56:07', '2025-10-07 10:56:07'),
(47, 'BALLESTEROS, Shane Ashley L.', '22b2079@marsu.edu.ph', NULL, '$2y$12$dwDVp5H2x9cRvbVMbfW3keveeAM58J8G.Njkrga.e8viSQ0JsPY7y', NULL, 'student', 'BALLESTEROS', 'Shane Ashley', 'L.', '', 'female', '2025-10-07 10:56:49', '2025-10-07 10:56:49'),
(48, 'CAY, Mark Gil', '22b2186@marsu.edu.ph', NULL, '$2y$12$ICraPUwpSSwOADYv3cxHP.8Ui5uF.MXCogXUBS9UK/IsSa5BnQVFG', NULL, 'student', 'CAY', 'Mark Gil', '', '', 'male', '2025-10-07 10:56:49', '2025-10-07 10:56:49'),
(49, 'DE LA CRUZ, Sharry Z.', '22b1968@marsu.edu.ph', NULL, '$2y$12$78x9yFkA6zTD.5l88YjK4.Wd9REDDRAEpBG3VSx4SHrIaYkxHA0DG', NULL, 'student', 'DE LA CRUZ', 'Sharry', 'Z.', '', 'female', '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(50, 'ERTA, Angelo Menor', '21b1411@marsu.edu.ph', NULL, '$2y$12$QlDfw4Es2qz0VZQ1KJik..Xo9cFk2Taeyq0o.neDNWrH0Rj.roB1y', NULL, 'student', 'ERTA', 'Angelo Menor', '', '', 'male', '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(51, 'GERONAGA , Jemharie Vien  F.', '22b1967@marsu.edu.ph', NULL, '$2y$12$Rhmu1zQLxZtVWHWsRFgknOkTCwYvK2AfaPkEVeZO6pOuBHnQMZY5y', NULL, 'student', 'GERONAGA', 'Jemharie Vien ', 'F.', '', 'female', '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(52, 'MAJABA, Jeo Sapungan', '19b1654@marsu.edu.ph', NULL, '$2y$12$3VOWOhBe8oFmU044WDB9MujpW9BcNW0D7uRfQJ3LXKJPsrA4UNuhS', NULL, 'student', 'MAJABA', 'Jeo Sapungan', '', '', 'male', '2025-10-07 10:56:50', '2025-10-07 10:56:50'),
(53, 'MATRE, Rose Anne D.', '22b2125@marsu.edu.ph', NULL, '$2y$12$HxSIMsv95yyrmxCAy32BZe4ivZaRrXpDis/WMNYQu6wLfW0Fo.9aS', NULL, 'student', 'MATRE', 'Rose Anne', 'D.', '', 'female', '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(54, 'MERCENE, Kristel Requinala', '20b0923@marsu.edu.ph', NULL, '$2y$12$tiz4eL5SASgdKds4SqZKDeZEE43gg3HpyKKJBuHdBb0t7dXr62tjq', NULL, 'student', 'MERCENE', 'Kristel Requinala', '', '', 'female', '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(55, 'MICIANO, Reymond Fiedalan', '20b1045@marsu.edu.ph', NULL, '$2y$12$4ak1lS.GLvlZaSAKVkUM4ur.X2CQOGJFt2w1QfqW5iprUl0WfeURK', NULL, 'student', 'MICIANO', 'Reymond Fiedalan', '', '', 'male', '2025-10-07 10:56:51', '2025-10-07 10:56:51'),
(56, 'MOLBOG, Arjay M.', '22b2394@marsu.edu.ph', NULL, '$2y$12$18UwjcME.hYahP27DmqYYu7FWOzDc47JqWLKQODxUBOCb1f2YXOqa', NULL, 'student', 'MOLBOG', 'Arjay', 'M.', '', 'male', '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(57, 'OSINSAO, Jan Christian O.', '22b2373@marsu.edu.ph', NULL, '$2y$12$aS6QlVdt0oFHM04Jii0n4OU3fLBnNqJFZEbmminiCPiq.4HXJXGJ.', NULL, 'student', 'OSINSAO', 'Jan Christian', 'O.', '', 'male', '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(58, 'PASCUAL, Rhey Magculang', '21b1549@marsu.edu.ph', NULL, '$2y$12$4r3RLgLakb9WTmhBaw/zCeuwyI2W6pTAtWGyhiEpt6pNhKpDXVpBe', NULL, 'student', 'PASCUAL', 'Rhey Magculang', '', '', 'male', '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(59, 'SELDA, Hanna Kristel Jane Saporna', '21b1186@marsu.edu.ph', NULL, '$2y$12$R50uWEOGAKd40NZe/1zlp.GrMB2FdD63BZeLojKtq2bPtK18jEs3u', NULL, 'student', 'SELDA', 'Hanna Kristel Jane Saporna', '', '', 'female', '2025-10-07 10:56:52', '2025-10-07 10:56:52'),
(60, 'TAN, Maica Joy', '22b2108@marsu.edu.ph', NULL, '$2y$12$o./uoEEe/zYjo65syL6yf.I5809PurwiCW.30KnkYoNKW9CM5fNlq', NULL, 'student', 'TAN', 'Maica Joy', '', '', 'female', '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(61, 'URTAL, Carl Angel Mangana', '20b0919@marsu.edu.ph', NULL, '$2y$12$e1B3DqNxwBj3m4V1seXZ.e0OJmbd3N52nHvu5HMoX0TZIjIFUvCYW', NULL, 'student', 'URTAL', 'Carl Angel Mangana', '', '', 'male', '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(62, 'VILLAVICENCIO, Angeline L.', '22b2196@marsu.edu.ph', NULL, '$2y$12$UiQNLqYGGsBRlrgSqiahBu35D8V5xg69ARJTRNKLNdNH556AK9i6C', NULL, 'student', 'VILLAVICENCIO', 'Angeline', 'L.', '', 'female', '2025-10-07 10:56:53', '2025-10-07 10:56:53'),
(63, 'JANAP, Marianne P.', 'janap.marianne@marsu.edu.ph', NULL, '$2y$12$7QJ35WW3Vr4Cw/8tjGG3ZuLHJNJVZra00Z.5AzJtX835R/7lNGTzC', NULL, 'student', 'JANAP', 'Marianne', 'P.', '', 'female', '2025-10-07 10:58:58', '2025-10-07 10:58:58'),
(64, 'PEÃ‘ASCOSAS, Joven Tagle', 'penascosas.joven@marsu.edu.ph', NULL, '$2y$12$9.5Rg4NthMo0Y7X5GzNnTeMXgaR6picZhIf4aQGCyx6yThQ7wsFAS', NULL, 'student', 'PEÃ‘ASCOSAS', 'Joven Tagle', '', '', 'male', '2025-10-07 10:58:59', '2025-10-07 10:58:59'),
(65, 'FERRER, Joanne Rea Mazo', 'ferrer.joannerea@marsu.edu.ph', NULL, '$2y$12$kWrINuwjwTKEOnbJ3jSMReKkxcPt2AMiDY3na21/KoaNbsepDv2ti', NULL, 'student', 'FERRER', 'Joanne Rea Mazo', '', '', 'female', '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(66, 'FLORES, Jhon Jhon W.', 'flores.jhonjhon@marsu.edu.ph', NULL, '$2y$12$Bx743NHx1vrtfSa8Yd3s3.rKql.XZ5k7uXxoaNrqx/shzEMzkgRf.', NULL, 'student', 'FLORES', 'Jhon Jhon', 'W.', '', 'male', '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(67, 'MADIZ, Kevin Dominic Mataya', 'madiz.kevindominic@marsu.edu.ph', NULL, '$2y$12$oC.MELOq58TZPAZzKDmcYOIGbhSimX33xkX0qUGQ7i3bPQa/xtHYe', NULL, 'student', 'MADIZ', 'Kevin Dominic Mataya', '', '', 'male', '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(68, 'MUHI, Tescel S.', 'muhi.tescel@marsu.edu.ph', NULL, '$2y$12$kZme7u3uXx0osPXZ7zR5nuc.bZPAhghv41nxJ7goL2.OrVgyT11pS', NULL, 'student', 'MUHI', 'Tescel', 'S.', '', 'female', '2025-10-07 11:01:22', '2025-10-07 11:01:22'),
(69, 'SELDA, Catherine Lean', 'selda.catherinelean@marsu.edu.ph', NULL, '$2y$12$3uQRzucRqnbZyy207V.kYeiKMSXZaAb29AbrDVqYVP/.tESxht6oC', NULL, 'student', 'SELDA', 'Catherine Lean', '', '', 'female', '2025-10-07 11:01:23', '2025-10-07 11:01:23'),
(70, 'MATRE, Jonel C.', 'matre.jonel@marsu.edu.ph', NULL, '$2y$12$B0fgz6JFafv4UD7MHiIhS.Okbtm45xYTRtTWSJ1kwJOzrt.a2g80y', NULL, 'student', 'MATRE', 'Jonel', 'C.', '', 'male', '2025-10-07 11:02:57', '2025-10-07 11:02:57'),
(71, 'MIRAMBIL, Jhon Victor  Rhey L.', 'mirambil.jhonvictorrhey@marsu.edu.ph', NULL, '$2y$12$8or.o2QUWmOmI82fRwCrmeb4wyd.yeget68n.t.Ff/IOofP1hQ/3.', NULL, 'student', 'MIRAMBIL', 'Jhon Victor  Rhey', 'L.', '', 'male', '2025-10-07 11:02:58', '2025-10-07 11:02:58'),
(72, 'SELDA, Chresta Mae S.', 'selda.chrestamae@marsu.edu.ph', NULL, '$2y$12$Yc7M0IN6t49ZAdAb919b0edCku4wprfC.A8hS1HQPNfYjTpy0XIxe', NULL, 'student', 'SELDA', 'Chresta Mae', 'S.', '', 'female', '2025-10-07 11:02:58', '2025-10-07 11:02:58');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `colleges`
--
ALTER TABLE `colleges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `course_majors`
--
ALTER TABLE `course_majors`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `course_outcomes`
--
ALTER TABLE `course_outcomes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `curricula`
--
ALTER TABLE `curricula`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `enrolled_subjects`
--
ALTER TABLE `enrolled_subjects`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `evaluations`
--
ALTER TABLE `evaluations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `evaluation_comments`
--
ALTER TABLE `evaluation_comments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_eval_comment` (`semester_id`,`subject_id`,`student_id`);

--
-- Indexes for table `evaluation_schedules`
--
ALTER TABLE `evaluation_schedules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faculties`
--
ALTER TABLE `faculties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faculty_subjects`
--
ALTER TABLE `faculty_subjects`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outcome_links`
--
ALTER TABLE `outcome_links`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `program_outcomes`
--
ALTER TABLE `program_outcomes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rating_settings`
--
ALTER TABLE `rating_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `scales`
--
ALTER TABLE `scales`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `semesters`
--
ALTER TABLE `semesters`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `students_id_number_unique` (`id_number`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `colleges`
--
ALTER TABLE `colleges`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `course_majors`
--
ALTER TABLE `course_majors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `course_outcomes`
--
ALTER TABLE `course_outcomes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `curricula`
--
ALTER TABLE `curricula`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `enrolled_subjects`
--
ALTER TABLE `enrolled_subjects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=180;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `evaluations`
--
ALTER TABLE `evaluations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `evaluation_comments`
--
ALTER TABLE `evaluation_comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `evaluation_schedules`
--
ALTER TABLE `evaluation_schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `faculties`
--
ALTER TABLE `faculties`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `faculty_subjects`
--
ALTER TABLE `faculty_subjects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `outcome_links`
--
ALTER TABLE `outcome_links`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `program_outcomes`
--
ALTER TABLE `program_outcomes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `rating_settings`
--
ALTER TABLE `rating_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `scales`
--
ALTER TABLE `scales`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `semesters`
--
ALTER TABLE `semesters`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
