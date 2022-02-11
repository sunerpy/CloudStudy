#!/bin/bash
LOGFILE=/tmp/acrs.log
ls > ${LOGFILE}
whoami>> ${LOGFILE}
pwd >>${LOGFILE}
