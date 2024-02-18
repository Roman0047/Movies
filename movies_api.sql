-- Adminer 4.8.1 MySQL 5.7.44 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `adonis_schema`;
CREATE TABLE `adonis_schema` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  `migration_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `adonis_schema` (`id`, `name`, `batch`, `migration_time`) VALUES
(1,	'database/migrations/1699708609418_create_types_tables',	1,	'2024-02-03 10:44:54'),
(2,	'database/migrations/1699708881365_create_users_tables',	1,	'2024-02-03 10:44:54'),
(3,	'database/migrations/1699710316895_create_directors_tables',	1,	'2024-02-03 10:44:54'),
(4,	'database/migrations/1699710346873_create_genres_tables',	1,	'2024-02-03 10:44:54'),
(5,	'database/migrations/1699710981798_create_companies_tables',	1,	'2024-02-03 10:44:54'),
(6,	'database/migrations/1699710996684_create_movies_tables',	1,	'2024-02-03 10:44:55'),
(7,	'database/migrations/1699713602170_create_movies_directors_tables',	1,	'2024-02-03 10:44:55'),
(8,	'database/migrations/1699714706693_create_movies_genres_tables',	1,	'2024-02-03 10:44:56'),
(9,	'database/migrations/1700323166539_jwt_tokens',	1,	'2024-02-03 10:44:56'),
(10,	'database/migrations/1702193993451_create_rating_tables',	1,	'2024-02-03 10:44:57'),
(11,	'database/migrations/1702195894571_create_comments_tables',	1,	'2024-02-03 10:44:57');

DROP TABLE IF EXISTS `adonis_schema_versions`;
CREATE TABLE `adonis_schema_versions` (
  `version` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `adonis_schema_versions` (`version`) VALUES
(2);

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `comment` text NOT NULL,
  `movie_id` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `comments_movie_id_foreign` (`movie_id`),
  KEY `comments_user_id_foreign` (`user_id`),
  CONSTRAINT `comments_movie_id_foreign` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `comments` (`id`, `comment`, `movie_id`, `user_id`, `created_at`, `updated_at`) VALUES
(1,	'I\'m not lazy; I\'m in energy-saving mode.',	3,	1,	'2024-02-03 14:03:15',	'2024-02-03 14:03:15'),
(2,	'I put the \'Pro\' in procrastination.',	5,	1,	'2024-02-03 14:03:30',	'2024-02-03 14:03:30'),
(3,	'My bed is a magical place where I suddenly remember everything I forgot to do.',	9,	1,	'2024-02-03 14:03:48',	'2024-02-03 14:03:48'),
(4,	'I haven\'t lost my mind; it\'s backed up on a hard drive somewhere.',	11,	1,	'2024-02-03 14:04:01',	'2024-02-03 14:04:01'),
(5,	'I\'m on a whiskey diet. I\'ve lost three days already.',	8,	1,	'2024-02-03 14:04:53',	'2024-02-03 14:04:53'),
(6,	'I\'m not arguing; I\'m just explaining why I\'m right.',	4,	2,	'2024-02-03 14:09:03',	'2024-02-03 14:09:03'),
(7,	'I\'m not a vegetarian because I love animals. I\'m a vegetarian because I hate plants.',	10,	2,	'2024-02-03 14:09:17',	'2024-02-03 14:09:17'),
(8,	'I\'m not clumsy; the floor just hates me.',	11,	2,	'2024-02-03 14:09:25',	'2024-02-03 14:09:25'),
(9,	'I don\'t snore; I dream I\'m a motorcycle.',	9,	2,	'2024-02-03 14:10:42',	'2024-02-03 14:10:42'),
(10,	'I\'m not short; I\'m vertically challenged.',	10,	3,	'2024-02-03 14:11:54',	'2024-02-03 14:11:55'),
(11,	'I\'m not short; I\'m vertically challenged.',	8,	3,	'2024-02-03 14:12:08',	'2024-02-03 14:12:08'),
(12,	'I\'m not addicted to chocolate. Chocolate is addicted to me.',	2,	3,	'2024-02-03 14:12:26',	'2024-02-03 14:12:26'),
(13,	'I\'m not a baker because I love kneading; I\'m a baker because I \'knead\' dough.',	5,	4,	'2024-02-03 14:13:32',	'2024-02-03 14:13:32'),
(14,	'I\'m not a baker because I love kneading; I\'m a baker because I \'knead\' dough.',	9,	4,	'2024-02-03 14:13:40',	'2024-02-03 14:13:40'),
(15,	'I\'m not late; I just wanted to make an entrance.',	11,	4,	'2024-02-03 14:13:50',	'2024-02-03 14:13:51'),
(16,	'I don\'t need an alarm clock; my ideas wake me up.',	3,	4,	'2024-02-03 14:14:00',	'2024-02-03 14:14:00'),
(17,	'I\'m not a chef; I\'m an artist on a tight budget.',	6,	4,	'2024-02-03 14:14:10',	'2024-02-03 14:14:10'),
(18,	'I\'m not a morning person or a night owl. I\'m a permanently exhausted pigeon.',	4,	4,	'2024-02-03 14:14:34',	'2024-02-03 14:14:34');

DROP TABLE IF EXISTS `companies`;
CREATE TABLE `companies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `companies_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `companies` (`id`, `name`, `created_at`, `updated_at`) VALUES
(2,	'Netflix',	'2024-02-03 11:38:39',	'2024-02-03 11:38:39'),
(3,	'Disney',	'2024-02-03 11:38:48',	'2024-02-03 11:38:48'),
(4,	'Amazon',	'2024-02-03 11:43:56',	'2024-02-03 11:43:56'),
(5,	'Warner Bros',	'2024-02-03 11:44:01',	'2024-02-03 11:44:01'),
(6,	'Universal Pictures',	'2024-02-03 11:44:07',	'2024-02-03 11:44:07'),
(7,	'Paramount Pictures',	'2024-02-03 11:44:13',	'2024-02-03 11:44:13'),
(8,	'Sony Pictures',	'2024-02-03 11:44:18',	'2024-02-03 11:44:18'),
(9,	'Hulu',	'2024-02-03 11:44:24',	'2024-02-03 11:44:24'),
(10,	'Apple TV+',	'2024-02-03 11:44:29',	'2024-02-03 11:44:29'),
(11,	'ViacomCBS',	'2024-02-03 11:44:33',	'2024-02-03 11:44:33'),
(12,	'MGM',	'2024-02-03 11:44:40',	'2024-02-03 11:44:40');

DROP TABLE IF EXISTS `directors`;
CREATE TABLE `directors` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `bio` text,
  `rewards` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `directors_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `directors` (`id`, `name`, `image`, `bio`, `rewards`, `created_at`, `updated_at`) VALUES
