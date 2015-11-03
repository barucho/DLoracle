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
##step 1 run as admin prep system
if [[ $(id -nu) -ne $INSTALL_USER ]] ; then echo "Please run as admin" ; exit 1 ; fi

#chack if oracle install finishd
#run root.sh
if [[ $DEBUG -ne 0 ]] ; then echo "run root.sh as root"; fi
sudo -H sh -c $ORACLE_HOME/root.sh
