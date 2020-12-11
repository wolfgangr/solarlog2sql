#!/bin/bash

# select proper handler to run SL database update
# should work fine with icrontab
# usage: SL-dispatcher.sh path file

# echo "file" $2
# echo "path" $1

# make sure to find companions
SCRIPTDIR=`dirname "$0"`
cd $SCRIPTDIR

FILENAME=${2}
PATHNAME=${1}
FULLPATH=${PATHNAME}/${FILENAME}

echo -e "\t...dispatching ${FULLPATH}"

case ${FILENAME} in

	events.js )
		echo "events.js still to do"
		;;

	*.js )
		echo "don't like to talk js"
		;;

	min??????.csv )
		# echo "call minute parser"
		./SL-log-minutes.pl ${PATHNAME} ${FILENAME}
		echo -e "\t\t----  completed minutes - ${FULLPATH} ----"
		;;

	days.csv )
		# echo "call day parser"
		./SL-log-days.pl ${PATHNAME} ${FILENAME}
		echo -e "\t\t----  completed days - ${FULLPATH} ----"
		;;
	
	months.csv )
		# echo "call month parser"
		./SL-log-months.pl ${PATHNAME} ${FILENAME}
		echo -e "\t\t---- completed months - ${FULLPATH} ----"
		;;

	years.csv )
		# echo "call year parser"
		./SL-log-year.pl ${PATHNAME} ${FILENAME}
                echo -e "\t\t---- completed years - ${FULLPATH} ----"
                ;;

	pm.csv )
		echo "pm parser still to do"
		;;

	* )
		echo " do nothing with ${FULLPATH}"
		;;
esac
