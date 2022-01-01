# Ftp-downloader 

This is a little script written in bash for downloading files from a ftp server, it uses [wget](https://www.gnu.org/software/wget/) to download the files.

NOTE: this is a little learning script for understanding bash and some little commands. I'm not an expert!

## Requirements
- `jq` (it comes pre-installed in a lot of distros)

## Install
Before to modify the the config file (`config.json`) make sure to read the guide to configure it.

``` bash
git clone repoNname
cd repoNanem
nano config.json
./clone.sh 
```

### Configuration 

The configuration file is located in the same folder ad the executable, make sure they are always in the same folder.

This is the default config file.

``` json
{
    "config": {
        "url": "stuff",
        "username": "stuff",
        "password": "super_secure_password",
        "dw_path": "the/pat/to/your/folder",
        "ftp_path": "path/to/download/on/your/server"
    }
}
```

#### Options
- `url` =This is the url of the ftp server 
- `username` = Username for authenticate to the server (if have some special characters may you need to format it, see: [url encoding](https://www.w3schools.com/tags/ref_urlencode.ASP))
- `password`= This is the password for the authentication (if have some special characters may you need to format it, see: [url encoding](https://www.w3schools.com/tags/ref_urlencode.ASP))
- `dw_path` = This is the path where the downloaded file are begin stores
- `ftp_path` = This is the path of the folder or file on the remote server

## Features

- Super fast, (thanks wget)
- Log download time in a csv file, for performance logging (just for fun)
- Logs all in a txt file

