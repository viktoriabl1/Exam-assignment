#!/bin/bash
#Defining the input file to use to insert into link
input_file="latlon.txt"

#Execute if files already exists, here we want the information to be updated
> weather.txt
> weatherparag.txt

# Read the latlon.txt file line by line
while IFS= read -r line && [[ -n $line ]]; do
  # Get the latitude and longitude from each line
  latitude="$(echo "$line" | awk '{print $1}')"
  longitude="$(echo "$line" | awk '{print $2}')"

  # Replace the placeholders in the API URL with latitude and longitude variables
  api_url="https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=${latitude}&lon=${longitude}"

  # Fetch the weather data from the API
  weather_data=$(curl -s "$api_url")

  # Extract the required information from the weather data
  temperature=$(echo "$weather_data" | jq -r '.properties.timeseries[0].data.instant.details.air_temperature')
  precipitation=$(echo "$weather_data" | jq -r '.properties.timeseries[0].data.next_1_hours.details.precipitation_amount')
  humidity=$(echo "$weather_data" | jq -r '.properties.timeseries[0].data.instant.details.relative_humidity')

  # Save the weather data to a file
  echo "Latitude: $latitude" >> weather.txt
  echo "Longitude: $longitude" >> weather.txt
  echo "Temperature: $temperature" >> weather.txt
  echo "Precipitation: $precipitation" >> weather.txt
  echo "Humidity: $humidity" >> weather.txt

#Making a seperator to create a more organized file
  echo "**********************************" >> weather.txt


# Save the weather data to the weatherparag.txt file
echo "This is the weather data for this $municipality: Temperature: $temperature degrees, precipitation: $precipitation mm  and humidity: $humidity %." >> weatherparag.txt


done < <(tail -n +2 "$input_file")

#######################################################################################################

 #CRON JOB
 # Add a cron job to update the parameters every half hour
 # i set up a cron job that looks like this: */30 * * * * /bin/bash /var/www/html/project/weather/weather.sh in the /tmp/crontab.0k0saG/crontab folder

#######################################################################################################

 #CREATING FILES TO INPUT INTO WEBSITES

 #Combining the paragraph for task d, c and b into one file, that will be implemented in the overview webpage at the end
 #Define the input files
  dataparag="../dataparag.txt"
  weatherparag="weatherparag.txt"

 #Define the output file
  output="combineparag.txt"

 #Clear the output file if it exists
  > combineparag.txt

 #Read the lines from both files simultaneously
  paste -d " " "$dataparag" "$weatherparag" | while IFS=$'\t' read -r dp wp; do

 #Write the merged paragraph to the output file
  echo "$dp $wp" >> "$output"

  done

########################################################################################################

#Delete the file if it already exist, so the new input will appear
> link.txt

 #Add the links to each municipality's dynamic page and creates a link.txt file
 awk '{print $5}' /var/www/html/project/weather/combineparag.txt |tr -d ','| while read municipality; do
    link="http://viktoriabl.dynv6.net/project/weather/pages/$municipality.html"
    echo "View the <a href=\"$link\">$municipality</a> website" >> /var/www/html/project/weather/link.txt
 done

#########################################################################################################

 #Defining the input files
  combineparag="combineparag.txt"
  link="link.txt"

 #Defining the output file
  outputfile="combineall.txt"

 #Clear the output file if it exists
  > combineall.txt

  #Read the lines from both files simultaneously
  paste -d" " "$combineparag" "$link" | while IFS=$'\t' read -r cg l; do

  #Write the merged paragraph to the output file
   echo "$cg $l" >> "$outputfile"

done

############################################################################################################



  #CREATING THE WEBPAGE FOR TASK C

 #Using echo to output a html file
 #This will output the parag.html
 #I added the structual tags to build the website and styling to style the website
 echo "<html>
	 <head> <title>Municipalities of Norway</title>
	 <style>
	 body { font-family: Calibri, sans-serif; margin: 0 auto; padding: 20px 50px; min-height: 150px;  text-align: center; }
	 .header { background-color: rgb(192,192,192); text-align: center; padding: 20px; margin: 30px; }
	 h1{ color: rgb(178,34,34); }
       	 .footer { background-color: rgb(122,122,122); text-align: center; bottom: 0; padding: 20px; position: fixed; font-style: italic; width: 100%; margin: auto; align: center; }
	 </style>
	 </head>
	 <body>
 		 <div class='header'>
       		 <h1>Municipalities of Norway</h1>
       			 <p> This project is hosted on a raspberry pi with apache2 as web server. This project was created by a student with student exam code 10010, and is the final assignment in the subject IDG1100.
        		Here I have extracted information from  <a href='https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway'>Wikipedia</a> table, and used bash scripting to extract
			 specific information. Under is a paragraph for each municipality of Norway, its population and its latitude and longitude. </p>
			<p> In addition to that i have also extracted the weatherforecast for each municipality. It tells the temperature, the precipitation and the humidity for the next day, tommorow.
				The website updates every 30 min so the weather data is always up to date.
			 </p>
   		 </div>
  	 <div class='$paragraph'>" > weather.html

 #The sed editor can extract specific information
 #Here I extract the information i want from the paragdata.txt  file to the parag.html file with sed and with the >> tags transfers it
 #The -n after sed specifies that the specific info
 sed -n 's/^\(.*\)$/<p>\1<\/p>/p' combineparag.txt  >>  weather.html

 #new echo to print the footer
 #starting new echo so the sed doesnt get rendered as text isntead of a command.
 echo "
   	 <div class='footer'>
        Made by student with student exam-id 10010 for the subject IDG1100.
   	 </div>
	</body>
	</html>" >> weather.html


