#!/bin/bash

# here you can configure the repos
REPOS="yavdr-addon-asunder yavdr-addon-chromium yavdr-addon-claws-mail yavdr-addon-dvdrip yavdr-addon-helix yavdr-addon-mame yavdr-addon-mediathek yavdr-addon-performous yavdr-addon-pidgin yavdr-addon-pip yavdr-addon-semsix yavdr-addon-simfy yavdr-addon-skype yavdr-addon-supertuxkart yavdr-addon-thunderbird yavdr-addon-tuxracer yavdr-addon-tvbrowser yavdr-addon-vlc yavdr-addon-wormux yavdr-addon-youtube yavdr-dashboard yavdr-dev yavdr-essential yavdr-hardware-mdm166a yavdr-hardware-sundtek yavdr-i18n yavdr-internalscripts yavdr-test yavdr-webfrontend yavdr-remote yavdr-dkms-scripts yavdr-plymouth-theme vdr-plugin-restfulapi"

# clone or pull repos
for REPO in $REPOS
do
  cd $REPO
cat > README <<EOF
yaVDR - $REPO
---------------------------------------

"yet another VDR" (yaVDR) is a Linux distribution focussed on Klaus Schmidingers Video Disk Recorder and based on Ubuntu.

yaVDR tries to let you:

 * Watch and record TV easily and enjoy your media in a smart way: Quickly set up a digital video recorder (PVR) on your HTPC, receive SD and HD channels, manage it simply with a remote control. Furthermore, take advantage of the full blown media center software XBMC to listen to music, watch videos, check the weather.

 * Enjoy High Definition without high CPU load: HDTV normally needs a strong CPU to be displayed flawlessly. If you own a Nvidia ION based nettop or a HTPC with a Nvidia GPU that supports VDPAU, your CPU will remain cool and your energy bill won't hurt you. yaVDR relies on VDPAU which is currently the only simple way to get GPU based HD video decoding on Linux.

 * Start immediately after turning on the HTPC: yaVDR wants to compete with other living room devices as much as possible using upstart to speed up the boot. Besides that, the shutdown method S3 (Suspend to RAM) is enabled by default to bypass cold boot. It is possible to let the system automatically wake up on timers and go to sleep after a configurable timeout.

Links:

Installation: http://www.yavdr.org/installation/
Configuration: http://www.yavdr.org/configuration/
Features: http://www.yavdr.org/features/
Issue tracker: https://bugs.yavdr.com/projects/yavdr/issues/new
Package source: https://github.com/yavdr/$REPO
Team members: http://www.yavdr.org/developer-zone/team-members/

EOF
  git add README
  git commit -m 'update readme'
  git push
  cd ..
done
