#!/bin/bash

# Check if an input string was provided
if [ $# -eq 0 ]; then
    echo "No input string provided."
    exit 1
fi

# Input string from the first argument with spaces added
input_string=" $1 "

# Calculate the length of the input string
input_length=${#input_string}

# Total width of the header
total_width=50

# Number of hashes before and after the input string
num_hashes=$(( (total_width - input_length) / 2 ))

# Print the top line of hashes
echo $(printf '%*s' $total_width | tr ' ' '#')

# Print the input string centered and surrounded by hashes
printf '%*s' $((num_hashes + input_length)) "$input_string" | tr ' ' '#'
printf '%*s\n' $((total_width - num_hashes - input_length)) '' | tr ' ' '#'

# Print the bottom line of hashes
echo $(printf '%*s' $total_width | tr ' ' '#')
