-- Expploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

-- checking the max laid off
SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_staging2;

-- checking where the laid off was 100%
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- comapny wise total laid off
SELECT company , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

-- checking the date range 
SELECT MAX(`date`), MIN(`date`)
FROM layoffs_staging2;

-- industry wise total laid off (consurmer and reatail took a big hit)
SELECT industry , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

-- Country wise total laid off (US tops the list)
SELECT country , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

SELECT *
FROM layoffs_staging2;

-- year wise (2023 is the highest)
SELECT YEAR(`date`) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`) DESC;

-- Stage wise 
SELECT stage , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- comapny wise pervcentage laid off
-- percentage laid off is not very easy to work with due to the lack off total employee count
SELECT company , AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;



-- rolling total of layoffs

SELECT SUBSTRING(date,1,7) AS `MONTH`,SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC;


WITH Rolling_Total AS
( 
SELECT SUBSTRING(date,1,7) AS `MONTH`,SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC
) 
SELECT `MONTH`, total_off,SUM(total_off) OVER( ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;




SELECT company , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;


SELECT company ,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

-- ranking the company based of the years

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company ,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
) ,Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY  total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE ranking <= 5;

