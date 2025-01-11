#!/bin/bash
logging(){
    logging_event=$1        # For what happened like Command successful, Error Occurred, Warning etc
    logging_message=$2      # Message to print along with the event like "The user is created in bash shell"
    timestamp=$(date "+%d-%b-%Y %H:%M:%S")

    # Log the event
    echo "[$timestamp] [$logging_event] $logging_message" >> /var/log/users_logs.log
}

loading(){
        echo -n "Loading"
        for i in {1..5}; do
                echo -n "..."
                sleep 0.7
        done
        echo -e "\nDone!"
}

newuser(){
        read -p "Enter a name for the new user: " name
        while true; do
		read -p "Enter a password for $name user [minimum of 8 characters]: " passwd
		leng="${#passwd}"
		if [[ $leng -ge 8 ]];then
			echo $passwd | grep -q [0-9]
			if [[ $? -eq 0 ]]; then
				echo $passwd | grep -q [A-Z]
				if [[ $? -eq 0 ]];then
					echo $passwd | grep -qE [\,\.\+\-\$\@\%\*\]
					if [[ $? -eq 0 ]]; then
						echo -e "Strong Password!"
						break
					else
						echo -e "Error: Please use special characters like <,*.$%-+@>!"
						continue
					fi
				else
					echo -e "Error: Please use some upper case characters!"
					continue
				fi
			else
				echo -e "Error: Please use some numerical values!"
				continue
			fi
		else
			echo -e "Error: Please use minimum more than 8, characters are less than 8 in your password!"
		fi
	done
        read -p "Choose a shell for the $name user |B|ash or |Z|sh: " shell
        shell=${shell,,}
        if [[ "$shell" == "b" || "$shell" == "bash" ]]; then
               	useradd -m -p $passwd -s /bin/bash -U $name
		if [[ $? -eq 0 ]]; then
			loading
			echo -e "\tNew user added successfully and its login shell is 'bash'!"
		 	logging "SUCCESS" "New user created in BASH shell"
		else
			echo -e "Error: There is some problem in name or password, please <try again>"
			logging "ERROR" "New user is not created because of some error in name or password"
		fi
        elif [[ "$shell" == "z" || "$shell" == "zsh" ]]; then
               	useradd -m -p $passwd -s /bin/zsh -U $name
		if [[ $? -eq 0 ]]; then
			loading
			echo -e "\tNew user added successfully and its login shell is 'zsh'!"
			logging "SUCCESS" "New user created in ZSH shell"
		else
			echo -e "Error: There is some problem in name or password, please <try again>"
			logging "ERROR" "New user is not created because of some error in name or password"
		fi
        else
               	echo "Error: Please select [B] for bash shell & [Z] for zshell!"
        fi
}

user_removal(){
        read -p "Enter the specific user's name which you want to delete: " name
        read -p "Do you really want to delete $name user and the group associated to this user, it's home directory will also be deleted? [Y/n]: " ans
        local ans=${ans,,}
        if [[ "$ans" == "y" || "$ans" == "yes" ]]; then
		loading
                userdel -f $name; groupdel -f $name; rm -rf /home/$name
		if [[ $? -eq 0 ]]; then
			echo -e "\t\"$name\" user deleted successfully!"
			logging "SUCCESS" "'$name' user is deleted successfully and the group associated with the '$name' is also deleted"
		else
			echo -e "Error: Command failed!\n<Recheck username>"
			logging "ERROR" "'$name' user deletion failed because of wrong username!"
		fi
        elif [[ "$ans" == "n" || "$ans" == "no" ]]; then
                echo "Next time, be careful when choosing an option!"
        else
                echo -e "\nError: Choose an option between |yes| or |no|!"
        fi
}

