#! /bin/bash
#############################################################################
# Script Name:
# Description: Download the file from Precisely and unzip the file and then upload the files to MOVEIT
# Date       :
# History    :
#############################################################################
#importing Config Variable
script_dir=$(dirname $(readlink -f "$0"))
source "$script_dir/logger.sh"
cd $script_dir
source $script_dir/config
> $SFTP_COMMAND_FILE
# Date Format for File download and Upload.
date="$(date +'%Y.%m')"
log="$(date +'%Y-%m-%d').log"
month="$(date +'%b')"
#Changing the string to Uppercase
month="${month^^}"
#filename="us${month}eb.zip"
filename="usNOVeb.zip"

#Check if the job already ran and file downloaded
if [ -e $script_dir/download/$filename ]
then
    ERROR "File Already Downloaded"
    exit 1
fi

sdk_list() {
        $PYTHON ./sdk/demo.py deliveries -p "Trillium Quality Addressing S7" -g "United States" -r "All USA" -df "EBCDIC" -k "ig8UiXxdPWttx8PKbYOkae5zsx1w2pAt" -s "Fk9GAWGgYVqLFkiH" >list.txt
        list=`grep $list_date list.txt`
        IFS='-'
        # Reading the spliit string into array
        read -ra arr <<< "$list"
        arr=${arr[1]}
        version=`echo $arr | sed -e 's/^[[:space:]]*//'`