#################################################################################################

 #CREATING THE WEBPAGE FOR TASK B

 #Using echo to output a html file
 #This will output the overview.html
 #I added the structual tags to build the website and styling to style the website
  echo "<html>
         <head> <title>Municipalities of Norway</title>
         <style>
         body { font-family: Calibri, sans-serif; margin: 20px; padding: 20px 100px; min-height: 150px; text-align: center;  }
         .header { background-color: rgb(192,192,192); text-align: center; padding: 20px 50px; margin: 30px; }
         h1{ color: rgb(178,34,34); }
         .footer { background-color: rgb(122,122,122); text-align: center; bottom: 0; padding: 20px; position: fixed; font-style: italic; width: 100%; margin: auto; align: center; }
   </style>
         </head>
         <body>
                 <div class='header'>
                 <h1>Municipalities of Norway</h1>
                         <p>
			 This project is hosted on a raspberry pi with apache2 as web server.This project was created by a student with exam id 10010, 
			and is the final assignment in the subject IDG1100.
                        Here I have extracted information from <a href='https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway'>Wikipedia</a> table, and used bash scripting to extract
                         specific information. Under is a paragraph for each municipality of Norway, its population and its latitude and longitude.
			 </p> 
                        <p> In addition to that i have also extracted the weatherforecast for each municipality.
			In the end of each paragraph you can click the link called the municipality's name. This will guide you
			to a dynamically created webpage just for that specific municipality.
			 </p>
                 </div>
         <div class='$paragraph'>" > overview.html

 #The sed editor can extract specific information
 #Here I extract the information i want from the paragdata.txt  file to the parag.html file with sed and with>
 #The -n after sed specifies that the specific info
 sed -n 's/^\(.*\)$/<p>\1<\/p>/p' combineall.txt  >>  overview.html

 #new echo to print the footer
 #starting new echo so the sed doesnt get rendered as text isntead of a command.
 echo "
         <div class='footer'>
        Made by student with exam-id 10010 for the subject IDG1100.
         </div>
        </body>
        </html>" >> overview.html

 #######################################################################################
 #DYNAMICALLY GENERATING THE WEBPAGE FOR EACH MUNICIPALITY

 #Read combineall.txt line by line
 while IFS= read -r line; do
    # Extract the fifth word of the line as the municipality name
    municipality=$(echo "$line" | awk '{print $5}' | tr -d ',')

    # Remove any leading/trailing whitespaces from the municipality name
    municipality=$(echo "$municipality" | awk '{$1=$1};1')

	#Delete the old HTML info when executing the script again.
	if [[ -f "$municipality.html" ]]; then
	 rm "$municipality.html"
	 fi

    # Generate the URL using the municipality name
    url="http://viktoriabl.dynv6/project/weather/pages/$municipality.html"

    #Adding css rules and style to not make the webpage generated so boring
    echo "<html> <head>
	 <style>
	 body { font-family: Calibri, sans-serif; margin: 0 auto; padding: 30px; min-height: 150px; text-align: center; background-color:rgb(211,211,211) }
	 h1{ background-color: rgb(192,192,192);text-align: center;padding: 20px; margin: 30px;	font-size: 20px;color: rgb(178,34,34); }
	 p{margin: 30px;text-align: center; }
	div{ padding: 10px 40px; justify-content:center; }
 	 footer { background-color: rgb(122,122,122);text-align: center;bottom: 0;padding: 15px;position: fixed;font-style: italic;width: 100%; margin: auto; }
	</style>
	</head>
	<body>
	<h1>"$municipality"</h1>
	<div>
	<p>"$line"</p>
	</div>
	<footer>My student code is 10010 and these websites are created for the subject IDG1100 on my Raspberry PI </footer>
	</body>
	</html>"  > pages/$municipality.html

done < combineall.txt
