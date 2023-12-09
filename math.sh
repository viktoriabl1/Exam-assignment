#!/bin/bash

#THIS BASH FILE CONVERTS THE COORDINATES TO DECIMALS
	#Outputs the latlondeci.txt in the end with latitude and longitude in decimals
	#Saving most of the outputs file in the math folder, except the last one

	#Using the placecoordspopulation.txt file made by data.sh

	#Extracting just the coordinates from each line and creating a file with just coordinates on the lines
	#Putting it into the math folder and as a coordinates.txt file

	#Making the first line empty
	echo "" > coordinates.txt

	sed 's/[a-zA-Z\-]//g' placecoordspopulation.txt | awk '{print $1, $2}' > math/coordinates.txt



	#Create a file for longitude numbers and one for langitude numbers from the coordinates.txt file
	#Removing the symbols so only numbers are left

	#Latitude extract from coordinates.txt
	awk '{print $1}' math/coordinates.txt > math/latitude.txt


	#Longitude extract from coordinates.txt
	awk '{print $2}' math/coordinates.txt > math/longitude.txt


	#Removing symbols in the latitude.txt file and outputting it as latitude2.txt file
	sed 's/°/ /g' math/latitude.txt | sed 's/\′/ /g'| sed 's/\″//g' > math/latitude2.txt


	#Removing symbols in the longitude.txt file and outputting it as longitude2.txt
	sed 's/°/ /g' math/longitude.txt | sed 's/\′/ /g'| sed 's/\″//g' > math/longitude2.txt


	#Converting the numbers from the files to decimals at requested

	#Converting latitude
	awk '{ result = $1 + $2/60 + $3/3600; print "LAT= " result }' math/latitude2.txt > math/latitude3.txt

	#Converting longitude
	awk '{ result = $1 + $2/60 + $3/3600; print "LON= " result }' math/longitude2.txt > math/longitude3.txt


	#Create one file with by pasting the latitude3.txt and the longitude3.txt file into one
	#Making the first line empty

	echo "" > latlondeci.txt

	paste math/latitude3.txt math/longitude3.txt > latlondeci.txt
