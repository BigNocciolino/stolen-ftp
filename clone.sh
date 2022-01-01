#!/usr/bin/env bash

URL=`jq .config.url config.json -r`
#%40 is for decoding @ in urls
USERNAME=`jq .config.username config.json -r`
PASSWORD=`jq .config.password config.json -r`
DIR_NAME="/$(date +"%d-%m-%Y")"
DIR_PATH=`jq .config.dw_path config.json -r`
#DIR_COUNT=`ls -l $DIR_PATH | grep ^d | wc -l`
FULL_PATH=$DIR_PATH$DIR_NAME

LOG_FILE="$DIR_PATH/log/log.txt"
LOG_ERROR_PREFIX="[X]"
LOG_INFO_PREFIX="[!]"

#TODO: cech if file exist to not overwrite
#echo "BEGIN OF LOG FILE - $(date)" > LOG_FILE
echo "$LOG_INFO_PREFIX Starting full backup " >> $LOG_FILE
echo "$LOG_INFO_PREFIX DIR: $FULL_PATH" >> $LOG_FILE

#TODO: time logging in csv file for performace test
#Always overwrite baskup
START=`date +%s`
wget -m "ftp://$USERNAME:$PASSWORD@$URL" -P $FULL_PATH
END=`date +%s`

RUNTIME=$((END-START))

echo "$LOG_INFO_PREFIX Backup runned in $RUNTIME" >> $LOG_FILE
echo "---------------------------------------" >> $LOG_FILE