(1,	'Christopher Nolan',	'reLSnkdAja6cPwjY0do75',	'British director Christopher Nolan, known for his intricate storytelling and visionary approach, has crafted mind-bending films such as \"Inception\" and \"The Dark Knight Trilogy,\" earning multiple Academy Award nominations.',	'Multiple Academy Award nominations',	'2024-02-03 12:04:36',	'2024-02-03 12:04:36'),
(2,	'Quentin Tarantino',	'n7vHZTdfCa7yfTEvy8YBF',	'Maverick filmmaker Quentin Tarantino, recognized for his bold and genre-defying works like \"Pulp Fiction\" and \"Kill Bill,\" has garnered two Academy Awards, a Golden Globe, and a BAFTA.',	'Two Academy Awards, Golden Globe, BAFTA',	'2024-02-03 12:05:19',	'2024-02-03 12:05:31'),
(3,	'Steven Spielberg',	'b21BwfF_SY7s3asL-2BR6',	'Iconic director Steven Spielberg, renowned for shaping modern cinema with classics like \"Jurassic Park\" and \"Schindler\'s List,\" has received three Academy Awards, a Golden Globe, and a BAFTA.',	'Three Academy Awards, Golden Globe, BAFTA.',	'2024-02-03 12:06:32',	'2024-02-03 12:06:32'),
(4,	'Martin Scorsese',	'gLwN5H6dyfel2wC16Wr5A',	'Martin Scorsese, a legendary director in the realm of crime epics, with films like \"Goodfellas\" and \"The Irishman,\" has won an Academy Award, a Golden Globe, and a BAFTA.',	'Academy Award, Golden Globe, BAFTA.',	'2024-02-03 12:07:06',	'2024-02-03 12:07:06'),
(5,	'Stanley Kubrick',	'q-r8r5M8BrUIUDjP5IKXg',	'Visionary filmmaker Stanley Kubrick, acclaimed for masterpieces like \"2001: A Space Odyssey\" and \"A Clockwork Orange,\" received an Oscar, a BAFTA, and a Golden Globe during his illustrious career.',	'Oscar, BAFTA, Golden Globe',	'2024-02-03 12:07:31',	'2024-02-03 12:07:31'),
(6,	'Alfred Hitchcock',	'pNdQ7sWy_6220qqiLzRsd',	'Alfred Hitchcock, the master of suspense, left an indelible mark on cinema with classics such as \"Psycho\" and \"Vertigo,\" earning an Academy Honorary Award.',	'Academy Honorary Award',	'2024-02-03 12:07:49',	'2024-02-03 12:07:49'),
(7,	'Francis Ford Coppola',	'WZbwhGa-VajQOTPYCR-Fg',	'Francis Ford Coppola, a five-time Academy Award-winning director, achieved cinematic greatness with \"The Godfather\" trilogy and \"Apocalypse Now.\"',	'Five Academy Awards, Golden Globe',	'2024-02-03 12:08:16',	'2024-02-03 12:08:16'),
(8,	'Akira Kurosawa',	'S2FXeS4W15jU9ehC9x3Q9',	'Japanese maestro Akira Kurosawa, celebrated for timeless classics like \"Seven Samurai\" and \"Rashomon,\" received an Academy Honorary Award for his influential contributions to cinema.',	'Academy Honorary Award',	'2024-02-03 12:08:30',	'2024-02-03 12:08:30'),
(9,	'Ang Lee',	'pn9Ws4wJt1nXssXBoL8Aw',	'Oscar-winning director Ang Lee, known for visually stunning films such as \"Crouching Tiger, Hidden Dragon\" and \"Life of Pi,\" has earned two Academy Awards, a Golden Globe, and a BAFTA.',	'Two Academy Awards, Golden Globe, BAFTA.',	'2024-02-03 12:08:50',	'2024-02-03 12:08:50'),
(10,	'Greta Gerwig',	'O41peIVt2vGUg3K-FPwyA',	'Greta Gerwig, an accomplished actress-turned-director, has made a mark with critically acclaimed films like \"Lady Bird\" and \"Little Women,\" earning Academy Award nominations for her directorial prowess.',	'Academy Award nominations.',	'2024-02-03 12:09:07',	'2024-02-03 12:09:07');

