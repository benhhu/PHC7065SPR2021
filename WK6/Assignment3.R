#Assignment 3

#Q1. Install the package "sas7bdat" (1.5 pts).

#Q2. Load the packages "sas7bdat", "sqldf", and "dplyr" (0.5 pt).

#Q3. Set working directory to "WK6" folder (0.5 pt).

#Q4. Download and import the MME conversion table from CDC: https://www.cdc.gov/drugoverdose/data-files/cdc_mme_table_sept2018.sas7bdat Hint: use read.sas7bdat function (2.5 pts).

#Q5. Import rx data (2.5 pts).

#Q6. Merge MME conversion table to rx data based on NDC code (2.5 pts).

#Q7. Create frequency tables for the variables "Class", "DEAClassCode", and "Drug" (2.5 pts).

#Q8. Limit the analyses to records with "Class"="Opioid" and "DEAClassCode"=2, 3, or 4 (2.5 pts).

#Q9. Calculate monthly number of methadone and opioid analgesics dispensed (5 pts).

#Q10. Multiple provider episodes: calculate monthly number of patients receiving opioid prescriptions from two or more prescribers dispensed at two or more pharmacies in a 180-day period. Hint: the same patient might have multiple rx records in the same month, but as long as any of these record meets the criteria of multiple provider episodes, this patient should be counted as having multiple provider episodes for that month (12.5 pts).

#Q11. Calculate the daily Morphine Milligram Equivalents (MME) for each rx record, and then exclude all records with missing filldate, missing daily MME, or dayssupply=0. Hint: Daily MME=Strength_Per_Unit*MME_Conversion_Factor*(metric_qty/dayssupply) (2.5 pts).

#Q12. Calculate the monthly number of patients receiving more than an average daily dose of 90 MME in any day within a month (15 pts).
