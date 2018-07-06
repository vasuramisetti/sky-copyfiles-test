#!/bin/bash

#Ex: Version 1.2.3

VERSION=$1

#If Ex: Jenkins Build Number: 1

BuildNumber=$2

REPO=$3

if [ -z "$VERSION" ]; then
   echo "Invalid version."
   exit 1
fi

if [ -z "$BuildNumber" ]; then
   echo "Invalid tag."
   exit 1
fi

PATH="/sbin:/usr/sbin:/usr/bin:/bin"
export PATH

INITPROGRAM="/etc/init/skynet.conf"
SKYNETDIR="/wic/sys/skynet"
BINDIR="$SKYNETDIR/bin"
CONFIGDIR="$SKYNETDIR/config"
LIBDIR="$SKYNETDIR/lib"
WORKDIR="/wic/work/walmart/skynet"
STAGEDIR="$WORKDIR/stage/skynet-$VERSION"
COMPLETEDDIR="$WORKDIR/completed"
WBERRDIR="$WORKDIR/wberrors"
LOGDIR="/var/log/skynet"
LOGLINK="$SKYNETDIR/logs"

ROLLBACKDATE=`date "+%Y%m%d_%H:%M:%S"`

#Check for staged dir before doing anything
#NOTE: This will not check for files because not
# all files could be staged for deployment
#if [ ! -d "$STAGEDIR" ]; then
#   echo "Staging for $STAGEDIR has not been done!"
#   exit 1
#fi

if [ ! -d "$STAGEDIR" ]; then
           mkdir -p "$STAGEDIR"

fi



cd "$STAGEDIR"

        if [ ! -d bin ]; then
           mkdir -p bin
        fi

        if [ ! -d lib ]; then
           mkdir -p lib
        fi

        if [ ! -d config ]; then
           mkdir -p config
        fi


       cd $STAGEDIR/bin/
        rm -f $STAGEDIR/bin/*.sh
        wget http://artifacts.west.com/artifactory/Customer-Experience-maven-dev/notifications-walmart-skynet/${BuildNumber}/skynet.sh


        cd $STAGEDIR/lib/
        rm -f $STAGEDIR/lib/*.jar
        wget http://artifacts.west.com/artifactory/Customer-Experience-maven-dev/notifications-walmart-skynet/${BuildNumber}/skynet-${VERSION}.jar



       cd $STAGEDIR/config/
       rm -f $STAGEDIR/config/*.*

       cp -rf /tmp/skynet-configfile/* .
       rm -rf /tmp/skynet-configfile/*

       # wget   http://artifacts.sandbox.west.com/artifactory/libs-snapshot/Customer-Experience/notifications-walmart-skynet/Dev/${BuildNumber}/led01506/application-led01506.yml
       #
       #
       # wget  http://artifacts.sandbox.west.com/artifactory/libs-snapshot/Customer-Experience/notifications-walmart-skynet/Dev/${BuildNumber}/led01506/logback-led01506.xml
       #
       #
       # wget   http://artifacts.sandbox.west.com/artifactory/libs-snapshot/Customer-Experience/notifications-walmart-skynet/Dev/${BuildNumber}/led01506/upstart-skynet.conf


#Make the requisite directories if they don't
# already exist
if [ ! -d "$BINDIR" ]; then
   mkdir -p "$BINDIR"
   chmod 755 $BINDIR
   chown wngapp:wngapp $BINDIR
fi

if [ ! -d "$CONFIGDIR" ]; then
   mkdir -p "$CONFIGDIR"
   chmod 755 $CONFIGDIR
   chown wngapp:wngapp $CONFIGDIR
fi

if [ ! -d "$LIBDIR" ]; then
   mkdir -p "$LIBDIR"
   chmod 755 $LIBDIR
   chown wngapp:wngapp $LIBDIR
fi

if [ ! -d "$COMPLETEDDIR" ]; then
   mkdir -p "$COMPLETEDDIR"
fi

if [ ! -d "$WBERRDIR" ]; then
   mkdir -p "$WBERRDIR"
   chmod 755 $LIBDIR
   chown wngapp:wngapp $LIBDIR
fi

if [ ! -d "$LOGDIR" ]; then
   mkdir -p "$LOGDIR"
   chmod 755 $LOGDIR
   chown wngapp:wngapp $LOGDIR
fi

#Create the rollbacks
mkdir -p $SKYNETDIR/rollback.$ROLLBACKDATE/{bin,lib,config}
mv $BINDIR/* $SKYNETDIR/rollback.$ROLLBACKDATE/bin/
mv $CONFIGDIR/* $SKYNETDIR/rollback.$ROLLBACKDATE/config/
mv $LIBDIR/* $SKYNETDIR/rollback.$ROLLBACKDATE/lib/

#Copy the new files
cp $STAGEDIR/bin/* $BINDIR
chmod 755 $BINDIR
chown wngapp:wngapp $BINDIR
cp $STAGEDIR/config/* $CONFIGDIR
chmod 755 $CONFIGDIR
chown wngapp:wngapp $CONFIGDIR
ln -s $CONFIGDIR/logback-*.xml $SKYNETDIR
cp $STAGEDIR/lib/*.jar $LIBDIR
chmod 755 $LIBDIR
chown wngapp:wngapp $LIBDIR
chmod +x $BINDIR/skynet.sh

if [ ! -L "$LOGLINK" ]; then
   ln -s $LOGDIR $LOGLINK
fi

if [ ! -f "$INITPROGRAM" ]; then
   cp $CONFIGDIR/upstart-skynet.conf $INITPROGRAM
fi