DROP TABLE IF EXISTS `genres`;
CREATE TABLE `genres` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `genres_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `genres` (`id`, `name`, `created_at`, `updated_at`) VALUES
(2,	'Action',	'2024-02-03 11:36:41',	'2024-02-03 11:36:41'),
(3,	'Adventure',	'2024-02-03 11:36:44',	'2024-02-03 11:36:44'),
(4,	'Comedy',	'2024-02-03 11:36:47',	'2024-02-03 11:36:47'),
(5,	'Drama',	'2024-02-03 11:36:50',	'2024-02-03 11:36:50'),
(6,	'Horror',	'2024-02-03 11:36:54',	'2024-02-03 11:36:54'),
(7,	'Science Fiction',	'2024-02-03 11:36:58',	'2024-02-03 11:36:58'),
(8,	'Fantasy',	'2024-02-03 11:37:03',	'2024-02-03 11:37:03'),
(9,	'Romance',	'2024-02-03 11:37:06',	'2024-02-03 11:37:06'),
(10,	'Mystery',	'2024-02-03 11:37:09',	'2024-02-03 11:37:09'),
(11,	'Thriller',	'2024-02-03 11:37:13',	'2024-02-03 11:37:13'),
(12,	'Crime',	'2024-02-03 11:37:16',	'2024-02-03 11:37:16'),
(13,	'Historical',	'2024-02-03 11:37:18',	'2024-02-03 11:37:18'),
(14,	'War',	'2024-02-03 11:37:21',	'2024-02-03 11:37:21'),
(15,	'Western',	'2024-02-03 11:37:24',	'2024-02-03 11:37:24'),
(16,	'Musical',	'2024-02-03 11:37:27',	'2024-02-03 11:37:27'),
(17,	'Documentary',	'2024-02-03 11:37:30',	'2024-02-03 11:37:30'),
(18,	'Biography',	'2024-02-03 11:37:34',	'2024-02-03 11:37:34'),
(19,	'Family',	'2024-02-03 11:37:37',	'2024-02-03 11:37:37'),
(20,	'Sports',	'2024-02-03 11:37:43',	'2024-02-03 11:37:43');

DROP TABLE IF EXISTS `jwt_tokens`;
CREATE TABLE `jwt_tokens` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `jwt_tokens_token_unique` (`token`),
  KEY `jwt_tokens_user_id_foreign` (`user_id`),
  CONSTRAINT `jwt_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `jwt_tokens` (`id`, `user_id`, `name`, `type`, `token`, `expires_at`, `created_at`) VALUES
