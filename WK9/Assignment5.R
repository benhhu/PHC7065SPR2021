#Assignment 5

#Q1. Load the packages "sp", "rgdal", "ggplot2", "rgeos", "maptools", "ggmap", "ggsn", "plyr", and "sf" (0 pt).


#Q2. Set working directory to "WK9" folder (0 pt).

#####################
#Introduction to WKT#
#####################

#WKT is a common format used to represent spatial data:
wkt<-"POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))"
spwkt<-readWKT(wkt)
plot(spwkt)

#A polygon with one hole:
wkt<-"POLYGON((0 0, 0 1, 1 1, 1 0, 0 0),(0.25 0.25, 0.25 0.5, 0.5 0.5, 0.5 0.25, 0.25 0.25))"
spwkt<-readWKT(wkt)
plot(spwkt)

#A polygon with two holes:
wkt<-"POLYGON((0 0, 0 1, 1 1, 1 0, 0 0),(0.25 0.25, 0.25 0.5, 0.5 0.5, 0.5 0.25, 0.25 0.25),(0.75 0.75, 0.75 0.8, 0.8 0.8, 0.8 0.75, 0.75 0.75))"
spwkt<-readWKT(wkt)
plot(spwkt)

#Q3. Import "reslist143.Rda", which include 30-minute drive boundaries to PCPs (1 pt).

#Q4. Get the boundary for the first PCP and save it as "reslist1" (4 pts).

#Q5. Extract the shell and holes from the first PCP, and save it as shell and holes. Hint: You can flatten a list using the unlist() function (5 pts).

#Q6. Convert shell to a string (name it shellstring) following the WKT format: e.g. (1 1, 0 0, ..., 1 1). (10 pts)

#Q7. Convert the first hole from holes to a string (name it holesstring) following the WKT format: e.g. (1 1, 0 0, ..., 1 1). (10 pts)

#Q8. Write a loop to convert all holes to a WKT formatted string (name it holesstring): e.g. (1 1, 0 0, ..., 1 1), (1 0, 0 0, ..., 1 0). (10 pts)

#Q9. Combine "shellstring" and "holesstring", wrap them with "POLYGON()", and save it as "wktstring". (2 pts)

#Q10. Covert "wktstring" to a spatialpolygon "pcp1", and plot it. (3 pts)

#Q11. We have generated the spatialpolygon for the 30-minute drive boundary to the first PCP. Now write a loop to generate spatialpolygons for all PCPs. Save the spatialpolygons as "pcp1", "pcp2 , ..., "pcp143". Hint: some boundaries may not have holes, and the number of holes is not the same for different boundaries. These need to be taken care of in the loop. (20 pts)

#Q12. merge the boundaries and save it as "pcp". Hint: 1) use the st_union() function from "sf" package, 2) st_union() function only works with sf objects, so you need to covert spatialpolygons to sf first using the function st_as_sf(). (5 pts)

#Q13. Convert "pcp" back to spaitalpolygons using the function as_Spatial(). (2 pts)

#Q14. Set the SRID as 4326 for "pcp". (3 pts)

#Q15. Create a map to show the 30-minute drive boundary to PCPs with Google's roadmap as basemap. Hint: to correctly show polygons with holes, you will need to use the geom_polypath() function in the package "ggpolypath" instead of geom_polygon() function. (5 pts)

#Q16. Import the block boundaries for alachua county as "alachuabk". Hint: use encoding="ESRI Shapefile" in the function readOGR(). (3 pts)

#Q17. Transform the SRS of "alachuabk" to 4326. (2 pts)

#Q18. Get the centroid coordinates for each block and save the results as "bkcentroid". Hint: use gCentroid() function. (5 pts)

#Q19. Determine whether the block centroids are located within the 30-minute drive boundary. (10 pts)
