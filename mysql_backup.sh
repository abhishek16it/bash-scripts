#!/bin/bash
## Shell Script for Daily Bugzilla Backup ##
#today=$(date +%Y%m%d_%H%M%S)
today=`date +%Y%m%d_%H%M%S`
month=`date +%Y%m`
MYSQLUSER=root
MYSQLPWD=password
MAILLIST= 
BACKUP_LOCATION=http://IP/backup/$month
cd /mnt/backup/$month/
#
# Outputs the time the backup started, for log/tracking purposes
echo Time backup started = $(date +%T)
before="$(date +%s)"
#
mysqldump -u $MYSQLUSER -h localhost -p$MYSQLPWD bugs > backup_$today.sql
if [ $(echo $?) == 0 ]; then
zip backup_$today.zip backup_$today.sql
if [ $(echo $?) == 0 ]; then
MSG1=" mysql backup completed successfully.\nThe last line of backup file is:\n`tail -n 1 backup_$today.sql`\nFollowing is the backup location:\n$BACKUP_LOCATION"
else
MSG1="mysql backup failed."
fi
fi
#
# Outputs the time the backup finished, for log/tracking purposes
echo Time Backup Finished = $(date +%T)
#
# Calculates and outputs the total backup time
after="$(date +%s)"
#
elapsed="$(expr $after - $before)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
Total_Backup_Time="$hours hours $minutes minutes $seconds seconds"
#
# Backup Notification
##echo -e "$MSG1\nThe total backup time is:$Total_Backup_Time" | mailx -s "`hostname` Daily Backup Status" $MAILLIST && rm -rf backup_$today.sql
echo -e "$MSG1\nThe total backup time is:$Total_Backup_Time" | mailx -s "`hostname` Daily Backup Status" $MAILLIST
