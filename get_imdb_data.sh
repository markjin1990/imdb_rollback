#
# This is a script that downloads the latest imdb data from the remote repository and roll back the data to an older version at a specific date
#
# How to use it:
# ./download [-d YYMMDD]
#

imdbAttr='ftp://ftp.fu-berlin.de/pub/misc/movies/database/'
imdbDiffAttr='ftp://ftp.fu-berlin.de/pub/misc/movies/database/diffs/'

echo "====================="
echo "IMDB DATA FOR TESTING"
echo ""
echo "Author: Zhongjun Jin (markjin1990@gmail.com)"
echo "====================="

echo "[STEP 0] Cleaning local data"
# rm *.gz

echo "[STEP 1] Downloading IMDB data"
# wget -q -r --accept="*.gz" --no-directories --no-host-directories --level 1 ftp://ftp.fu-berlin.de/pub/misc/movies/database/


if [ "$1" = "-d" ] && [ ${#2} = 6 ]; then

    # echo "[STEP 2] Downloading ApplyDiffs-2.5.tar.gz"
    # mkdir diffs
    # wget ftp://ftp.fu-berlin.de/pub/misc/movies/database/diffs/ApplyDiffs-2.5.tar.gz -O ApplyDiffs-2.5.tar.gz
    # gzip -f -d ApplyDiffs-2.5.tar.gz
    # tar -xf ApplyDiffs-2.5.tar -C .
    # make -C ApplyDiffs/

    echo "[STEP 2] Downloading diff files older than $2 and rollback"

    # get all files in diff directory
    echo "    => Get the list of diff files from $imdbDiffAttr"
    tempFilenames=($(curl -l $imdbDiffAttr))
    diffFileName=($(for l in ${tempFilenames[@]}; do echo $l; done | sort))

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

        # Check if the file name matches the regex. If it does, download the file to diff directory. The file is sorted in a reversed order.
        for (( idx=${#diffFileName[@]}-1 ; idx>=0 ; idx-- )) ; 
        do

            if [[ ${diffFileName[idx]} =~ ^$regex$ ]];
            then
                echo "    => Download diff file ${diffFileName[idx]}"
                wget -q "$imdbDiffAttr${diffFileName[idx]}" -O ./diffs/${diffFileName[idx]}  | sed 's/^/       /'
                echo "    => Decompress ${diffFileName[idx]}"
                gzip -f -d diffs/${diffFileName[idx]}  | sed 's/^/       /'
                tar -xf diffs/${diffFileName[idx]:0:${#diffFileName[idx]}-3}  | sed 's/^/       /'

                echo "    => Roll back data using ${diffFileName[idx]}"
                diffFiles=($(ls ./diffs/*.list))
                for diffFile in "${diffFiles[@]}"
                do
                    
                    curFile=$(basename "$diffFile")

                    gzip -f -d "$curFile.gz"  | sed 's/^/       /'

                    patch -R $curFile $diffFile  | sed 's/^/       /'

                    # output=$( patch -R $curFile $diffFile )

                    # echo "patch output $output"

                    gzip -f "$curFile" | sed 's/^/       /'
                done
                echo ""
            fi
        done
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

        # Check if the file name matches the regex. If it does, download the file to diff directory.
        for (( idx=${#diffFileName[@]}-1 ; idx>=0 ; idx-- )) ; 
        do
            if [ ${diffFileName[idx]} =~ ^$regex$ ]
            then
                echo "    => Download diff file ${diffFileName[idx]}"
                wget -q "$imdbDiffAttr${diffFileName[idx]}" -O ./diffs/${diffFileName[idx]}  | sed 's/^/       /'
                echo "    => Decompress ${diffFileName[idx]}"
                gzip -f -d diffs/${diffFileName[idx]}  | sed 's/^/       /'
                tar -xf diffs/${diffFileName[idx]:0:${#diffFileName[idx]}-3}  | sed 's/^/       /'

                echo "    => Roll back data using ${diffFileName[idx]}"
                diffFiles=($(ls ./diffs/*.list))
                for diffFile in "${diffFiles[@]}"
                do
                    curFile=$(basename "$diffFile")

                    gzip -f -d "$curFile.gz" | sed 's/^/       /'

                    patch -R $curFile $diffFile | sed 's/^/       /'

                    # output=$( patch -R $curFile $diffFile )

                    # echo "patch output $output"

                    gzip -f "$curFile" | sed 's/^/       /'
                done

                echo ""
            fi
        done

        for (( idx=${#diffFileName[@]}-1 ; idx>=0 ; idx-- )) ; 
        do
            if [ ${diffFileName[idx]} =~ ^$regex$ ]
            then
                echo "    => Download diff file ${diffFileName[idx]}"
                wget -q "$imdbDiffAttr{diffFileName[idx]}" -O ./diffs/${diffFileName[idx]}  | sed 's/^/       /'
                echo "    => Decompress ${diffFileName[idx]}"
                gzip -f -d diffs/${diffFileName[idx]}  | sed 's/^/       /'
                tar -xf diffs/${diffFileName[idx]:0:${#diffFileName[idx]}-3}  | sed 's/^/       /'

                echo "    => Roll back data using ${diffFileName[idx]}"
                diffFiles=($(ls ./diffs/*.list))
                for diffFile in "${diffFiles[@]}"
                do
                    curFile=$(basename "$diffFile")

                    gzip -f -d "$curFile.gz" | sed 's/^/       /'

                    patch -R $curFile $diffFile | sed 's/^/       /'

                    # output=$( patch -R $curFile $diffFile )

                    # echo "patch output $output"

                    gzip -f "$curFile" | sed 's/^/       /'
                done
                echo ""
            fi
        done
    fi
    
fi