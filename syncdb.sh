#!/bin/bash
### This script to check if data files has changed and sync files to iti schema in mariadb
##########################################################################################
## he script must be called from Crontab 
##	 */2 * * * /home/syncdb.sh
CHECKDB=$(find customers.db -mmin -3 | wc -l)
CHECKAC=$(find accs.db -mmin -3 | wc -l)
if [ ${CHECKDB} -eq 1 ]
then
	mysql -u iti -p123 -e "TRUNCATE TABLE bashdb.user";
	while read LINE
	do
		ID=$(echo ${LINE} | awk ' BEGIN { FS=":" } { print $1 }')
		NAME=$(echo ${LINE} | awk ' BEGIN { FS=":" } { print $2 }')
		EMAIL=$(echo ${LINE} | awk ' BEGIN { FS=":" } { print $3 }')
		mysql -u iti -p123 -e "insert into bashdb.user (id,username,email) values (${ID},'${NAME}','${EMAIL}');";
		echo "Done!!"
	done < customers.db
fi
if [ ${CHECKAC} -eq 1 ]
then
        mysql -u iti -p123 -e "TRUNCATE TABLE bashdb.accs";
        while read LINE
        do
                ID=$(echo ${LINE} | awk ' BEGIN { FS=":" } { print $1 }')
                NAME=$(echo ${LINE} | awk ' BEGIN { FS=":" } { print $2 }')
                PASS=$(echo ${LINE} | awk ' BEGIN { FS=":" } { print $3 }')
                mysql -u iti -p123 -e "insert into bashdb.accs (id,name,userpass) values (${ID},'${NAME}','${PASS}');";
                echo "Done!!"
        done < accs.db
fi

