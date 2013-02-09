#!/bin/bash

# set-ee-perms.sh
# (c) Nathan Nobbe 2013
#
# This script automates the process described in section 3 as documeted here
# http://ellislab.com/expressionengine/user-guide/installation/installation.html
# It is designed under the assumption the system directory is beneath the webroot.
# If you wish to move the system directory out, above the webroot, just run this
# script first, then do the move.

# Usage function if first arg is -h
if [ "$1" = -h ] || [ $# -lt 3 ]; then
    echo 'set-ee-perms.sh <ee-directory> <user> [group]'
    exit 0
fi

# First cli argument indicates directory to operate on
# it is the root of the EE installation
dir=$1
if [ ! -d "$1" ]; then 
    echo Directory $1 doesn\'t exist
    exit
fi

## Known relative sub-directories from base directory
## These are base on system directory not being moved out
EE_DIR="$dir/system/expressionengine"
CONFIG_DIR="$dir/system/expressionengine/config"
IMG_DIR="$dir/images"

# Bail if any of these directories DNE
if [ ! -d $EE_DIR ]; then
    echo $EE_DIR does not exist!
    exit 1;
fi

if [ ! -d $CONFIG_DIR ]; then
    echo $CONFIG_DIR does not exist!
    exit 1;
fi

# Only issue a warning if the images directory isn't found
found_images=1
if [ ! -d $IMG_DIR ]; then
    found_images=0
    echo Warning: $IMG_DIR does not exist.
fi

user=$2

# Optional group via third cli arg
group=$user
if [ -n "$3" ]; then
    group=$3
fi

## make sure it's ok to proceed
echo "We're about to set perms on $dir"
echo "Specifically, we'll set the standard EE perms"
echo "and change ownership to $user:$group"
echo Type Ctrl+C to abort or Enter to continue
read

## set all files to owned by $user:group
echo "chown -R $user:$group $dir"
chown -R $user:$group $dir

## set standard perms on files & directories
echo "find $dir -type d -exec chmod 755 '{}' ';'"
find $dir -type d -exec chmod 755 '{}' ';'
echo "find $dir -type f -exec chmod 644 '{}' ';'"
find $dir -type f -exec chmod 644 '{}' ';'

## Now set permissions per EE docs
# Always operate on the cache directory
echo "chmod -R 777 $EE_DIR/cache/" 
chmod -R 777 $EE_DIR/cache/ 

# Only opearate on the images directory if it's out there
if [ $found_images -gt 0 ]; then
    declare -a wide_open_dirs=( \
                "$IMG_DIR/avatars/uploads/" "$IMG_DIR/captchas/" \
                "$IMG_DIR/member_photos/" "$IMG_DIR/pm_attachments/" \
                "$IMG_DIR/signature_attachments/" "$IMG_DIR/uploads/" \
                );
    for dir in "${wide_open_dirs[@]}"
    do
        echo "chmod -R 777 $dir"
        chmod -R 777 "$dir"
    done
fi

echo "chmod 666 $CONFIG_DIR/config.php"
chmod 666 $CONFIG_DIR/config.php
echo "chmod 666 $CONFIG_DIR/database.php"
chmod 666 $CONFIG_DIR/database.php
