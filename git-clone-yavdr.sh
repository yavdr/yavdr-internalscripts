#!/bin/bash

# clone or pull repos
for REPO in `curl -s https://api.github.com/users/yavdr/repos?per_page=200 | grep full_name | sort | awk -F \" '{ print $4 }'`
do
  DIR=`echo $REPO | awk -F / '{ print $2 }'`
  echo $DIR
  if [ ! -d $REPO ]; then
    if [ "$READONLY" = "1" ]; then
      git clone git://github.com/${REPO}.git
    else
      git clone git@github.com:${REPO}.git
    fi
  else
    cd $DIR
    git pull --all&
    cd ..
  fi
done
