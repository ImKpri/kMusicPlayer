CREATE TABLE `music_history` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `player_name` varchar(255) NOT NULL,
    `url` varchar(512) NOT NULL,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
);
