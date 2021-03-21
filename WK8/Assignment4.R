#Assignment 4

#Q1. Load the packages "httr" and "jsonlite" (3 pts).


#Q2. Set working directory to "WK8" folder (2 pts).


#Q3. Import pcp data (5 pts).

#Q4. Create a new variable "address" which include street address, city, state, and zip code (10 pts). 


#Q5. Create an empty dataframe "geo" to store the results of geocoding with the following variables: id (numeric), long (numeric), lat (numeric), locationType (character), formattedAddress (character) (5 pts).

#Q6. Use Google Geocoding API to geocode the first record in PCP and save the results to the dataframe "geo" (10 pts).

#Q7. Write a for loop to geocode all the records in pcp. Hint: you can loop from the first record to the last record, and for each iteration, geocode the record and store the results to the dataframe "geo" (25 pts).

#Q8. Obtain an API key from the TravelTime platform: http://docs.traveltimeplatform.com/overview/getting-keys/, save your key to "traveltimekey", save your application ID to "traveltimeappid", and run the codes below to get the 15-minute drive boundary to the location -82.34930, 29.63763 (that's where the first pcp is located) (10 pts).

traveltimekey<-''
traveltimeappid<-''

#set the parameters of the api call: e.g. id, coordiates, transportation type, travel time (in seconds)
qstring<-'
            {"arrival_searches": [
              {
              "id": "1",
              "coords": {
                          "lat": 29.63763,
                          "lng": -82.34930
                        },
              "transportation": {
                                  "type": "driving"
                                },
                "arrival_time": "2019-02-24T08:00:00Z",
                "travel_time": 1800
              }
              ]}
          '
#covert the string to json
apiqjson<-toJSON(fromJSON(qstring))

#send POST request
req<-POST(url="http://api.traveltimeapp.com/v4/time-map",
          config=add_headers(.headers=c(
            "Content-Type"="application/json",
            "X-Application-Id"=traveltimeappid,
            "X-Api-Key"=traveltimekey
          )),
          body=apiqjson,encode="json",verbose()
)

#obtain the results: search_id, and shapes
res<-content(req)$results
res[[1]]$search_id
res[[1]]$shapes

#save the shapes to a list
reslist<-list()
reslist[[1]]<-res[[1]]$shapes

#Q9. Write a for loop to get the 15-minute drive boundaries for the first 2 records in pcp, and save the shapes returned by the api call to a list called "reslist" (30 pts).

#Q10. Try to use the for loop in Q9 to get the boundaries for all the 143 records. Do you encounter any errors? Try to solve them by revising the for loop. Hint 1: within the loop, after making the POST request, you can check the status of "req". A status code=200 meaindicates that ns the api call is successful, and you can then proceed to the next step. Otherwise, you need to make the POST request again. You can do this with a while loop to check whether the status code is 200 or not. Hint 2: APIs usually have rate limits. In this case, the error is likely caused by too many requests within a short time period. One way to avoid this error is to let R pause for a small amount of time before a new API call is made. You can do this with the function Sys.sleep() (Bonus: 3 course total pts). 







