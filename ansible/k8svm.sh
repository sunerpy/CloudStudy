#!/bin/bash
#   if [ -n "$1" ];then
#       while getopts :n: opt
#           do
#           case $opt in
#                n)HCResult=$OPTARG
#                    ;;
#                *)echo "unknown options! script stop!"
#                   echo "Usage:"
#                   echo "$0 -[st|sp] <start|stop>"
#                   exit
#                   ;;
#           esac
#           done
#   fi
hosts=(servera serverb serverc serverd)
case $1 in
    "start"|"shutdown")
        #echo ${hosts[@]}
        for i in ${hosts[@]}
        do
            sudo virsh $1 "${i}"
        done
        sudo virsh list --all
        ;;
    *)
        echo "Input error"
        ;;
esac