(1,	1,	'JWT Access Token',	'jwt_refresh_token',	'e6db75f53957f5d2425a609aefea71d3d2fe26882d0538f41e8cf3f17aa149eb',	'2024-03-04 10:52:20',	'2024-02-03 10:52:20'),
(2,	1,	'JWT Access Token',	'jwt_refresh_token',	'49e50aad2d73a9e2ab690661134fbac306b1eedd54a34f4b1e1c2e80d3c51e1b',	'2024-03-04 10:52:20',	'2024-02-03 10:52:20'),
(3,	1,	'JWT Access Token',	'jwt_refresh_token',	'5783d444806bf2c01f477516ccd12e4859a38ae44e91429dabeb00c5e47434c7',	'2024-03-04 10:52:20',	'2024-02-03 10:52:20'),
(4,	2,	'JWT Access Token',	'jwt_refresh_token',	'6561eccd244d13ed7e483830674427dddfb2c850e5cdc7e9f10e18052735037f',	'2024-03-04 14:07:29',	'2024-02-03 14:07:29'),
(5,	2,	'JWT Access Token',	'jwt_refresh_token',	'c4c82cade44f0a6358bcb354296074455b987634edeb053c61c3bc65071a4c5f',	'2024-03-04 14:07:29',	'2024-02-03 14:07:29'),
(6,	2,	'JWT Access Token',	'jwt_refresh_token',	'5e768ddbd07ac7f13df4a2ed9792428b4d919f789bacb9012a03efa6cd80e997',	'2024-03-04 14:07:29',	'2024-02-03 14:07:29'),
(7,	3,	'JWT Access Token',	'jwt_refresh_token',	'90b8b8dd7b86c307784ee5de0a956ea9920f6e45ba7095eaa54ccef4bbb23066',	'2024-03-04 14:11:27',	'2024-02-03 14:11:27'),
(8,	3,	'JWT Access Token',	'jwt_refresh_token',	'c7ed68812404261784b03ee0536061c89ebf986614a0b53b5ee695ed44844499',	'2024-03-04 14:11:27',	'2024-02-03 14:11:27'),
(9,	3,	'JWT Access Token',	'jwt_refresh_token',	'70dbc92cffd139385e7ad64fda3cf5010fb40f3ef0736bbf9d674ec4cff8bfc0',	'2024-03-04 14:11:27',	'2024-02-03 14:11:27'),
(10,	2,	'JWT Access Token',	'jwt_refresh_token',	'c59bd52b8e55111c4aaf0eb276d5a2f81c6b2364331c58b0c95cb22ee9442052',	'2024-03-04 14:12:39',	'2024-02-03 14:12:39'),
(11,	4,	'JWT Access Token',	'jwt_refresh_token',	'a768b0b7bff20195f8188cfdefc982469c121608619f790b5fce249679b025dd',	'2024-03-04 14:13:09',	'2024-02-03 14:13:09'),
(12,	4,	'JWT Access Token',	'jwt_refresh_token',	'1f7819c5d73cb0239d274aa33dc6f8a908fe67f4b276131925f9119422dca0d1',	'2024-03-04 14:13:09',	'2024-02-03 14:13:09'),
(13,	4,	'JWT Access Token',	'jwt_refresh_token',	'60bba9a93e22b1795d4f491357c1b4a38922c648f3860aa79a667b1711276e10',	'2024-03-04 14:13:09',	'2024-02-03 14:13:09');

