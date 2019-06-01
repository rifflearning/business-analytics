#! /usr/bin/env bash
#
# Run this script to loop over .sql files inside ./database-backups
# and restore their databases to the running mysql-business-analytics container
#

function restoreDatabaseBackup() {
   echo "Processing $1"
   cat "$1" | docker exec -i ba-mysql /usr/bin/mysql --user=root --password=root
}

for i in database-backups/*.sql
do
  restoreDatabaseBackup $i
done
