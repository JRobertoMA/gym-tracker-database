SET
  NAMES utf8;

SET
  time_zone = '+00:00';

SET
  foreign_key_checks = 0;

SET
  sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET
  NAMES utf8mb4;

DROP TABLE IF EXISTS `api_tokens`;

CREATE TABLE
  `api_tokens` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `user_id` int (10) unsigned NOT NULL,
    `token` char(64) NOT NULL,
    `last_used_at` datetime DEFAULT NULL,
    `expires_at` datetime DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_api_tokens_token` (`token`),
    KEY `fk_api_tokens_user` (`user_id`),
    CONSTRAINT `fk_api_tokens_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `block_exercises`;

CREATE TABLE
  `block_exercises` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `block_id` int (10) unsigned NOT NULL,
    `exercise_id` int (10) unsigned NOT NULL,
    `exercise_order` tinyint (3) unsigned DEFAULT NULL,
    `sets_override` tinyint (3) unsigned DEFAULT NULL,
    `reps_override` tinyint (3) unsigned DEFAULT NULL,
    `rest_override` smallint (5) unsigned DEFAULT NULL,
    `method_override` varchar(150) DEFAULT NULL,
    `organization_override` enum (
      'Circuito',
      'Estaciones',
      'Triserie',
      'Superserie',
      'N/A'
    ) DEFAULT NULL,
    `notes` varchar(200) DEFAULT NULL,
    `duration_override_sec` smallint (5) unsigned DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `block_id` (`block_id`),
    KEY `exercise_id` (`exercise_id`),
    CONSTRAINT `1` FOREIGN KEY (`block_id`) REFERENCES `training_blocks` (`id`),
    CONSTRAINT `2` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `exercises`;

CREATE TABLE
  `exercises` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `muscle_group_id` tinyint (3) unsigned NOT NULL,
    `name` varchar(150) NOT NULL,
    `organization` enum (
      'N/A',
      'Circuito',
      'Estaciones',
      'Biserie',
      'Triserie',
      'Superserie'
    ) NOT NULL DEFAULT 'N/A',
    `method` varchar(150) DEFAULT NULL,
    `default_sets` tinyint (3) unsigned DEFAULT NULL,
    `default_reps` tinyint (3) unsigned DEFAULT NULL,
    `default_rest_sec` smallint (5) unsigned DEFAULT NULL,
    `notes` text DEFAULT NULL,
    `tracking_type` enum ('reps', 'time') NOT NULL DEFAULT 'reps',
    PRIMARY KEY (`id`),
    KEY `muscle_group_id` (`muscle_group_id`),
    CONSTRAINT `1` FOREIGN KEY (`muscle_group_id`) REFERENCES `muscle_groups` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `foods`;

CREATE TABLE
  `foods` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(150) NOT NULL,
    `brand` varchar(100) DEFAULT NULL,
    `calories_kcal` decimal(6, 2) NOT NULL DEFAULT 0.00,
    `protein_g` decimal(5, 2) NOT NULL DEFAULT 0.00,
    `carbs_g` decimal(5, 2) NOT NULL DEFAULT 0.00,
    `fat_g` decimal(5, 2) NOT NULL DEFAULT 0.00,
    `fiber_g` decimal(5, 2) DEFAULT NULL,
    `serving_size_g` decimal(6, 2) DEFAULT NULL,
    `serving_unit` varchar(30) DEFAULT NULL,
    `category` enum (
      'Proteína',
      'Carbohidrato',
      'Grasa',
      'Fruta',
      'Vegetal',
      'Lácteo',
      'Suplemento',
      'Otro'
    ) DEFAULT 'Otro',
    `notes` text DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `meals`;

CREATE TABLE
  `meals` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `plan_id` int (10) unsigned NOT NULL,
    `meal_order` tinyint (3) unsigned NOT NULL,
    `name` varchar(80) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `plan_id` (`plan_id`),
    CONSTRAINT `1` FOREIGN KEY (`plan_id`) REFERENCES `nutrition_plans` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `meal_options`;

CREATE TABLE
  `meal_options` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `meal_id` int (10) unsigned NOT NULL,
    `option_number` tinyint (3) unsigned NOT NULL,
    `notes` text DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `meal_id` (`meal_id`),
    CONSTRAINT `1` FOREIGN KEY (`meal_id`) REFERENCES `meals` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `meal_option_foods`;

CREATE TABLE
  `meal_option_foods` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `meal_option_id` int (10) unsigned NOT NULL,
    `food_id` int (10) unsigned NOT NULL,
    `quantity_g` decimal(6, 2) NOT NULL,
    `preparation` varchar(100) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `meal_option_id` (`meal_option_id`),
    KEY `food_id` (`food_id`),
    CONSTRAINT `1` FOREIGN KEY (`meal_option_id`) REFERENCES `meal_options` (`id`),
    CONSTRAINT `2` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `measurements`;

