#! /bin/bash -x
#
# Install oracle
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
#chack if oracle install finishd
#run root.sh
if [[ $DEBUG -ne 0 ]] ; then echo "run root.sh as root"; fi
sudo -H sh -c $ORACLE_HOME/root.sh
