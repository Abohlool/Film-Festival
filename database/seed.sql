PRAGMA foreign_keys = ON;

-- ===== RESET DATABASE =====
DELETE FROM `evaluation`;
DELETE FROM `screening`;
DELETE FROM `film_actor`;
DELETE FROM `film_director`;
DELETE FROM `festival_film`;
DELETE FROM `festival_category`;
DELETE FROM `film`;
DELETE FROM `person`;
DELETE FROM `staff`;
DELETE FROM `category`;
DELETE FROM `festival`;

DELETE FROM `sqlite_sequence`;

-- ===== FESTIVAL =====
INSERT INTO `festival` 
    (`title`, `year`, `location`)
VALUES
('Cinema World Festival 2026', 2026, 'Cannes, France');

-- ===== CATEGORIES =====
INSERT INTO `category` (`name`) VALUES
('Best Picture'),
('Best Documentary'),
('Best Short Film'),
('Best International Film');

-- ===== PEOPLE =====
INSERT INTO `person` 
    (`name`, `type`)
VALUES
-- Directors (1-8)
('Christopher Nolan', 'director'),
('Greta Gerwig', 'director'),
('Denis Villeneuve', 'director'),
('Chloé Zhao', 'director'),
('Wes Anderson', 'director'),
('Sofia Coppola', 'director'),
('Bong Joon-ho', 'director'),
('Emerald Fennell', 'director'),

-- Actors (9-25)
('Margot Robbie', 'actor'),
('Timothée Chalamet', 'actor'),
('Cate Blanchett', 'actor'),
('Oscar Isaac', 'actor'),
('Saoirse Ronan', 'actor'),
('Florence Pugh', 'actor'),
('Ryan Gosling', 'actor'),
('Zendaya', 'actor'),
('Adam Driver', 'actor'),
('Emma Stone', 'actor'),
('Joaquin Phoenix', 'actor'),
('Viola Davis', 'actor'),
('Brad Pitt', 'actor'),
('Tilda Swinton', 'actor'),
('Daniel Kaluuya', 'actor'),
('Anya Taylor-Joy', 'actor'),
('Pedro Pascal', 'actor');

-- ===== STAFF =====
INSERT INTO `staff` 
    (`name`, `type`, `specialization`) 
VALUES
('Martin Scorsese', 'judge', 'Drama'),
('Kathryn Bigelow', 'judge', 'Action'),
('Alfonso Cuarón', 'judge', 'International'),
('Jane Campion', 'judge', 'Independent'),
('Guillermo del Toro', 'judge', 'Fantasy'),

('Sarah Johnson', 'coordinator', NULL),
('Mike Chen', 'coordinator', NULL),
('Elena Rodriguez', 'coordinator', NULL),
('David Kim', 'coordinator', NULL),
('Anna Müller', 'coordinator', NULL);

-- ===== FILMS =====
INSERT INTO `film`
    (`title`, `duration`, `year`, `country`, `category_id`) 
VALUES
('Eternal Horizons',     142, 2025, 'United States', 1),
('The Last Garden',      118, 2025, 'United Kingdom',1),
('Midnight in Seoul',    135, 2025, 'South Korea',   4),
('Desert Echoes',        127, 2024, 'Morocco',       4),
('The Silent Bridge',    145, 2025, 'France',        1),
('Quantum Dreams',       152, 2025, 'United States', 2),
('The Forgotten Valley', 112, 2024, 'Italy',         3),
('Northern Lights',      138, 2025, 'Sweden',        4),
('Bamboo Shadows',       125, 2024, 'Japan',         3),
('The Iron Coast',       141, 2025, 'Australia',     1),
('Velvet Night',         129, 2025, 'Spain',         2),
('Crimson Peak',         133, 2024, 'Canada',        4);

-- ===== FESTIVAL-CATEGORY =====
INSERT INTO `festival_category` VALUES
(1,1), (1,2), (1,3), (1,4);

-- ===== FESTIVAL-FILM =====
INSERT INTO `festival_film` VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
(1,7),(1,8),(1,9),(1,10),(1,11),(1,12);

-- ===== FILM-DIRECTOR =====
INSERT INTO `film_director` VALUES
(1,1), (1, 2), (2,2), (3,3), (4,4), (5,5), (6,1),
(7,6), (8,7), (9,8), (10,2), (11,3), (12,4);

-- ===== FILM-ACTOR =====
INSERT INTO `film_actor` VALUES
(1,9),(1,10),(1,13),(1,17),(1,21),
(2,11),(2,14),(2,18),(2,23),
(3,12),(3,15),(3,19),(3,24),
(4,9),(4,20),(4,25),
(5,10),(5,16),(5,22),(5,25),
(6,11),(6,15),(6,18),(6,21),(6,24),
(7,12),(7,14),(7,20),
(8,13),(8,17),(8,23),(8,25),
(9,19),(9,22),(9,24),
(10,9),(10,10),(10,16),(10,22),
(11,11),(11,18),(11,21),
(12,14),(12,17),(12,20);

-- ===== SCREENINGS =====
INSERT INTO `screening`
    (`date`, `time`, `room`, `capacity`, `film_id`, `coordinator_id`) 
VALUES
('2026-05-15','10:00','Grand Auditorium',500,1,6),
('2026-05-15','14:00','Room A',200,2,7),
('2026-05-15','16:30','Room B',150,3,8),
('2026-05-15','20:00','Grand Auditorium',500,4,9),
('2026-05-16','09:00','Room C',100,5,10),

('2026-05-16','11:30','Grand Auditorium',500,6,6),
('2026-05-16','14:30','Room A',200,7,7),
('2026-05-16','17:00','Room B',150,8,8),
('2026-05-17','10:00','Grand Auditorium',500,9,9),
('2026-05-17','13:00','Room A',200,10,10),

('2026-05-17','15:30','Room C',100,11,6),
('2026-05-17','19:00','Grand Auditorium',500,12,7),
('2026-05-18','10:00','Room B',150,1,8),
('2026-05-18','12:00','Room A',200,3,9),
('2026-05-18','14:30','Grand Auditorium',500,6,10),

('2026-05-18','17:00','Room C',100,2,6),
('2026-05-19','09:00','Room A',200,8,7),
('2026-05-19','11:30','Grand Auditorium',500,5,8),
('2026-05-19','14:00','Room B',150,10,9),
('2026-05-19','20:00','Grand Auditorium',500,1,10);

-- ===== EVALUATIONS =====
INSERT INTO `evaluation` 
    (`judge_id`, `film_id`, `score`) 
VALUES
-- Martin Scorsese (7 films)
(1,1,95), (1,3,88), (1,5,91), (1,7,79), (1,9,85), (1,11,90), (1,12,87),
-- Kathryn Bigelow (6 films)
(2,2,93), (2,4,87), (2,6,94), (2,8,82), (2,10,88), (2,12,86),
-- Alfonso Cuarón (5 films)
(3,1,92), (3,3,90), (3,5,88), (3,7,81), (3,9,84),
-- Jane Campion (2 films)
(4,6,96), (4,10,87);
-- Guillermo del Toro intentionally has no evaluations.


-- ===== FINAL SCORE =====
UPDATE `film`
SET `final_score` = (
    SELECT ROUND(AVG(`score`))
    FROM `evaluation`
    WHERE `evaluation`.`film_id` = `film`.`id`
)
WHERE EXISTS (
    SELECT 1
    FROM `evaluation`
    WHERE `evaluation`.`film_id` = `film`.`id`
);