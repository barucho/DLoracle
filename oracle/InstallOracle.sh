#! /bin/bash -x
#
# Install oracle
#
# description:
#         this script will
#1. install oracle software
#2. create database instance
#
#   8.31.2015 - created by baruch o
#
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
################################

##step 1 run as root prep system
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi
#install pre-install rpm
yum localinstal $INSTALL_LOCATION/$PREINSTELL_RPM_NAME

# create user oracle
/usr/sbin/groupadd oinstall
/usr/sbin/groupadd dba
/usr/sbin/useradd -m -g oinstall -G dba oracle
passwd oracle
id oracle
# fix ~oracle/.bash_profile
cp ~oracle/.bash_profile ~oracle/.bash_profile.$(date +%F_%R).old
echo "##add by $PRODUCT_NAME install "  >> ~oracle/.bash_profile
echo "export ORACLE_BASE=$ORACLE_BASE" >>  ~oracle/.bash_profile
echo "export ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/db_1" >> ~oracle/.bash_profile
echo "export ORACLE_SID=$ORACLE_SID " >>  ~oracle/.bash_profile
echo "PATH=\$PATH:\$ORACLE_HOME/bin/" >>  ~oracle/.bash_profile



## disable selinux

## create ORACLE_BASE
mkdir -p $ORACLE_BASE/product/11.2.0/
chown -R oracle:oinstall  $ORACLE_BASE
chmod -R 775 $ORACLE_BASE


##step 2 run as oracle Install oracle
##first create responseFile
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
