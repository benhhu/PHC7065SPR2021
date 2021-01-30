#SQL Part 1

#load the package that will allow us to connect to mysql
library(RMySQL)

########################
#1. create a connection#
########################

#password
pw <- "vmuser"

#load the mysql driver
drv<-dbDriver("MySQL")

#create a connection to the mysql database
con<-dbConnect(drv,dbname="PHC7065DB",host="localhost",user="phc7065",password=pw)

##############
#2. basic SQL#
##############

#a. SELECT and FROM
q<-"SELECT * FROM TESTTBL;"

#run the sql query and save the results as a dataframe
dat<-dbGetQuery(con,q)
head(dat)

#b. LIMIT
q<-"SELECT * FROM TESTTBL LIMIT 2;"
dbGetQuery(con,q)

#c. WHERE
q<-"
SELECT * 
FROM TESTTBL
WHERE date IS NOT NULL
;"
dbGetQuery(con,q)

#d. LIKE
q<-"
SELECT *
FROM TESTTBL
WHERE author LIKE '_uthor 5'
;"
dbGetQuery(con,q)

#e. IN
q<-"
SELECT *
FROM TESTTBL
WHERE id IN (1,2,3)
;"
dbGetQuery(con,q)

#f. BETWEEN
q<-"
SELECT *
FROM TESTTBL
WHERE date BETWEEN '2017-01-01' AND '2017-02-01'
;"
dbGetQuery(con,q)

#g. AND
q<-"
SELECT *
FROM TESTTBL
WHERE date IS NULL AND id > 5
;"
dbGetQuery(con,q)

#h. OR
q<-"
SELECT *
FROM TESTTBL
WHERE date IS NULL OR id > 5
;"
dbGetQuery(con,q)

#i. ORDER BY
q<-"
SELECT *
FROM TESTTBL
ORDER BY date DESC
;"
dbGetQuery(con,q)

#######################
#3. export df to MySQL#
#######################

q<-"
SELECT *
FROM TESTTBL
WHERE date IS NOT NULL
ORDER BY date DESC
;"
dat<-dbGetQuery(con,q)

dbWriteTable(con,"Rdfexp",dat,overwrite=T)

q<-"
SELECT *
FROM Rdfexp
;"
dbGetQuery(con,q)

