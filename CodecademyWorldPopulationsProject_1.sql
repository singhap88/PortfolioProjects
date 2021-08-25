https://www.codecademy.com/practice/projects/world-populations-sql-practice

-- What years are covered by the dataset? 

SELECT DISTINCT year FROM population_years;

-- What is the largest population size for Gabon in this dataset?

SELECT * FROM population_years
WHERE country = 'Gabon';

-- What were the 10 lowest population countries in 2005?

SELECT country FROM population_years
WHERE year = 2005
ORDER BY population ASC
LIMIT 10;

-- What are all the distinct countries with a population of over 100 million in the year 2010?

SELECT DISTINCT country FROM population_years
WHERE year = 2010
AND population > 100;

-- How many countries in this dataset have the word “Islands” in their name?

SELECT DISTINCT country FROM population_years
WHERE country like "%islands%";

-- What is the difference in population between 2000 and 2010 in Indonesia?

SELECT year, population FROM population_years
WHERE country = 'Indonesia'
AND year = 2000
OR country = 'Indonesia'
AND year = 2010;