CREATE TABLE
  `measurements` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `user_id` int (10) unsigned NOT NULL,
    `measured_at` date NOT NULL,
    `weight_kg` decimal(5, 2) DEFAULT NULL,
    `body_fat_pct` decimal(4, 2) DEFAULT NULL,
    `muscle_pct` decimal(4, 2) DEFAULT NULL,
    `visceral_fat` tinyint (3) unsigned DEFAULT NULL,
    `bmi` decimal(4, 2) DEFAULT NULL,
    `neck_cm` decimal(5, 2) DEFAULT NULL,
    `arm_right_cm` decimal(5, 2) DEFAULT NULL,
    `arm_left_cm` decimal(5, 2) DEFAULT NULL,
    `waist_cm` decimal(5, 2) DEFAULT NULL,
    `hip_cm` decimal(5, 2) DEFAULT NULL,
    `leg_right_cm` decimal(5, 2) DEFAULT NULL,
    `leg_left_cm` decimal(5, 2) DEFAULT NULL,
    `calves_cm` decimal(5, 2) DEFAULT NULL,
    `chest_cm` decimal(5, 2) DEFAULT NULL,
    `maintenance_kcal` smallint (5) unsigned DEFAULT NULL,
    `diet_kcal` smallint (5) unsigned DEFAULT NULL,
    `training_goal` varchar(150) DEFAULT NULL,
    `notes` text DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `user_id` (`user_id`),
    CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `muscle_groups`;

CREATE TABLE
  `muscle_groups` (
    `id` tinyint (3) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `nutrition_plans`;

CREATE TABLE
  `nutrition_plans` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `user_id` int (10) unsigned NOT NULL,
    `plan_month` date NOT NULL,
    `target_kcal` smallint (5) unsigned DEFAULT NULL,
    `protein_g` smallint (5) unsigned DEFAULT NULL,
    `carbs_g` smallint (5) unsigned DEFAULT NULL,
    `fat_g` smallint (5) unsigned DEFAULT NULL,
    `active` tinyint (1) DEFAULT 0,
    `is_draft` tinyint (1) NOT NULL DEFAULT 0,
    `notes` text DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `user_id` (`user_id`),
    CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `session_sets`;

CREATE TABLE
  `session_sets` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `session_id` int (10) unsigned NOT NULL,
    `exercise_id` int (10) unsigned NOT NULL,
    `set_number` tinyint (3) unsigned NOT NULL,
    `weight_kg` decimal(6, 2) DEFAULT NULL,
    `reps` tinyint (3) unsigned DEFAULT NULL,
    `rir` tinyint (3) unsigned DEFAULT NULL,
    `notes` varchar(200) DEFAULT NULL,
    `duration_sec` smallint (5) unsigned DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `session_id` (`session_id`),
    KEY `exercise_id` (`exercise_id`),
    CONSTRAINT `1` FOREIGN KEY (`session_id`) REFERENCES `workout_sessions` (`id`),
    CONSTRAINT `2` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `supplement_entries`;

CREATE TABLE
  `supplement_entries` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `plan_id` int (10) unsigned NOT NULL,
    `supplement_name` varchar(100) NOT NULL,
    `dose` varchar(100) DEFAULT NULL,
    `timing` varchar(150) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `plan_id` (`plan_id`),
    CONSTRAINT `1` FOREIGN KEY (`plan_id`) REFERENCES `supplement_plans` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `supplement_plans`;

CREATE TABLE
  `supplement_plans` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `user_id` int (10) unsigned NOT NULL,
    `plan_month` date NOT NULL,
    `active` tinyint (1) DEFAULT 0,
    `is_draft` tinyint (1) NOT NULL DEFAULT 0,
    `notes` text DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `user_id` (`user_id`),
    CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `training_blocks`;

CREATE TABLE
  `training_blocks` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `plan_id` int (10) unsigned NOT NULL,
    `block_order` tinyint (3) unsigned NOT NULL,
    `name` varchar(50) DEFAULT NULL,
    `assigned_days` varchar(20) DEFAULT NULL,
    `focus` varchar(100) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `plan_id` (`plan_id`),
    CONSTRAINT `1` FOREIGN KEY (`plan_id`) REFERENCES `training_plans` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `training_plans`;

CREATE TABLE
  `training_plans` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `user_id` int (10) unsigned NOT NULL,
    `name` varchar(100) NOT NULL,
    `start_date` date DEFAULT NULL,
    `end_date` date DEFAULT NULL,
    `active` tinyint (1) DEFAULT 0,
    `is_draft` tinyint (1) NOT NULL DEFAULT 0,
    `notes` text DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `user_id` (`user_id`),
    CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `users`;

CREATE TABLE
  `users` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(100) NOT NULL,
    `email` varchar(150) NOT NULL DEFAULT '',
    `password_hash` varchar(255) NOT NULL DEFAULT '',
    `role` enum ('admin', 'user') NOT NULL DEFAULT 'user',
    `is_active` tinyint (1) NOT NULL DEFAULT 1,
    `birthdate` date DEFAULT NULL,
    `gender` enum ('male', 'female', 'other') DEFAULT 'male',
    `height_cm` decimal(5, 2) DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_users_email` (`email`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `workout_sessions`;

CREATE TABLE
  `workout_sessions` (
    `id` int (10) unsigned NOT NULL AUTO_INCREMENT,
    `user_id` int (10) unsigned NOT NULL,
    `block_id` int (10) unsigned DEFAULT NULL,
    `session_date` date NOT NULL,
    `duration_min` smallint (5) unsigned DEFAULT NULL,
    `notes` text DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `user_id` (`user_id`),
    KEY `block_id` (`block_id`),
    CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    CONSTRAINT `2` FOREIGN KEY (`block_id`) REFERENCES `training_blocks` (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;