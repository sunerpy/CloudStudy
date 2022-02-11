#!/bin/bash
read -p "Input:" KEY
if [[ ${KEY} =~ ^[0-9]{3,6}$ ]];then
	echo "num"
else
	echo "other"
fi
