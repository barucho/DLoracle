#! /bin/bash -x
#
# PreInstall oracle database
#
# description:
#         this script need to run by admin user
#
#
#
#
#   3.11.2015 - created by baruch o
#
#
#
##############GLOBAL PARAM#################
. Config.conf
#############################################

##step 1 run as admin prep system
if [[ $(id -nu) -ne $INSTALL_USER ]] ; then echo "Please run as admin" ; exit 1 ; fi

#install pre-install rpm
if [[ $INSTALLYUM -eq 1 ]] ;
then echo "Install yum $PREINSTELL_RPM_NAME";
sudo yum localinstal $INSTALL_LOCATION/$PREINSTELL_RPM_NAME;
fi

#fix /tmp
sudo sh -c "chmod a+rwx /tmp"

# create user oracle
if [[ $DEBUG -ne 0 ]] ; then echo "Create user oracle"; fi
sudo /usr/sbin/groupadd oinstall
sudo /usr/sbin/groupadd dba
sudo /usr/sbin/useradd -m -g oinstall -G dba oracle

sudo passwd oracle << EOF
oracle
oracle
EOF

# fix ~oracle/.bash_profile
if [[ $DEBUG -ne 0 ]] ; then echo "fix ~oracle/.bash_profile"; fi
#make backup
sudo -u oracle -H sh -c "cp ~oracle/.bash_profile ~oracle/.bash_profile.$(date +%F_%R).old"
# add env for bash
sudo -u oracle -H sh -c "echo "##add by $PRODUCT_NAME install "  >> ~oracle/.bash_profile"
sudo -u oracle -H sh -c "echo "export ORACLE_BASE=$ORACLE_BASE" >>  ~oracle/.bash_profile"
sudo -u oracle -H sh -c "echo "export ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/db_1" >> ~oracle/.bash_profile"
sudo -u oracle -H sh -c "echo "export ORACLE_SID=$ORACLE_SID " >>  ~oracle/.bash_profile"
sudo -u oracle -H sh -c "echo "PATH=\$PATH:\$ORACLE_HOME/bin/" >>  ~oracle/.bash_profile"

## disable selinux
if [[ $DEBUG -ne 0 ]] ; then echo "disabling SELinux"; fi
#first disable SElinux until boot
sudo setenforce  0
# now make it Fixed
FILE=/etc/selinux/config
# create backup
  sudo cp  $FILE $FILE.orig
# create new selinux/config file
cat << EOF > $TEMP_LOCATION/config
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
EOF
#replace orig file
sudo cp  $TEMP_LOCATION/config $FILE

## create ORACLE_BASE
if [[ $DEBUG -ne 0 ]] ; then echo "Create  oracle base"; fi
ORACLE_MOUNT_POINT=`echo $ORACLE_BASE  |cut -d "/" -f 2`
sudo sh -c "chown -R oracle:oinstall /$ORACLE_MOUNT_POINT "
sudo sh -c "mkdir -p $ORACLE_BASE/product/11.2.0/ "
sudo sh -c "chown -R oracle:oinstall $ORACLE_BASE "
sudo sh -c "chmod -R 775 $ORACLE_BASE "
