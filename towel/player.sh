#!/usr/bin/env bash

# An example for pausing running processes and controlling them using background processing and **traps**

# Function that will get executed when the user presses Ctrl+C
function handler(){
    echo "Processing the Ctrl+C"
    kill $proc_id 
    exit
}

# Assign the handler function to the SIGINT signal
trap handler SIGINT

play_file() {
    cat TelnetTowel.txt | while read txt; do echo $txt; sleep 0.02; done
    # sample -d 50 
}

script(){ #a mock for your script
    # echo $RANDOM 
    play_file
}

set -m #use job control
script & #run it in the background in a separate process group

proc_id=$(jobs -l | awk '{print $2}')
while :; do
    read -sd ' ' #silently read until a space is read
    kill -STOP $proc_id #stop the background process group
    while :; do
        read -sd ' '
        kill -CONT $proc_id
        break
    done
    # kill -CONT $proc_id #resume the background process group
    # fg #put it in the forground so it's killable with Ctrl+C
done

