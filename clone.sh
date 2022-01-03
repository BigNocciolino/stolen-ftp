#!/usr/bin/env bash

#TODO: automatically delete old folders (mabye calling a third party script)
# |¬ See: https://stackoverflow.com/questions/17945538/delete-directory-based-on-date
#TODO: add colored output
#TODO: better time logging in csv file for performace test

URL=`jq .config.url config.json -r`
#For special characters https://www.w3schools.com/tags/ref_urlencode.ASP
USERNAME=`jq .config.username config.json -r`
PASSWORD=`jq .config.password config.json -r`
DIR_NAME="/$(date +"%d-%m-%Y")"
DIR_PATH=`jq .config.dw_path config.json -r`
SERVER_PATH=`jq .config.ftp_path config.json -r`
#DIR_COUNT=`ls -l $DIR_PATH | grep ^d | wc -l`
FULL_DW_PATH=$DIR_PATH$DIR_NAME

LOG_DIR="$DIR_PATH/log"
LOG_FILE="$LOG_DIR/log.txt"
LOG_ERROR_PREFIX="[X]"
LOG_INFO_PREFIX="[!]"

CSV_FILE="$LOG_DIR/performance.csv"

if [[ -d "$LOG_DIR" ]]; then
    echo "Starting log output in $LOG_DIR"
else
    echo "Creating log directory $LOG_DIR"
    mkdir -p $LOG_DIR
fi

#cech if log file exist to not overwrite
if [[ -f "$LOG_FILE" ]]; then
    #File exist
    echo "---------- `date` ----------" >> $LOG_FILE
    echo "$LOG_INFO_PREFIX Starting full backup " >> $LOG_FILE
    echo "$LOG_INFO_PREFIX OUTPUT DIR: $FULL_DW_PATH" >> $LOG_FILE
else
    #File doesen't exist
    echo "Creating log file"
    echo "BEGIN OF LOG FILE - $(date)" > $LOG_FILE
fi

#Always overwrite backup
START=`date +%s`
wget -m --user=$USERNAME --password=$PASSWORD "ftp://$URL/$SERVER_PATH" -P $FULL_DW_PATH
END=`date +%s`

RUNTIME=$((END-START))

#Ceck for csv file
if [[ -f "$CSV_FILE" ]]; then
    echo "`date`;$START;$END;$RUNTIME" >> $CSV_FILE
else
    echo "Creating csv file"
    echo "Date;Start;End;Job_running" > $CSV_FILE
fi

echo "$LOG_INFO_PREFIX Backup runned in $RUNTIME" >> $LOG_FILE
echo "---------------------------------------" >> $LOG_FILE