DROP TABLE IF EXISTS `movies`;
CREATE TABLE `movies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `video` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text,
  `release_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `countries` json NOT NULL,
  `company_id` int(10) unsigned DEFAULT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `movies_name_unique` (`name`),
  KEY `movies_company_id_foreign` (`company_id`),
  KEY `movies_type_id_foreign` (`type_id`),
  CONSTRAINT `movies_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `movies_type_id_foreign` FOREIGN KEY (`type_id`) REFERENCES `types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `movies` (`id`, `name`, `video`, `image`, `description`, `release_date`, `countries`, `company_id`, `type_id`, `created_at`, `updated_at`) VALUES
(2,	'Inception',	'Y3PYANNQGwijtq93pbI9F',	'2WvPH1JIZvxK4NbQIbmgh',	'Inception, directed by Christopher Nolan, is a mind-bending heist thriller that explores the world of dreams. Dom Cobb, played by Leonardo DiCaprio, leads a team of skilled thieves who enter the dreams of others to steal their deepest secrets. As they navigate through layers of subconsciousness, the boundaries between reality and illusion blur, leading to a complex and visually stunning narrative. The film delves into themes of reality, memory, and the power of the mind, creating a cinematic experience that challenges the audience\'s perception.',	'2011-10-05 14:48:00',	'[\"US\", \"GB\"]',	5,	2,	'2024-02-03 12:46:20',	'2024-02-03 13:31:45'),
(3,	'A Clockwork Orange',	'pIDmzOOYqiTRwxyqRxZhl',	'TyOSpfikVjRxskRbia81y',	'\"A Clockwork Orange,\" directed by Stanley Kubrick, is a dystopian crime film based on Anthony Burgess\'s novel. Set in a bleak future, it follows the charismatic and violent delinquent Alex DeLarge as he undergoes an experimental form of aversion therapy to cure his criminal tendencies. The film explores themes of free will, societal control, and the consequences of removing one\'s capacity for choice. Kubrick\'s unique vision and the film\'s provocative content have made it a landmark in cinematic history.',	'2024-02-16 00:00:00',	'[\"AS\", \"AL\"]',	5,	2,	'2024-02-03 13:36:39',	'2024-02-03 13:36:39'),
(4,	'Crouching Tiger, Hidden Dragon',	'RGHMk90MyJfJ0VPlse8uv',	'pfgFD0t2vSUZE4tCBpi7J',	'\"Crouching Tiger, Hidden Dragon,\" directed by Ang Lee, is a martial arts epic set in ancient China. The film revolves around a stolen sword and the intertwined destinies of its various characters, featuring gravity-defying martial arts sequences. The intricate narrative explores themes of love, honor, and the conflict between personal desires and social expectations. With breathtaking visuals and compelling storytelling, the film became a global phenomenon, winning multiple Academy Awards and solidifying its place as a cinematic masterpiece.',	'2021-02-04 00:00:00',	'[\"TD\", \"CL\", \"CX\", \"CN\"]',	8,	2,	'2024-02-03 13:41:42',	'2024-02-03 13:41:42'),
(5,	'Goodfellas',	'PJxuiS9ki6jGt97Q2u_Qy',	'aGrOol4e8D1yGV0Gc_1kx',	'\"Goodfellas,\" directed by Martin Scorsese, is a gritty crime drama based on the life of Henry Hill, a former mobster turned informant. The film follows Hill\'s rise through the ranks of the Italian-American mafia and the challenges he faces within the criminal underworld. Known for its intense performances, sharp dialogue, and Scorsese\'s signature style, \"Goodfellas\" is a compelling exploration of organized crime, loyalty, and the consequences of a life in the Mafia.',	'2019-07-19 00:00:00',	'[\"US\"]',	5,	2,	'2024-02-03 13:43:28',	'2024-02-03 13:43:28'),
(6,	'Jurassic Park',	'dEKXku8uPV5Ys0Lj3BMLq',	'WCjYN8kcL4hczHVi1sjob',	'\"Jurassic Park,\" directed by Steven Spielberg, is a groundbreaking adventure film that brings dinosaurs back to life through advanced genetic engineering. The story unfolds as a group of people, including paleontologists and a mathematician, visit the theme park where cloned dinosaurs roam freely. Chaos ensues when the creatures break free, leading to a thrilling and suspenseful tale of survival. Known for its revolutionary visual effects and Spielberg\'s storytelling prowess, \"Jurassic Park\" remains a classic in the science fiction adventure genre.',	'2017-03-03 00:00:00',	'[\"US\"]',	6,	2,	'2024-02-03 13:49:02',	'2024-02-03 13:49:02'),
(7,	'Kill Bill',	'EIU7WsZy3xz49bBQvrxL0',	'LodT5_g526VbRwCQeq4mX',	'\"Kill Bill,\" directed by Quentin Tarantino, is an epic two-part action thriller. The story follows The Bride, played by Uma Thurman, on a quest for revenge against a group of assassins who betrayed her. Known for its stylized violence, homage to martial arts films, and Tarantino\'s unique storytelling, \"Kill Bill\" is a visually striking and adrenaline-pumping cinematic experience. Split into two volumes, the film showcases Tarantino\'s masterful blend of genres and storytelling techniques.',	'2024-02-14 00:00:00',	'[\"AO\"]',	8,	2,	'2024-02-03 13:52:30',	'2024-02-03 13:52:30'),
(8,	'Lady Bird',	'aatC5h_GlfWY3bUiGvBbU',	'xgv9eUOotTieikNfENtJd',	'\"Lady Bird,\" directed by Greta Gerwig, is a coming-of-age comedy-drama that follows the tumultuous senior year of high school for Christine \"Lady Bird\" McPherson, played by Saoirse Ronan. Set in Sacramento, California, the film explores Lady Bird\'s relationships with her family, friends, and the challenges of self-discovery. Gerwig\'s directorial debut received critical acclaim for its authenticity, humor, and heartfelt portrayal of the complexities of adolescence and the mother-daughter dynamic.',	'2024-02-14 00:00:00',	'[\"CO\"]',	6,	2,	'2024-02-03 13:54:10',	'2024-02-03 13:54:10'),
(9,	'Psycho',	'ywpM0RCt0ItR5SgEyVbdh',	'ksS3bP_7hHmHEqaMZLZtO',	'\"Psycho,\" directed by Alfred Hitchcock, is a classic horror-thriller that follows Marion Crane, played by Janet Leigh, as she checks into the Bates Motel, managed by the mysterious Norman Bates, portrayed by Anthony Perkins. The film is known for its iconic shower scene and Hitchcock\'s masterful suspense-building techniques. \"Psycho\" is a landmark in cinema, redefining the horror genre and leaving an indelible mark on film history.',	'2024-02-13 00:00:00',	'[\"US\"]',	7,	2,	'2024-02-03 13:55:46',	'2024-02-03 13:55:47'),
(10,	'Rashomon',	'hqeLkK7BNP8q9QqqegIwV',	'5s9SABTTdIiFsmSXUI8VT',	'\"Rashomon,\" directed by Akira Kurosawa, is a landmark Japanese film that explores the subjectivity of truth. The story revolves around a crime, told through the perspectives of four different characters. Each account presents a different version of events, challenging the audience to question the nature of reality and perception. Known for its innovative narrative structure and powerful storytelling, \"Rashomon\" is a timeless cinematic classic.',	'2024-02-21 00:00:00',	'[\"JP\"]',	11,	2,	'2024-02-03 13:57:09',	'2024-02-03 13:57:09'),
(11,	'The Godfather',	'NfNB_3iU5uXCGMmMeTkXz',	'1vi-3UOusXKJ2pPnmI4ij',	'\"The Godfather,\" directed by Francis Ford Coppola, is a seminal crime drama based on Mario Puzo\'s novel. The film follows the powerful Corleone mafia family and the patriarch, Vito Corleone, played by Marlon Brando. The story explores themes of power, loyalty, and the consequences of a life in organized crime. Known for its stellar ensemble cast, including Al Pacino and Robert De Niro, \"The Godfather\" is celebrated for its intricate storytelling, memorable characters, and lasting impact on cinema.',	'2024-02-14 00:00:00',	'[\"US\"]',	7,	2,	'2024-02-03 13:59:35',	'2024-02-03 13:59:35');

