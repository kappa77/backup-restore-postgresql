#!/bin/bash
PGDATA="/var/lib/postgresql/9.4/main/"
DATATIME=`date +%Y%m%d%H%M%S`
DATA=`date +%Y%m%d`
LABEL="base_backup_${DATA}"
BASEBKCPDIR="/backup"
BKCPDIR="${BASEBKCPDIR}/${DATA}"
STARTBCKP="SELECT pg_start_backup('$LABEL')"
ENDBCKP="select file_name from pg_xlogfile_name_offset ( pg_stop_backup() )"
PSQLSTART="$STARTBCKP"
PSQLEND="$ENDBCKP"
SWITCHFILE="$PGDATA/backup_in_progress" 
TARFILE="$BKCPDIR/${LABEL}.tar.tgz"
indent=1
LASTARC="" 
create_bck_dir ()
{

test  ! -d ${BKCPDIR} && mkdir ${BKCPDIR}
test -d  ${BKCPDIR} 
if [ $? -ne 0  ] ; then
echo "  Error creating ${BKCPDIR}" >&2
exit 1
else
echo "  ${BKCPDIR} created / exist"
fi

}

pg_start_bck ()
{
psql -c "$PSQLSTART"

EXITCODE=$?

#echo "PSQL START $PSQLSTART exit $EXITCODE $RES"

if  [ $EXITCODE -ne 0  ] ; then
echo "  Error calling $PSQLSTART " >&2
exit 1
else
echo "  Started backup"
fi
}

pg_stop_bck ()
{
LASTARC=`psql  -E -t -c  "$PSQLEND" | cut -c 2- `
echo "----"$LASTARC"----"

EXITCODE=$?
#echo "PSQL END $PSQLEND exit $EXITCODE "

if  [ $? -ne $EXITCODE  ] ; then
echo "  Error calling $PSQLEND - try to execute $STARTBCKP inside psql console as postgres user" >&2
exit 1
else
echo "  End Backup"
fi
}

backup ()
{


TARCMD="tar -zc --warning=no-file-changed --warning=no-file-removed -f $TARFILE $PGDATA --exclude ${PGDATA}pg_xlog  ${PGDATA}pg_replslot "

$TARCMD

if  [ $? -ne 0 ] ; then
if  [ $? -ne 1 ] ; then
echo "  Error $TARCMD " >&2
pg_stop_bck
exit 1
else 
echo "  Some file not stored but is normal"
fi
fi
echo "  Tar file $TARFILE created"
}

#echo "Create switch file"
#touch $SWITCHFILE


echo "Create Backup dir"
create_bck_dir
echo "Start backup fase"
pg_start_bck
echo "Tar database"
backup
echo "End backup fase"
pg_stop_bck

BASE_DATE=$BKCPDIR/basebackup_${LASTARC}_${DATATIME}.tgz
mv $TARFILE $BASE_DATE
echo "Moved $TARFILE to $BASE_DATE file"
LASTFILE=$BASEBKCPDIR/basebackup_last.tgz
cp $BASE_DATE $LASTFILE
echo "Copied $BASE_DATE to $LASTFILE file"

#rm  $SWITCHFILE

echo "End"

exit 0
