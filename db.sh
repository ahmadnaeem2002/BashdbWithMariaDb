#!/bin/bash
########################################
######### Script that handles customer info in file customers.db ########
#	Data files:
#		customers.db:
#			id:name:email
#		accs.db:
#			id,username,pass
#	Operations:
#		Add a customer
#		Delete a customer
#		Update a customer email
#		Query a customer
#	Notes:
#		Add,Delete,Update --> needs a authentication
#		Query can be anonymous
#	Must be root to access the script
#########################################################################
## Exit codes:
##############
#	0: Success
#	1: No customers.db file exists
#	2: No accs.db file exists
#	3: No read perm on customer.db
#	4: No read perm on accs.db
#	5: Must be root to run the script
#	6: Can't write to customers.db
#	7: Customer name is not found
#	8: ID not integer
#	9: ID exist
#########################################################################
source ./checker.sh
source ./printmsg.sh
checkFile "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can't find customers.db" && exit 2
checkFile "accs.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can't find accs.db" && exit 2
checkFileR "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can't read from customers.db" && exit 3
checkFileR "accs.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can't read from accs.db" && exit 4
checkFileW "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can't write on customers.db" && exit 6
checkUser "root"
[ ${?} -ne 0 ] && printErrorMsg "You are not root, change to root and come back" && exit 5
FLAG=1
USERID=0
while [ ${FLAG} -eq 1 ]
do
	printMainMenu
	read OP
	case "${OP}" in
		"a")
			echo "Authentication:"
			echo "---------------"
			echo -n "Username: "
			read ADMUSER
			echo -n "Password: "
			read -s ADMPASS
			authUser ${ADMUSER} ${ADMPASS}
			USERID=$?
			if [ "${USERID}" == "0" ]
			then
				echo "Invaild username/password"
			else
				echo "Welcome to the system"
				echo "~~~~~~~~~~~~~~~~~~~~~"
			fi
			;;

		"1")
			if [ ${USERID} -eq 0 ]
                        then
                                echo "You are not authentication, please contact the admin"
				echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                        else
                                echo "Adding a new customer"
				echo "---------------------"
				echo -n "Enter customer id: "
				read CUSTID
				ID=$(echo ${CUSTID} | grep "^[0-9]*$" | wc -l)
				
				if [ ${ID} -eq 0 ] 
				then
					 printErrorMsg "please Enter valid id!"
				 else
					 checkID ${CUSTID}
					 if [ ${?} -eq 0 ]
					 then
						 printErrorMsg "ID is exit, please try again"
					 else
						echo -n "Enter customer name: "
                                                read CUSTNAME
                                                NA=$(echo ${CUSTNAME} | grep "^[[:alpha:]]*$" | wc -l)
					 	if [ ${NA} -eq 0 ]
					 	then
						 	printErrorMsg "please Enter valid Name"
					 	else
						 	echo -n "Enter customer email: "
						 	read CUSTEMAIL
							checkMailV ${CUSTMAIL}
							MA=${?}
						 	if [ "${MA}" != "0" ]
                                         	 	then
                                                 		printErrorMsg "please Enter valid Email"
                                         	 	else
								checkMail ${CUSTMAIL}
								CH=${?}
								if [ ${CH} -ne 0 ]
								then
									printErrorMsg "Email is exist, Please try another one"
								else
									echo "${CUSTID}:${CUSTNAME}:${CUSTEMAIL}" >> customers.db
					 	 	 		echo "customer ${CUSTNAME} add successfully."
								fi
							fi
						 fi
					 fi
				fi
				
                        fi
                        ;;

		"2")
			if [ ${USERID} -eq 0 ]
                        then
                                printErrorMsg "You are not authenticated, please contact the admin"
			else
				echo "Updating an existing email"
				echo -n "Please enter ID to update: "
				read E
				checkID ${E}
				if [ ${?} -eq 1 ]
                                then
                                        echo "ID is not exist, Please try again!"
                                else
					queryCustomer ${E}
					echo -n "Are you to update this customer ? (y/n): "
                        		read ED
					if [ ${ED} == 'y' ]
					then
						echo -n "Enter new email to update: "
						read NEWMAIL
						checkMailV ${NEWMAIL}
                                                MI=${?}
                                                if [ "${MI}" == "0" ]
                                                then
							printErrorMsg "please Enter valid Email"
                                                else
							checkMail ${CUSTMAIL}
                                                        CH=${?}
                                                        if [ ${CH} -ne 0 ]
                                                        then
                                                        	printErrorMsg "Email is not exist, Please try another one"
                                                        else
								OLD=$(grep "${E}:" customers.db)
								OLDMAIL=$(echo ${OLD} | awk ' BEGIN { FS=":" } { print $3 }')
                                                        	sed -i "s/${OLDMAIL}/${NEWMAIL}/" customers.db
							fi
                                               	fi

					fi

				fi
                        fi
			;;
		"3")
			if [ ${USERID} -eq 0 ]
                        then
                                printErrorMsg "You are not authenticated, please contact the admin"
                        else
                                echo -n "Enter ID to delete: "
				read DD
				checkID ${DD}
				if [ ${?} -eq 1 ]
				then
					echo "ID is not exist, Please try again!"
				else
					queryID ${DD}
					echo -n "Are you sure to delete the selected customer (y/n): "
					
					read W
					if [ ${W} == "y" ]
					then
						L=$(grep "${DD}" customers.db)
						sed -i "s/${L}//" customers.db
						sed -i '/^$/d' customers.db
						echo "Delete is done!" 
					fi


				fi

                        fi
			;;
		"4")
			echo -n "Enter name: "
			read CUSTNAME
			queryCustomer ${CUSTNAME}
			;;
		"5")
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			echo "Thank you fot using our system"
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			FLAG=0
			;;
		*)
			echo "Invalid choice, try again"
	esac
done

exit 0













