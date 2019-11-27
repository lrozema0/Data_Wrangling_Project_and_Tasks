# Data_Wrangling_Project_and_Tasks
Collection of all assignments, projects, and tasks from QBS 181: Data Wrangling, Fall 2019.
## Overview
The purpose of this repository is to display the code used for all graded projects completed in QBS 181 at Dartmouth College over the Fall, 2019 term. Express permission has been given by the instructor to make the code public. 
## Description of Subdirectories
### Project 1
The purpose of the first project was to display the utility of SQL when working with databases. This was shown in multiple ways. First, SQL was used to easily change the names of multiple columns to create unformity within a table. Second, a new column was created containing chracter strings that were assigned based on the value in an existing column. For example 167410011 in the existing column corresponded to "Complete" in the new column. This was done two more times, creating columns corresponding to sex and age group.  
### Project 2
The purpose of the second project was to display the interface between SQL and R through the use of ODBC connections and specialized packages such as sqldf. In addition, manipulation of dates was shown using the lubridate package in R. This was shown in a few ways. First, SQL commands were used in R through the sqldf command to create a new column based on an existing column as was done in the first project. Second, SQL commands were used to merge two dataframes together in R. Last, the lubridate package was used to round dates to the nearest week, then collect all observations in a week and plot them. 
### Midterm Project
The purpose of the midterm project was to clean a dataset from NHANES. To do this multiple techniques were used including mean/median imputation for conitnuous missing values and one hot encoding factor missing values.  
### Final Project
The purpose of the final project was to display all of the SQL and R tools that were learned over the term. This was done in a few ways. First, R was utilized to import a CSV file as a dataframe. Once imported a variable was renamed and the multilevel factor variable was grouped to make it a dichotomous variable keyed as 1 or 0. Next, this was merged with a SQL table that was pulled from a database and lubridate functions used to manipulate date data. Second, a three way join was shown in SQL and rows removed so that one row corresponds to an individual. Third, the same thing was done only in R usng dplyr functions. 
