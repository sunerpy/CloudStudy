#!/bin/bash

errcode(){
	echo $1
	case $2 in 
	1)
		exit
		;;
	*) 
		echo $2
		;;
	esac
}

SCRIPT_PATH=${0%/*}
if [[ "X${SCRIPT_PATH}" == "X$0" || "X${SCRIPT_PATH}" == "X." ]];then
	SCRIPT_PATH=$(pwd)
else
	SCRIPT_P ATH=$(pwd)/${SCRIPT_PATH}
fi

PROJECT="${SCRIPT_PATH}/N-MCP"
DIRFILE="${SCRIPT_PATH}/DIRFILE"
INITFILE="${SCRIPT_PATH}/INITFILE"
DIRCOUNT=$(sed -n '/:/p' ${DIRFILE} )
DIRNUM=$(echo "${DIRCOUNT}" |wc -l)

dir_touch()
{
[[ -d ${PROJECT} ]] && errcode "Directory is exsiting!" 1 || mkdir ${PROJECT}
for i in ${DIRCOUNT}
do
	tmpdir=${PROJECT}/$(echo $i|sed -r 's/(.*)(:)(.*)/\1/')
	tmpfilenum=$(echo $i|sed -r 's/(.*)(:)(.*)/\3/' )
	mkdir ${tmpdir}
	namefiled=$(echo $i|awk -F ":" '{print $1}')
	
	OLDIFS=${IFS}
	IFS=$'\n'
	namearray=($(sed -n "/${namefiled}/p" ${DIRFILE} |tail -n +2))
	IFS="$OLDIFS" 
	
	nametmp=$(sed -n "/${namefiled}/p" ${DIRFILE})
	
	for j in "${namearray[@]}"
	do
		IPTMP=$(echo "$j"|awk '{print $2}')
		file_name=${tmpdir}/$(echo "$j"|awk '{print $1"-"$2".ini"}')
		cp -f ${INITFILE} ${file_name}
		sed -i -r "s/(.*)(Hostname)(..)(.*)/\1\2\3${IPTMP}/" ${file_name}
	done

done
}

dir_touch
