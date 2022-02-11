#!/bin/bash
read -p "Input:" KEY
case ${KEY} in
    \([0-9]\)\{5,10\})
        echo "num"
        ;;
    [0-9][0-9])
        echo "two"
        ;;
    *)
        echo "other"
        ;;
esac
