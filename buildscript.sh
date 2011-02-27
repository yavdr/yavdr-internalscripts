#!/bin/bash
# build script

if [ -z $1 ]; then
  echo "no packet given"
  exit;
else
  PACKAGE=$1
fi

if [ -z $2 ]; then
  REPO="unstable"
else
  REPO=$2
fi

PACKAGE_NAME="yavdr-${PACKAGE}"
PACKAGE_VERSION="10000"
YAVDR_VERSION="0.3.0"
DIST="lucid"
PACKAGE_VERSION="${YAVDR_VERSION}.${PACKAGE_VERSION}"
PACKAGE_NAME_VERSION="${PACKAGE_NAME}_${PACKAGE_VERSION}"

echo " -- build packet ${PACKAGE_NAME} for ${REPO}"

mkdir -p /tmp/buildscript
cd /tmp/buildscript

if [ -d $PACKAGE_NAME_VERSION ]; then
  rm $PACKAGE_NAME_VERSION -rf
fi

# clone git repo
echo " --- git clone git://github.com/yavdr/${PACKAGE_NAME}.git"
git clone -q "git://github.com/yavdr/${PACKAGE_NAME}.git" "${PACKAGE_NAME_VERSION}"

# look to git version
cd $PACKAGE_NAME_VERSION
GIT_VERSION=`git log --pretty='format:%H'`
echo " ---- git version ${GIT_VERSION}"
cd ..

VERSION_SUFFIX="1yavdr-${GIT_VERSION}~${DIST}"
VERSION_SUFFIX="1yavdr1"

# cleanup
if [ -d $PACKET_NAME ]; then
  rm $PACKET_NAME -rf
fi

ORIG_FILE="${PACKAGE_NAME_VERSION}.orig.tar.gz"
echo " --- create ${ORIG_FILE}"

# cleanup
if [ -f $ORIG_FILE ]; then
  rm $ORIG_FILE -rf
fi

tar czf $ORIG_FILE $PACKAGE_NAME_VERSION --exclude=".git" --exclude="debian"

echo " --- create changelog for package"

cd $PACKAGE_NAME_VERSION
dch -v "${PACKAGE_VERSION}-${VERSION_SUFFIX}" "New Upstream Snapshot" --distribution=$DIST

echo " --- debuild"
debuild -S -sa > /dev/null

cd ..

#rm $GITHUB_REPO -rf
#rm $ORIG_FILE
