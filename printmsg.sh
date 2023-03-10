########################################################
# Script contain all msg that we will use in our project
## Function take massage and print an error msg
function printErrorMsg { 
	MSG=${1}
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo " "
	echo "Error: ${MSG}"
	return 0
}
########################################################
## function print main menu
function printMainMenu {
	echo "Main Menu"
	echo -e "\t a) Authenticate"
	echo -e "\t 1) Add a customer"
	echo -e "\t 2) Update a customer"
	echo -e "\t 3) Delete a customer"
	echo -e "\t 4) Query a customer "
	echo -e "\t 5) Quit"
	echo -n "Please, select a option: "
}
