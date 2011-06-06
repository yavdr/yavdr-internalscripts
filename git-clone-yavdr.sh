#!/bin/bash

# here you can configure the repos
REPOS="yavdr yavdr-addon-asunder yavdr-addon-chromium yavdr-addon-claws-mail yavdr-addon-dvdrip yavdr-addon-helix yavdr-addon-mame yavdr-addon-mediathek yavdr-addon-performous yavdr-addon-pidgin yavdr-addon-pip yavdr-addon-semsix yavdr-addon-simfy yavdr-addon-skype yavdr-addon-supertuxkart yavdr-addon-thunderbird yavdr-addon-tuxracer yavdr-addon-tvbrowser yavdr-addon-vlc yavdr-addon-wormux yavdr-addon-youtube yavdr-base yavdr-dashboard yavdr-dev yavdr-essential yavdr-hardware-mdm166a yavdr-hardware-sundtek yavdr-i18n yavdr-internalscripts yavdr-test yavdr-utils yavdr-webfrontend yavdr-remote yavdr-dkms-scripts yavdr-plymouth-theme vdr-plugin-restfulapi"

# clone or pull repos
for REPO in $REPOS
do
  if [ ! -d $REPO ]; then
    git clone git@github.com:yavdr/${REPO}.git
    cd $REPO
    git pull --all&
  else
    cd $REPO
    git pull --all&
    cd ..
  fi
done
