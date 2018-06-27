#!/bin/bash


#################################################################################
#
#   Script to roll back skynet application
#
#################################################################################

SKYNETDIR="/wic/sys/skynet"

# Remove changes made
echo "rm /wic/sys/skynet/bin/*"
echo "rm /wic/sys/skynet/config/*"
echo "rm /wic/sys/skynet/lib/*"

#Get latest rollback backup foldername
ROLLBACKFOLDER=`ls -t $SKYNETDIR | grep "rollback.*" | head -1`
echo $ROLLBACKFOLDER

#Roll back changes

cp $SKYNETDIR/$ROLLBACKFOLDER/bin/*  $SKYNETDIR/bin
cp $SKYNETDIR/$ROLLBACKFOLDER/config/*  $SKYNETDIR/config
cp $SKYNETDIR/$ROLLBACKFOLDER/lib/*  $SKYNETDIR/lib
