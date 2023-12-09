#!/bin/bash

# Input file
input_file="../latlondeci.txt"

# Output file
output_file="latlon.txt"

# Remove output file if it already exists
if [ -f "$output_file" ]; then
    rm "$output_file"
fi

# Iterate over each line in the input file
while IFS= read -r line; do
    # Extract latitude and longitude numbers using awk
    lat=$(echo "$line" | awk -F'LAT= ' '{print $2}' | awk -F'LON= ' '{print $1}')
    lon=$(echo "$line" | awk -F'LON= ' '{print $2}')

    # Remove leading and trailing whitespace from latitude and longitude numbers
    lat=$(echo "$lat" | awk '{$1=$1};1')
    lon=$(echo "$lon" | awk '{$1=$1};1')

    # Write latitude and longitude numbers to the output file

	 echo "$lat   $lon" >> "$output_file"
done < "$input_file"
