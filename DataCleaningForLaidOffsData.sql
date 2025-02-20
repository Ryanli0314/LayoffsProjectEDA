-- Data Cleaning Project
#Fix issue of raw data for visualization and issue-free
#Import data and clean the data
#Fix the problem by importing using json and change data type, eg. int, datetime

#Lets check the csv imported data!
SELECT *
FROM layoffs;

#What we will do
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns (?)

-- 1. Remove Duplicates
#Create a new table with same columns first for further modification, in case anything go wrong, back to raw data table!!:)
CREATE TABLE layoffs_staging
LIKE layoffs;

#Query to see new table columns
SELECT *
FROM layoffs_staging;

#INSERT DATA into layoffs_staging!
INSERT layoffs_staging
SELECT *
FROM layoffs;



#To create a row number and find if there are duplicate rows, if not, all row_num should be '1'!
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

#Create a cte for query of duplicate rows
#Actually in this case, all columns same = duplicate, so include all columns name plz!
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte 
WHERE row_num > 1;

#(Optional)This make me realized that I haven't mentioned all columns has to be the same --> duplicate!
#SELECT *
#FROM layoffs_staging
# company = 'Oda'

-- Until now we correctly found out which rows are duplicated! ----------------------------------------------------------------------------
#Notice that for cte, we can delete rows by identifying the row_num in Microsoft sql or PostgreSQL but not in MySQL!
#We cannot update an cte table in MySQL, DELETE is like update in MySQL
#DELETE FROM duplicate_cte WHERE row_num > 1; will not works as expected
#CREATE TABLE from layoffs_staging -->

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

SELECT *
FROM layoffs_staging2;

#Insert data into new new table to delete the row_num >1 data and row_num column afterwards!!!
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

#REMEMBER to disable Safety Editor mode by Preference --> SQL Editor --> Bottom --> Refresh to RDBMS
DELETE 
FROM layoffs_staging2
WHERE row_num >1;

SELECT *
FROM layoffs_staging2;

-- Until now we have removed all duplicated rows!! --------------------------------------------------------------------------------------
-- 2. Standardize the Data
-- USE trim or distinct if necessary to check data
SELECT DISTINCT(TRIM(company))
FROM layoffs_staging2;

#UPDATE THE TABLE BY TRIMMING company column
UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT company
FROM layoffs_staging2;

#WE see there is null which is a problem to be fixed
#Crypto, Crypto Currency and CryptoCurrency is distinct now, we want them group tgt
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

#Alternatives: TRIM(TRAILING '.' FROM country) but seems more complicated 
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

#Change date's data-type format for time series or EDA!
#lower case m and upper case m is different! --> %m/%d/%Y --> Capital M will makes the data become NULL
#Similar to excel date format stuff

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

#After this as u can see its data type is still text, you can now change its data type to date!
#Always do this to ur changing table but not raw table!

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

-- 3. Null Values or blank values

#WE can query specific columns and check if we can populate the NULL value by checking related columns
#Such as industry is related to company so we see the company of the industry NULL rows, 
#and we discover Airbnb can be categorized as Travel in industry
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

#UPDATE '' into NULL values first! Actually should be applied to all columns for convenience!
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

#However company 'Bally's Interactive' still have a NULL industry, since it has only one row!
#But it happens!If you know the data real value then you can update it yourself!
#Now We delete data that we cannot trust anymore!
# for total_laid_off and $laid off, we cannot calculate since no sum, for funds_raised, maybe scraping can work but totally another stuff
#First we delete rows that both laid off columns value are NULL

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 4. Remove Any Columns (?)
#We now drop the row_num column
#Then the data cleaning can be finished by now
SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Moving on to EDA projects!!! ----------------------------------------------------------------------------------------------------------






