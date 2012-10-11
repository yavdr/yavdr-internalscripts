#!/bin/bash

. /etc/lsb-release

#DIST=$DISTRIB_CODENAME
#DIST="lucid"
#DIST="natty"
#DIST="oneiric"
DIST="precise"
#DIST="quantal"

mkdir /tmp/build

PACKAGES="vdr-plugin-advchctrl \
vdr-plugin-alcd \
vdr-plugin-androvdr \
vdr-plugin-arghdirector \
vdr-plugin-atmo \
vdr-plugin-atscepg \
vdr-plugin-autosort \
vdr-plugin-autostart \
vdr-plugin-avards \
vdr-plugin-bewegung \
vdr-plugin-bgprocess \
vdr-plugin-block \
vdr-plugin-burn \
vdr-plugin-calc \
vdr-plugin-cdda \
vdr-plugin-cdplayer \
vdr-plugin-chanman \
vdr-plugin-channellists \
vdr-plugin-chanorg \
vdr-plugin-cinebars \
vdr-plugin-clock \
vdr-plugin-control \
vdr-plugin-dbus \
vdr-plugin-dbus2vdr \
vdr-plugin-ddci \
vdr-plugin-devstatus \
vdr-plugin-director \
vdr-plugin-dummydevice \
vdr-plugin-duplicates \
vdr-plugin-dvbhddevice \
vdr-plugin-dvd \
vdr-plugin-dvdswitch \
vdr-plugin-dynamite \
vdr-plugin-eepg \
vdr-plugin-epgfixer \
vdr-plugin-epgsearch \
vdr-plugin-epgsync \
vdr-plugin-extb \
vdr-plugin-externalplayer \
vdr-plugin-extrecmenu \
vdr-plugin-favorites \
vdr-plugin-femon \
vdr-plugin-fepg \
vdr-plugin-filebrowser \
vdr-plugin-freecell \
vdr-plugin-fritzbox \
vdr-plugin-games \
vdr-plugin-graphlcd \
vdr-plugin-graphtft \
vdr-plugin-image \
vdr-plugin-imonlcd \
vdr-plugin-iptv \
vdr-plugin-karaoke \
vdr-plugin-lastfm \
vdr-plugin-lcdproc \
vdr-plugin-lcr \
vdr-plugin-lircrc \
vdr-plugin-live \
vdr-plugin-mailbox \
vdr-plugin-markad \
vdr-plugin-mcli \
vdr-plugin-menuorg \
vdr-plugin-mlist \
vdr-plugin-mousemate \
vdr-plugin-mp3 \
vdr-plugin-muggle \
vdr-plugin-music \
vdr-plugin-newsticker \
vdr-plugin-noepg \
vdr-plugin-nordlichtsepg \
vdr-plugin-osdpip \
vdr-plugin-osdserver \
vdr-plugin-osdteletext \
vdr-plugin-osdtest256 \
vdr-plugin-picselshow \
vdr-plugin-pilot \
vdr-plugin-pim \
vdr-plugin-pin \
vdr-plugin-play \
vdr-plugin-playlist \
vdr-plugin-podcatcher \
vdr-plugin-powermate \
vdr-plugin-prefermenu \
vdr-plugin-proxy \
vdr-plugin-pvr350 \
vdr-plugin-pvrinput \
vdr-plugin-radio \
vdr-plugin-radiolist \
vdr-plugin-remote \
vdr-plugin-remoteosd \
vdr-plugin-remotetimers \
vdr-plugin-restfulapi \
vdr-plugin-rotorng \
vdr-plugin-rssreader \
vdr-plugin-scheduler \
vdr-plugin-screenshot \
vdr-plugin-serial \
vdr-plugin-shutdown \
vdr-plugin-skinelchi \
vdr-plugin-skinenigmang \
vdr-plugin-skinpearlhd \
vdr-plugin-skinsoppalusikka \
vdr-plugin-sleeptimer \
vdr-plugin-sndctl \
vdr-plugin-softhddevice \
vdr-plugin-solitaire \
vdr-plugin-span \
vdr-plugin-spider \
vdr-plugin-streamdev \
vdr-plugin-sudoku \
vdr-plugin-sundtek \
vdr-plugin-surfer \
vdr-plugin-suspendoutput \
vdr-plugin-svdrposd \
vdr-plugin-svdrpservice \
vdr-plugin-systeminfo \ 
vdr-plugin-targavfd \
vdr-plugin-text2skin \
vdr-plugin-timeline \
vdr-plugin-timersync \
vdr-plugin-trayopenng \
vdr-plugin-ttxtsubs \
vdr-plugin-tvguide \
vdr-plugin-tvonscreen \
vdr-plugin-tvtv \
vdr-plugin-undelete \
vdr-plugin-vcd \
vdr-plugin-vdrc \
vdr-plugin-vdrcd \
vdr-plugin-vdrmanager \
vdr-plugin-vdrrip \
vdr-plugin-vnsiserver \
vdr-plugin-vompserver \
vdr-plugin-webvideo \
vdr-plugin-wirbelscan \
vdr-plugin-xine \
vdr-plugin-xineliboutput \
vdr-plugin-xmltv2vdr \
vdr-plugin-xvdr \
vdr-plugin-yaepghd \
vdr-plugin-zaphistory \
vdr-plugin-zappilot"


for PACKAGE in $PACKAGES
do
  echo "verarbeite $PACKAGE"
  cd /tmp/build
  rm * -rf
  apt-get source $PACKAGE
  if [ $? -ne 0 ]; then
    echo "***** apt-get error *****"
  else
    cd *
    HEADER=$(head -n 1 debian/changelog)
    NAME=$(echo $HEADER |cut -d ' ' -f 1)
    FULLVERSION=$(echo $HEADER |cut -d ' ' -f 2)
    FULLVERSION=${FULLVERSION:1:${#FULLVERSION}-2}
    LENGTH=${#FULLVERSION}
    for ((j=LENGTH-1; j > 0; j--))
    do
      if [ "${FULLVERSION:$j:1}" = "-" ]; then
        VERSION=${FULLVERSION:0:$j}
        RELEASE=${FULLVERSION:$j+1}
        break
      fi
    done
    RELEASE="$(expr "$RELEASE" : '\([0-9]*\)')yavdr$(($(expr "$RELEASE" : '[0-9]*[a-z]*\([0-9]*\)')+1))~$DIST"
#    sudo apt-get build-dep $PACKAGE
    dch -v "$VERSION-$RELEASE" "rebuild" --distribution=$DIST --urgency=medium
    debuild -S -sa || exit;
    cd ..
    FILEVERSION=$(echo $VERSION |cut -d ':' -f 2)
    echo "${NAME}_${FILEVERSION}-${RELEASE}_source.changes"
    dput ppa:yavdr/unstable-vdr "${NAME}_${FILEVERSION}-${RELEASE}_source.changes"
  fi
done

rm -rf /tmp/build
