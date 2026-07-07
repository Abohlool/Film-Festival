PRAGMA foreign_keys = ON;

-- =====================================================
-- TABLES
-- =====================================================

-- Festival
CREATE TABLE IF NOT EXISTS `festival` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `title` TEXT NOT NULL,
    `year` INTEGER NOT NULL CHECK(`year` >= 1888),
    `location` TEXT DEFAULT 'unavailable',
    UNIQUE (`title`, `year`)
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
    `type` TEXT NOT NULL CHECK(`type` IN ('judge', 'coordinator')),
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
    `final_score` INTEGER DEFAULT 0 CHECK(`final_score` BETWEEN 0 AND 100),

    FOREIGN KEY(`category_id`) REFERENCES `category`(`id`)
);

-- Screening
-- film-screenings (1:N)
-- coordinator-screening (1:1)
CREATE TABLE IF NOT EXISTS `screening` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,

    `date` TEXT,
    `time` TEXT,
    `room` TEXT,

    `capacity` INTEGER CHECK(`capacity` >= 0),

    `film_id` INTEGER NOT NULL,
    `coordinator_id` INTEGER NOT NULL,

    UNIQUE (`room`, `date`, `time`),
    UNIQUE (`coordinator_id`, `date`, `time`),

    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`)
        ON DELETE CASCADE,                                          -- Deleting a film removes all its screenings

    FOREIGN KEY(`coordinator_id`) REFERENCES `staff`(`id`)
);

-- Festival-Category (M:N)
CREATE TABLE IF NOT EXISTS `festival_category` (
    `festival_id` INTEGER NOT NULL,
    `category_id` INTEGER NOT NULL,

    PRIMARY KEY (`festival_id`, `category_id`),

    FOREIGN KEY(`festival_id`) REFERENCES `festival`(`id`)
        ON DELETE CASCADE,                                          -- Deleting a festival removes all its entries

    FOREIGN KEY(`category_id`) REFERENCES `category`(`id`)
        ON DELETE CASCADE                                           -- Deleting a category removes its festival associations 
);

-- Director-Film (M:N)
CREATE TABLE IF NOT EXISTS `film_director` (
    `film_id` INTEGER NOT NULL,
    `director_id` INTEGER NOT NULL,

    PRIMARY KEY (`film_id`, `director_id`),

    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`)
        ON DELETE CASCADE,                                          -- Deleting a film removes its director associations

    FOREIGN KEY(`director_id`) REFERENCES `person`(`id`)
        ON DELETE CASCADE                                           -- Deleting a director will remove
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

    PRIMARY KEY (`judge_id`, `film_id`),

    FOREIGN KEY(`judge_id`) REFERENCES `staff`(`id`)
        ON DELETE CASCADE,

    FOREIGN KEY(`film_id`) REFERENCES `film`(`id`)
        ON DELETE CASCADE
);

-- Festival-Film (N:M)
CREATE TABLE IF NOT EXISTS `festival_film` (
    `festival_id` INTEGER NOT NULL,
    `film_id` INTEGER NOT NULL,

    PRIMARY KEY (`festival_id`, `film_id`),

    FOREIGN KEY (`festival_id`)
        REFERENCES `festival`(`id`)
        ON DELETE CASCADE,

    FOREIGN KEY (`film_id`)
        REFERENCES `film`(`id`)
        ON DELETE CASCADE
);

-- =====================================================
-- INDEXES
-- =====================================================

-- Index for film title searches
CREATE INDEX IF NOT EXISTS `idx_film_title`
ON `film`(`title`);

-- Index for actor/director name searches
CREATE INDEX IF NOT EXISTS `idx_person_type_name`
ON `person`(`type`, `name`);


-- =====================================================
-- VIEWS
-- =====================================================

-- Directors
CREATE VIEW IF NOT EXISTS `director` AS
SELECT
    `id`,
    `name`
FROM `person`
WHERE `type` = 'director';


-- Actors
CREATE VIEW IF NOT EXISTS `actor` AS
SELECT
    `id`,
    `name`
FROM `person`
WHERE `type` = 'actor';


-- Judges
CREATE VIEW IF NOT EXISTS `judge` AS
SELECT
    `id`,
    `name`,
    `specialization`
FROM `staff`
WHERE `type` = 'judge';


-- Coordinators
CREATE VIEW IF NOT EXISTS `coordinator` AS
SELECT
    `id`,
    `name`
FROM `staff`
WHERE `type` = 'coordinator';

-- =====================================================
-- TRIGERS
-- =====================================================

-- Update final score after a new evaluation
CREATE TRIGGER IF NOT EXISTS `trg_evaluation_insert`
AFTER INSERT ON `evaluation`
BEGIN
    UPDATE `film`
    SET `final_score` = (
        SELECT ROUND(AVG(`score`))
        FROM `evaluation`
        WHERE `film_id` = NEW.`film_id`
    )
    WHERE `id` = NEW.`film_id`;
END;


-- Update final score after an evaluation changes
CREATE TRIGGER IF NOT EXISTS `trg_evaluation_update`
AFTER UPDATE OF `score` ON `evaluation`
BEGIN
    UPDATE `film`
    SET `final_score` = (
        SELECT ROUND(AVG(`score`))
        FROM `evaluation`
        WHERE `film_id` = NEW.`film_id`
    )
    WHERE `id` = NEW.`film_id`;
END;


-- Update final score after an evaluation is removed
CREATE TRIGGER IF NOT EXISTS `trg_evaluation_delete`
AFTER DELETE ON `evaluation`
BEGIN
    UPDATE `film`
    SET `final_score` = COALESCE(                                   -- returns 0 If last evaluation is removed
        (
            SELECT ROUND(AVG(`score`))
            FROM `evaluation`
            WHERE `film_id` = OLD.`film_id`
        ),
        0
    )
    WHERE `id` = OLD.`film_id`;
END;
