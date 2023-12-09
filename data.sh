#!/bin/bash

#BASH SCRIPT TO EXTRACT PLACE, COORDINATIONS AND POPULATION FROM EACH MUNICIPALITY

	#Using the wikipedia url to  fetch the information needed

	#Fetching the wikipedia site and making a text file
	#This way I have it downloaded as a text file and its easier to acsess and dowloaded locally
		wget -O wikipedia.txt https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway

	#Use the just fetched wikipedia.txt file and turn it into one line called line.txt
		cat "wikipedia.txt" | tr -d '\n\t' > line.txt

	#Extracting the table from the line.txt file to a table.txt file
		sed -E 's/.*<table class="sortable wikitable">(.*)<\/table>.*/\1/g' line.txt | sed 's/<\/table>/\n/g' | sed -n '1p' | grep -o '<tbody[ >].*<\/tbody>' | sed -E 's/<tbody[^>]*>(.*)<\/tbody>/\1/g' | sed -E 's/<tr[^>]*>//g' | sed 's/<\/tr>/\n/g' | sed -E 's/<td[^>]*>//g' | sed 's/<\/td>/\t/g' | sed '1d' > table.txt

	#Extracting the second column from the table.txt which is the name of the municipality
		cut -f 2 table.txt > placepopulation.txt

	#Making sure the first line is blank so it matches up with the other file line by line
		echo "" > population.txt

	#Extracting the fifth column from the table.txt which is the population numbers of each municipality
		cut -f 5 table.txt >> population.txt

	#Making a file that has the url for each of the pages and the places name behind it
		awk 'match($0, /href="[^"]*"/){url=substr($0, RSTART+6, RLENGTH-7)} match($0, />[^<]*<\/a>/){printf("%s%s\t%s\n", "https://en.wikipedia.org", url, substr($0, RSTART+1, RLENGTH-5))} ' placepopulation.txt  > urlforplaces.txt




	#Now that I have the url for each municipality, I can extract the specific information from each one of them
	#Makes the placecoordinations.txt file with the name of the municipilty and the coordinates behind it, on municipality on each line

	#Making the first line blank so it matches with the other files line by line, as done with population.txt
		echo "" > placecoordinates.txt


	#Reading the url and fetching the coordinates
		while read -r url place; do
    		Fetchlatlon=$(curl -s "$url")

	#If the url visited are empty, it will pop up a error code in the terminal, with the specified echo output
	#Then you'll know you most likely have the wrong url

		if [ -z "$Fetchlatlon" ]; then
       			 echo "Error fetching coordinates for $place ($url)"
       		 continue
   	 	fi

	#Giving the latitude the variable $lat, then using this to fetch latitude from the urls
		lat=$(echo "$Fetchlatlon" | grep -o '<span class="latitude">[^<]*' | head -n 1 | sed 's/<span class="latitude">//' )

	#Giving the longitude the variable $lon, then using this to fetch longitude from the urls
		lon=$(echo "$Fetchlatlon" | grep -o '<span class="longitude">[^<]*' | head -n 1 | sed 's/<span class="longitude">//' )



	#Asure the information we are looking for was found in the urls
	#If not I will recieve the error message data not found
   	 	if [ -z "$lat" ] || [ -z "$lon" ]; then
        		echo "Error: Latitude or longitude not found for $place ($url)"
        	 continue
    		fi

	#Appending all the information retrived to one file with the name of the place then the coordinates, first latitude, then longitude
		printf "%s\t%s\t%s\n" "$place" "$lat" "$lon" >> placecoordinates.txt

	#Defining that we are done using the urlforplaces.txt
		done < urlforplaces.txt



	#From all the info retrived in this bash script making one combined file with the place, coordinates, and population for each municipality on one and one line
		paste -d ' ' placecoordinates.txt  population.txt > placecoordspopulation.txt


	#Printing the file place.txt by extracting the name from the urlforplaces.txt file
	#Firstly makin the first line blank like the others
		echo "" > places.txt
		awk '{ $1=""; print $0 }'  urlforplaces.txt | sed 's/ /-/g' | sed 's/ /-/g' | sed 's/ /-/g' >> places.txt
