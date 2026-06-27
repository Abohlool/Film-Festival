PRAGMA foreign_keys = ON;

-- Festival
CREATE TABLE IF NOT EXISTS `festival` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `title` TEXT NOT NULL,
    `year` INTEGER NOT NULL CHECK(`year` >= 1888),
    `location` TEXT DEFAULT 'unavailable',
    UNIQUE(`title`, `year`)
);

-- Category
CREATE TABLE IF NOT EXISTS `category` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `name` TEXT NOT NULL UNIQUE
);

-- Person (Director / Actor)
CREATE TABLE IF NOT EXISTS `person` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `name` TEXT NOT NULL,
    `type` TEXT NOT NULL CHECK(`type` IN ('director', 'actor'))
);

-- Staff (Judge / Coordinator)
CREATE TABLE IF NOT EXISTS `staff` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `name` TEXT NOT NULL,
    `type` TEXT NOT NULL CHECK(`type` IN ('judge', 'coordinator'))
    `specialization` TEXT,
    CHECK (
        (`type` = 'judge')
        OR
        (`type` = 'coordinator' AND `specialization` IS NULL)
    )
);

-- Film (1:N)
CREATE TABLE IF NOT EXISTS `film` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `title` TEXT NOT NULL,
    `duration` INTEGER NOT NULL CHECK(`duration` > 0),
    `year` INTEGER NOT NULL CHECK(`year` >= 1888),
    `country` TEXT NOT NULL,
    `category_id` INTEGER NOT NULL,

    FOREIGN KEY(`category_id`) REFERENCES `category`(`id`)
);

-- Screening
-- film-screenings (1:N)
-- coordinator-screening (1:1)
CREATE TABLE IF NOT EXISTS `screening` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,

    `date` TEXT DEFAULT 'unavailable',
    `time` TEXT DEFAULT 'unavailable',
    `room` TEXT DEFAULT 'unavailable',

    `capacity` INTEGER CHECK(`capacity` >= 0),

    `film_id` INTEGER NOT NULL,
    `coordinator_id` INTEGER NOT NULL UNIQUE,

    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`)
        ON DELETE CASCADE,

    FOREIGN KEY(`coordinator_id`) REFERENCES `staff`(`id`)
);

-- Festival-Category (M:N)
CREATE TABLE IF NOT EXISTS `festival_category` (
    `festival_id` INTEGER NOT NULL,
    `category_id` INTEGER NOT NULL,

    PRIMARY KEY (`festival_id`, `category_id`),

    FOREIGN KEY(`festival_id`) REFERENCES `festival`(`id`)
        ON DELETE CASCADE,

    FOREIGN KEY(`category_id`) REFERENCES `category`(`id`)
        ON DELETE CASCADE
);

-- Director-Film (M:N)
CREATE TABLE IF NOT EXISTS `film_director` (
    `film_id` INTEGER NOT NULL,
    `director_id` INTEGER NOT NULL,

    PRIMARY KEY (`film_id`, `director_id`),

    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`)
        ON DELETE CASCADE,

    FOREIGN KEY(`director_id`) REFERENCES `person`(`id`)
        ON DELETE CASCADE
);

-- Actor-Film (M:N)
CREATE TABLE IF NOT EXISTS `film_actor` (
    `film_id` INTEGER NOT NULL,
    `actor_id` INTEGER NOT NULL,

    PRIMARY KEY (`film_id`, `actor_id`),

    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`)
        ON DELETE CASCADE,

    FOREIGN KEY(`actor_id`) REFERENCES `person`(`id`)
        ON DELETE CASCADE
);

-- Judge-Film (Evaluation)
CREATE TABLE IF NOT EXISTS `evaluation` (
    `judge_id` INTEGER NOT NULL,
    `film_id` INTEGER NOT NULL,

    `score` INTEGER CHECK(`score` BETWEEN 0 AND 100),

    `final_score` INTEGER CHECK(`final_score` BETWEEN 0 AND 100),

    PRIMARY KEY (`judge_id`, `film_id`),

    FOREIGN KEY(`judge_id`) REFERENCES `staff`(`id`)
        ON DELETE CASCADE,

    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`)
        ON DELETE CASCADE
);