DROP TABLE IF EXISTS `movies_directors`;
CREATE TABLE `movies_directors` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movie_id` int(10) unsigned DEFAULT NULL,
  `director_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `movies_directors_movie_id_foreign` (`movie_id`),
  KEY `movies_directors_director_id_foreign` (`director_id`),
  CONSTRAINT `movies_directors_director_id_foreign` FOREIGN KEY (`director_id`) REFERENCES `directors` (`id`),
  CONSTRAINT `movies_directors_movie_id_foreign` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `movies_directors` (`id`, `movie_id`, `director_id`, `created_at`, `updated_at`) VALUES
(8,	2,	1,	'2024-02-03 13:31:45',	'2024-02-03 13:31:45'),
(9,	3,	5,	'2024-02-03 13:36:39',	'2024-02-03 13:36:39'),
(10,	4,	9,	'2024-02-03 13:41:42',	'2024-02-03 13:41:42'),
(11,	5,	4,	'2024-02-03 13:43:28',	'2024-02-03 13:43:28'),
(12,	6,	3,	'2024-02-03 13:49:02',	'2024-02-03 13:49:02'),
(13,	7,	2,	'2024-02-03 13:52:30',	'2024-02-03 13:52:30'),
(14,	8,	10,	'2024-02-03 13:54:10',	'2024-02-03 13:54:10'),
(15,	9,	6,	'2024-02-03 13:55:47',	'2024-02-03 13:55:47'),
(16,	10,	8,	'2024-02-03 13:57:09',	'2024-02-03 13:57:09'),
(17,	11,	5,	'2024-02-03 13:59:35',	'2024-02-03 13:59:35'),
(18,	11,	7,	'2024-02-03 13:59:35',	'2024-02-03 13:59:35');

