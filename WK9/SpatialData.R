library(sp)
library(rgdal)
library(ggplot2)
library(rgeos)
library(maptools)
library(ggmap)
library(ggsn)
library(plyr)

setwd("/home/vmuser/Desktop/PHC7065SPR2021/WK9")

#1. Basics

#import geojson files to R
alachuabg<-readOGR(dsn="data/alachuabg.geojson",encoding = "OGRGeoJSON")
school<-readOGR(dsn="data/school.geojson",encoding = "OGRGeoJSON")

#spatial objects in R are made up of many slots. A key slot is @data, which stores non-spatial attribute data
head(alachuabg@data)
head(school@data)

#another key slot is @polygon, @lines, and @coords for polygons, lines, and points, respectively
head(alachuabg@polygons)
head(school@coords)

#we can also access the bounding box
alachuabg@bbox
school@bbox

#we can also check the SRS (it's called CRS or coordinate reference system in R)
alachuabg@proj4string
school@proj4string

#the SRS are already correctly specified, although it did not include the SRID 
#in R, we can access the details of a particular SRID by:
CRS("+init=epsg:4326")

#in case where you need to set the SRS, you can use the proj4string() function, e.g. set SRS as EPSG 4326: 
proj4string(alachuabg)<-CRS("+init=epsg:4326")
proj4string(school)<-CRS("+init=epsg:4326")

#you will see a warning message, which notified you that no corrdinates were transformed. only the SRS was changed
alachuabg@proj4string

#we can also create a dataframe with all the EPSG codes and details
epsgdetail<-make_EPSG()
head(epsgdetail)

#now, let's reproject the data to UTM 17N (EPSG: 26917)
alachuabgutm<-spTransform(alachuabg,CRS("+init=epsg:26917"))
alachuabgutm@proj4string

#let's do a quick plot using plot() function
plot(alachuabg)

#include schools
plot(alachuabg[alachuabg@data$countyfp=="001",],col="lightgray")
points(school,col="red",pch=18)

#create and manipulate spatial data in R
#let's first create a dataframe which stores coordinates
df<-data.frame(x=1:3,y=c(1/2,2/3,3/4))

#let's then convert these coordinates to SpatialPoints
rpt<-SpatialPoints(coords=df)

#we can also add non-spatial data to it, and make it SpatialPointsDataFrame
rptdf<-SpatialPointsDataFrame(rpt,data=df)

#we can also export it as KML (before exporting, we must set the SRS)
proj4string(rptdf)<-CRS("+init=epsg:4326")
writeOGR(rptdf,dsn="data/rptdf.kml",layer="rptdf",driver = "KML")

#2. Geotag

head(alachuabg@data)
head(school@data)
over(school,alachuabg)

school$fips<-as.character(over(school,alachuabg)$geoid)
head(school@data)

#3. Visualization

#let's now make a better map using ggplot2
#the basic plot() function can use Spatial* objects direclty, however, ggplot cannot. Therefore, we must extract them as a data frame using the fortify() function from package rgeos and maptools first

alachuabg_f<-fortify(alachuabg,region="geoid")
head(alachuabg_f)

alachuabg_data<-alachuabg@data
head(alachuabg_data)

alachuabg_data$id<-alachuabg$geoid
alachuabg_f<-join(alachuabg_f,alachuabg_data,by="id")

head(alachuabg_f)

#now let's create a map using ggplot2
map1<-ggplot()+geom_polygon(data=alachuabg_f,aes(long,lat,group=group,fill=aland,alpha=0.3))+geom_path(color="white")+coord_equal()+theme(panel.background=element_blank(),axis.title=element_blank(),axis.text=element_blank(),axis.ticks = element_blank())+scale_fill_gradientn("Land Area",colours=c("#DFEBF7","#11539A"))
map1

#let's now display locations of schools on the map
map2<-map1+geom_point(data=school@data,aes(x=lon_ggmap,y=lat_ggmap,group=id,col=type),size=2)+labs(col="Type")
map2

#use ggmap to retrieve the google map for a given area
#before that, we need to enable the Google Static Maps API: https://console.developers.google.com/apis/dashboard (go to Enable APIs and Services)
#register your api key
register_google("")

#get the centroid of the area
gnv_center<-as.numeric(geocode("Gainesville,FL"))

#retrieve the map
myMap<-get_map(location=gnv_center,source="google",maptype="roadmap",crop=F)
ggmap(myMap)

#add polygon and points to it
map3<-ggmap(myMap)+geom_polygon(data=alachuabg_f,aes(long,lat,group=group,fill=aland,alpha=0.7))+coord_equal()+theme(panel.background=element_blank(),axis.title=element_blank(),axis.text=element_blank(),axis.ticks = element_blank())+scale_fill_gradientn("Land Area",colours=c("#DFEBF7","#11539A"))
map3

map4<-map3+labs(col="Type")+geom_point(data=school@data,aes(x=lon_ggmap,y=lat_ggmap,group=id,col=type),size=2)
map4

#add a north arrow and a scale bar
map5<-map4+north(alachuabg_f,scale=0.2,symbol=3,location="topright")+scalebar(alachuabg_f,location="bottomleft",transform=T,dist_unit = "mi",model="WGS84",dist=10,st.dist = 0.05)
map5

#export the map as a png image
ggsave("map.png",dpi=300)

