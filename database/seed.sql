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
-- Directors
('Christopher Nolan', 'director'),
('Greta Gerwig', 'director'),
('Denis Villeneuve', 'director'),
('Chloé Zhao', 'director'),
('Wes Anderson', 'director'),
('Sofia Coppola', 'director'),
('Bong Joon-ho', 'director'),
('Emerald Fennell', 'director'),

-- Actors
('Cillian Murphy', 'actor'),
('Emily Blunt', 'actor'),
('Margot Robbie', 'actor'),
('Ryan Gosling', 'actor'),
('Timothée Chalamet', 'actor'),
('Zendaya', 'actor'),
('Frances McDormand', 'actor'),
('David Strathairn', 'actor'),
('Ralph Fiennes', 'actor'),
('Saoirse Ronan', 'actor'),
('Cailee Spaeny', 'actor'),
('Jacob Elordi', 'actor'),
('Song Kang-ho', 'actor'),
('Park So-dam', 'actor'),
('Barry Keoghan', 'actor'),
('Rosamund Pike', 'actor'),
('Robert Downey Jr.', 'actor');

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
('Oppenheimer',              180, 2023, 'United States', 1),
('Barbie',                   114, 2023, 'United States', 1),
('Dune: Part Two',           166, 2024, 'United States', 4),
('Nomadland',                107, 2020, 'United States', 1),
('Asteroid City',            105, 2023, 'United States', 1),
('Interstellar',             169, 2014, 'United States', 2),
('Priscilla',                113, 2023, 'United States', 1),
('Parasite',                 132, 2019, 'South Korea',   4),
('Saltburn',                 131, 2023, 'United Kingdom',4),
('Little Women',             135, 2019, 'United States', 1),
('Arrival',                  116, 2016, 'United States', 4),
('Eternals',                 157, 2021, 'United States', 1);

-- ===== FESTIVAL-CATEGORY =====
INSERT INTO `festival_category` VALUES
(1,1), (1,2), (1,3), (1,4);

-- ===== FESTIVAL-FILM =====
INSERT INTO `festival_film` VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
(1,7),(1,8),(1,9),(1,10),(1,11),(1,12);

-- ===== FILM-DIRECTOR =====
INSERT INTO `film_director` VALUES
(1,1), (2,2), (3,3), (4,4), (5,5), (6,1),
(7,6), (8,7), (9,8), (10,2), (11,3), 
(12,4), (12,3);

-- ===== FILM-ACTOR =====
INSERT INTO `film_actor` VALUES
(1,9),(1,10),(1,17),
(2,11),(2,12),
(3,13),(3,14),
(4,15),(4,16),
(5,17),(5,18),(5,11),
(6,9),(6,13),
(7,19),(7,20),
(8,21),(8,22),
(9,23),(9,24),
(10,18),(10,13),(10,15),
(11,10),(11,16),
(12,11),(12,23);

-- ===== SCREENINGS =====
INSERT INTO `screening`
    (`date`, `time`, `room`, `capacity`, `film_id`, `coordinator_id`) 
VALUES
-- Past screenings
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
('2026-05-18','10:00','Room B',150,1,8),
('2026-05-18','12:00','Room A',200,3,9),
('2026-05-18','14:30','Grand Auditorium',500,6,10),

('2026-05-18','17:00','Room C',100,2,6),
('2026-05-19','09:00','Room A',200,8,7),
('2026-05-19','11:30','Grand Auditorium',500,5,8),
('2026-05-19','14:00','Room B',150,10,9),
('2026-05-19','20:00','Grand Auditorium',500,1,10),

-- Future screenings
('2026-07-10','14:00','Grand Auditorium',500,1,6),
('2026-07-11','16:00','Room A',200,3,7),
('2026-07-12','18:00','Room B',150,8,8),
('2026-07-15','10:00','Grand Auditorium',500,2,9),
('2026-07-16','20:00','Room C',100,9,10),

('2026-08-01','11:00','Grand Auditorium',500,6,6),
('2026-08-02','15:00','Room A',200,10,7),
('2026-08-05','19:00','Grand Auditorium',500,1,8),
('2026-08-10','13:00','Room B',150,4,9),
('2026-08-15','17:00','Room C',100,11,10),

('2026-09-01','10:00','Grand Auditorium',500,5,6),
('2026-09-05','14:00','Room A',200,7,7),
('2026-09-10','20:00','Grand Auditorium',500,3,8),
('2026-09-20','18:00','Room C',100,8,10),

('2026-12-25','15:00','Grand Auditorium',500,2,6),
('2026-12-31','20:00','Grand Auditorium',500,1,7),
('2027-01-01','18:00','Room A',200,6,8),
('2027-03-15','14:00','Grand Auditorium',500,9,9),
('2027-06-01','19:00','Room B',150,10,10);

-- ===== EVALUATIONS =====
INSERT INTO `evaluation` 
    (`judge_id`, `film_id`, `score`) 
VALUES
(1,1,95), (1,2,92), (1,3,88), (1,5,91), (1,7,79), (1,9,85), (1,11,90),
(2,1,90), (2,3,85), (2,4,87), (2,6,94), (2,8,82), (2,10,88),
(3,1,92), (3,2,88), (3,3,90), (3,5,88), (3,7,81), (3,9,84),
(4,6,96), (4,10,87);

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