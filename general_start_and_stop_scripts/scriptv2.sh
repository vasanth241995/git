#! /bin/bash
#############################################################################
# Script Name:
# Description: Download the file from Precisely and unzip the file and then upload the files to MOVEIT
# Date       :
# History    :
#############################################################################
#importing Config Variable
script_dir=$(dirname $(readlink -f "$0"))
#source "$script_dir/logger.sh"
cd $script_dir
source $script_dir/config
> $SFTP_COMMAND_FILE
# Date Format for File download and Upload.
date="$(date +'%Y.%m')"
list_date="$(date +'%Y.%-m')"
log="$(date +'%Y-%m-%d').log"
log_file="$script_dir/logs/${log}"
month="$(date +'%b')"
#Changing the string to Uppercase
month="${month^^}"
#filename="us${month}eb.zip"
filename="usJANeb.zip"
list_date="2023.5"
echo $list_date
echo "Script started:" >$log_file
#Check if the job already ran and file downloaded
if [ -e $script_dir/download/$filename ]
then
    echo "ERROR: File Already Downloaded" >>$log_file
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
        echo "INFO: File Download Failed" >>$log_file
        return 1
    elif [ -e  "$script_dir/download/$filename" ]
    then
        echo "INFO: File Download Success" >>$log_file
        moveit_upload
    else
        echo "ERROR: File Not Downloaded" >>$log_file
        return 1
    fi
}

moveit_upload () {
    unzip $script_dir/download/$filename -d $script_dir/download/files/
    STATUS1=$?
    if (( $STATUS1 != 0 )); then
        echo "ERROR: Unzip Failed" >>$log_file
        return 1
    else
        echo "INFO: Files Extracted in $script_dir/download/files/" >>$log_file
    fi
    echo "INFO: Starting MOVEIT Transfer" >>$log_file
        files=`ls -1 download/files/ > file.txt`
    while read filename
    do
        echo "put $SOURCE/$filename $DESTINATION" >> $script_dir/${SFTP_COMMAND_FILE};
    done < file.txt

    echo "bye" >> $script_dir/$SFTP_COMMAND_FILE
    #MoveIT Upload Start Here
    sftp -b ${SFTP_COMMAND_FILE} ${SFTP_USER}@${SFTP_SERVER_NAME}
    STATUS2=$?
    if (( $STATUS2 != 0 )); then
        echo "ERROR: File Upload Failed" >>$log_file
        return 1
    else
        echo "INFO: File Upload Success" >>$log_file
        rm -rf $script_dir/download/files $script_dir/download/files_list.txt file.txt list.txt
        return 0
    fi
}
sdk_list
ret=$?
if (( $ret != 0 )); then
    echo "ERROR: Job ran failed" >>$log_file
    exit 1
else
    echo "INFO: Job ran successfully" >>$log_file
    exit 0
fi
exit 0
