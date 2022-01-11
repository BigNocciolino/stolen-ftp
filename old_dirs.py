import os
import shutil
import sys
import re
from datetime import datetime
import logging
import argparse

parser = argparse.ArgumentParser(description="Find the saved folders with a date format and delete the oldest ones")
parser.add_argument('-k', help="The number of backup folder to keep", type=int, default=4)
parser.add_argument('dw_path', help="The path where the backup are stored")
args = parser.parse_args()

#Regex pattern to find only folder named as date
pattern = "^([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])(.|-)([1-9]|0[1-9]|1[0-2])(.|-|)20[0-9][0-9]$"
path = args.dw_path
keep_backup = args.k
log_file = os.path.join(path, "log/log.txt")

#Confnig for the logger
LOG_PY_PREFIX="[PY]"
extra = {'log_py': LOG_PY_PREFIX}
logger = logging.getLogger(__name__)
logging.basicConfig(filename=log_file, format='%(log_py)s %(message)s', level="INFO")
logger = logging.LoggerAdapter(logger, extra)

print(f"Starting log output at {log_file}")

x = ""
date_dirs = []
old_folders = []
filetimes = []
keep = []

try:
    dir_list = os.listdir(path)
except OSError:
    logger.error("Invalid directory, can not list dirs, exiting")
    sys.exit()

if len(dir_list) > 0:
    #Travel all the list
    for dir in dir_list:
        #Search if the dir_name match the regex pattern
        x = re.search(pattern, dir)
        if (x):
            date_dirs.append(dir)
else: 
    logger.info("The download folder is empity")

#Convert the string dates saved in date_dirs list into a datetime object
#So after we can sort it
for i in range(len(date_dirs)):
    filetimes.append(datetime.strptime(date_dirs[i], "%d-%m-%Y"))

#Sort the list
#The newest date is the first
filetimes = sorted(filetimes)
#Reverse the list
filetimes=filetimes[::-1]

for x in range(keep_backup):
    #Append always 0 beacouse we pop the item, so delete it in the filetimes list and save it into keep list
    #So every time we do this the newest date is always at the index 0
    keep.append(filetimes.pop(0))

#Now filetimes object has the oldest folder (we don't want that)
#now we need to reformat into the original name
for x in range(len(filetimes)):
    filetimes[x] = filetimes[x].strftime("%d-%m-%Y")
#Now we delete that
if len(filetimes) <= 0:
    logger.info("No dir to delete, skipping")
else:
    for dir in filetimes:
        dir = os.path.join(path, dir)
        if os.path.exists(dir):
            try:
                shutil.rmtree(dir)
                logger.info("Removed '%s'" %dir)
            except OSError as error:
                logger.error(error)
                logger.error("Directory '%s' can not be removed" %dir) 
        else:
            logger.error("The dir: %s does not exist" %dir)
#And keep have the newest folders (yes we want that)

