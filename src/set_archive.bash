#!/bin/bash
PGDATA=/var/lib/postgresql/9.3/mainv

ETCPOSTGR=/etc/postgresql/9.3/main

ARCHIVEDIR=/archive

cd $ETCPOSTGR
echo 'wal_level=archive' >> postgresql.conf
echo 'archive_mode=on' >> postgresql.conf
#echo "archive_command='test ! -f $PGDATA/backup_in_progress ||( test ! -f  $ARCHIVEDIR/%f &&  ( cp %p $ARCHIVEDIR/%f.tmp && mv $ARCHIVEDIR/%f.tmp $ARCHIVEDIR/%f ) )'" >> postgresql.conf
echo "archive_command='cp %p $ARCHIVEDIR/%f.tmp && mv $ARCHIVEDIR/%f.tmp $ARCHIVEDIR/%f'" >> postgresql.conf

#echo 'local replication postgres trust' >> pg_hba.conf
