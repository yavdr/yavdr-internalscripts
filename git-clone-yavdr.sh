#!/bin/bash

# clone or pull repos
for REPO in `curl -s https://api.github.com/users/yavdr/repos?per_page=200 | grep name | sort | awk -F \" '{ print $4 }'`
do
  if [ ! -d $REPO ]; then
    if [ "$READONLY" = "1" ]; then
      git clone git://github.com/yavdr/${REPO}.git
    else
      git clone git@github.com:yavdr/${REPO}.git
    fi
    cd $REPO
    git pull --all&
    cd ..
  else
    cd $REPO
    git pull --all&
    cd ..
  fi
done
