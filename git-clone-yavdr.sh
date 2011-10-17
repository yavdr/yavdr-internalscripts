#!/bin/bash

# here you can configure the repos
REPOS="\
 channelpedia\
 vdr\
 vdr-addon-avahi-mounter\
 vdr-addon-epgdata2vdr\
 vdr-plugin-dbus\
 vdr-plugin-dbus2vdr\
 vdr-plugin-dynamite\
 vdr-plugin-jsonapi\
 vdr-plugin-pvrinput\
 vdr-plugin-restfulapi\
 vdr-plugin-shutdown\
 vdr-plugin-sundtek\
 vtuner\
 yavdr\
 yavdr-addon-asunder\
 yavdr-addon-chromium\
 yavdr-addon-claws-mail\
 yavdr-addon-dvdrip\
 yavdr-addon-helix\
 yavdr-addon-mame\
 yavdr-addon-mediathek\
 yavdr-addon-performous\
 yavdr-addon-pidgin\
 yavdr-addon-pip\
 yavdr-addon-semsix\
 yavdr-addon-simfy\
 yavdr-addon-skype\
 yavdr-addon-supertuxkart\
 yavdr-addon-thunderbird\
 yavdr-addon-tuxracer\
 yavdr-addon-tvbrowser\
 yavdr-addon-vlc\
 yavdr-addon-wormux\
 yavdr-addon-youtube\
 yavdr-base\
 yavdr-dashboard\
 yavdr-dev\
 yavdr-dkms-scripts\
 yavdr-doc\
 yavdr-essential\
 yavdr-hardware-displaylink\
 yavdr-hardware-mdm166a\
 yavdr-hardware-sundtek\
 yavdr-i18n\
 yavdr-internalscripts\
 yavdr-internal-server\
 yavdr-plymouth-theme\
 yavdr-remote\
 yavdr-test\
 yavdr-utils\
 yavdr-webfrontend"

# clone or pull repos
for REPO in $REPOS
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
