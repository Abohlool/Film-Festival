-- Films in a specific festival
SELECT 
    `f`.*
FROM `film` AS 'f'
JOIN `festival_film` AS 'ff'
    ON `ff`.`film_id` = `f`.`id`
WHERE `ff`.`festival_id` = ?;


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
    `p`.`name` AS 'director'
FROM `film` AS 'f'
JOIN `film_director` AS 'fd'
    ON `f`.`id` = `fd`.`film_id`
JOIN `person` AS 'p'
    ON `fd`.`director_id` = `p`.`id`
WHERE `f`.`id` = ?;


-- Actors of a film
SELECT
    `p`.`name` AS 'actor'
FROM `film` AS 'f'
JOIN `film_actor` AS 'fa'
    ON `f`.`id` = `fa`.`film_id`
JOIN `person` AS 'p'
    ON `fa`.`actor_id` = `p`.`id`
WHERE `f`.`id` = ?;


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
WHERE `f`.`id` = ?
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
    `s`.`id`,
    `s`.`name`,
    `s`.`specialization`,
    COUNT(`e`.`film_id`) AS 'films_evaluated'
FROM `staff` AS 's'
JOIN `evaluation` AS 'e'
    ON `s`.`id` = `e`.`judge_id`
WHERE `s`.`type` = 'judge'
GROUP BY
    `s`.`id`,
    `s`.`name`,
    `s`.`specialization`
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
HAVING COUNT(`fd`.`director_id`) > 1;


-- Actors in more than two films
SELECT
    `p`.`id`,
    `p`.`name`,
    COUNT(`fa`.`actor_id`) AS 'film_count'
FROM `person` AS 'p'
JOIN `film_actor` AS 'fa'
    ON `p`.`id` = `fa`.`actor_id`
GROUP BY
    `p`.`id`,
    `p`.`name`
HAVING COUNT(`fa`.`actor_id`) > 2;


-- Screenings on specific date
SELECT
    `f`.`title`,
    `sc`.`time`,
    `sc`.`room`,
    `sc`.`capacity`,
    `s`.`name`
FROM `film` AS 'f'
JOIN `screening` AS 'sc'
    ON `f`.`id` = `sc`.`film_id`
JOIN `staff` AS 's'
    ON `s`.`id` = `sc`.`coordinator_id`
WHERE `sc`.`date` = ?
ORDER BY `sc`.`time`;


-- Screenings per room by date
SELECT
    `sc`.`room`,
    COUNT(*) AS 'screening_count'
FROM `screening` AS 'sc'
WHERE `sc`.`date` = ?
GROUP BY `sc`.`room`;


-- Judges without evaluations
SELECT
    `s`.`id`,
    `s`.`name`,
    `s`.`specialization`
FROM `staff` AS 's'
LEFT JOIN `evaluation` AS 'e'
    ON `s`.`id` = `e`.`judge_id`
WHERE `s`.`type` = 'judge'
    AND `e`.`judge_id` IS NULL
ORDER BY `s`.`name`;


-- Films without screenings
SELECT
    `f`.`id`,
    `f`.`title`
FROM `film` AS 'f'
LEFT JOIN `screening` AS 'sc'
    ON `sc`.`film_id` = `f`.`id`
WHERE `sc`.`film_id` IS NULL;




-- Screenings by coordinator
SELECT
    `sc`.`id`,
    `sc`.`date`,
    `sc`.`time`,
    `sc`.`room`,
    `sc`.`capacity`,
    `f`.`title` AS 'film'
FROM `screening` AS 'sc'
JOIN `film` AS 'f'
    ON `sc`.`film_id` = `f`.`id`
WHERE `sc`.`coordinator_id` = ?;


-- Films evaluated by a specific judge
SELECT
    `f`.`id`,
    `f`.`title`,
    `e`.`score`
FROM `evaluation` AS 'e'
JOIN `film` AS 'f'
    ON `e`.`film_id` = `f`.`id`
WHERE `e`.`judge_id` = ?;


-- Director info for a specific film
SELECT
    `p`.*
FROM `person` AS 'p'
JOIN `film_director` AS 'fd'
    ON `p`.`id` = `fd`.`director_id`
JOIN `film` AS 'f'
    ON `fd`.`film_id` = `f`.`id`
WHERE `f`.`id` = ?;