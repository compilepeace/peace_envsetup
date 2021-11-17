#!/usr/bin/env bash

# Author: Abhinav Thakur
# Email : compilepeace@gmail.com
# Description: Script for installation of custom linux environment

setup_dotfiles () {
	# yet to be written (using ln -s)
	for file in $(ls ./dotfiles); do
		echo "creating symbolic link : ln -s ./dotfiles/$file ~/.$file"
		rm -f ~/."$file"
		$(ln -s $(pwd)/dotfiles/"$file" ~/."$file")
	done
}

install_tools () {

	echo_ "basic utilities"
	sudo apt install -y vim git gcc g++ gdb yasm nasm build-essential  

	echo_ "useful tools"
	sudo apt install -y tldr
	tldr -u		 	# update tldr database
	sudo apt install -y hexedit htop tree shellcheck 

	echo "visual studio code"
	sudo snap install code
	sudo snap install p7zip-desktop
}


customize_env () {
	echo_ "installing zsh and alacritty"
	install_zsh
	install_alacritty
	echo_ "terminal multiplexer (tmux)"
	sudo apt install -y tmux
}

install_zsh () {
	# Can install ohmyzsh (which installs zsh by default)
	# Select ZSH_THEME (in .zshrc) 	--> (https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
	# To zsh plugins   		--> (https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
	# To install ohmyzsh: 
	# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	sudo apt install -y zsh
}

install_alacritty () {
	# Alacritty will search its configuration file in one of these direcotries:
	# $HOME/.alacritty.yml
	# $HOME/.config/alacritty/alacritty.yml
	# $XDG_CONFIG_HOME/alacritty.yml
	# $XDG_CONFIG_HOME/alacritty/alacritty.yml
	# 
	# Find alacritty configuration file --> (https://github.com/alacritty/alacritty/blob/master/alacritty.yml)
	echo_ "terminal emulator alacritty"
	sudo add-apt-repository -y ppa:mmstick76/alacritty	
	sudo apt install -y alacritty
	#echo_ "/ moving alacritty.yml file to $HOME/.config/alacritty/ ..."
	#mkdir -p $HOME/.config/alacritty/ 
	#mv -i ./alacritty.yml $HOME/.config/alacritty/
	echo "done."
}


echo_ () {
	echo "-x-x-x-x-x-x- Installing $1 -x-x-x-x-x-x-"  
}


# -x-x-x-x-x-x- call functions -x-x-x-x-x-x-
#install_tools
#customize_env
setup_dotfiles
