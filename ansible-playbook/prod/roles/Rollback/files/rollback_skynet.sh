#!/bin/bash


#################################################################################
#
#   Script to roll back skynet application
#
#################################################################################

SKYNETDIR="/wic/sys/skynet"

# Remove changes made
rm /wic/sys/skynet/bin/*
rm /wic/sys/skynet/config/*
rm /wic/sys/skynet/lib/*

#Get latest rollback backup foldername
ROLLBACKFOLDER=`ls -t $SKYNETDIR | grep "rollback.*" | head -1`
echo "Rollback folder name:  $ROLLBACKFOLDER"

#Roll back changes

cp $SKYNETDIR/$ROLLBACKFOLDER/bin/*  $SKYNETDIR/bin
cp $SKYNETDIR/$ROLLBACKFOLDER/config/*  $SKYNETDIR/config
cp $SKYNETDIR/$ROLLBACKFOLDER/lib/*  $SKYNETDIR/lib