DROP TABLE IF EXISTS `movies_genres`;
CREATE TABLE `movies_genres` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movie_id` int(10) unsigned DEFAULT NULL,
  `genre_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `movies_genres_movie_id_foreign` (`movie_id`),
  KEY `movies_genres_genre_id_foreign` (`genre_id`),
  CONSTRAINT `movies_genres_genre_id_foreign` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`),
  CONSTRAINT `movies_genres_movie_id_foreign` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `movies_genres` (`id`, `movie_id`, `genre_id`, `created_at`, `updated_at`) VALUES
(18,	2,	2,	'2024-02-03 13:31:45',	'2024-02-03 13:31:45'),
(19,	2,	7,	'2024-02-03 13:31:45',	'2024-02-03 13:31:45'),
(20,	2,	3,	'2024-02-03 13:31:45',	'2024-02-03 13:31:45'),
(21,	2,	11,	'2024-02-03 13:31:45',	'2024-02-03 13:31:45'),
(22,	3,	12,	'2024-02-03 13:36:39',	'2024-02-03 13:36:39'),
(23,	3,	5,	'2024-02-03 13:36:39',	'2024-02-03 13:36:39'),
(24,	4,	2,	'2024-02-03 13:41:42',	'2024-02-03 13:41:42'),
(25,	4,	3,	'2024-02-03 13:41:42',	'2024-02-03 13:41:42'),
(26,	4,	8,	'2024-02-03 13:41:42',	'2024-02-03 13:41:42'),
(27,	5,	5,	'2024-02-03 13:43:28',	'2024-02-03 13:43:28'),
(28,	5,	12,	'2024-02-03 13:43:28',	'2024-02-03 13:43:28'),
(29,	5,	18,	'2024-02-03 13:43:28',	'2024-02-03 13:43:28'),
(30,	6,	3,	'2024-02-03 13:49:02',	'2024-02-03 13:49:02'),
(31,	6,	7,	'2024-02-03 13:49:02',	'2024-02-03 13:49:02'),
(32,	7,	2,	'2024-02-03 13:52:30',	'2024-02-03 13:52:30'),
(33,	7,	12,	'2024-02-03 13:52:30',	'2024-02-03 13:52:30'),
(34,	7,	11,	'2024-02-03 13:52:30',	'2024-02-03 13:52:30'),
(35,	8,	4,	'2024-02-03 13:54:10',	'2024-02-03 13:54:10'),
(36,	8,	5,	'2024-02-03 13:54:10',	'2024-02-03 13:54:10'),
(37,	9,	6,	'2024-02-03 13:55:47',	'2024-02-03 13:55:47'),
(38,	9,	10,	'2024-02-03 13:55:47',	'2024-02-03 13:55:47'),
(39,	9,	11,	'2024-02-03 13:55:47',	'2024-02-03 13:55:47'),
(40,	10,	5,	'2024-02-03 13:57:09',	'2024-02-03 13:57:09'),
(41,	10,	10,	'2024-02-03 13:57:09',	'2024-02-03 13:57:09'),
(42,	10,	12,	'2024-02-03 13:57:09',	'2024-02-03 13:57:09'),
(43,	11,	5,	'2024-02-03 13:59:35',	'2024-02-03 13:59:35'),
(44,	11,	12,	'2024-02-03 13:59:35',	'2024-02-03 13:59:35');

DROP TABLE IF EXISTS `ratings`;
CREATE TABLE `ratings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rating` float(8,2) unsigned DEFAULT NULL,
  `movie_id` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ratings_movie_id_foreign` (`movie_id`),
  KEY `ratings_user_id_foreign` (`user_id`),
  CONSTRAINT `ratings_movie_id_foreign` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ratings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `ratings` (`id`, `rating`, `movie_id`, `user_id`, `created_at`, `updated_at`) VALUES
