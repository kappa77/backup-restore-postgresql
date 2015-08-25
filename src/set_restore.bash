#/bin/bash
ARCHIVE_RES=/archive/restore
PGDATA=/var/lib/postgresql/9.3/main
echo "restore_command = 'cp /archive/restore/%f %p'" > $PGDATA/recovery.conf
