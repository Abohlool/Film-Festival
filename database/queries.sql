-- Films in a specific festival
SELECT 
    `f`.*
FROM `film` AS 'f'
JOIN `festival_film` AS 'ff'
    ON `ff`.`film_id` = `f`.`id`
WHERE `ff`.`festival_id` = 1;


-- Number of films per category
SELECT 
    `c`.`id`,
    `c`.`name`,
    COUNT(`f`.`id`) AS 'film_count'
FROM `category` AS 'c'
LEFT JOIN `film` AS 'f'
    ON `c`.`id` = `f`.`category_id`
GROUP BY
    `c`.`id`,
    `c`.`name`;


-- Directors of a film
SELECT
    `d`.`name` AS 'director'
FROM `director` AS 'd'
JOIN `film_director` AS 'fd'
    ON `fd`.`director_id` = `d`.`id`
WHERE `fd`.`film_id` = 1;


-- Actors of a film
SELECT
    `a`.`name` AS 'actor'
FROM `actor` AS 'a'
JOIN `film_actor` AS 'fa'
    ON `a`.`id` = `fa`.`actor_id`
WHERE `fa`.`film_id` = 1;


-- Future screenings of a film
SELECT
    `f`.`title`,
    `sc`.`time`,
    `sc`.`date`,
    `sc`.`room`,
    `sc`.`capacity`,
    `s`.`name`
FROM `film` AS 'f'
JOIN `screening` AS 'sc'
    ON `f`.`id` = `sc`.`film_id`
JOIN `staff` AS 's'
    ON `s`.`id` = `sc`.`coordinator_id`
WHERE `f`.`id` = 1
    AND datetime(`sc`.`date` || ' ' || `sc`.`time`) > datetime('now')
ORDER BY `sc`.`date`, `sc`.`time`;


-- Number of screenings per film
SELECT 
    `f`.`id`,
    `f`.`title`,
    COUNT(`sc`.`id`) AS 'screening_count'
FROM `film` AS 'f'
LEFT JOIN `screening` AS 'sc'
    ON `sc`.`film_id` = `f`.`id`
GROUP BY 
    `f`.`id`,
    `f`.`title`
ORDER BY 
    `screening_count` DESC,
    `f`.`title`;


-- Average score for each film
SELECT
    `f`.`id`,
    `f`.`title`,
    ROUND(AVG(`e`.`score`), 2) AS 'average_score'
FROM `film` AS 'f'
JOIN `evaluation` AS 'e'
    ON `e`.`film_id` = `f`.`id`
GROUP BY
    `f`.`id`,
    `f`.`title`;


/*
-- Average score
SELECT
    `f`.`id`,
    `f`.`title`,
    `f`.`final_score`
FROM `film` AS 'f';
*/


-- Films ranked by average score
SELECT
    `f`.`id`,
    `f`.`title`,
    ROUND(AVG(`e`.`score`), 2) AS 'average_score'
FROM `film` AS 'f'
JOIN `evaluation` AS 'e'
    ON `e`.`film_id` = `f`.`id`
GROUP BY
    `f`.`id`,
    `f`.`title`
ORDER BY
    `average_score` DESC,
    `f`.`title`;


-- Films without evaluations
SELECT
    `f`.`id`,
    `f`.`title`
FROM `film` AS 'f'
LEFT JOIN `evaluation` AS 'e'
    ON `e`.`film_id` = `f`.`id`
WHERE `e`.`film_id` IS NULL;


-- Judges evaluating over five films
SELECT
    `j`.`id`,
    `j`.`name`,
    `j`.`specialization`,
    COUNT(`e`.`film_id`) AS 'films_evaluated'
FROM `judge` AS 'j'
JOIN `evaluation` AS 'e'
    ON `j`.`id` = `e`.`judge_id`
GROUP BY
    `j`.`id`,
    `j`.`name`,
    `j`.`specialization`
HAVING COUNT(`e`.`film_id`) > 5
ORDER BY `films_evaluated` DESC;


-- Films with multiple directors
SELECT
    `f`.`id`,
    `f`.`title`,
    COUNT(`fd`.`director_id`) AS 'director_count'
FROM `film` AS 'f'
JOIN `film_director` AS 'fd'
    ON `f`.`id` = `fd`.`film_id`
GROUP BY
    `f`.`id`,
    `f`.`title`
HAVING COUNT(DISTINCT `fd`.`director_id`) > 1;


-- Actors in more than two films
SELECT
    `a`.`id`,
    `a`.`name`,
    COUNT(`fa`.`actor_id`) AS 'film_count'
FROM `actor` AS 'a'
JOIN `film_actor` AS 'fa'
    ON `a`.`id` = `fa`.`actor_id`
GROUP BY
    `a`.`id`,
    `a`.`name`
HAVING COUNT(`fa`.`actor_id`) > 2;


-- Screenings on specific date
SELECT
    `f`.`title`,
    `sc`.`time`,
    `sc`.`room`,
    `sc`.`capacity`,
    `c`.`name`
FROM `film` AS 'f'
JOIN `screening` AS 'sc'
    ON `f`.`id` = `sc`.`film_id`
JOIN `coordinator` AS 'c'
    ON `c`.`id` = `sc`.`coordinator_id`
WHERE `sc`.`date` = "2027-01-01";


-- Screenings per room by date
SELECT
    `sc`.`room`,
    COUNT(*) AS 'screening_count'
FROM `screening` AS 'sc'
WHERE `sc`.`date` = "2027-01-01"
GROUP BY `sc`.`room`;


-- Judges without evaluations
SELECT
    `j`.`id`,
    `j`.`name`,
    `j`.`specialization`
FROM `judge` AS 'j'
LEFT JOIN `evaluation` AS 'e'
    ON `j`.`id` = `e`.`judge_id`
WHERE `e`.`judge_id` IS NULL
ORDER BY `j`.`name`;


-- Films without screenings
SELECT
    `f`.`id`,
    `f`.`title`
FROM `film` AS 'f'
LEFT JOIN `screening` AS 'sc'
    ON `sc`.`film_id` = `f`.`id`
WHERE `sc`.`film_id` IS NULL;