(1,	2.50,	8,	1,	'2024-02-03 14:04:56',	'2024-02-03 14:05:15'),
(2,	2.50,	5,	1,	'2024-02-03 14:05:00',	'2024-02-03 14:05:00'),
(3,	1.50,	8,	1,	'2024-02-03 14:05:10',	'2024-02-03 14:05:10'),
(4,	3.00,	3,	1,	'2024-02-03 14:05:27',	'2024-02-03 14:05:36'),
(5,	3.50,	4,	2,	'2024-02-03 14:08:52',	'2024-02-03 14:08:52');

DROP TABLE IF EXISTS `types`;
CREATE TABLE `types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `types_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `types` (`id`, `name`, `created_at`, `updated_at`) VALUES
(2,	'Film',	'2024-02-03 11:32:44',	'2024-02-03 11:32:44'),
(3,	'Animated Movie',	'2024-02-03 11:32:56',	'2024-02-03 11:32:56');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'user',
  `email` varchar(255) NOT NULL,
  `password` varchar(180) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `users` (`id`, `name`, `image`, `role`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1,	'admin@admin.admin',	'5FBmjihhOz6FlUZ3p9tR4',	'admin',	'test@test.test',	'$scrypt$n=16384,r=8,p=1$9zGbzn3DEtRt25MkNg88Vw$Fll9v6NRHQs1KWTBCnsFnsSUoWfjgj8oDzRBV58T/MMIBNkQ4e1PQD6Z/bCCOLGu910EkEw3rnLf4+s5MAnwxA',	'2024-02-03 10:52:20',	'2024-02-03 13:50:42'),
(2,	'bear',	'-xa_LGMzL7O296qDCco0G',	'user',	'bear@bear.bear',	'$scrypt$n=16384,r=8,p=1$Z+qCJRCh7J4hz/dwAnLGTw$aksEzJIY8m1CJo8ERFUeQJbOqwBASzDStcPv9k6yxUnX7rh84S9B8VxQWogxclOmnGRzIdE9YIstZH7ikJq7Hw',	'2024-02-03 14:07:29',	'2024-02-03 14:12:44'),
(3,	'wolf',	'G8V_cc1s2_6_FKCBAPH-h',	'user',	'wolf@wolf.wolf',	'$scrypt$n=16384,r=8,p=1$n9eAZBEC9G95l2H4rKgRAw$YCN5/mcta7y7pd/9JL6ZModGr9BRoyo/uJ7YHM6tMWBnxXZElMboyAgSB5qv27YijlCvn2MDfALjmCJhidSJOQ',	'2024-02-03 14:11:27',	'2024-02-03 14:11:43'),
(4,	'lion',	'Atog9l67jp9I0ihpMLg6X',	'user',	'lion@lion.lion',	'$scrypt$n=16384,r=8,p=1$11o5S/VGUPmxwwBB7aJjwQ$WfMSLbx0WAHv2bDzrz9SCgytFM8OrHNZvVG31vk2eR3DndpP+4AHqh0b2G26SxRZAJ7owictahvJynNgsTp6zA',	'2024-02-03 14:13:09',	'2024-02-03 14:13:20');

-- 2024-02-03 14:15:49
