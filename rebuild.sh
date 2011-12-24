#!/bin/bash

. /etc/lsb-release

#DIST=$DISTRIB_CODENAME
#DIST="lucid"
DIST="natty"
#DIST="oneiric"
#DIST="precise"

mkdir /tmp/build

  PACKAGES="vdr-plugin-skinpearlhd vdr-plugin-graphtft vdr-plugin-markad vdr-plugin-iptv vdr-plugin-wirbelscan vdr-plugin-streamdev vdr-plugin-extrecmenu vdr-plugin-femon vdr-plugin-text2skin vdr-plugin-live vdr-plugin-dbus2vdr vdr-plugin-sundtek vdr-plugin-xine vdr-plugin-xineliboutput vdr-plugin-channellists vdr-plugin-menuorg vdr-plugin-dummydevice vdr-plugin-dynamite vdr-plugin-control vdr-plugin-dbus vdr-plugin-advchctrl vdr-plugin-alcd vdr-plugin-androvdr vdr-plugin-arghdirector vdr-plugin-atscepg vdr-plugin-autosort vdr-plugin-autostart vdr-plugin-avards vdr-plugin-bewegung vdr-plugin-bgprocess vdr-plugin-block vdr-plugin-burn vdr-plugin-calc vdr-plugin-cdda vdr-plugin-cdplayer vdr-plugin-chanorg vdr-plugin-cinebars vdr-plugin-devstatus vdr-plugin-director vdr-plugin-dvd vdr-plugin-dvdswitch vdr-plugin-epgsearch vdr-plugin-extb vdr-plugin-fepg vdr-plugin-filebrowser vdr-plugin-freecell vdr-plugin-fritzbox vdr-plugin-games vdr-plugin-image vdr-plugin-imdbsearch vdr-plugin-imonlcd vdr-plugin-infosatepg vdr-plugin-karaoke vdr-plugin-lastfm vdr-plugin-lcdproc vdr-plugin-lcr vdr-plugin-lircrc vdr-plugin-loadepg vdr-plugin-mailbox vdr-plugin-mcli vdr-plugin-mlist vdr-plugin-mousemate vdr-plugin-mp3 vdr-plugin-muggle vdr-plugin-music vdr-plugin-newsticker vdr-plugin-noepgmenu vdr-plugin-nordlichtsepg vdr-plugin-osdpip vdr-plugin-osdserver vdr-plugin-osdteletext vdr-plugin-osdtest256 vdr-plugin-pilot vdr-plugin-pim vdr-plugin-pin vdr-plugin-playlist vdr-plugin-podcatcher vdr-plugin-prefermenu vdr-plugin-proxy vdr-plugin-pvr350 vdr-plugin-radio vdr-plugin-radiolist vdr-plugin-recstatus vdr-plugin-remote vdr-plugin-remoteosd vdr-plugin-remotetimers vdr-plugin-rotor vdr-plugin-rssreader vdr-plugin-scheduler vdr-plugin-screenshot vdr-plugin-skinelchi vdr-plugin-skinenigmang vdr-plugin-skinsoppalusikka vdr-plugin-sleeptimer vdr-plugin-span vdr-plugin-spider vdr-plugin-suspendoutput vdr-plugin-systeminfo  vdr-plugin-targavfd vdr-plugin-trayopenng vdr-plugin-webvideo vdr-plugin-xmltv2vdr vdr-plugin-zappilot vdr-plugin-zaphistory vdr-plugin-yaepghd vdr-plugin-tvtv vdr-plugin-sudoku vdr-plugin-tvonscreen vdr-plugin-upnp vdr-plugin-sndctl vdr-plugin-svdrposd vdr-plugin-powermate vdr-plugin-svdrpservice vdr-plugin-vdrrip vdr-plugin-picselshow vdr-plugin-vompserver vdr-plugin-clock vdr-plugin-externalplayer vdr-plugin-serial vdr-plugin-solitaire vdr-plugin-vcd vdr-plugin-vdrc vdr-plugin-vdrcd vdr-plugin-ttxtsubs vdr-plugin-undelete vdr-plugin-timeline vdr-plugin-timersync vdr-plugin-surfer vdr-plugin-dvbhddevice vdr-plugin-shutdown vdr-plugin-graphlcd vdr-plugin-epgsync vdr-plugin-pvrinput vdr-plugin-favorites vdr-plugin-rotorng vdr-plugin-xvdr vdr-plugin-restfulapi vdr-plugin-atmo vdr-plugin-duplicates vdr-plugin-softhddevice vdr-plugin-eepg"


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
