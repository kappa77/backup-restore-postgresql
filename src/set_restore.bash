#/bin/bash
ARCHIVE_RES=/archive/restore
PGDATA=/var/lib/postgresql/9.4/main
echo "restore_command = 'cp /archive/restore/%f %p'" > $PGDATA/recovery.conf
