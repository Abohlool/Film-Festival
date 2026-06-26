-- ===== FESTIVAL =====
INSERT INTO `festival` (`title`, `year`, `location`) VALUES
('Cinema World Festival 2026', 2026, 'Cannes, France');

-- ===== CATEGORIES =====
INSERT INTO `category` (`name`) VALUES
('Best Picture'),
('Best Documentary'),
('Best Short Film'),
('Best International Film');

-- ===== PEOPLE =====
INSERT INTO `person` (`name`, `type`) VALUES
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
INSERT INTO `staff` (`name`, `type`) VALUES
-- Judges
('Martin Scorsese', 'judge'),
('Kathryn Bigelow', 'judge'),
('Alfonso Cuarón', 'judge'),
('Jane Campion', 'judge'),
('Guillermo del Toro', 'judge'),

-- Coordinators
('Sarah Johnson', 'coordinator'),
('Mike Chen', 'coordinator'),
('Elena Rodriguez', 'coordinator'),
('David Kim', 'coordinator'),
('Anna Müller', 'coordinator');

-- ===== FILMS =====
INSERT INTO `film` (`title`, `duration`, `year`, `country`) VALUES
('Eternal Horizons', 142, 2025, 'United States'),
('The Last Garden', 118, 2025, 'United Kingdom'),
('Midnight in Seoul', 135, 2025, 'South Korea'),
('Desert Echoes', 127, 2024, 'Morocco'),
('The Silent Bridge', 145, 2025, 'France'),
('Quantum Dreams', 152, 2025, 'United States'),
('The Forgotten Valley', 112, 2024, 'Italy'),
('Northern Lights', 138, 2025, 'Sweden'),
('Bamboo Shadows', 125, 2024, 'Japan'),
('The Iron Coast', 141, 2025, 'Australia'),
('Velvet Night', 129, 2025, 'Spain'),
('Crimson Peak', 133, 2024, 'Canada');

-- ===== FILM-DIRECTOR RELATIONSHIPS =====
INSERT INTO `film_director` (`film_id`, `director_id`) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 1), 
(7, 6), (8, 7), (9, 8), (10, 2), (11, 3), (12, 4);

-- ===== FILM-ACTOR RELATIONSHIPS =====
INSERT INTO `film_actor` (`film_id`, `actor_id`) VALUES
(1, 9), (1, 10), (1, 13), (1, 17), (1, 21),
(2, 11), (2, 14), (2, 18), (2, 23),
(3, 12), (3, 15), (3, 19), (3, 24),
(4, 9), (4, 20), (4, 25),
(5, 10), (5, 16), (5, 22), (5, 26),
(6, 11), (6, 15), (6, 18), (6, 21), (6, 24),
(7, 12), (7, 14), (7, 20),
(8, 13), (8, 17), (8, 23), (8, 26),
(9, 19), (9, 22), (9, 25),
(10, 9), (10, 10), (10, 16), (10, 22);

-- ===== FILM-CATEGORY RELATIONSHIPS =====
INSERT INTO `film_category` (`film_id`, `category_id`) VALUES
(1, 1), (2, 1), (3, 4), (4, 4), (5, 1), (6, 2), 
(7, 3), (8, 4), (9, 3), (10, 1), (11, 2), (12, 4);

-- ===== FESTIVAL-CATEGORY RELATIONSHIPS =====
INSERT INTO `festival_category` (`festival_id`, `category_id`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4);

-- ===== SCREENINGS =====
INSERT INTO `screening` (`date`, `time`, `room`, `capacity`, `film_id`, `coordinator_id`) VALUES
('2026-05-15', '10:00:00', 'Grand Auditorium', 500, 1, 6),
('2026-05-15', '14:00:00', 'Room A', 200, 2, 7),
('2026-05-15', '16:30:00', 'Room B', 150, 3, 8),
('2026-05-15', '20:00:00', 'Grand Auditorium', 500, 4, 9),

('2026-05-16', '09:00:00', 'Room C', 100, 5, 10),
('2026-05-16', '11:30:00', 'Grand Auditorium', 500, 6, 6),
('2026-05-16', '14:30:00', 'Room A', 200, 7, 7),
('2026-05-16', '17:00:00', 'Room B', 150, 8, 8),

('2026-05-17', '10:00:00', 'Grand Auditorium', 500, 9, 9),
('2026-05-17', '13:00:00', 'Room A', 200, 10, 10),
('2026-05-17', '15:30:00', 'Room C', 100, 11, 6),
('2026-05-17', '19:00:00', 'Grand Auditorium', 500, 12, 7),

('2026-05-18', '10:00:00', 'Room B', 150, 1, 8),
('2026-05-18', '12:00:00', 'Room A', 200, 3, 9),
('2026-05-18', '14:30:00', 'Grand Auditorium', 500, 6, 10),
('2026-05-18', '17:00:00', 'Room C', 100, 2, 6),

('2026-05-19', '09:00:00', 'Room A', 200, 8, 7),
('2026-05-19', '11:30:00', 'Grand Auditorium', 500, 5, 8),
('2026-05-19', '14:00:00', 'Room B', 150, 10, 9),
('2026-05-19', '20:00:00', 'Grand Auditorium', 500, 1, 10);

-- ===== EVALUATIONS =====
INSERT INTO `evaluation` (`judge_id`, `film_id`, `score`, `final_score`) VALUES
(1, 1, 95, 92), (1, 3, 88, 85), (1, 5, 91, 90), (1, 7, 79, 78), (1, 9, 85, 83), (1, 11, 90, 88),
(2, 2, 93, 91), (2, 4, 87, 86), (2, 6, 94, 93), (2, 8, 82, 80), (2, 10, 88, 87), (2, 12, 86, 84),
(3, 1, 92, 91), (3, 3, 90, 89), (3, 5, 88, 87), (3, 7, 81, 80), (3, 9, 84, 82), (3, 11, 89, 88),
(4, 2, 90, 89), (4, 4, 85, 84), (4, 6, 96, 95), (4, 8, 80, 79), (4, 10, 87, 86), (4, 12, 83, 82),
(5, 1, 94, 93), (5, 3, 89, 88), (5, 5, 92, 91), (5, 7, 78, 77), (5, 9, 86, 85), (5, 11, 91, 90);