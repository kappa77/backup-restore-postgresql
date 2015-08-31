#!/bin/bash
PGDATA=/var/lib/postgresql/9.4/main

ETCPOSTGR=/etc/postgresql/9.4/main

ARCHIVEDIR=/archive

cd $ETCPOSTGR
echo 'wal_level=archive' >> postgresql.conf
echo 'archive_mode=on' >> postgresql.conf
#echo "archive_command='test ! -f $PGDATA/backup_in_progress ||( test ! -f  $ARCHIVEDIR/%f &&  ( cp %p $ARCHIVEDIR/%f.tmp && mv $ARCHIVEDIR/%f.tmp $ARCHIVEDIR/%f ) )'" >> postgresql.conf
echo "archive_command='cp %p  $ARCHIVEDIR/%f.tmp && mv $ARCHIVEDIR/%f.tmp  $ARCHIVEDIR/%f'" >> postgresql.conf

##echo "archive_command='gzip < %p >  $ARCHIVEDIR/%f.tmp && mv $ARCHIVEDIR/%f.tmp $ARCHIVEDIR/%f.gzip'" >> postgresql.conf

#echo 'local replication postgres trust' >> pg_hba.conf
