-- First create a database called "OlympicsDB", then create the tables with the commands below.
-- After creating the tables, run the code in "loading_data_into_sql.ipynb" to load the data into the tables.
-- After importing the data, run the second set of commands below to create the merged table for the analysis and machine learning model.

CREATE TABLE population (
    country_name VARCHAR NOT NULL,
    population INT,
    PRIMARY KEY (country_name)
);

CREATE TABLE gdp_per_capita (
    country_name VARCHAR NOT NULL,
    gdp_per_capita FLOAT,
    PRIMARY KEY (country_name)
);

CREATE TABLE hdi (
    country_name VARCHAR NOT NULL,
    human_development_index FLOAT,
    PRIMARY KEY (country_name)
);

CREATE TABLE gii (
    country_name VARCHAR NOT NULL,
    gender_inequality_index FLOAT,
    PRIMARY KEY (country_name)
);

CREATE TABLE cpi (
    country_name VARCHAR NOT NULL,
    corruption_perceptions_index FLOAT,
    PRIMARY KEY (country_name)
);

CREATE TABLE winter_medals (
    country_name VARCHAR NOT NULL,
    gold INT,
	silver INT,
	bronze INT,
	total INT,
    PRIMARY KEY (country_name)
);
CREATE TABLE summer_medals (
    country_name VARCHAR NOT NULL,
    gold INT,
	silver INT,
	bronze INT,
	total INT,
    PRIMARY KEY (country_name)
);


-- SECOND SET OF COMMANDS
-- Do not run these before importing the data.

-- The code below creates a new table that combines the two medal tables and adds the total medal count.
SELECT country_name,SUM(total) total
INTO combined_medals
FROM
(
	SELECT country_name,total
	FROM winter_medals
	UNION ALL
	SELECT country_name,total
	FROM summer_medals
) t
GROUP BY country_name

-- The code below combines the demographic data, economic indicators and total medal counts into one table.
SELECT population.country_name,
	population.population,
	gdp_per_capita.gdp_per_capita,
	hdi.human_development_index,
	gii.gender_inequality_index,
	cpi.corruption_perceptions_index,
	combined_medals.total
	INTO combined_info
	FROM population
	LEFT JOIN gdp_per_capita
		ON (population.country_name = gdp_per_capita.country_name)
	LEFT JOIN hdi
		ON (population.country_name = hdi.country_name)
	LEFT JOIN gii
		ON (population.country_name = gii.country_name)
	LEFT JOIN cpi
		ON (population.country_name = cpi.country_name)
	LEFT JOIN combined_medals
		ON (population.country_name = combined_medals.country_name)

-- Removing rows with missing data.
DELETE FROM combined_info WHERE gdp_per_capita IS NULL OR human_development_index IS NULL OR gender_inequality_index IS NULL OR corruption_perceptions_index IS NULL
-- Changing null values in the medal count table to zeros.
UPDATE combined_info
SET total = COALESCE(total, 0 )

select * from combined_info

