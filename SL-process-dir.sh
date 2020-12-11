#!/bin/bash

# process all files in a directory, provided as first command line parameter

SCRIPTDIR=`dirname "$0"`
# cd $SCRIPTDIR
DISPATCHER=${SCRIPTDIR}/SL-dispatcher.sh


PATHNAME=${1}
FINDSPEC="${PATHNAME}/ -maxdepth 1  "  

find $FINDSPEC    |
while read FILENAME
do
    echo $FILENAME    # ... or any other command using $filename
    TPATH=`dirname $FILENAME`  
    TBASE=`basename $FILENAME`
    $DISPATCHER $TPATH $TBASE 
done


