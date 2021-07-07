#!/bin/bash

SITESFILE=sites.txt #list the sites you want to monitor in this file
EMAILS="you@email.com,someoneelse@email.com" #list of email addresses to receive alerts (comma separated)

while read site; do
    if [ ! -z "${site}" ]; then
        
        CURL=$(curl -s --head $site)
        
        if echo $CURL | grep "200 OK" > /dev/null
        then
            echo "The HTTP server on ${site} is up!"
        else    

            MESSAGE="This is an alert that your site ${site} has failed to respond 200 OK."

            for EMAIL in $(echo $EMAILS | tr "," " "); do
                SUBJECT="$site (http) Failed"
                echo "$MESSAGE" | mail -s "$SUBJECT" $EMAIL
                echo $SUBJECT
                echo "Alert sent to $EMAIL"
            done      
        fi
    fi
done < $SITESFILE
