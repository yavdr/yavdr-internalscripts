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

PACKAGE_VERSION="${YAVDR_VERSION}${REPO}${PACKAGE_VERSION}"
PACKAGE_NAME_VERSION="${PACKAGE_NAME}_${PACKAGE_VERSION}"


if [ -d $PACKAGE_NAME_VERSION ]; then
  rm $PACKAGE_NAME_VERSION -rf
fi

mv "${PACKAGE_NAME}" "${PACKAGE_NAME_VERSION}"

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
dch -v "${PACKAGE_VERSION}${VERSION_SUFFIX}" "New Upstream Snapshot" --distribution=$DIST

echo " --- debuild"
debuild -S -sa > /dev/null
cd ..

dput ppa:traxanos/yavdr-$REPO "${PACKAGE_NAME_VERSION}${VERSION_SUFFIX}_source.changes"



#rm $GITHUB_REPO -rf
#rm $ORIG_FILE
