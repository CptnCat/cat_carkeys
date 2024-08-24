CREATE TABLE IF NOT EXISTS `temp_vehicle_keys` (
  `identifier` varchar(255) DEFAULT NULL,
  `plate` varchar(12) NOT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;