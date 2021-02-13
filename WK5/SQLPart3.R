#SQL Part 3

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

#########
#2. JOIN#
#########

#a. Create some tables

#first table to store individual-level data
q1<-"
DROP TABLE IF EXISTS Subject;
"
q2<-"
        CREATE TABLE Subject(
        id INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(20) NOT NULL,
        gender INT NOT NULL,
        age INT NOT NULL,
        race INT NOT NULL,
        county_id INT NOT NULL,
        state_id INT NOT NULL,
        PRIMARY KEY (id)
        );"

#second table to store county-level data
q3<-"
DROP TABLE IF EXISTS County;
"

q4<-"
CREATE TABLE County(
        id INT NOT NULL,
        state_id INT NOT NULL,
        name VARCHAR(20) NOT NULL,
        income INT NOT NULL,
        PRIMARY KEY (id,state_id)
        );
"

#third table to store state-level data
q5<-"
DROP TABLE IF EXISTS State;
"

q6<-"
CREATE TABLE State(
        id INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(20) NOT NULL,
        policy INT NOT NULL,
        start_date DATE,
        end_date VARCHAR(20),
        PRIMARY KEY (id)
        );
"

#execute the queries
dbSendQuery(con,q1)
dbSendQuery(con,q2)
dbSendQuery(con,q3)
dbSendQuery(con,q4)
dbSendQuery(con,q5)
dbSendQuery(con,q6)

#b. Insert some data
q1<-"
INSERT INTO Subject(name,gender,age,race,county_id,state_id)
        VALUES  ('John',1,5,1,1,1),
                ('Mary',0,7,2,2,1),
                ('Mike',1,6,3,1,2),
                ('Linda',0,5,1,2,2),
                ('Lucas',1,4,1,1,3),
                ('Aiden',1,10,4,2,3),
                ('Alice',0,3,2,3,5);
"

q2<-"
INSERT INTO County(id,state_id,name,income)
        VALUES  (1,1,'Alachua',78987),
                (2,1,'Orange',87689),
                (3,1,'Marion',65908),
                (1,2,'Newton',56765),
                (2,2,'Burke',67890),
                (1,3,'Glenn',98678),
                (2,3,'Kings',87908);
"

q3<-"
INSERT INTO State(name,policy,start_date,end_date)
        VALUES  ('Florida',1,'2002-11-23','12/23/2006'),
                ('Georgia',0,NULL,'12/25/2007'),
                ('California',1,'2004-12-23','11/03/2009'),
                ('Washington',1,'2003-11-20','08/23/2007');
"

#execute the queries
dbSendQuery(con,q1)
dbSendQuery(con,q2)
dbSendQuery(con,q3)

#c. check the tables
q<-"SELECT * FROM Subject;"
dbGetQuery(con,q)
q<-"SELECT * FROM County;"
dbGetQuery(con,q)
q<-"SELECT * FROM State;"
dbGetQuery(con,q)

#d. INNER JOIN
q<-"
SELECT Subject.name, State.name as state_name, State.policy
        FROM Subject
        INNER JOIN State ON Subject.state_id=State.id
        ;
"
dbGetQuery(con,q)

#e. LEFT JOIN
q<-"
SELECT Subject.name, State.name as state_name, State.policy
        FROM Subject
        LEFT JOIN State ON Subject.state_id=State.id
        ;
"
dbGetQuery(con,q)

#f. RIGHT JOIN
q<-"
SELECT Subject.name, State.name as state_name, State.policy
        FROM Subject
        RIGHT JOIN State ON Subject.state_id=State.id
        ;
"
dbGetQuery(con,q)

#g. FULL JOIN
q<-"
SELECT Subject.name, State.name as state_name, State.policy
        FROM Subject
        LEFT JOIN State ON Subject.state_id=State.id
        UNION
        SELECT Subject.name, State.name as state_name, State.policy
        FROM Subject
        RIGHT JOIN State ON Subject.state_id=State.id
        ;
"
dbGetQuery(con,q)

#h. CROSS JOIN
q<-"
SELECT Subject.name,State.name
        FROM Subject
        CROSS JOIN State 
        ;
"
dbGetQuery(con,q)

#i. Theta JOIN
q<-"
SELECT Subject.name, State.name as state_name, State.policy,Subject.state_id,State.id
        FROM Subject
        JOIN State ON Subject.state_id>=State.id 
        ;
"
dbGetQuery(con,q)

#####################
#3. String Functions#
#####################
q<-"
SELECT UPPER(LEFT(name,2)) as new_name,LENGTH(name) as length_name
        FROM State
        ;
"
dbGetQuery(con,q)

q<-"
SELECT TRIM(LEADING 'F' FROM name) as new_name
        FROM State
        ;
"
dbGetQuery(con,q)

