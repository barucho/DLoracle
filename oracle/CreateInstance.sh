#! /bin/bash -x
#
# Create  oracle Instance by running dbca
#
# description:
#         this script need to run by admin user
#
#   3.11.2015 - created by baruch o
#   2.11.2015 - add
#
#
#
##############GLOBAL PARAM#################
. Config.conf
#############################################
#run netca to create listenr
if [[ $DEBUG -ne 0 ]] ; then echo "create responsefile for netca"; fi
FILE=$TEMP_LOCATION/netca.rsp
cat << EOF > $FILE
[GENERAL]
RESPONSEFILE_VERSION="11.2"
CREATE_TYPE="CUSTOM"
[oracle.net.ca]
INSTALLED_COMPONENTS={"server","net8","javavm"}
INSTALL_TYPE=""typical""
LISTENER_NUMBER=1
LISTENER_NAMES={"LISTENER"}
LISTENER_PROTOCOLS={"TCP;1521"}
LISTENER_START=""LISTENER""
NAMING_METHODS={"TNSNAMES","ONAMES","HOSTNAME"}
NSN_NUMBER=1
NSN_NAMES={"EXTPROC_CONNECTION_DATA"}
NSN_SERVICE={"PLSExtProc"}
NSN_PROTOCOLS={"TCP;HOSTNAME;1521"}
EOF
#fix responseFile premition
sudo chmod 777 $FILE
# run netca
sudo -u oracle -H sh -c "$ORACLE_HOME/bin/netca /silent /responsefile=$FILE"
#test LISTENER

############
#sudo -u oracle -H -sh -c $ORACLE_HOME/dbca
