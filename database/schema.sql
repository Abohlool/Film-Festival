-- Festival Table
CREATE TABLE IF NOT EXISTS `festival` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `title` VARCHAR(256) NOT NULL,
    `year` INTEGER NOT NULL,
    `location` TEXT DEFAULT 'unavailable'
);

-- Category Table
CREATE TABLE IF NOT EXISTS `category` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `name` VARCHAR(64) NOT NULL
);

-- Person Table (Directors & Actors)
CREATE TABLE IF NOT EXISTS `person` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `type` TEXT NOT NULL CHECK(`type` IN ('director', 'actor'))
);

-- Film Table
CREATE TABLE IF NOT EXISTS `film` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `title` VARCHAR(128) NOT NULL,
    `duration` INTEGER NOT NULL,
    `year` INTEGER NOT NULL,
    `country` VARCHAR(64) NOT NULL
);

-- Staff Table (Judges & Coordinators)
CREATE TABLE IF NOT EXISTS `staff` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `type` TEXT NOT NULL CHECK(`type` IN ('judge', 'coordinator'))
);

-- Screening Table 
CREATE TABLE IF NOT EXISTS `screening` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `date` TEXT DEFAULT 'unavailable',
    `time` TEXT DEFAULT 'unavailable',
    `room` VARCHAR(32) DEFAULT 'unavailable',
    `capacity` INTEGER DEFAULT -1,
    `film_id` INTEGER NOT NULL,
    `coordinator_id` INTEGER NOT NULL,
    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`),
    FOREIGN KEY(`coordinator_id`) REFERENCES `staff`(`id`)
);

-- Film to Director Relation (M:N)
CREATE TABLE IF NOT EXISTS `film_director` (
    `film_id` INTEGER NOT NULL,
    `director_id` INTEGER NOT NULL,
    PRIMARY KEY(`film_id`, `director_id`),
    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`),
    FOREIGN KEY(`director_id`) REFERENCES `person`(`id`)
);

-- Film to Actor Relation (M:N)
CREATE TABLE IF NOT EXISTS `film_actor` (
    `film_id` INTEGER NOT NULL,
    `actor_id` INTEGER NOT NULL,
    PRIMARY KEY(`film_id`, `actor_id`),
    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`),
    FOREIGN KEY(`actor_id`) REFERENCES `person`(`id`)
);

-- Evaluation Table (Film to Judge Relation)
CREATE TABLE IF NOT EXISTS `evaluation` (
    `judge_id` INTEGER NOT NULL,
    `film_id` INTEGER NOT NULL,
    `score` INTEGER,
    `final_score` INTEGER,
    PRIMARY KEY(`judge_id`, `film_id`),
    FOREIGN KEY(`judge_id`) REFERENCES `staff`(`id`),
    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`)
);

-- Festival to Category Relation (M:N)
CREATE TABLE IF NOT EXISTS `festival_category` (
    `festival_id` INTEGER NOT NULL,
    `category_id` INTEGER NOT NULL,
    PRIMARY KEY(`festival_id`, `category_id`),
    FOREIGN KEY(`festival_id`) REFERENCES `festival`(`id`),
    FOREIGN KEY(`category_id`) REFERENCES `category`(`id`)
);

-- Film to Category Relation (N:1)
CREATE TABLE IF NOT EXISTS `film_category` (
    `film_id` INTEGER NOT NULL,
    `category_id` INTEGER NOT NULL,
    PRIMARY KEY(`film_id`, `category_id`),
    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`),
    FOREIGN KEY(`category_id`) REFERENCES `category`(`id`)
);
