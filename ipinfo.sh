#!/bin/bash

# Check for file presence
if [ $# -lt 1 ]; then
    echo "Usage: $0 <IP_file_name> [ipinfo_token]"
    exit 1
fi

FILE="$1"
TOKEN="$2"
HOSTNAMES_FILE="hostnames.txt"

# Colors
WHITE='\033[0;0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
HOSTNAMES=''

if [ -f "$HOSTNAMES_FILE" ]; then
    # Read hostnames from file
    HOSTNAMES=$(grep -v "^$" "$HOSTNAMES_FILE" | tr '\n' '|')
    HOSTNAMES=${HOSTNAMES%|} # Remove the last '|' character
fi

# Check for the existence of the IP file
if [ ! -f "$FILE" ]; then
    echo "Error: file $FILE not found"
    exit 1
fi

# Create a directory for results
RESULTS_FILE="ipinfo_results.log"

echo "Requesting information for IP addresses from file $FILE..."

# Counter to track progress
TOTAL=$(grep -v "^$" "$FILE" | wc -l)
COUNTER=0

# Process each IP address
while IFS= read -r ip || [[ -n "$ip" ]]; do
    # Skip empty lines
    [ -z "$ip" ] && continue

    # Increment counter
    ((COUNTER++))

    # Display progress
    echo -ne "Processing: $COUNTER out of $TOTAL IP addresses (${ip}) [$(( COUNTER * 100 / TOTAL ))%]\r"

    # Form the request
    if [ -n "$TOKEN" ]; then
        # Using token
        RESPONSE=$(curl -s "https://ipinfo.io/${ip}?token=${TOKEN}")
    else
        # Without token (limited access)
        RESPONSE=$(curl -s "https://ipinfo.io/${ip}")
    fi

    # Save the result to a file
    echo "${RESPONSE}" >> "$RESULTS_FILE"

    # Determine the output color
    if [[ $HOSTNAMES != "" ]]; then
        HOSTNAME=$(echo "$RESPONSE" | grep -oP '"hostname":\s*"\K[^"]+')
        if [[ -z "$HOSTNAME" ]]; then
            COLOR=$ORANGE
        elif [[ "$HOSTNAME" =~ $HOSTNAMES ]]; then
            COLOR=$GREEN
        else
            COLOR=$RED
        fi
    else
      COLOR=$WHITE
    fi

    # Display main information in the console
    echo -e "${COLOR}\nInformation about IP: $ip${NC}"
    echo -e "${COLOR}$(echo "$RESPONSE" | grep -E '"city"|"region"|"country"|"org"|"hostname"|"loc"')${NC}"
    echo "----------------------"

    # Delay to avoid exceeding request limits
    sleep 1
done < "$FILE"

echo -e "\nProcessing completed. Results saved in directory $RESULTS_FILE"