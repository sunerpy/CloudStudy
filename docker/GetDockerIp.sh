#!/bin/bash
for ID in $(docker ps -q | awk '{print $1}')
do
    IP=$(docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$ID")
    NAME=$(docker ps | grep "$ID" | awk '{print $NF}')
    printf "%s \t %s\n" "$IP" "$NAME"
done
