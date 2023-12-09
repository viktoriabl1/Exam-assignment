#!/bin/bash

#THIS BASH SCRIPT CREATES THE DATAPARAG AND MAKES A WEBSITE WITH THE PARAGRAPHS INSERTED

	#Making a file called data.txt from places.txt, population.txt and latlondeci.txt
		paste places.txt population.txt latlondeci.txt | sed '1d;$d' > data.txt


	#Then making the dataparag.txt file which I will implement in the parag.html webpage

	#getting the data.txt file to output the name, population and latitude+longitude
	file="data.txt"

	#make it output paragdata.txt to use in parag.html later
	output="dataparag.txt"


	while IFS= read -r line; do


 	#Extracting name, population, latitude and longitude from the data.txt file and inserting it in a paragraph

	#Extracting name of each municipality line by line
	name=$(echo "$line" | awk '{print $1}' | sed 's/-//')

 	#Extracting the population of each municipality line by line
	population=$(echo "$line" | awk '{print $2}')

	#Extracting latitude of each municipality line by line
	latitude=$(echo "$line" | awk -F 'LAT= ' '{print $2}' | awk '{print $1}')

	#Extracting longitude from each municipality line by lien
 	longitude=$(echo "$line" | awk -F 'LON= ' '{print $2}' | awk '{print $1}')


	#Creating the paragraph with the extracted elements, this will appear on the webiste
	paragraph="This municipality is called $name, has a population of $population.$name is located at latitude $latitude and longitude $longitude."


	#Making the paragraph inserted in the output file daraparag.txt file
	echo "$paragraph" >> "$output"
	done < "$file"


#CREATING THE WEBSITE

#This will output the parag.html
#I added the structual tags to build the website and styling to style the website
echo "<html>
	 <head> <title>Municipalities of Norway</title>
	 <style>
	 body { font-family: Calibri, sans-serif; margin: 20px; padding: 20px; min-height: 150px; display: flex; flex-direction: column; text-align: center; }
	 .header { background-color: rgb(192,192,192); text-align: center; padding: 20px; margin: 30px; }
	 .content { flex: 1; margin: 30px; text-align: center; }
	 h1{ color: rgb(178,34,34); }
       	 .footer { background-color: rgb(122,122,122); text-align: center; bottom: 0; padding: 20px; position: fixed; font-style: italic; width: 100%; margin: auto; align: center; }
	 </style>
	 </head>
	 <body>
 		 <div class='header'>
       		 <h1>Municipalities of Norway</h1>
       			 <p> This project is hosted on a raspberry pi with apache2 as web server. This project was created by student with exam-id 10010  and is the final assignment in the subject IDG1100.
        		Here I have extracted information from  <a href='https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway'>Wikipedia</a> table, and used bash scripting to extract
			 specific information. Under is a paragraph for each municipality of Norway, its population and its latitude and longitude. </p>
   		 </div>
  	 <div class='$paragraph'>" > parag.html

#The sed editor can extract specific information
#Here I extract the information i want from the paragdata.txt  file to the parag.html file with sed and with the >> tags transfers it
#The -n after sed specifies that the specific info
sed -n 's/^\(.*\)$/<p>\1<\/p>/p' dataparag.txt >> parag.html

#new echo to print the footer
#starting new echo so the sed doesnt get rendered as text isntead of a command.
echo "
   	 <div class='footer'>
        Made by student with exam-id 10010 for the subject IDG1100.
   	 </div>
	</body>
	</html>" >> parag.html

#TASK C DONE
