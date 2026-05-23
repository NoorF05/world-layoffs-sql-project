# World Layoffs SQL Data Analysis Project

## Project Overview
This project focuses on cleaning and analyzing a real-world layoffs dataset using SQL. The goal of the project was to practice core data analysis techniques such as data cleaning, handling duplicates, standardizing inconsistent values, working with dates, and performing exploratory data analysis (EDA).

The dataset contains information about company layoffs across different industries, countries, and time periods.

---
## Project Steps

### 1. Data Cleaning
A staging table was created to preserve the original raw dataset before making any modifications.

The cleaning process included:
- Removing duplicate records using `ROW_NUMBER()`
- Standardizing inconsistent values
- Trimming extra spaces from company names
- Fixing inconsistent country and industry names
- Converting date columns from text format to `DATE`
- Handling NULL and blank values
- Removing unnecessary rows and columns

---

### 2. Exploratory Data Analysis (EDA)
After cleaning the data, exploratory analysis was performed to identify trends and insights.

Analysis included:
- Companies with the highest layoffs
- Industries most affected by layoffs
- Countries with the highest layoffs
- Year-wise layoff trends
- Companies with 100% workforce layoffs
- Monthly rolling totals of layoffs
- Ranking companies by layoffs using window functions

---

## SQL Concepts Used
This project helped practice several important SQL concepts, including:

- `CTEs`
- `WINDOW FUNCTIONS`
- `ROW_NUMBER()`
- `DENSE_RANK()`
- `AGGREGATIONS`
- `GROUP BY`
- `JOINS`
- `DATE FUNCTIONS`
- `DATA CLEANING TECHNIQUES`

---

## Key Insights
- The United States had the highest number of layoffs.
- Consumer and retail industries were heavily impacted.
- Several companies experienced 100% workforce layoffs.
- Layoffs peaked during 2023.
- Rolling monthly analysis showed periods of rapid workforce reductions.

---

## Files Included
- `layoffs.csv` → Raw dataset
- `data_cleaning.sql` → SQL queries used for cleaning the data
- `eda.sql` → SQL queries used for exploratory data analysis

---
