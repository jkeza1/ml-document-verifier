-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 04, 2026 at 08:08 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `iremboaipowered`
--

-- --------------------------------------------------------

--
-- Table structure for table `applicationcriminalrecord`
--

CREATE TABLE `applicationcriminalrecord` (
  `id` int(11) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `national_id` varchar(20) NOT NULL,
  `purpose` text NOT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `service_name` varchar(150) DEFAULT NULL,
  `processing_days` int(11) DEFAULT NULL,
  `price` varchar(50) DEFAULT NULL,
  `provided_by` varchar(100) DEFAULT NULL,
  `application_date` datetime DEFAULT NULL,
  `expected_feedback_date` datetime DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `admin_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `applicationdrivinglicense`
--

CREATE TABLE `applicationdrivinglicense` (
  `id` int(11) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `national_id` varchar(30) NOT NULL,
  `service_name` varchar(200) NOT NULL,
  `processing_time` int(11) NOT NULL COMMENT 'Number of days',
  `price` decimal(10,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `application_date` datetime DEFAULT current_timestamp(),
  `expected_feedback_date` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `admin_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applicationdrivinglicense`
--

INSERT INTO `applicationdrivinglicense` (`id`, `full_name`, `email`, `phone`, `national_id`, `service_name`, `processing_time`, `price`, `currency`, `application_date`, `expected_feedback_date`, `status`, `admin_reason`) VALUES
(1, 'AIME', 'jetaime@gmail.com', '0787936791', '1234567890', 'Application for Definitive Driving License', 14, 50000.00, 'RWF', '2026-02-24 19:41:27', '2026-03-10 19:41:27', 'Approved', 'Your document has been approved ');

-- --------------------------------------------------------

--
-- Table structure for table `applicationdrivingreplacement`
--

CREATE TABLE `applicationdrivingreplacement` (
  `id` int(11) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `national_id` varchar(30) NOT NULL,
  `license_number` varchar(50) NOT NULL,
  `reason` varchar(100) DEFAULT 'Driving License Replacement',
  `service_name` varchar(200) DEFAULT NULL,
  `processing_time` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `old_license_image` varchar(255) DEFAULT NULL,
  `police_document` varchar(255) DEFAULT NULL,
  `application_date` datetime DEFAULT current_timestamp(),
  `expected_feedback_date` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `admin_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applicationdrivingreplacement`
--

INSERT INTO `applicationdrivingreplacement` (`id`, `full_name`, `email`, `phone`, `national_id`, `license_number`, `reason`, `service_name`, `processing_time`, `price`, `currency`, `old_license_image`, `police_document`, `application_date`, `expected_feedback_date`, `status`, `admin_reason`) VALUES
(1, 'AIME', 'jetaime@gmail.com', '0787936791', '1234567890', '1234', 'Driving License Replacement', 'Application for Definitive Driving License', 14, 50000.00, 'RWF', '1772023223_license.jpg', '1772023223_police.jpg', '2026-02-25 13:40:23', '2026-03-11 13:40:23', 'Pending', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `applicationgoodconduct`
--

CREATE TABLE `applicationgoodconduct` (
  `id` int(11) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `national_id` varchar(30) NOT NULL,
  `service_name` varchar(200) NOT NULL,
  `processing_time` int(11) NOT NULL,
  `price` varchar(50) DEFAULT NULL,
  `application_date` datetime DEFAULT current_timestamp(),
  `expected_feedback_date` datetime DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `admin_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applicationgoodconduct`
--

INSERT INTO `applicationgoodconduct` (`id`, `full_name`, `email`, `phone`, `national_id`, `service_name`, `processing_time`, `price`, `application_date`, `expected_feedback_date`, `attachment`, `status`, `admin_reason`) VALUES
(1, 'AIME', 'jetaime@gmail.com', '0787936791', '1234567890', 'Certificate of Good Conduct', 7, 'free', '2026-02-25 10:46:36', '2026-03-04 10:46:36', '1772012796_virunga-Lodge-Volcanoes-NP.jpeg', 'Pending', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `applicationmarriagecertificate`
--

CREATE TABLE `applicationmarriagecertificate` (
  `id` int(11) NOT NULL,
  `husband_full_name` varchar(150) NOT NULL,
  `wife_full_name` varchar(150) NOT NULL,
  `applicant_email` varchar(150) NOT NULL,
  `applicant_phone` varchar(20) NOT NULL,
  `husband_national_id` varchar(30) NOT NULL,
  `wife_national_id` varchar(30) NOT NULL,
  `service_name` varchar(200) NOT NULL,
  `processing_time` int(11) NOT NULL COMMENT 'Number of days',
  `price` decimal(10,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `application_date` datetime DEFAULT current_timestamp(),
  `expected_feedback_date` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `admin_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applicationmarriagecertificate`
--

INSERT INTO `applicationmarriagecertificate` (`id`, `husband_full_name`, `wife_full_name`, `applicant_email`, `applicant_phone`, `husband_national_id`, `wife_national_id`, `service_name`, `processing_time`, `price`, `currency`, `application_date`, `expected_feedback_date`, `status`, `admin_reason`) VALUES
(1, 'aime', 'Aline', 'jetaimetech@gmail.com', '+250787936791', '1234', '4321', 'Marriage Certificate', 1, 1000.00, 'RWF', '2026-02-25 10:30:19', '2026-02-26 10:30:19', 'Pending', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `applicationnationalid`
--

CREATE TABLE `applicationnationalid` (
  `id` int(11) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `national_id` varchar(30) NOT NULL,
  `reason` varchar(255) DEFAULT 'Lost ID Replacement',
  `service_name` varchar(200) NOT NULL,
  `processing_time` int(11) NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `old_id_image` varchar(255) DEFAULT NULL,
  `police_document` varchar(255) DEFAULT NULL,
  `application_date` datetime DEFAULT current_timestamp(),
  `expected_feedback_date` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `admin_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applicationnationalid`
--

INSERT INTO `applicationnationalid` (`id`, `full_name`, `email`, `phone`, `national_id`, `reason`, `service_name`, `processing_time`, `price`, `currency`, `old_id_image`, `police_document`, `application_date`, `expected_feedback_date`, `status`, `admin_reason`) VALUES
(1, 'AIME', 'jetaime@gmail.com', '0787936791', '1234567890', 'Lost ID Replacement', 'Application for National ID', 30, 500.00, 'RWF', '1772019263_old.jpg', '1772019263_police.jpg', '2026-02-25 12:34:23', '2026-03-27 12:34:23', 'Pending', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `applicationpassport`
--

CREATE TABLE `applicationpassport` (
  `id` int(11) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `national_id` varchar(30) NOT NULL,
  `service_name` varchar(200) NOT NULL,
  `request_type` varchar(200) DEFAULT NULL,
  `processing_time` int(11) NOT NULL COMMENT 'Number of days',
  `fee` varchar(100) DEFAULT NULL,
  `application_date` datetime DEFAULT current_timestamp(),
  `expected_feedback_date` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `admin_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applicationpassport`
--

INSERT INTO `applicationpassport` (`id`, `full_name`, `email`, `phone`, `national_id`, `service_name`, `request_type`, `processing_time`, `fee`, `application_date`, `expected_feedback_date`, `status`, `admin_reason`) VALUES
(2, 'AIME', 'jetaimetech@gmail.com', '0787936791', '1234567890', 'e-Passport Application', 'e-Passport Application', 4, '100000', '2026-02-26 13:42:47', '2026-03-02 13:42:47', 'Approved', 'good');

-- --------------------------------------------------------

--
-- Table structure for table `applicationpassportreplacement`
--

CREATE TABLE `applicationpassportreplacement` (
  `id` int(11) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `national_id` varchar(20) NOT NULL,
  `passport_number` varchar(20) NOT NULL,
  `reason` text NOT NULL,
  `service_name` varchar(150) DEFAULT NULL,
  `processing_days` int(11) DEFAULT NULL,
  `fee` varchar(50) DEFAULT NULL,
  `provided_by` varchar(100) DEFAULT NULL,
  `application_date` datetime DEFAULT NULL,
  `expected_feedback_date` datetime DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `admin_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applicationpassportreplacement`
--

INSERT INTO `applicationpassportreplacement` (`id`, `full_name`, `email`, `phone`, `national_id`, `passport_number`, `reason`, `service_name`, `processing_days`, `fee`, `provided_by`, `application_date`, `expected_feedback_date`, `status`, `created_at`, `admin_reason`) VALUES
(1, 'AIME', 'jetaime@gmail.com', '0787936791', '1234567890', '1234', 'lost', 'e-Passport Application', 4, '100000', 'DGIW', '2026-02-25 14:47:04', '2026-03-01 14:47:04', 'Rejected', '2026-02-25 13:47:04', 'good');

-- --------------------------------------------------------

--
-- Table structure for table `applicationprovisionallicense`
--

CREATE TABLE `applicationprovisionallicense` (
  `id` int(11) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `national_id` varchar(30) NOT NULL,
  `service_name` varchar(200) NOT NULL,
  `processing_time` int(11) NOT NULL COMMENT 'Number of days',
  `price` decimal(10,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `application_date` datetime DEFAULT current_timestamp(),
  `expected_feedback_date` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `admin_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applicationprovisionallicense`
--

INSERT INTO `applicationprovisionallicense` (`id`, `full_name`, `email`, `phone`, `national_id`, `service_name`, `processing_time`, `price`, `currency`, `application_date`, `expected_feedback_date`, `status`, `admin_reason`) VALUES
(1, 'AIME', 'jetaime@gmail.com', '0787936791', '1234567890', 'Application for e-Provisional Driving License', 1, 10000.00, 'RWF', '2026-02-24 19:57:47', '2026-02-25 19:57:47', 'Pending', NULL),
(2, 'Keza', 'kezjoana7@gmail.com', '+250789418569', '1', 'Application for e-Provisional Driving License', 1, 10000.00, 'RWF', '2026-03-02 20:14:51', '2026-03-03 20:14:51', 'Approved', 'Your document has been approved');

-- --------------------------------------------------------

--
-- Table structure for table `citizensregistry`
--

CREATE TABLE `citizensregistry` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `date_of_birth` date NOT NULL,
  `national_id` varchar(20) DEFAULT NULL,
  `passport_number` varchar(20) DEFAULT NULL,
  `provisional_driving_number` varchar(20) DEFAULT NULL,
  `driving_license_number` varchar(20) DEFAULT NULL,
  `passport_image` varchar(255) DEFAULT NULL,
  `place_of_birth` varchar(150) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `marital_status` enum('Single','Married','Widowed','Divorced','Other') DEFAULT 'Single',
  `father_name` varchar(150) DEFAULT NULL,
  `mother_name` varchar(150) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `citizensregistry`
--

INSERT INTO `citizensregistry` (`id`, `first_name`, `last_name`, `gender`, `date_of_birth`, `national_id`, `passport_number`, `provisional_driving_number`, `driving_license_number`, `passport_image`, `place_of_birth`, `phone`, `email`, `address`, `marital_status`, `father_name`, `mother_name`, `created_at`, `updated_at`) VALUES
(1, 'Jean Aime', 'NISINGIZWE', 'Male', '2026-02-25', '0', '1', '2', '3', '', 'kigali', '0787936791', 'jetaimetech@gmail.com', 'kigali', 'Single', 'Gatanazi', 'Keza', '2026-02-25 17:11:28', '2026-02-25 17:24:13');

-- --------------------------------------------------------

--
-- Table structure for table `criminalrecordinfo`
--

CREATE TABLE `criminalrecordinfo` (
  `id` int(11) NOT NULL,
  `service_name` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `requirements` text DEFAULT NULL,
  `processing_time` varchar(100) DEFAULT NULL,
  `price` varchar(50) DEFAULT NULL,
  `currency` varchar(20) DEFAULT 'RWF',
  `provided_by` varchar(150) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `criminalrecordinfo`
--

INSERT INTO `criminalrecordinfo` (`id`, `service_name`, `description`, `requirements`, `processing_time`, `price`, `currency`, `provided_by`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Criminal Record Certificate', 'This service allows Rwandans and foreigners living/who have lived in Rwanda to apply for a Criminal Record Certificate. This certificate has a validity of 6 months.', 'This service allows Rwandans and foreigners living/who have lived in Rwanda to apply for a Criminal Record Certificate. This certificate has a validity of 6 months.', '3', '10000', 'RWF', 'RNP', 'Active', '2026-02-25 15:27:15', '2026-02-25 15:27:15');

-- --------------------------------------------------------

--
-- Table structure for table `drivinglicenseinfo`
--

CREATE TABLE `drivinglicenseinfo` (
  `id` int(11) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `requirements` text DEFAULT NULL,
  `processing_time` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT 'RWF',
  `provided_by` varchar(150) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `drivinglicenseinfo`
--

INSERT INTO `drivinglicenseinfo` (`id`, `service_name`, `description`, `requirements`, `processing_time`, `price`, `currency`, `provided_by`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Application for Definitive Driving License', 'This service allows Rwanda citizens who passed the definitive driving test to request their definitive driving license.', 'This service allows Rwanda citizens who passed the definitive driving test to request their definitive driving license.', '14', 50000.00, 'RWF', 'RNP', 'Active', '2026-02-24 09:24:59', '2026-02-24 09:24:59');

-- --------------------------------------------------------

--
-- Table structure for table `goodconductinfo`
--

CREATE TABLE `goodconductinfo` (
  `id` int(11) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `required_attachments` text DEFAULT NULL,
  `processing_time` varchar(100) DEFAULT NULL,
  `price` varchar(100) DEFAULT NULL,
  `provided_by` varchar(150) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `goodconductinfo`
--

INSERT INTO `goodconductinfo` (`id`, `service_name`, `description`, `required_attachments`, `processing_time`, `price`, `provided_by`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Certificate of Good Conduct', 'The certificate is issued to individuals living or who have previously lived in Rwanda to ascertain that they exhibit good community conduct.   ', 'The certificate is issued to individuals living or who have previously lived in Rwanda to ascertain that they exhibit good community conduct.', '7', 'free', 'RIB', 'Active', '2026-02-23 17:06:17', '2026-02-23 17:06:17');

-- --------------------------------------------------------

--
-- Table structure for table `marriageinfo`
--

CREATE TABLE `marriageinfo` (
  `id` int(11) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `requirements` text DEFAULT NULL,
  `processing_time` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT 'RWF',
  `provided_by` varchar(150) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `marriageinfo`
--

INSERT INTO `marriageinfo` (`id`, `service_name`, `description`, `requirements`, `processing_time`, `price`, `currency`, `provided_by`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Marriage Certificate', 'The marriage Certificate is the official document that identifies that a couple is legally married. The application will be submitted to local government authorities at the sector level for processing where the marriage has been celebrated.                ', 'The marriage Certificate is the official document that identifies that a couple is legally married. The application will be submitted to local government authorities at the sector level for processing where the marriage has been celebrated.                        ', '1', 1000.00, 'RWF', 'MINALOC', 'Active', '2026-02-23 15:10:10', '2026-02-23 15:10:47');

-- --------------------------------------------------------

--
-- Table structure for table `nationalidinfo`
--

CREATE TABLE `nationalidinfo` (
  `id` int(11) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `requirements` text DEFAULT NULL,
  `processing_time` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT 0.00,
  `currency` varchar(10) DEFAULT 'RWF',
  `provided_by` varchar(150) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nationalidinfo`
--

INSERT INTO `nationalidinfo` (`id`, `service_name`, `description`, `requirements`, `processing_time`, `price`, `currency`, `provided_by`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Application for National ID', 'This service enables Rwanda citizens to apply for a national ID. The applicant must have an application number in NIDA offices. A citizen who does not have the application number should carry any Identification and reach out the nearest sector office to request it from the Civil Registration officer (CRO) before applying for the National ID. For any more information, visit: info@nida.gov.rw', 'This service enables Rwanda citizens to apply for a national ID. The applicant must have an application number in NIDA offices. A citizen who does not have the application number should carry any Identification and reach out the nearest sector office to request it from the Civil Registration officer (CRO) before applying for the National ID. For any more information, visit: info@nida.gov.rw', '30', 500.00, 'RWF', 'NIDA', 'Active', '2026-02-23 13:26:17', '2026-02-23 13:26:17');

-- --------------------------------------------------------

--
-- Table structure for table `passportinfo`
--

CREATE TABLE `passportinfo` (
  `id` int(11) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `request_type` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `requirements` text DEFAULT NULL,
  `processing_time` varchar(100) DEFAULT NULL,
  `fee` varchar(255) DEFAULT NULL,
  `provided_by` varchar(150) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `passportinfo`
--

INSERT INTO `passportinfo` (`id`, `service_name`, `request_type`, `description`, `requirements`, `processing_time`, `fee`, `provided_by`, `status`, `created_at`, `updated_at`) VALUES
(1, 'e-Passport Application', 'e-Passport Application', 'This service allows Rwandans to apply for the most recent Rwanda East Africa electronic passport issued by DGIE from 28 June 2019. The Directorate General of Immigration and Emigration issues three types of passports: ordinary, service, and diplomatic passports. You are eligible to apply for this service if: 1. You will be a first-time holder of a Rwandan passport. or 2. You are replacing or renewing a passport, and the type of passport that you are replacing is the discontinued, dark blue passport, issued by DGIE before 28 June 2019.\r\n\r\n                ', 'This service allows Rwandans to apply for the most recent Rwanda East Africa electronic passport issued by DGIE from 28 June 2019. The Directorate General of Immigration and Emigration issues three types of passports: ordinary, service, and diplomatic passports. You are eligible to apply for this service if: 1. You will be a first-time holder of a Rwandan passport. or 2. You are replacing or renewing a passport, and the type of passport that you are replacing is the discontinued, dark blue passport, issued by DGIE before 28 June 2019.                ', '4', '100000', 'DGIW', 'Active', '2026-02-23 13:46:09', '2026-02-23 13:48:41');

-- --------------------------------------------------------

--
-- Table structure for table `provisionaldrivinginfo`
--

CREATE TABLE `provisionaldrivinginfo` (
  `id` int(11) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `requirements` text DEFAULT NULL,
  `processing_time` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT 'RWF',
  `provided_by` varchar(150) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `provisionaldrivinginfo`
--

INSERT INTO `provisionaldrivinginfo` (`id`, `service_name`, `description`, `requirements`, `processing_time`, `price`, `currency`, `provided_by`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Application for e-Provisional Driving License', 'The e-provisional license is an e-document issued on IremboGov certifying that a citizen has passed their provisional driving test. This service allows Rwandan citizens of age or a foreigner with a resident ID who passed the provisional driving test to request, pay, and have their e-provisional license generated.', 'The e-provisional license is an e-document issued on IremboGov certifying that a citizen has passed their provisional driving test. This service allows Rwandan citizens of age or a foreigner with a resident ID who passed the provisional driving test to request, pay, and have their e-provisional license generated.', '1', 10000.00, 'RWF', 'RNP', 'Active', '2026-02-24 18:54:18', '2026-02-24 18:54:18');

-- --------------------------------------------------------

--
-- Table structure for table `systeminfo`
--

CREATE TABLE `systeminfo` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `termsofuse` longtext DEFAULT NULL,
  `privacypolicy` longtext DEFAULT NULL,
  `aboutsystem` longtext DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `nationalid` varchar(255) DEFAULT NULL,
  `drivinglicense` varchar(255) DEFAULT NULL,
  `passport` varchar(255) DEFAULT NULL,
  `marriagecertificate` varchar(255) DEFAULT NULL,
  `goodconduct` varchar(255) DEFAULT NULL,
  `provisionaldriving` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `systeminfo`
--

INSERT INTO `systeminfo` (`id`, `name`, `termsofuse`, `privacypolicy`, `aboutsystem`, `icon`, `logo`, `nationalid`, `drivinglicense`, `passport`, `marriagecertificate`, `goodconduct`, `provisionaldriving`, `created_at`) VALUES
(1, 'IremboGov', 'By accessing and using this Platform, you agree to comply with and be bound by these Terms of Use. The Platform provides digital services that allow users to apply for and access government and related services. Users are responsible for maintaining the confidentiality of their account credentials and for all activities conducted under their accounts. Unauthorized use, misuse of information, or any activity that violates applicable laws and regulations may result in suspension or termination of access. By continuing to use the Platform, you acknowledge that you have read, understood, and agreed to these terms.', 'We are committed to protecting your privacy and ensuring the security of your personal data. We collect and process personal information such as your name, contact details, identification numbers, and usage data strictly for the purpose of delivering services, managing your account, and complying with legal obligations. Your information is handled securely and will only be shared with authorized service providers, affiliates, or public authorities when required by law or with your consent. You have the right to access, correct, restrict, or request deletion of your personal data in accordance with applicable data protection laws.', 'Irembo Ltd operates the IremboGov platform, a secure digital gateway that enables citizens, residents, and businesses to access government services online. The system is designed to simplify service delivery by reducing paperwork, minimizing physical visits to offices, and improving efficiency through technology. Users can apply for various public services, make payments electronically, and track application progress in real time. The platform is built with a strong focus on accessibility, transparency, data protection, and user convenience, supporting Rwanda’s vision of digital transformation and improved public service delivery.', '', '', 'system_699d69026faa0.jpg', 'system_699d690270516.jpg', 'system_699d6955a5fe7.jpg', '', '', '', '2026-02-23 12:41:32');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `account_type` enum('Phone','Email') NOT NULL,
  `status` enum('Active','Inactive','Blocked') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `phone`, `email`, `password`, `account_type`, `status`, `created_at`, `updated_at`) VALUES
(2, '+250787936791', 'jetaimetech@gmail.com', '$2y$10$W5/7vpqYW80kMV4t5lnrLexl9XP0rRavLv6X0aYdy57OAnTAU.9au', '', 'Active', '2026-02-26 10:57:42', '2026-02-27 09:44:01'),
(3, '+250789418569', 'kezjoana7@gmail.com', '$2y$10$.7E4GRGuZGe5sek4uOGS5ugaUrQ0w.2XO.yS5oXxudgM0t6.h7zla', '', 'Active', '2026-03-02 19:11:28', '2026-03-02 19:11:28');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `applicationcriminalrecord`
--
ALTER TABLE `applicationcriminalrecord`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `applicationdrivinglicense`
--
ALTER TABLE `applicationdrivinglicense`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `applicationdrivingreplacement`
--
ALTER TABLE `applicationdrivingreplacement`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `applicationgoodconduct`
--
ALTER TABLE `applicationgoodconduct`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `applicationmarriagecertificate`
--
ALTER TABLE `applicationmarriagecertificate`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `applicationnationalid`
--
ALTER TABLE `applicationnationalid`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `applicationpassport`
--
ALTER TABLE `applicationpassport`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `applicationpassportreplacement`
--
ALTER TABLE `applicationpassportreplacement`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `applicationprovisionallicense`
--
ALTER TABLE `applicationprovisionallicense`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `citizensregistry`
--
ALTER TABLE `citizensregistry`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `national_id` (`national_id`),
  ADD UNIQUE KEY `passport_number` (`passport_number`),
  ADD UNIQUE KEY `provisional_driving_number` (`provisional_driving_number`),
  ADD UNIQUE KEY `driving_license_number` (`driving_license_number`);

--
-- Indexes for table `criminalrecordinfo`
--
ALTER TABLE `criminalrecordinfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `drivinglicenseinfo`
--
ALTER TABLE `drivinglicenseinfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `goodconductinfo`
--
ALTER TABLE `goodconductinfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `marriageinfo`
--
ALTER TABLE `marriageinfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nationalidinfo`
--
ALTER TABLE `nationalidinfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `passportinfo`
--
ALTER TABLE `passportinfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `provisionaldrivinginfo`
--
ALTER TABLE `provisionaldrivinginfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `systeminfo`
--
ALTER TABLE `systeminfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone_2` (`phone`),
  ADD UNIQUE KEY `email_2` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `applicationcriminalrecord`
--
ALTER TABLE `applicationcriminalrecord`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `applicationdrivinglicense`
--
ALTER TABLE `applicationdrivinglicense`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `applicationdrivingreplacement`
--
ALTER TABLE `applicationdrivingreplacement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `applicationgoodconduct`
--
ALTER TABLE `applicationgoodconduct`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `applicationmarriagecertificate`
--
ALTER TABLE `applicationmarriagecertificate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `applicationnationalid`
--
ALTER TABLE `applicationnationalid`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `applicationpassport`
--
ALTER TABLE `applicationpassport`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `applicationpassportreplacement`
--
ALTER TABLE `applicationpassportreplacement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `applicationprovisionallicense`
--
ALTER TABLE `applicationprovisionallicense`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `citizensregistry`
--
ALTER TABLE `citizensregistry`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `criminalrecordinfo`
--
ALTER TABLE `criminalrecordinfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `drivinglicenseinfo`
--
ALTER TABLE `drivinglicenseinfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `goodconductinfo`
--
ALTER TABLE `goodconductinfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `marriageinfo`
--
ALTER TABLE `marriageinfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nationalidinfo`
--
ALTER TABLE `nationalidinfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `passportinfo`
--
ALTER TABLE `passportinfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `provisionaldrivinginfo`
--
ALTER TABLE `provisionaldrivinginfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `systeminfo`
--
ALTER TABLE `systeminfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
