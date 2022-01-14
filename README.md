# Ftp-downloader 

This is a little script written in bash for downloading files from a ftp server, it uses [wget](https://www.gnu.org/software/wget/) to download the files.

NOTE: this is a little learning script for understanding bash and some little commands. I'm not an expert!

## Requirements

- [jq](https://github.com/stedolan/jq) (it comes pre-installed in a lot of distros)

## Install

**Before to modify the the config file (`config.json`) make sure to read the guide to modify it**

``` bash
git clone https://github.com/BigNocciolino/stolen-ftp.git
cd stolen-ftp
nano config.json
chmod +x clone.sh 
```

## Info

- **The script download a file or a folder on the remote server secified in the config file**
- **Save the output in a folder formatted as `%d-%m-%Y` in the download path**
- **Run a python script to check and delete the oldest folders (only the time formatted)**

## Usage

You can run this script manually or you can [automate it](#automate-the-script)

**If you would to run it manually**

```bash
./clone.sh -c [config path]
```

Or you can override the -c option ad the script will find the config file in the same direcotry. 

``` bash
./clone.sh
```

This will get all the options from the config file, save the backup in a folder with the current date formatted as `% d-% m-% Y`, then run the old_dirs.py script which find all the folders formatted as first and delete the oldest, based on the `keep_backup` option in your configuration

## Configuration 

This is the default config file.

``` json
{
    "config": {
        "url": "stuff",
        "username": "stuff",
        "password": "super_secure_password",
        "dw_path": "the/pat/to/your/folder",
        "ftp_path": "path/to/download/on/your/server",
        "keep_backup": 4
    }
}
```

### Options

- `url` => This is the url of the ftp server 
- `username` => Username for authentication to the server
- `password`=> This is the password for the authentication
- `dw_path` => This is the path where the downloaded file are being stored
- `ftp_path` => This is the path of the folder or file on the remote server
- `keep_backup` => This number indicates how many backup folders are maintained, the script automatically delete the oldest folders

## Automate the script

To automate the script you can use cron, by adding this line in the `/etc/crontab` file

``` 
0 5 * * 1,6 pi /usr/bin/bash [path to the clone.sh file] -c [path to the config file]
```

This line will run the script at the 5 AM on Monday and Saturday of every week

## Features

- Super fast, (thanks wget)
- Run a script that only detects the folder saved with a date format and deletes the oldest
- Log download time in a csv file, for performance logging (just for fun)
- All info are logged in a text file

# TODO 

- [ ] Add the log path to te config
- [ ] Better csv file logging
