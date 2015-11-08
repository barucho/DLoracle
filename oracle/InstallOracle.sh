#! /bin/bash -x
#
# Install oracle
#
# description:
#         this script need to run by admin user
#1. install oracle software
#2. create database instance
#
#   8.31.2015 - created by baruch o
#   2.11.2015 - add
#   8.11.2015 - fix to run as oracle
#
#
##############GLOBAL PARAM#################
. Config.conf
#############################################


##step 2 run as oracle Install oracle
##first create responseFile
if [[ $DEBUG -ne 0 ]] ; then echo "create responseFile"; fi
FILE=$TEMP_LOCATION/db11ginstall.rsp
cat << EOF > $FILE
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0
oracle.install.option=INSTALL_DB_SWONLY
ORACLE_HOSTNAME=$HOSTNAME
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=$ORACLE_BASE/oraInventory
SELECTED_LANGUAGES=en
ORACLE_HOME=$ORACLE_HOME
ORACLE_BASE=$ORACLE_BASE
oracle.install.db.InstallEdition=EE
oracle.install.db.EEOptionsSelection=false
oracle.install.db.optionalComponents=
oracle.install.db.DBA_GROUP=dba
oracle.install.db.OPER_GROUP=oinstall
oracle.install.db.CLUSTER_NODES=
oracle.install.db.isRACOneInstall=false
oracle.install.db.racOneServiceName=
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.config.starterdb.globalDBName=
oracle.install.db.config.starterdb.SID=
oracle.install.db.config.starterdb.characterSet=
oracle.install.db.config.starterdb.memoryOption=false
oracle.install.db.config.starterdb.memoryLimit=
oracle.install.db.config.starterdb.installExampleSchemas=false
oracle.install.db.config.starterdb.enableSecuritySettings=true
oracle.install.db.config.starterdb.password.ALL=
oracle.install.db.config.starterdb.password.SYS=
oracle.install.db.config.starterdb.password.SYSTEM=
oracle.install.db.config.starterdb.password.SYSMAN=
oracle.install.db.config.starterdb.password.DBSNMP=
oracle.install.db.config.starterdb.control=DB_CONTROL
oracle.install.db.config.starterdb.gridcontrol.gridControlServiceURL=
oracle.install.db.config.starterdb.automatedBackup.enable=false
oracle.install.db.config.starterdb.automatedBackup.osuid=
oracle.install.db.config.starterdb.automatedBackup.ospwd=
oracle.install.db.config.starterdb.storageType=
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=
oracle.install.db.config.asm.diskGroup=
oracle.install.db.config.asm.ASMSNMPPassword=
MYORACLESUPPORT_USERNAME=
MYORACLESUPPORT_PASSWORD=
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
DECLINE_SECURITY_UPDATES=true
PROXY_HOST=
PROXY_PORT=
PROXY_USER=
PROXY_PWD=
PROXY_REALM=
COLLECTOR_SUPPORTHUB_URL=
oracle.installer.autoupdates.option=SKIP_UPDATES
oracle.installer.autoupdates.downloadUpdatesLoc=
AUTOUPDATES_MYORACLESUPPORT_USERNAME=
AUTOUPDATES_MYORACLESUPPORT_PASSWORD=
EOF
#fix responseFile premition
sudo chmod 777 $FILE
##run install
if [[ $DEBUG -ne 0 ]] ; then echo "run install"; fi
cd $INSTALL_LOCATION
./runInstaller -silent -noconfig -ignoreSysPrereqs -ignorePrereq -responseFile $TEMP_LOCATION/db11ginstall.rsp &


#test for install Successfully ending
echo "Waiting  for install Successfully end"
wait
#LOG=`ls -1tr  /u01/app/oraInventory/logs/ |tail -1`
#tail -f $LOG | while read LOGLINE
#do
   #[[ "${LOGLINE}" == *"Successfully Setup Software."* ]] && pkill -P $$ tail
#done
