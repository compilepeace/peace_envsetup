#!/usr/bin/env bash

# Author: Abhinav Thakur
# Email : compilepeace@gmail.com
# Description: Script for installation of custom linux environment

setup_dotfiles () {
	# yet to be written (using ln -s)
	for file in $(ls ./dotfiles); do
		echo "creating symbolic link : ln -s ./dotfiles/$file ~/.$file"
		rm -f ~/."$file"
		ln -s "$(pwd)"/dotfiles/"$file" ~/."$file"
	done
}

install_tools () {
	echo_ "basic utilities"
	sudo apt install -y python3 python3-pip vim git gcc g++ gdb yasm nasm build-essential make net-tools
	
	install_vim_plugins

	echo_ "useful tools"
	sudo apt install -y tldr
	tldr -u		 	# update tldr database
	sudo apt install -y hexedit htop tree 

	echo_ "visual studio code"
	sudo snap install code
	sudo snap install p7zip-desktop

	echo_ "profilers (memory,line profiler,cpu)"
	# To use memory_profiler, decorate the function (to be analyzed) with '@profile' (after importing 'profile' keyword - from memory_profiler import profile)
	# (python3 -m memory_profiler <sample.py>) 
	# 'kernprof': a line profiler (kernprof -l -v <sample.py>)
	# 'time': to measure time spend executing 'userspace', 'kernelspace' code
	pip3 install memory_profiler
	sudo apt install -y python3-line-profiler	# kernprof -l -v
	sudo apt install -y time			# time <sample.sh>
	sudo apt install htop				# System rsrcs profiler
	
	
	echo_ "static analyzers & linters"
	sudo apt install -y writegood shellcheck pyflakes3
}


customize_env () {
	echo_ "zsh" 
	# Can install ohmyzsh (which installs zsh by default)
	# Select ZSH_THEME (in .zshrc) 	--> (https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
	# To zsh plugins   		--> (https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
	# To install ohmyzsh: 
	# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	sudo apt install -y zsh

	# Alacritty will search its configuration file in one of these direcotries:
	# $HOME/.alacritty.yml
	# $HOME/.config/alacritty/alacritty.yml
	# $XDG_CONFIG_HOME/alacritty.yml
	# $XDG_CONFIG_HOME/alacritty/alacritty.yml
	# 
	# Find alacritty configuration file --> (https://github.com/alacritty/alacritty/blob/master/alacritty.yml)
	echo_ "terminal emulator Alacritty"
	sudo add-apt-repository -y ppa:mmstick76/alacritty	
	sudo apt install -y alacritty
	#echo_ "/ moving alacritty.yml file to $HOME/.config/alacritty/ ..."
	#mkdir -p $HOME/.config/alacritty/ 
	#mv -i ./alacritty.yml $HOME/.config/alacritty/
	echo "done."

	echo_ "terminal multiplexer (tmux)"
	sudo apt install -y tmux
}

install_vim_plugins () {
	echo_ "Vim plugins"

	# Asynchronous Lint Engine (ALE)
	mkdir -p ~/.vim/pack/git-plugins/start
	git clone --depth 1 https://github.com/dense-analysis/ale.git ~/.vim/pack/git-plugins/start/ale
	# writegood.vim (an English language linter)
	#git clone https://github.com/davidbeckingsale/writegood.vim ~/.vim/pack/plugins/start/writegood.vim
}


echo_ () {
	echo "-x-x-x-x-x-x- Installing $1 -x-x-x-x-x-x-"  
}


# -x-x-x-x-x-x- call functions -x-x-x-x-x-x-
#install_tools
#customize_env
setup_dotfiles
