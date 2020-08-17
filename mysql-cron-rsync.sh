#!/bin/bash
echo "cleaning up backup folder for the files older then 90 days" 
find /backup/db -mtime +90 -exec rm -f {} \;

# Database1 Credentials:
 username="user1"
 password="pass1"
 host="localhost"
 db_name="db1"

 # Database2 Credentials:
 username2="user2"
 password2="pass2"
 host2="localhost"
 db_name2="db2"

# Rsync Server Credentials:
 rsync_user="user"
 rsync_pass="pass"
 rsync_host="ip_or_host"

# Other options:
 mysql_backup_path="/backup/db"
 date=$(date +"%Y%m%d")

# Empty Backup Directory:
rm -rf $backup_path/*.gz > /dev/null 2>&1
rm -rf $backup_path/*.sql > /dev/null 2>&1

# Dump database into SQL file:
mysqldump -u $username -p$password -h $host $db_name > $mysql_backup_path/$db_name-$date.sql
mysqldump -u $username2 -p$password2 -h $host2 $db_name2 > $mysql_backup_path/$db_name2-$date.sql

# Create a tarball:
if [ "$?" -eq 0 ];
then
	cd  $mysql_backup_path && tar -cvzf $db_name-$date.sql.tar.gz  $db_name-$date.sql
	cd  $mysql_backup_path && tar -cvzf $db_name2-$date.sql.tar.gz  $db_name2-$date.sql
	if [ "$?" -eq 0 ];
	then
		# Delete SQL File:
		rm -rf $mysql_backup_path/$db_name-$date.sql
		rm -rf $mysql_backup_path/$db_name2-$date.sql
		sshpass -p $rsync_pass rsync -aP -e "ssh -o StrictHostKeyChecking=no" $db_name-$date.sql.tar.gz $rsync_user@$rsync_host:/share/Qrecordings/
		sshpass -p $rsync_pass rsync -aP -e "ssh -o StrictHostKeyChecking=no" $db_name2-$date.sql.tar.gz $rsync_user@$rsync_host:/share/Qrecordings/
		if [ "$?" -eq 0 ];
		then
			echo " $db_name DATABASE BACKUP Rsync and was Successful."
		else
			echo " $db_name Rsync was failed hence DB Backup was Failed."
		fi
	else
		echo " $db_name TAR creation Unsuccessful hence Backup was Failed."
	fi
else
	echo " $db_name DATABASE DUMP was Unsuccessful hence Backup was Failed."
fi
