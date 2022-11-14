#!/bin/bash
# Intialization
# Author (Raiyuu) note: This project is still unfinished so dont complain-- xd
# To do: Add Sh detection (For magisk delta)

# Check for tsu packages
clear
echo -e "Checking if tsu is installed..\n"
# (main) check if tsu package is installed
if [ "$(which tsu)" == "" ];
	then
		echo -e "Package tsu is not installed,\nDo you want to install it? (y/n)"
		# Ask the user if they want to install tsu package
		read choice_inst
		if [ "$choice_inst" == "y" -o "$choice_inst" == "Y" ];
			# Then it'll install the package tsu
			then
			pkg update && pkg install tsu -y
			# Double check if package installation fails
				if [ "$(which tsu)" == "" ];
					then
						clear
						echo -e "Failed to install the package tsu.\nPlease try again."
						exit 0
				else
					clear
					echo -e "Successfully installed tsu!"
				fi
				# End of the double check
		# (main) If the user inputs "n" the script will exit
		else
			exit 0
		fi			
	else
		echo -e "Package tsu is installed."
fi
# Check for root access
echo -e "\nChecking for root access..\n"
# Check for root
touch ./tempfile_root
root_chk=$(su -c rm ./tempfile_root && exit | paste -s)
if [[ "$root_chk" == *"No su"* ]];
	then
			echo -e "Root is not detected,\nPlease install a root provider to proceed."
			rm ./tempfile_root
			exit 0
	 elif [ "$(ls -ah | grep -o tempfile_root)" == "tempfile_root" ];
		then
			echo -e "\nRoot is present but root permissions are denied.\nPlease grant root permissions to continue.\n"
			rm ./tempfile_root
			exit 0
	else
		echo -e "Root detected proceeding with the script."
fi
# End checking root access
clear
echo -e ">_N0bl0ater by raiyuu\\n\n\nThe package youre looking for (fuzzy): "
read -e INPUTHING
####### Main stuff #########
# List packages
OTHERINPUT=$(sudo cmd package list packages | grep $INPUTHING | cut -c 9-)
# Now check if there are spaces present in the package list
OTHERINPUT_SPACE=$(echo $OTHERINPUT | grep -o " " | wc -m)
# The package space multiplies by 2 for no reason idk why so we're gonna divide it
OTHERINPUT_SPACE=$(($OTHERINPUT_SPACE/2))
# Check if theres single package or multiple package name
if [ $OTHERINPUT_SPACE -eq 1 -o $OTHERINPUT_SPACE -ge 1 ];
	then
		# If there are multiple packages it'll detect it
		echo -e packages: $OTHERINPUT
		echo -e "\n> Multiple package name detected\\nPlease select one manually from the list down below using their index:"
		# Make a loop to print out package name with their index thing
		OTHERINPUT_SPACE=$(($OTHERINPUT_SPACE+1))
		for xly in $(seq "$OTHERINPUT_SPACE")
		do
			echo -e $xly: $(echo $OTHERINPUT | cut -d " " -f $xly)
		done
		# Ask user for input to manually select a index
		read -rep $'\n'"Please enter the index number: " CHOICE
		# -le flag literary could stand for less than equal or equal, imo. since it evaluates the boolean to true if uhh yk
		if [ $CHOICE -le $OTHERINPUT_SPACE ];
			then
				OTHERINPUT=$(echo $OTHERINPUT | cut -d " " -f $CHOICE)
				echo -e "\nSelected package: $OTHERINPUT"
			# now if the user inputs an index thats something out of the boundary it'll throw an error straight to their face xd
			else 
				echo -e "\nInvalid input."
				exit 0
			fi
	# Or else if there is a single package
	else
		echo -e "\n> Single package name detected\nSelected package:"
fi
# Print out the selected package name
echo $OTHERINPUT
read -p "↑ Is this correct?(Y/N) " CHOICE
if [ $CHOICE == "y" ];
	then 
		echo -e "Debloating... (Disabling the package first)"
		sudo pm disable --user 0 $OTHERINPUT
		echo -e "Uninstalling package $OTHERINPUT:"
		sudo pm uninstall --user 0 $OTHERINPUT
fi
