#!/bin/bash

<<com
Author: Abhinav Thakur
Email : compilepeace@gmail.com
File  : setup.bash 
PoE:
    This script sets up my working environment on any machine.

Usage:
	$ ./setup.bash
com

# Default CONFIGURATION parameters (global variables)
COLOR_BRED="\033[1m\033[31m"
COLOR_BGREEN="\033[1m\033[32m"
COLOR_BYELLOW="\033[1m\033[33m"
COLOR_RESET="\033[0m"
STATUS="failed"

# $1 : msg string
# $2 : one of the cases (done/fail/info)
debugMsg()
{
	MSG_STRING=""
	case "$2" in
		SUCCESS | success | DONE | done)
			MSG_STRING="$COLOR_BGREEN[+]"
			;;
		ERROR | error | FAIL | fail | FAILED | failed)
			MSG_STRING="$COLOR_BRED[-]"
			;;
		INFO | info | WARN | warn)
			MSG_STRING="$COLOR_BYELLOW[*]"
			;;
		*)								# default case
			MSG_STRING="$COLOR_RESET[ ]"
	esac
		
	MSG_STRING="$MSG_STRING $1 $COLOR_RESET"
	echo -e "$MSG_STRING"
}

# $1 : send "$?"
updateStatus()
{
	STATUS="failed"

	if [ "$1" -eq "0" ]; then
		STATUS="done"
	else
		STATUS="failed"
	fi
}


# setup dotfile symbolic links
dotfiles () {
	# yet to be written (using ln -s)
	for file in $(ls ./dotfiles); do
		debugMsg "creating symbolic link : ln -s ./dotfiles/$file ~/.$file" "info"
		rm -f ~/."$file"
		ln -s "$(pwd)"/dotfiles/"$file" ~/."$file"
	done
}

# setup shell theme
shell()
{	
    # ZSH
	sudo apt install zsh -y
	updateStatus "$?"
	debugMsg "installed zsh." "$STATUS"

    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	updateStatus "$?"
	debugMsg "installed OH-MY-ZSH." "$STATUS"

	# install powerlevel-10k (to configure run - p10k configure)
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	updateStatus "$?"
	debugMsg "Installed powerlevel10k, to configure type -> p10k configure" "$STATUS"

	# change defaut shell to zsh
	sudo chsh -s $(which zsh)
	updateStatus "$?"
	debugMsg "default shell updated to ZSH." "$STATUS"

	debugMsg "You may want to restart your system to reflect changes" "INFO"
}

if [ "$#" -gt 0 ]
then
	if [[ "$1" == "all" ]]
	then
		debugMsg "setting up everything." "INFO"
		shell
	else
		for cmd in "$@"
		do
			$cmd
    	done
	fi
	dotfiles
else
	debugMsg "Usage: $0 [function]..." "error"
fi