q<-"
SELECT State.name as name_State, County.name as name_County, CONCAT(County.name,' County, ',State.name) as name
        FROM State
        INNER JOIN County ON State.id=County.state_id
        ;
"
dbGetQuery(con,q)

###################
#4. Time Functions#
###################

q<-"
SELECT end_date, STR_TO_DATE(end_date,'%m/%d/%Y') AS cleaned_end_date
        FROM State
        ;
"
dbGetQuery(con,q)

q<-"
SELECT EXTRACT(MONTH FROM test.cleaned_end_date) AS end_month  
        FROM
        (SELECT end_date, STR_TO_DATE(end_date,'%m/%d/%Y') AS cleaned_end_date
        FROM State) AS test
        ;
"
dbGetQuery(con,q)

#############
#5. COALESCE#
#############
q<-"
SELECT *, COALESCE(start_date,'2001-01-01') as recode_start_date  
        FROM State
        ;
"
dbGetQuery(con,q)

##############
#6. NHIS Data#
##############

#a. download and import the 2015 family file and household file (https://www.cdc.gov/nchs/nhis/nhis_2015_data_release.htm)

#create a temp file
temp<-tempfile()

#download the file into the tempfile
download.file("ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/2015/familyxx.zip",temp)

#unzip the file and import as a dataframe family
family<-read.csv(unz(temp,"familyxx.csv"),header = T)

#remove the temp file
unlink(temp)

#do the same for the household file
temp<-tempfile()
download.file("ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/2015/househld.zip",temp)
household<-read.csv(unz(temp,"househld.csv"),header = T)
unlink(temp)

#check the downloaded data
head(family)
str(family)
head(household)
str(household)

#b. export the data to MySQL database
dbWriteTable(con,"Family",family,overwrite=T,row.names=F)
dbWriteTable(con,"Household",household,overwrite=T,row.names=F)

#check the exported tables
q<-"
SELECT *
        FROM Family
        LIMIT 10
        ;
"
dbGetQuery(con,q)

q<-"
SELECT *
        FROM Household
        LIMIT 10
        ;
"
dbGetQuery(con,q)

#c. subqueries

#what's the maximum number of families within a household?
#seperate queries
q1<-"
DROP TABLE IF EXISTS Temp;
"

q2<-"
CREATE TABLE Temp(
        SELECT COUNT(FMX) AS MAX_N_FAM
        FROM Family
        GROUP BY HHX
        )
        ;
"

q3<-"
SELECT MAX(MAX_N_FAM) 
        FROM Temp
        ;
"

dbSendQuery(con,q1)
dbSendQuery(con,q2)
dbGetQuery(con,q3)

#subqueries
q4<-"
SELECT MAX(temp.MAX_N_FAM)
        FROM
        (
        SELECT COUNT(FMX) AS MAX_N_FAM
        FROM Family
        GROUP BY HHX
        ) AS temp
        ;
"
dbGetQuery(con,q4)

#get 1) the highest education level (Family.FM_EDUC1) within a household, and 2) the housing type (Household.LIVQRT) for each household
#seperate queries
q1<-"
DROP TABLE IF EXISTS Temp2;
"

q2<-"
CREATE TABLE Temp2(
        SELECT HHX,FMX,
               CASE WHEN FM_EDUC1 BETWEEN 97 AND 99 THEN NULL
               ELSE FM_EDUC1
               END AS recodeFM_EDUC1
        FROM Family)
        ;
"

q3<-"
DROP TABLE IF EXISTS Temp3;
"

q4<-"
CREATE TABLE Temp3(
        SELECT MAX(recodeFM_EDUC1) AS MaxEDUC, HHX
        FROM Temp2
        GROUP BY Temp2.HHX)
        ;
"

q5<-"
SELECT Temp3.HHX,Temp3.MaxEDUC,Household.LIVQRT
        FROM Temp3
        LEFT JOIN Household ON Temp3.HHX=Household.HHX
        LIMIT 10
        ;
"

dbSendQuery(con,q1)
dbSendQuery(con,q2)
dbSendQuery(con,q3)
dbSendQuery(con,q4)
dbGetQuery(con,q5)

#subqueries
q6<-"
SELECT t2.HHX,t2.MaxEDUC,Household.LIVQRT
        FROM
        (SELECT MAX(t1.recodeFM_EDUC1) AS MaxEDUC, t1.HHX
        FROM
        (SELECT HHX,FMX,
               CASE WHEN FM_EDUC1 BETWEEN 97 AND 99 THEN NULL
               ELSE FM_EDUC1
               END AS recodeFM_EDUC1
        FROM Family) AS t1
        GROUP BY t1.HHX) AS t2
        LEFT JOIN Household ON t2.HHX=Household.HHX
        LIMIT 10
;
"
dbGetQuery(con,q6)