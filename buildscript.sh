#!/bin/bash
# build script

if [ -z $1 ]; then
  echo "no packet given"
  exit;
else
  PACKAGE_NAME=$1
fi

if [ -z $2 ]; then
  REPO="unstable"
else
  REPO=$2
fi

if [ -z $3 ]; then
  DIST="lucid"
else
  DIST=$3
fi

PACKAGE_VERSION="10000"
YAVDR_VERSION="1."
VERSION_SUFFIX="-0yavdr0~${DIST}" #

echo " -- build packet ${PACKAGE_NAME} for ${REPO}"

mkdir -p /tmp/buildscript
cd /tmp/buildscript

if [ -d $PACKAGE_NAME ]; then
  rm $PACKAGE_NAME -rf
fi

# clone git repo
echo " --- git clone git://github.com/yavdr/${PACKAGE_NAME}.git"
git clone -q "git://github.com/yavdr/${PACKAGE_NAME}.git" "${PACKAGE_NAME}"


# look to git version
cd $PACKAGE_NAME
PACKAGE_VERSION=`git rev-list --all | wc -l`
echo " ---- package version ${PACKAGE_VERSION}"
cd ..

PACKAGE_VERSION="${YAVDR_VERSION}${PACKAGE_VERSION}${REPO}"
PACKAGE_NAME_VERSION="${PACKAGE_NAME}_${PACKAGE_VERSION}"


if [ -d $PACKAGE_NAME_VERSION ]; then
  rm $PACKAGE_NAME_VERSION -rf
fi

mv $PACKAGE_NAME $PACKAGE_NAME_VERSION
# cleanup
rm "${PACKAGE_NAME_VERSION}/.git" -rf

if [ -d $PACKET_NAME ]; then
  rm $PACKET_NAME -rf
fi


ORIG_FILE="${PACKAGE_NAME_VERSION}.orig.tar.gz"
echo " --- create ${ORIG_FILE}"

# cleanup
if [ ! -f $ORIG_FILE ]; then
  tar czf $ORIG_FILE $PACKAGE_NAME_VERSION --exclude="debian"
fi


echo " --- create changelog for package"

cd $PACKAGE_NAME_VERSION
dch -v "${PACKAGE_VERSION}${VERSION_SUFFIX}" "New Upstream Snapshot" --distribution=$DIST

echo " --- debuild"
debuild -S -sa > /dev/null
cd ..

if [ ${PACKAGE_NAME:0:5} = "yavdr" ]; then
  dput ppa:yavdr/${REPO}-yavdr "${PACKAGE_NAME_VERSION}${VERSION_SUFFIX}_source.changes"
else
  dput ppa:yavdr/${REPO}-vdr "${PACKAGE_NAME_VERSION}${VERSION_SUFFIX}_source.changes"
fi

rm -rf "${PACKAGE_NAME_VERSION}"
rm -rf "${PACKAGE_NAME_VERSION}${VERSION_SUFFIX}.orig.tar.gz"
rm -rf "${PACKAGE_NAME_VERSION}${VERSION_SUFFIX}.debian.tar.gz"
rm -rf "${PACKAGE_NAME_VERSION}${VERSION_SUFFIX}.dsc"
rm -rf "${PACKAGE_NAME_VERSION}${VERSION_SUFFIX}_source.ppa.upload"
rm -rf "${PACKAGE_NAME_VERSION}${VERSION_SUFFIX}_source.build"
rm -rf "${PACKAGE_NAME_VERSION}${VERSION_SUFFIX}_source.changes"
