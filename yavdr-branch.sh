#!/bin/bash

VERSION=0.6
URL=git@github.com:yavdr/
BASE=master
REMOTE=origin
TARGET=testing-$VERSION
OPTTARGET=
WORKINGDIR=/tmp/$0
PACKAGES=

while getopts "b:p:r:t:u:v:w:" opt; do
  case $opt in
    b)
      BASE=$OPTARG
      ;;
    p)
      PACKAGES=$OPTARG
      ;;
    r)
      REMOTE=$OPTARG
      ;;
    t)
      OPTTARGET=$OPTARG
      ;;
    u)
      URL=$OPTARG
      ;;
    v)
      VERSION=$OPTARG
      ;;
    w)
      WORKINGDIR=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -n "$OPTTARGET" ]
then
  TARGET=$OPTTARGET-$VERSION
fi

echo "version = $VERSION"
echo "base = $BASE"
echo "remote = $REMOTE"
echo "target = $TARGET"
echo "working dir = $WORKINGDIR"

if [ -z "$PACKAGES" ]
then
  if [ ! -f yavdr-$VERSION-packages.sh ]
  then
    echo "package-list for version $VERSION not found." >&2
    exit 1
  fi

  . ./yavdr-$VERSION-packages.sh
fi

echo $REMOTE/$BASE to $TARGET

# if not directory exists
#   if not clone repository ok
#     skip package

# if not update repository ok
#   skip package

# if not base branch exists remote
#   skip package

# if not base branch exists local
#   create new local base branch from remote base
# else if base branch exists local
#   checkout local base branch
# if not update local base branch ok
#   skip package

# if not target branch exists remote
#   if not target branch exists local
#     create new target branch from remote base
#     push package
#   else if target branch exists local
#     skip package

# if target branch exists remote
#   if not target branch exists local
#     create new target branch from remote target
#   else if target branch exists local
#     update local target branch

# if merge with local base ok
#   push package

mkdir -p $WORKINGDIR

FAILED=

for PACKAGE in $PACKAGES
do
  cd $WORKINGDIR
  echo
  echo processing $PACKAGE

  if [ ! -d $PACKAGE ]
  then
    git clone $URL$PACKAGE.git $PACKAGE
    if [ $? -ne 0 ]
    then
      echo "can't clone $PACKAGE, skipping" >&2
      FAILED=$FAILED $PACKAGE
      continue
    fi
  fi

  # update repository
  cd $PACKAGE
  git fetch --all
  if [ $? -ne 0 ]
  then
    echo "can't update $PACKAGE, skipping" >&2
    FAILED=$FAILED $PACKAGE
    continue
  fi

  # if not base branch exists remote
  git ls-remote --exit-code --heads $REMOTE "refs/heads/$BASE"
  if [ $? -ne 0 ]
  then
    echo "can't find base branch $BASE, skipping package" >&2
    FAILED=$FAILED $PACKAGE
    continue
  fi

  # if not base branch exists local
  git show-ref --verify --quiet "refs/heads/$BASE"
  if [ $? -ne 0 ]
  then
    git checkout -b $BASE $REMOTE/$BASE
    if [ $? -ne 0 ]
    then
      echo "can't create base branch $BASE, skipping" >&2
      FAILED=$FAILED $PACKAGE
      continue
    fi
  else
    git checkout $BASE
    if [ $? -ne 0 ]
    then
      echo "can't checkout base branch $BASE, skipping" >&2
      FAILED=$FAILED $PACKAGE
      continue
    fi
    git pull
    if [ $? -ne 0 ]
    then
      echo "can't update base branch $BASE, skipping" >&2
      FAILED=$FAILED $PACKAGE
      continue
    fi
  fi
  # now local base branch is up-to-date

  # if not target branch exists remote
  git ls-remote --exit-code --heads $REMOTE "refs/heads/$TARGET"
  if [ $? -ne 0 ]
  then
    # if not target branch exists local
    git show-ref --verify --quiet "refs/heads/$TARGET"
    if [ $? -ne 0 ]
    then
      echo "target branch $TARGET does not exists, creating..."
      git checkout -b $TARGET $REMOTE/$BASE
      if [ $? -ne 0 ]
      then
        echo "can't create target branch $TARGET, skipping..." >&2
        FAILED=$FAILED $PACKAGE
      else
        echo "pushing to $REMOTE..."
        git commit --allow-empty -m "force rebuild"
        git push -u $REMOTE $TARGET
      fi
    else
      echo "unexpected local branch $TARGET, skipping" >&2
      FAILED=$FAILED $PACKAGE
    fi
    continue
  fi

  echo "update target branch $TARGET..."
  # if not target branch exists local
  git show-ref --verify --quiet "refs/heads/$TARGET"
  if [ $? -ne 0 ]
  then
    git checkout -b $TARGET $REMOTE/$TARGET
    if [ $? -ne 0 ]
    then
      echo "can't create local target branch $TARGET, skipping" >&2
      FAILED=$FAILED $PACKAGE
      continue
    fi
  else  
    git checkout $TARGET
    if [ $? -ne 0 ]
    then
      echo "can't checkout local target branch $TARGET, skipping" >&2
      FAILED=$FAILED $PACKAGE
      continue
    fi
    git pull
    if [ $? -ne 0 ]
    then
      echo "can't update local target branch $TARGET, skipping" >&2
      FAILED=$FAILED $PACKAGE
      continue
    fi
  fi
  # now local target branch is up-to-date

  echo "merging with $BASE..."
  git merge $BASE
  if [ $? -ne 0 ]
  then
    echo "merge failed, skipping" >&2
    FAILED=$FAILED $PACKAGE
    continue
  fi

  echo "pushing to $REMOTE..."
  git commit --allow-empty -m "force rebuild"
  git push -u $REMOTE $TARGET
done

if [ -n "$FAILED" ]
then
  echo "failed to update following packages:"
  echo "$FAILED"
fi

