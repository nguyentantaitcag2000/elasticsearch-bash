#!/bin/bash

# Define ANSI color codes
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Run the df command to get disk usage information, filter for the total line, and store the result
if [ "$1" == "GB" ]; then
    df_output=$(df -h --total | grep total | sed 's/ \+/ /g')
    # Extract individual values in GB
    total_space=$(echo "$df_output" | awk '{print $2}')
    total_used=$(echo "$df_output" | awk '{print $3}') 
    total_available=$(echo "$df_output" | awk '{print $4}')
    # Output in GB format
    unit="GB"
else
    df_output=$(df -h --total -BM | grep total | sed 's/ \+/ /g')
    # Extract individual values in MB
    total_space=$(echo "$df_output" | awk '{print $2}')
    total_used=$(echo "$df_output" | awk '{print $3}') 
    total_available=$(echo "$df_output" | awk '{print $4}')
    # Output in MB format
    unit="MB"
fi

# Extract percentage used
percentage_used=$(echo "$df_output" | awk '{print $5}')
percentage_used_value=$(echo "$percentage_used" | sed 's/%//')

# Calculate percentage free
percentage_free=$((100 - percentage_used_value))

# Function to format disk space values
format_value() {
    # Check if the unit is GB or MB and format accordingly
    if [ "$unit" == "GB" ]; then
        # Use awk to add dots as thousands separators for GB
        formatted_value=$(awk -v value="$1" 'BEGIN { printf "%.3f", value }')
        # Check if the formatted value has .000, if yes, remove it
        if [[ $formatted_value =~ \.000$ ]]; then
            formatted_value=${formatted_value%.*}
        fi
        echo $formatted_value
    else
        # Use awk to add dots as thousands separators for MB
        awk -v value="$1" 'BEGIN { printf "%.3f", value / 1024 }'
    fi
}
# Output the results with aligned formatting
printf "Free:\t${green}%s${reset} (%s%%)\n" "$(format_value $total_available)" "$percentage_free"
printf "Used:\t${red}%s${reset} (%s)\n" "$(format_value $total_used)" "$percentage_used"
printf "Total:\t%s %s\n" "$(format_value $total_space)" "$unit"
