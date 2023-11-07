#! /bin/bash
#############################################################################
# Script Name:
# Description: Download the file from Precisely and unzip the file and then upload the files to MOVEIT
# Date       :
# History    :
#############################################################################
#importing Config Variable
script_dir=$(dirname $(readlink -f "$0"))
source $script_dir/log.sh
cd $script_dir
source $script_dir/config
> $SFTP_COMMAND_FILE
# Date Format for File download and Upload.
date="$(date +'%Y.%m')"
list_date="$(date +'%Y.%-m')"
log="$(date +'%Y-%m-%d').log"
month="$(date +'%b')"
#Changing the string to Uppercase
month="${month^^}"
#filename="us${month}eb.zip"
filename="usJANeb.zip"
list_date="2023.1"
echo $list_date
#Check if the job already ran and file downloaded
if [ -e $script_dir/download/$filename ]
then
    ERROR "TEST_Trillium"
    exit 1
fi

sdk_list() {
        $PYTHON ./sdk/demo.py deliveries -p "Trillium Quality Addressing S7" -g "United States" -r "All USA" -df "EBCDIC" -k "ig8UiXxdPWttx8PKbYOkae5zsx1w2pAt" -s "Fk9GAWGgYVqLFkiH" >list.txt
        list=`grep $list_date list.txt`
        IFS='-'
        # Reading the spliit string into array
        read -ra arr <<< "$list"
        arr1=${arr[1]}
        version=`echo $arr1 | xargs`
        product="Trillium Quality Addressing S7"
        sdk_download
        }

sdk_download () {
    $PYTHON ./sdk/demo.py download -p "${product}::${version}" -g "United States" -r "All USA" -v $list_date -df "EBCDIC" -k "ig8UiXxdPWttx8PKbYOkae5zsx1w2pAt" -s "Fk9GAWGgYVqLFkiH"
    STATUS=$?
    if (( $STATUS != 0 )); then
        ERROR "File Download Failed"
        return 1
    elif [ -e  "$script_dir/download/$filename" ]
    then
        INFO "File Download Success"
        moveit_upload
    else
        INFO "File Not Downloaded"
        return 1
    fi
}

moveit_upload () {
    unzip $script_dir/download/$filename -d $script_dir/download/files/
    STATUS1=$?
    if (( $STATUS1 != 0 )); then
        ERROR "Unzip Failed" >> ./$log
        return 1
    else
        INFO "Files Extracted in $script_dir/download/files/ "
    fi
    INFO "Starting MOVEIT Transfer"
    files=`ls -1 download/files/ > file.txt`
    while read filename
    do
        echo "put $SOURCE/$filename $DESTINATION" >> $script_dir/${SFTP_COMMAND_FILE};
    done < file.txt
    #for file in ${files[@]}; do
    #   echo "put $SOURCE/$file $DESTINATION" >> $script_dir/${SFTP_COMMAND_FILE}
    #   echo $file
    # done
    echo "bye" >> $script_dir/${SFTP_COMMAND_FILE}
    #MoveIT Upload Start Here
    sftp -b ${SFTP_COMMAND_FILE} ${SFTP_USER}@${SFTP_SERVER_NAME}
    STATUS2=$?
    if (( $STATUS2 != 0 )); then
        ERROR "File Upload Failed"
        return 1
    else
        INFO "File Upload Success"
        rm -rf $script_dir/download/files $script_dir/download/files_list.txt
        return 0
    fi
}
sdk_list
ret=$?
if (( $ret != 0 )); then
    ERROR "Job ran failed"
    exit 1
else
    INFO "Job ran successfully"
    exit 0
fi
exit 0