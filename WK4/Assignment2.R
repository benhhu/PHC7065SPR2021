#Assignment 2

#Q1. Load RMySQL package, and create the connection to MySQL database "PHC7065DB" (5 pts)


#Q2. Import the 2015 NHIS Person File (personsx.csv) and Injury Episode File (injpoiep.csv) as dataframes (5 pts) 


#Q3. Check the imported datasets by printing out the top 6 rows (2.5 pts)


#Q4. Keep only the first 50 columns in the dataframe 'person' and delete all the other columns. (5 pts)


#Q5. Export these two dataframes to MySQL database 'PHC7065DB' and name them as 'Person' and 'Injury'. There should be only 50 columns in the table "Person" (5 pts)


#Q6. Print out the first 5 rows in the tables "Person" and "Injury". You must use SQL to get the results. (2.5 pts)


#Q7. Write a SQL query to calculate the total number of injury episodes for each individual (create a new column "nInjury" to store the results), and save the results to a new dataframe "nInjury". The dataframe should also include the identifiers (HHX, FMX, FPX) (5 pts)


#Q8. Export the dataframe "nInjury" to MySQL database "PHC7065DB" as a table with the name "nInjury" (2.5 pts)


#Q9. Merge nInjury to Person, and keep the columns "SEX", "nInjury", and all identifiers (HHX, FMX, FPX). Save the merged file as a new dataframe with the name "personInjury". Note: the table "Person" should have the same number of rows as the dataframe "personInjury" (5 pts)


#Q10. Use 0 to replace the missing value of the column "nInjury" in the dataframe "personInjury" (since only individuals with at least 1 injury/poison episode are included in the Injury dataset). Print the bottom 6 rows. (5 pts)


#Q11. Export the dataframe "personInjury" to MySQL database "PHC7065DB" as a table, and name it as "PersonInjury" (2.5 pts)


#Q12. Write a SQL query to get the average, minimum, and maximum number of injury/poison episodes by SEX (5 pts)
