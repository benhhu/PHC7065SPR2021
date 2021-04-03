#install and load mongolite package
install.packages("mongolite")
library(mongolite)
library(jsonlite)
library(rjson)

#setwd
setwd("/home/vmuser/Desktop/PHC7065SPR2021/WK10/")

#create a connection to the collection "Students" in the database "phc7065" (mongodb creates new collections and databases implicitly upon their first use)
con<-mongo(collection = "Students",db="phc7065",url="mongodb://localhost:27017")

#insert some data
student1<-'{"_id":1,
            "name": "John",
            "hometown": "Gainesville, Florida",
            "age":20,
            "courses": ["a","b","c"],
            "department": "a",
            "college": "a"
           }'
student2<-'{"_id":2,
            "name": "Mike",
            "hometown": "Gainesville, Georgia",
            "age":23,
            "courses": ["b","a","c"],
            "department": "b",
            "college": "b"
           }'
student3<-'{"_id":3,
            "name": "Tom",
            "hometown": "Miami, Florida",
            "age":19,
            "courses": ["c","b","a"],
            "department": "b",
            "college":"b"
           }'
student4<-'{"_id":4,
            "name": "Joe",
            "hometown": "Jacksonville, Florida",
            "age":19,
            "courses": ["d","e"],
            "department": "a",
            "college": "c"
           }'

# delete all data in the collection
con$drop()

#insert data
con$insert(student1)
con$insert(student2)
con$insert(student3)
con$insert(student4)

#retrieve data
con$find()

#basic queries
con$find('{"age":20}',fields='{"age":1,"name":1}')
con$find('{"courses":{"$in":["a","b"]}}')
con$find('{"courses":{"$nin":["a","b"]}}')
con$find('{"courses.0":"a"}')
con$find('{"$and":[
                    {
                      "$or":[
                              {"age":20},
                              {"age":23}
                            ]
                    },
                    {
                      "$or":[
                              {"courses.1":"a"},
                              {"courses.1":"b"}
                            ]
                    }
                  ]
          }')

#counting and distinct
con$count('{"age":{"$exists":true}}')
con$count()
length(con$distinct('age'))

#aggregation
con$aggregate('[
    {"$group":{"_id":"$department","meanAge":{"$avg":"$age"}}}
]')

con$aggregate('[
    {"$group":{"_id":"department","meanAge":{"$avg":"age"}}}
]')

con$aggregate('[
    {"$match":{"courses":{"$in":["a"]}}},
    {"$group":{"_id":"$department","meanAge":{"$avg":"$age"}}}
]')

con$aggregate('[
    {"$match":{"courses":"a"}},
    {"$group":{"_id":"$department","meanAge":{"$avg":"$age"}}}
]')

#multi-attribute aggregation
con$aggregate('[
    {"$group":{"_id":{"department":"$department","college":"$college"},"meanAge":{"$avg":"$age"}}},
    {"$sort":{"meanAge":1}}
]')

#aggregation with text search
#create a text index
con$index('{"hometown":"text"}')

con$aggregate('[
    {"$match":{"$text":{"$search":"Miami Florida"}}},
    {"$sort":{"score":{"$meta":"textScore"}}},
    {"$project":{"hometown":1,"name":1}}
]')

#Join
#create some data
con2<-mongo(collection = "Colleges",db="phc7065",url="mongodb://localhost:27017")
college1<-'{"_id":1,
            "name": "a",
            "nStudents": 300
           }'
college2<-'{"_id":2,
            "name": "b",
            "nStudents": 400
           }'
college3<-'{"_id":3,
            "name": "c",
            "nStudents": 500
           }'
college4<-'{"_id":4,
            "name": "d",
            "nStudents": 600
           }'

con2$drop()
con2$insert(c(college1,college2,college3,college4))
con2$find()

con2$aggregate('[
    {
        "$lookup":{
            "from":"Students",
            "localField":"name",
            "foreignField":"college",
            "as":"students"
        }
    }
]')

con$aggregate('[
    {
        "$lookup":{
            "from":"Colleges",
            "localField":"college",
            "foreignField":"name",
            "as":"colleges"
        }
    }
]')

#import JSON files to mongoDB
system('mongoimport --db phc7065 --collection tweets --type json --file /home/vmuser/Desktop/PHC7065SPR2020/WK10/data/tweet.json')
con3<-mongo(collection = "tweets",db="phc7065",url="mongodb://localhost:27017")
head(con3$find())