modify_user(){
	user_lock(){
		usermod -L $username
		if [[ $? -eq 0 ]]; then
			echo -e "Command Successful: \"$username\" is Locked"
			logging "SUCCESS" "'$username' is locked"
		else
			echo -e "Operation Failed: Please Recheck username!"
			logging "ERROR" "'$username' didn't locked becasue the username is not valid!"
		fi
	}
	user_unlock(){
		usermod -U $username
		if [[ $? -eq 0 ]]; then
			echo -e "Command Successful: \"$username\" is Unlocked"
			logging "SUCCESS" "'$username' is Unlocked"
		else
			echo -e "Operation Failed: Please Recheck username!"
			logging "ERROR" "'$username' didn't Unlocked because the username is not valid!"
		fi
	}
	user_passwdch(){
		while true; do
		read -p "Enter a new password for $username [minimum of 8 characters]: " password
		leng="${#password}"
		if [[ $leng -ge 8 ]];then
			echo $password | grep -q [0-9]
			if [[ $? -eq 0 ]]; then
				echo $password | grep -q [A-Z]
				if [[ $? -eq 0 ]];then
					echo $password | grep -qE [\,\.\+\-\$\@\%\*\]
					if [[ $? -eq 0 ]]; then
						echo -e "Strong Password!"
						break
					else
						echo -e "Error: Please use special characters like <,*.$%-+@>!"
						continue
					fi
				else
					echo -e "Error: Please use some upper case characters!"
					continue
				fi
			else
				echo -e "Error: Please use some numerical values!"
				continue
			fi
		else
			echo -e "Error: Please use minimum more than 8, characters are less than 8 in your password!"
		fi
	done
	usermod -p $password $username
	if [[ $? -eq 0 ]]; then
		echo -e "Command Successful: \"$username\'s\" password is changed"
	 	logging "SUCCESS" "'$username' password is now changed to a new password."
	else
		echo -e "Operation Failed: Please Recheck username!"
	 	logging "ERROR" "Failed to change the password of user '$username'"
	fi
	}
	user_chgrp(){
		echo -e "WARNING: Changing primary group of User will change the group ownership of all the files owned by your user to the new group!"
		sleep 2
		read -p "Do you still wish to continue? [Y/n] " answ
		answ="${answ,,}"
		if [[ "$answ" == "y" || "$answ" == "yes" ]]; then
			read -p "Group should be existed before executing this command, is it? [Y/n]" answer
			answer="${answer,,}"
			if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
				read -p "Enter username: " usrnme
				read -p "Enter the existing Group Name/ID: " grp
				usermod -g $grp $usrnme
				if [[ $? -eq 0 ]]; then
					echo -e "\tAll groups ownership under $usrnme have been changed to $grp"
				 	logging "INFO" "The '$grp' is now the group owner of all the files owned by '$usrnme'"
				else
					"Error: Please recheck the username or the group name/id"
				 	logging "ERROR" "Failed to change the group ownership of files owned by '$usrnme'"
				fi
			elif [[ "$answer" == "n" || "$answer" == "no" ]]; then
				echo -e "Do you want to make a group? [Y/n]" ansr
				ansr="${ansr}"
				while true; do
					if [[ "$ansr" == "y" || "$ansr" == "yes" ]]; then
						read -p "Enter the new Group name: " grpname
						groupadd $grpname
						if [[ $? -eq 0 ]]; then
							echo -e "\tNew group $grpname created successfully!"
						 	logging "INFO" "'$grpname' is a group created while changing the group ownership of files owned by '$usrnme'"
							break
						else
							echo "Error: Please recheck the group name you entered"
						 	logging "ERROR" "Error encountered while creating a group!"
							continue
						fi
					elif [[ "$ansr" == "n" || "$ansr" == "no" ]]; then
						echo -e "Please be careful when choosing an option"
						break
					else
						echo "Error: Please answer in Yes or No!"
						continue
					fi
				done
			else
				echo "Error: Please answer in Yes or No!"
			fi
		elif [[ "$answ" == "n" || "$answ" == "no" ]]; then
			echo -e "As you wish!"
		else
			echo "Error: Please answer in Yes or No!"
		fi
	}
	while true; do
	clear
	echo "===================================="
	echo -e "[1] Lock user\n[2] Unlock User\n[3] Change Password\n[4] Change primary group of User\n[0] To exit this menu\v"
	read -p "Choose an option from above: " opt
	read -p "Please Enter the User's name: " username
		case $opt in
			1) user_lock; read -p "Press any key to return back to the menu" continue;;
			2) user_unlock; read -p "Press any key to return back to the menu" continue;;
			3) user_passwdch;read -p "Press any key to return back to the menu" continue;;
			4) user_chgrp; read -p "Press any key to return back to the menu" continue;;
			0) break;;
			*) echo -e "Please enter a valid option"
		esac
	done
}

users_list(){
	echo -e "USERS\t\t   GID's  HOME-DIRS\t\t   LOGIN-SHELLS" && awk -F: '{print $1 "\t" $4 "\t" $6 "\t" $7}' /etc/passwd | column -t  
	echo -e "\n\tHere is list of all users with their group ID's, home directories and login shells.\n\v\tPress [shift+Pageup] to go up and {page-down] to go down the list."
	
}
	while true; do
        clear
        echo "============================================"
        echo -e "\t[1] Add User\n\t[2] Remove User\n\t[3] Modify User\n\t[4] List Users\n\t[0] Exit this Menu"

        read -p "Enter your desired action: " option

        case $option in
                1) echo -e "Creating a User\n"; newuser; read -p "Press any key to return to the menu" continue;;
                2) user_removal; read -p "Press any key to return to the menu" continue;;
                3) modify_user; read -p "Press any key to return to the menu" continue ;;
                4) users_list; read -p "Press any key to return to the menu" continue ;;
		0) break;;
                *) echo "Error: Please choose a valid option!"; read -p "Press any key to return to the menu" continue;;
        esac
done