#Access web data

#load the packages
library(httr)
library(jsonlite)

#1. Send HTTP request
temp<-GET("http://www.ufl.edu/index.html")
html<-content(temp,as="text")

#2. Google Geocoding API

#Set url, address, api key
serviceurl<-'https://maps.googleapis.com/maps/api/geocode/json?'
address<-'Gainesville FL'
key<-''

#encode url
geocodingurl<-URLencode(paste0(serviceurl,'address=',address,'&key=',key))

#API call
temp<-GET(geocodingurl)

#clean the result
json<-content(temp,as="text")
geocode<-fromJSON(json)
geocoderes<-geocode$results
head(geocoderes)

#3. Twitter API

#Create your own appication key at https://dev.twitter.com/apps
consumer_key = ""
consumer_secret = ""

#Use basic auth
secret <- base64_enc(paste(consumer_key, consumer_secret, sep = ":"))
req <- POST("https://api.twitter.com/oauth2/token",add_headers("Authorization" = paste("Basic", gsub("\n", "", secret)),"Content-Type" = "application/x-www-form-urlencoded;charset=UTF-8"),body = "grant_type=client_credentials");

#Extract the access token
req
#stop_for_status(req, "authenticate with twitter")
token <- paste("bearer", content(req)$access_token)

#API call
url <- "https://api.twitter.com/1.1/statuses/user_timeline.json?count=5&screen_name=POTUS"
req <- GET(url, add_headers(Authorization = token))
json <- content(req, as = "text")
tweets <- fromJSON(json)
substring(tweets$text, 1, 100)
