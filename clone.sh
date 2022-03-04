#!/usr/bin/env bash

CONFIG_PATH=""
#Thanks to: https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

default_config() { CONFIG_PATH="$SCRIPTPATH/config.json"; }

while getopts ":c:" o; do
    case "${o}" in
        c)
            c=${OPTARG}
            CONFIG_PATH=$c
            ;;
        *)
            default_config
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${c}" ]; then
    default_config
fi

URL=`jq .config.url $CONFIG_PATH -r`
#For special characters https://www.w3schools.com/tags/ref_urlencode.ASP
USERNAME=`jq .config.username $CONFIG_PATH -r`
PASSWORD=`jq .config.password $CONFIG_PATH -r`
DIR_NAME="/$(date +"%d-%m-%Y")"
DIR_PATH=`jq .config.dw_path $CONFIG_PATH -r`
SERVER_PATH=`jq .config.ftp_path $CONFIG_PATH -r`
KEEP_BACKUP=`jq .config.keep_backup $CONFIG_PATH -r`
#DIR_COUNT=`ls -l $DIR_PATH | grep ^d | wc -l`
FULL_DW_PATH=$DIR_PATH$DIR_NAME

LOG_DIR="$DIR_PATH/log"
LOG_FILE="$LOG_DIR/log_$(date +"%d-%m-%Y").txt"
LOG_ERROR_PREFIX="[X][BASH]"
LOG_INFO_PREFIX="[!][BASH]"

CSV_FILE="$LOG_DIR/performance.csv"

if [[ -d "$LOG_DIR" ]]; then
    echo "Starting log output in $LOG_DIR"
else
    echo "Creating log directory $LOG_DIR"
    mkdir -p $LOG_DIR
fi

#check if log file exist to not overwrite
if [[ -f "$LOG_FILE" ]]; then
    #File exist
    echo "---------- `date` ----------" >> $LOG_FILE
    echo "$LOG_INFO_PREFIX Starting full backup " >> $LOG_FILE
    echo "$LOG_INFO_PREFIX Config file dir: $CONFIG_PATH" >> $LOG_FILE
    echo "$LOG_INFO_PREFIX OUTPUT DIR: $FULL_DW_PATH" >> $LOG_FILE
else
    #File doesen't exist
    echo "Creating log file"
    echo "BEGIN OF LOG FILE - $(date +%d-%m-%Y_%H-%M-%S)" > $LOG_FILE
fi

# redirect stdout/stderr to a file
exec >> $LOG_FILE 2>&1

#Ceck for csv file
if [[ ! -f "$CSV_FILE" ]]; then
    echo "Creating csv file"
    echo "Date (%d-%m-%Y_%H-%M-%S);Start (seconds since the Epoch);End (seconds since the Epoch);Job_time (seconds)" > $CSV_FILE
fi

#Always overwrite backup
START=`date +%s`
wget -nv -m --user=$USERNAME --password=$PASSWORD "ftp://$URL/$SERVER_PATH" -P $FULL_DW_PATH
END=`date +%s`

RUNTIME=$((END-START))

echo "`date +%d-%m-%Y_%H-%M-%S`;$START;$END;$RUNTIME" >> $CSV_FILE

#Start the script
echo "$LOG_INFO_PREFIX Starting the old_dirs script" >> $LOG_FILE
python3 $SCRIPTPATH/old_dirs.py $DIR_PATH -k $KEEP_BACKUP

echo "$LOG_INFO_PREFIX Backup runned in $RUNTIME s" >> $LOG_FILE
echo "---------------------------------------" >> $LOG_FILE
