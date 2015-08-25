#!/bin/bash
PGDATA="/var/lib/postgresql/9.3/main/"
DATA=`date +%Y%m%d%H%M%S`
LABEL="bckp_${DATA}"
BKCPDIR="/backup/${DATA}"
TARFILE="$BKCPDIR/${LABEL}.tar.tgz"
STARTBCKP="SELECT pg_start_backup('$LABEL')"
ENDBCKP="SELECT pg_stop_backup()"
TARCMD="tar -zc --warning=no-file-changed --warning=no-file-removed -f $TARFILE $PGDATA"
PSQLSTART="$STARTBCKP"
PSQLEND="$ENDBCKP"
SWITCHFILE="$PGDATA/backup_in_progress"
indent=1

create_bck_dir ()
{
test  ! -d ${BKCPDIR} && mkdir ${BKCPDIR}

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
psql -c  "$PSQLEND"


EXITCODE=$?
#echo "PSQL END $PSQLEND exit $EXITCODE "

if  [ $? -ne $EXITCODE  ] ; then
echo "  Error callin $PSQLEND - try to execute $STARTBCKP inside psql console as postgres user" >&2
exit 1
else
echo "  End Backup"
fi
}

backup ()
{
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
echo "Remove Switch file"

#rm  $SWITCHFILE

echo "End"

exit 0
