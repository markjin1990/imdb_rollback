#
# This is a script that downloads the latest imdb data from the remote repository and roll back the data to an older version at a specific date
#
# How to use it:
# ./download [-d YYMMDD]
#

re='^[0-9]+$'

echo "====================="
echo "IMDB DATA FOR TESTING"
echo ""
echo "Author: Zhongjun Jin (markjin1990@gmail.com)"
echo "====================="

echo "[STEP 0] Cleaning local data"
# rm *.gz

echo "[STEP 1] Downloading IMDB data"
# wget -r --accept="*.gz" --no-directories --no-host-directories --level 1 ftp://ftp.fu-berlin.de/pub/misc/movies/database/


if [ "$1" = "-d" ] && [ ${#2} = 6 ]; then

	echo "[STEP 2] Downloading ApplyDiffs-2.5.tar.gz"
	# mkdir diffs
	# wget ftp://ftp.fu-berlin.de/pub/misc/movies/database/diffs/ApplyDiffs-2.5.tar.gz -O ApplyDiffs-2.5.tar.gz
	# gzip -d ApplyDiffs-2.5.tar.gz
	# tar -xvf ApplyDiffs-2.5.tar -C .
	# make -C ApplyDiffs/

	echo "[STEP 3] Downloading diff files older than $2 and rollback"

	# get all files in diff directory
	tempFilenames=($(curl -l ftp://ftp.fu-berlin.de/pub/misc/movies/database/diffs/))
	fileName=($(for l in ${tempFilenames[@]}; do echo $l; done | sort))

	if [ "$2" -lt "990000" ]
	then
		digit1=${2:0:1}
		digit1plus1=`expr ${2:0:1} + 1`

		digit2=${2:1:1}
		digit2plus1=`expr ${2:1:1} + 1`

		digit3=${2:2:1}
		digit3plus1=`expr ${2:2:1} + 1`

		digit4=${2:3:1}
		digit4plus1=`expr ${2:3:1} + 1`

		digit5=${2:4:1}
		digit5plus1=`expr ${2:4:1} + 1`

		digit6=${2:5:1}
		digit6plus1=`expr ${2:5:1} + 1`

		# Regex to check the files older than user-specified date
		regex="diffs-([$digit1plus1-8][0-9]{5}|$digit1[$digit2plus1-9][0-9]{4}|$digit1$digit2[$digit3plus1-9][0-9]{3}|$digit1$digit2$digit3[$digit4plus1-9][0-9]{2}|$digit1$digit2$digit3$digit4[$digit5plus1-9][0-9]|$digit1$digit2$digit3$digit4$digit5[$digit6-9]).tar.gz"

		# Check if the file name matches the regex. If it does, download the file to diff directory.
		for (( idx=${#fileName[@]}-1 ; idx>=0 ; idx-- )) ; 
		do

		   [[ ${fileName[idx]} =~ ^$regex$ ]] && echo "    Download diff file ${fileName[idx]}"  && wget -q ftp://ftp.funet.fi/pub/mirrors/ftp.imdb.com/pub/diffs/${fileName[idx]} -O ./diffs/${fileName[idx]}  && echo "    Decompress ${fileName[idx]}" && gzip -d diffs/${fileName[idx]} &&  tar -xvf diffs/${fileName[idx]:0:${#fileName[idx]}-3} && echo "    Roll back data using ${fileName[idx]}" && ./ApplyDiffs/ApplyDiffs -quiet . ./diffs/ && echo ""
		done
		# wget -r --accept-regex "$regex" -p ftp://ftp.funet.fi/pub/mirrors/ftp.imdb.com/pub/diffs/ -P ./diffs
	else
		
		digit1=${2:0:1}
		digit1plus1=`expr ${2:0:1} + 1`

		digit2=${2:1:1}
		digit2plus1=`expr ${2:1:1} + 1`

		digit3=${2:2:1}
		digit3plus1=`expr ${2:2:1} + 1`

		digit4=${2:3:1}
		digit4plus1=`expr ${2:3:1} + 1`

		digit5=${2:4:1}
		digit5plus1=`expr ${2:4:1} + 1`

		digit6=${2:5:1}
		digit6plus1=`expr ${2:5:1} + 1`

		# All files since year 2000
		regex1="diffs-[0-8][0-9][0-1][0-9][0-3][0-9].tar.gz"


		# files older than user-specified date but earlier than year 2000
		regex2="([$digit1plus1-9][0-9]{5}|$digit1[$digit2plus1-9][0-9]{4}|$digit1$digit2[$digit3plus1-9][0-9]{3}|$digit1$digit2$digit3[$digit4plus1-9][0-9]{2}|$digit1$digit2$digit3$digit4[$digit5plus1-9][0-9]|$digit1$digit2$digit3$digit4$digit5[$digit6-9])"
		# wget -r --accept-regex="diffs-$regex.tar.gz" --no-directories --no-host-directories --level 1 ftp://ftp.fu-berlin.de/pub/misc/movies/database/diffs/ -P ./diffs
		# Check if the file name matches the regex. If it does, download the file to diff directory.
		for (( idx=${#fileName[@]}-1 ; idx>=0 ; idx-- )) ; 
		do

		   [[ ${fileName[idx]} =~ ^$regex$ ]] && echo "    Download diff file ${fileName[idx]}"  && wget -q ftp://ftp.funet.fi/pub/mirrors/ftp.imdb.com/pub/diffs/${fileName[idx]} -O ./diffs/${fileName[idx]}  && echo "    Decompress ${fileName[idx]}" && gzip -d diffs/${fileName[idx]} &&  tar -xvf diffs/${fileName[idx]:0:${#fileName[idx]}-3} && echo "    Roll back data using ${fileName[idx]}" && ./ApplyDiffs/ApplyDiffs -quiet . ./diffs/ && echo ""
		done

		for (( idx=${#fileName[@]}-1 ; idx>=0 ; idx-- )) ; 
		do

		   [[ ${fileName[idx]} =~ ^$regex$ ]] && echo "    Download diff file ${fileName[idx]}"  && wget -q ftp://ftp.funet.fi/pub/mirrors/ftp.imdb.com/pub/diffs/${fileName[idx]} -O ./diffs/${fileName[idx]}  && echo "    Decompress ${fileName[idx]}" && gzip -d diffs/${fileName[idx]} &&  tar -xvf diffs/${fileName[idx]:0:${#fileName[idx]}-3} && echo "    Roll back data using ${fileName[idx]}" && ./ApplyDiffs/ApplyDiffs -quiet . ./diffs/ && echo ""
		done
	fi
	
fi