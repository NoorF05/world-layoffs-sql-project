-- SQL Project 

-- Data Cleaning

-- 1. Removing Dupicates
-- 2. Standardizing the Data
-- 3. NUll and Blank Values
-- 4. Removing rows and Columns 

USE world_layoffs;
SELECT * FROM layoffs;


# Create a stagging table to keep the raw data unchanged
CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging 
SELECT * FROM world_layoffs.layoffs;

SELECT * FROM layoffs_staging;


-- Removing Dupilcates 

# Checking for duplicates using row number 

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (PARTITION BY company, industry, total_laid_off,`date`) AS row_num
FROM world_layoffs.layoffs_staging;

SELECT *
FROM (
	SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM layoffs_staging
) duplicates
WHERE 
	row_num > 1;
    
-- Checking for just oda to confirm
SELECT *
FROM layoffs_staging
WHERE company = 'Oda';

#Partitioning by all the columns as there are legitimate entries

-- Real duplicates
SELECT * FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER 
		(PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM layoffs_staging
) duplicates
WHERE row_num > 1;

-- using a cte
WITH DELETE_CTE AS 
(
SELECT * FROM 
	( SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, 
            stage, country, funds_raised_millions
			) AS row_num
	FROM layoffs_staging
) duplicates
WHERE row_num > 1
)
SELECT * FROM DELETE_CTE
;

-- to delete the columns we are creating a new table with an additonal column row number and delete the rows where the row num is greater than 1

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, 
            stage, country, funds_raised_millions
			) AS row_num
	FROM layoffs_staging;


SELECT * FROM layoffs_staging2
WHERE row_num >1;

-- Delete the duplicate rows 
DELETE
FROM layoffs_staging2
WHERE row_num >1;


-- Standardizing the data

SELECT * FROM layoffs_staging2;

-- We have extra spaces before the company name 
SELECT DISTINCT (company) 
FROM layoffs_staging2;

SELECT company , TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company =  TRIM(company);

-- checking for null and blank values in industry 
SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY industry ;

-- Crypto had different variations so we will change them to be the same 

SELECT * 
FROM layoffs_staging2 
WHERE industry LIKE "Crypto%";

UPDATE layoffs_staging2
SET industry = "Crypto"
WHERE industry LIKE "Crypto%";

-- Checking country values too 

SELECT DISTINCT country 
FROM layoffs_staging2
ORDER BY country;

-- United States has a entry with a period . at the end

SELECT DISTINCT country 
FROM layoffs_staging2
WHERE country LIKE "United States%";

SELECT DISTINCT country , TRIM(TRAILING '.' FROM country )
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE "United States%";

-- changing the date data type as it is set to text

SELECT `date`,STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

-- changing the format 
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- but the data type still reamains text which can be changed with alter table
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;



-- checking null and blank values in industry 
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- looking at a specific values
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'airbnb%';

-- we have another entry for airbnb and the industry is not populated 
-- so using the filled field we can populate the blank

-- setting the blank values to null as they are easier to work with 
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- checking if all the values are null 
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

SELECT t1.industry, t2.industry 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- checking any remaining null values 
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- Ballys is the only one reamining cause there is no other entry we can use to populate it 


-- removing rows and columns not needed 

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL;

-- where both these values are null can't be used so we need to remove them 
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- deleting the values
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT * 
FROM layoffs_staging2;

-- dropping the row_num col as it is not needed anymore 
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM layoffs_staging2;