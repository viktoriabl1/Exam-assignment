#!/bin/bash
#the code over tells it that this is going to be ran as a bash script

#Using wget to download the wikipedia file
#-0 specifies the name of the file with the info collected
wget -O wikipedia.html https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway

#Using echo to output a html file
#This will output the index.html file
#I added the structual tags to buils the website and styling to style the website

echo "<html>
	<head>		<title>Municipalities of Norway</title>
	<style>
        body { font-family: Calibri, sans-serif; margin: 20px; padding: 20px; min-height: 150px; display: flex; flex-direction: column; }
        .header { background-color: rgb(192,192,192); text-align: center; padding: 20px; margin: 30px; }
        .content { flex: 1; }
        h1{ color: rgb(178,34,34); }
        table { border-collapse: collapse; width: 100%; margin-bottom: 15px; }
        th, td { border: 1px solid rgb(221,221,221); padding: 10px; text-align: center; }
        tr:nth-child(even) { background-color: rgb(220,220,220); }
        tr:hover { background-color: (241,241,241); }
        .footer { background-color: rgb(122,122,122); text-align: center; padding: 20px; position: fixed; bottom: 0; font-style: italic; width: 100%; margin: auto; align: center; }
   	 </style>
	</head>
	<body>
    <div class='header'>
        <h1>Municipalities of Norway</h1>
        <p> This project is hosted on a raspberry pi with apache2 as web server. This project was created by student with exam-id code 10010, and is the final assignment in the subject IDG1100.
        The table below is taken from the  <a href='https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway'>Wikipedia</a>.</p>
    </div>
    <div class='content'>" > table.html

#The sed editor can extract specific information
#Here I extract the information i want from the wiki.html to table.html file with sed and with the >> tags transfers it
#The -n after sed specifies that the specific info is private between the parts
#Inside the '' the sed -n select the specified content I want to extract, here the table
sed -n '/<table class="sortable wikitable">/,/<\/td><\/tr><\/tbody><\/table>/p' wikipedia.html >> table.html

#new echo to print the footer
#starting new echo so the sed doesnt get rendered as text instead of a command.
echo "    </div>
    <div class='footer'>
        Made by student with exam-id 10010 for the subject IDG1100.
    </div>
</body>
</html>" >> table.html
























