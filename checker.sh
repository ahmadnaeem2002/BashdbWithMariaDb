#!/bin/bash
### Script to check functions 
##############################
## Function check if filename exist or not
## return 1 if not exist and 0 if exist
function checkFile {
	FILENAME=${1}
	[ ! -f ${FILENAME} ] && return 1
	return 0	
}
###########################################
# check read perm
function checkFileR {
	FILENAME=${1}
	[ ! -r ${FILENAME} ] && return 1
	return 0
}
###########################################
# check write perm
function checkFileW { 
	FILENAME=${1}
	[ ! -w ${FILENAME} ] && return 1
	return 0
}
##########################################
#check user
function checkUser {
	RUSER=${1}
	[ ${RUSER} == ${USER} ] && return 0
	return 1
}
##########################################
# check if username and password in accs.db
function authUser {
	US=${1}
	PASS=${2}
	## Get the password hash from accs.db
	USERLINE=$(grep ":${US}:" accs.db)
	[ -z ${US} ] && return 0
	## get password hash
	PASSHASH=$(echo ${USERLINE} | awk ' BEGIN { FS=":" } { print $3 }')
	## get salt from password
	SALT=$(echo ${PASSHASH} | awk ' BEGIN { FS="$" } { print $3 }')
	## create new password with same salt
	NEWPASS=$(openssl passwd -salt ${SALT} -6 ${PASS})
	#check if new password match the old password
	if [ "${NEWPASS}" == "${PASSHASH}" ]
	then
		USERID=$(echo ${USERLINE} | awk ' BEGIN { FS=":" } {print $1 }' )
		return $USERID
	else
		return 0
	fi

}
###############################################################################
## check if customer exist in customers.db file
function queryCustomer {
	local CUSTNAME=${1}
	LINE=$(grep ":${CUSTNAME}:" customers.db  )
	[ -z ${LINE} ] && printErrorMsg "Sorry, ${CUSTNAME} is not found" && return 7
	echo "Information for customer"
	echo -e "\t ${LINE}"
}
function queryID {
        local CUSTID=${1}
        LINE=$(grep "^${CUSTID}:" customers.db  )
        [ -z ${LINE} ] && printErrorMsg "Sorry, ${CUSTID} is not found" && return 7
        echo "Information for customer"
        echo -e "\t ${LINE}"
}

function checkID {
	local CUID=${1}
	LINE=$(grep "^${CUID}:" customers.db | wc -l)
	if [ ${LINE} -eq 1 ] 
	then
		return 0
	else
		return 1
	fi
}

function checkMail {
        local EM=${1}
        LINEM=$(grep ":${EM}$" customers.db )
        [ -z ${LINEM} ] && return 0
	return 1
}
function checkMailV {
	MAL=$(echo ${1} | grep -E  "[A-Za-z0-9][A-Za-z0-9._%+-]+@[A-Za-z0-9][A-Za-z0-9.-]+\.[A-Za-z]" | wc -l)
	[ "${MAL}" != "0" ] && return 1
	return 0
}

