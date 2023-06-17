#!/bin/bash

<<com
Author: Abhinav Thakur
Email : compilepeace@gmail.com
File  : setup.bash 
PoE:
    This script sets up my working environment on any machine.

Usage:
	$ ./setup.bash task 
com

# Default CONFIGURATION parameters (global variables)
GHAR=~/ghar/
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

#----------------------------------------------------------------------------------------------

# setup dotfile symbolic links
dotfiles ()
{
	# yet to be written (using ln -s)
	for file in $(ls ./dotfiles); do
		debugMsg "creating symbolic link : ln -s ./dotfiles/$file ~/.$file" "info"
		rm -f ~/."$file"
		ln -s "$(pwd)"/dotfiles/"$file" ~/."$file"
	done
}

# foundational setup
basic ()
{
	# update
	sudo apt update -y
	updateStatus "$?"
	debugMsg "updating system." "$STATUS"

	# utilities
	sudo apt install -y vim git tmux xclip build-essential gcc g++ nasm gdb hexedit tree make net-tools openssl gpg htop time shellcheck curl
	updateStatus "$?"
	debugMsg "installing fundamental utilities." "$STATUS"

	# snap packages
	sudo snap install code --classic
	sudo snap install p7zip-desktop
	updateStatus "$?"
	debugMsg "installing snap packges." "$STATUS"

	# VMs 
	# sudo apt --fix-broken install		# install dependencies of virtualbox
	sudo apt install -y virtualbox 
	updateStatus "$?"
	debugMsg "installing virtualbox." "$STATUS"

	# autoremove
	sudo apt autoremove -y
}

# setup shell theme
shell()
{	
	# Alacritty terminal emulator
	# with snap installation - a few programs like 'hexedit' may have symbol version issues
	# set LD_LIBRARY=	(empty) to overcome this issue
	sudo snap install alacritty --classic
	updateStatus "$?"
	debugMsg "installing Alacritty." "$STATUS"

	# ZSH
	sudo apt install zsh -y
	updateStatus "$?"
	debugMsg "installing zsh." "$STATUS"

    # install oh-my-zsh
	rm -rf /home/abhinav/.oh-my-zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    updateStatus "$?"
    debugMsg "installing OH-MY-ZSH." "$STATUS"

	# install powerlevel-10k (to configure run - p10k configure)
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	updateStatus "$?"
	debugMsg "Installing powerlevel10k, to configure type -> p10k configure" "$STATUS"

	# change defaut shell to zsh (both for current & root)
	sudo chsh -s $(which zsh)
	chsh -s $(which zsh)
	updateStatus "$?"
	debugMsg "default shell updated to ZSH." "$STATUS"

	debugMsg "You may want to restart your system to reflect changes" "INFO"
}

# setup GDB with pwndbg plugin
debugger()
{
	# install GDB
	sudo apt install gdb
	updateStatus "$?"
	debugMsg "Installing GNU Gdb" "$STATUS"

	# extend GDB features with pwndbg plugin
	git clone https://github.com/pwndbg/pwndbg "$GHAR/pwndbg" && cd "$GHAR/pwndbg" && ./setup.sh
	updateStatus "$?"
	debugMsg "Installing pwndbg plugin for GNU Gdb" "$STATUS"
}

radare()
{
	git clone https://github.com/radareorg/radare2 "$GHAR/radare2/" && "$GHAR/radare2/sys/install.sh"
	updateStatus "$?"
	debugMsg "Installing radare2 framework" "$STATUS"

	# install ghidra decompiler plugin for radare2 
	r2pm update && r2pm -ci r2ghidra
	updateStatus "$?"
	debugMsg "Installing r2ghidra plugin" "$STATUS"
}

security_tools()
{
	# reverse engineering user-mode software
	debugger		# dynamic analysis
	radare			# static analysis
}

embedded_dev()
{
	sudo apt install -y openocd gdb-multiarch screen qemu-user-static
	updateStatus "$?"
	debugMsg "Installing embedded development environment" "$STATUS"
}

if [ "$#" -gt 0 ]
then
	if [[ "$1" == "all" ]]
	then
		debugMsg "setting up everything." "INFO"
		basic
		shell
		security_tools
		embedded_dev
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
