#! /bin/bash -x
#
# Install oracle
#
# description:
#         this script will run as admin user
#1. install oracle software
#2. create database instance
#
#   8.31.2015 - created by baruch o
#   2.11.2015 - add
#
#
#
##############GLOBAL PARAM#################
INSTALL_LOCATION=/u01/InstallPack/
ORACLE_BASE=/u01/app/oracle/
TEMP_LOCATION=/tmp/
PRODUCT_NAME="dialogic ORACLE Install"
PREINSTELL_RPM_NAME=oracle-rdbms-server-11gR2-preinstall-1.0-3.el7.nouek.x86_64.rpm
ORACLE_SID=orcl
DEBUG=1
INSTALLYUM=0
################################

##step 1 run as admin prep system
if [[ $(id -nu) -ne "admin" ]] ; then echo "Please run as admin" ; exit 1 ; fi

#install pre-install rpm
if [[ $INSTALLYUM -eq 1 ]] ;
then echo "Install yum $PREINSTELL_RPM_NAME";
sudo yum localinstal $INSTALL_LOCATION/$PREINSTELL_RPM_NAME;
fi

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
sudo cp ~oracle/.bash_profile ~oracle/.bash_profile.$(date +%F_%R).old
sudo echo "##add by $PRODUCT_NAME install "  >> ~oracle/.bash_profile
sudo echo "export ORACLE_BASE=$ORACLE_BASE" >>  ~oracle/.bash_profile
sudo echo "export ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/db_1" >> ~oracle/.bash_profile
sudo echo "export ORACLE_SID=$ORACLE_SID " >>  ~oracle/.bash_profile
sudo echo "PATH=\$PATH:\$ORACLE_HOME/bin/" >>  ~oracle/.bash_profile

## disable selinux
FILE=/etc/selinux/config
sudo cp  $FILE $FILE.orig
echo "disabling SELinux"
sudo cp $FILE /tmp
sudo cat << EOF > $FILE
echo
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

## create ORACLE_BASE
if [[ $DEBUG -ne 0 ]] ; then echo "Create  oracle base"; fi
sudo -H mkdir -p $ORACLE_BASE/product/11.2.0/
sudo -H mkdir chown -R oracle:oinstall  $ORACLE_BASE
sudo -H mkdir chmod -R 775 $ORACLE_BASE

##step 2 run as oracle Install oracle
##first create responseFile
if [[ $DEBUG -ne 0 ]] ; then echo "Create  create responseFile"; fi
echo "" > $TEMP_LOCATION/db11ginstall.rsp
echo "oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0" >> $TEMP_LOCATION/db11ginstall.rsp
echo "oracle.install.option=INSTALL_DB_SWONLY" >> $TEMP_LOCATION/db11ginstall.rsp
echo "UNIX_GROUP_NAME=oinstall" >> $TEMP_LOCATION/db11ginstall.rsp
echo "INVENTORY_LOCATION=$ORACLE_BASE/OraInventory" >> $TEMP_LOCATION/db11ginstall.rsp
echo "ORACLE_HOME=$ORACLE_BASE/product/11.2.0/template" >> $TEMP_LOCATION/db11ginstall.rsp
echo "ORACLE_BASE=$ORACLE_BASE" >> $TEMP_LOCATION/db11ginstall.rsp
echo "oracle.install.db.InstallEdition=EE" >> $TEMP_LOCATION/db11ginstall.rsp
echo "oracle.install.db.DBA_GROUP=dba" >> $TEMP_LOCATION/db11ginstall.rsp
echo "oracle.install.db.OPER_GROUP=oinstall" >> $TEMP_LOCATION/db11ginstall.rsp
echo "DECLINE_SECURITY_UPDATES=true" >> $TEMP_LOCATION/db11ginstall.rsp

##run install
cd $INSTALL_LOCATION
./runInstaller -silent -noconfig -responseFile $TEMP_LOCATION/db11ginstall.rsp
#########
