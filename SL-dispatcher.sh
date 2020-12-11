#!/bin/bash

# select proper handler to run SL database update
# should work fine with icrontab
# usage: SL-dispatcher.sh path file

# echo "file" $2
# echo "path" $1

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
		echo "call minute parser"
		;;

	days.csv )
		echo "call day parser"
		;;
	
	months.csv )
		echo "call month parser"
                ;;

 
	years.csv )
		echo "call year parser"
                ;;

	pm.csv )
		echo "pm parser still to do"
		;;

	* )
		echo " do nothing with ${FULLPATH}"
esac
