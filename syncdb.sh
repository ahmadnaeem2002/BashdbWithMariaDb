#!/bin/bash
### This script to check if data files has changed and sync files to iti schema in mariadb
##########################################################################################
## he script must be called from Crontab 
## YOU MUST RUN THIS COMMAND FIRST echo $(stat -c %Y accs.db) > timeacc
## YOU MUST RUN THIS COMMAND FIRST echo $(stat -c %Y customers.db) > timedb
CHECKDBOLD=$(awk ' { print $1 } ' timedb)
CHECKDBNEW=$(echo $(stat -c %Y customers.db))
CHECKACOLD=$(awk ' { print $1 } ' timeacc)
CHECKACNEW=$(echo $(stat -c %Y accs.db))
if [ ${CHECKDBOLD} -ne ${CHECKDBNEW} ]
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
	echo $(stat -c %Y customers.db) > timedb
fi
set -x
if [ ${CHECKACOLD} -ne ${CHECKACNEW} ]
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
	echo $(stat -c %Y accs.db) > timeacc
fi
set +x
