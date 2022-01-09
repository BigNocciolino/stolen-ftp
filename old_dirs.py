import os
import shutil
import sys
import json
import re
from datetime import datetime, timedelta

argv = sys.argv

config_file=""

if len(argv) > 1:
    config_file = sys.argv[1]
else:
    config_file="config.json"

#TODO add mush more logging
f = open(config_file)
data = json.load(f)
f.close()

path = data["config"]["dw_path"]
keep_backup = data["config"]["keep_backup"]
dir_list = os.listdir(path)
#Regex pattern to find only folder named as date
pattern = "^([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])(.|-)([1-9]|0[1-9]|1[0-2])(.|-|)20[0-9][0-9]$"

x=""
date_dirs=[]
old_folders = []
filetimes = []
keep = []
if len(dir_list) > 0:
    #Travel all the list
    for dir in dir_list:
        #Search if the dir_name match the regex pattern
        x = re.search(pattern, dir)
        if (x):
            date_dirs.append(dir)
else: 
    #TODO beautify log 
    print("The folder is empity")

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
for dir in filetimes:
    dir = os.path.join(path, dir)
    if os.path.exists(dir):
        try:
            shutil.rmtree(dir)
            print("removed '%s'" %dir)
        except OSError as error:
            print(error)
            print("Directory '%s' can not be removed" %dir) 
    else:
        print("The path dowsent exist")
#And keep have the newest folders (yes we want that)

