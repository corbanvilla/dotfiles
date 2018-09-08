#!/bin/bash
#This is a quick and dirty script to quickly install @Animcogn's i3-gaps configuration on any new ubuntu install. 
#Author: @animcogn

#basic configuration, leave default if you're unsure. 
#this should mostly be used for debugging

#Required Installs (TRUE / FALSE)
DO_PACKAGE_UPDATES=TRUE
DO_DEPENDENCY_INSTALLS=TRUE
DO_COMPILE_I3=TRUE

#Customizable Installs (TRUE / FALSE / PROMPT)

DO_COPY_CONFIGS=PROMPT
	#Copy all animcogn's snazzy dotfiles and fonts! 
	#if you do this make sure you install 
	#recommended or it will break things!
DO_INSTALL_RECOMMENDED=PROMPT
	#Installs recommended software for config file to work
	#and pretty up i3, such as compton, i3lock, etc, etc
DO_INSTALL_ANIMCOGN_RECOMMENDED=PROMPT
	#Installs Animcogn's most used applications:
	#chromium-browser, terminator, and spotify
DO_INSTALL_PLAYERCTL=PROMPT
	#Installs playerctl to automatically pause music when
	#screen locks
DO_DOWNLOAD_WALLPAPERS=PROMPT
	#Downloads some cool wallpapers animcogn found on reddit :D
DO_RESTART_AFTERWARDS=PROMPT
	#Restarts the computer afterwards to properly load everything

#if you are unsure what version to use, don't change it
I3_VERSION="4.15.0.1"
PLAYERCTL_VERSION="0.6.1"

#get full path of THIS script
SCRIPTPATH=`dirname $(readlink -f $0)`

#update packages
if [ "$DO_PACKAGE_UPDATES" == "TRUE" ] ; then
	echo "updating packages..."
	sudo apt update
	sudo apt upgrade
fi

#downloading dependencies
if [ "$DO_DEPENDENCY_INSTALLS" == "TRUE" ] ; then
	echo "downloading i3-gaps dependencies..."
	sudo apt install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm-dev 
  	sudo apt install curl autoconf
  
  	sudo add-apt-repository ppa:aguignard/ppa
  	sudo apt-get update
  	sudo apt-get install libxcb-xrm-dev
fi

#compile and download i3 all in one function! what a time to be alive!
if [ "$DO_COMPILE_I3" == "TRUE" ] ; then
	#download and untar
	echo "curling and extracting i3-gaps version $I3_VERSION..."
	mkdir -p ~/build
	curl -L "https://github.com/Airblader/i3/archive/$I3_VERSION.tar.gz" -o ~/build/i3-gaps-$I3_VERSION.tar.gz
	tar xvf ~/build/i3-gaps-$I3_VERSION.tar.gz -C ~/build/

	#compile / install
	echo "compiling and installing i3-gaps"
	#this section modified from:
	#https://github.com/Airblader/i3/wiki/Compiling-&-Installing
	cd ~/build/i3-$I3_VERSION

	autoreconf --force --install
	rm -rf build/
	mkdir -p build && cd build/

	# Disabling sanitizers is important for release versions!
	# The prefix and sysconfdir are, obviously, dependent on the distribution.
	../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
	make
	sudo make install
fi

function install_configs {
	#copy config files
	echo "copying config files"
	mkdir -p ~/.config/
	cp -R $SCRIPTPATH/config/* ~/.config/

	#copy fonts
	echo "copying new font files"
	mkdir -p ~/.fonts
	cp -R $SCRIPTPATH/fonts/* ~/.fonts/
}

if [ "$DO_COPY_CONFIGS" == "TRUE" ] ; then
	install_configs
elif [ "$DO_COPY_CONFIGS" == "FALSE" ] ; then
	echo "skipping config installs!"
elif [ "$DO_COPY_CONFIGS" == "PROMPT" ] ; then
	while true; do
		read -p "install animcogn's i3 configs and fonts? [Y/n]" yn
		case $yn in
			[Nn]* ) break;;
			* ) install_configs; break;;
		esac
	done
fi

function install_i3_recommended {
	echo "installing recommended..."
	sudo apt install i3blocks i3lock feh compton fonts-font-awesome fonts-hack rofi scrot pavucontrol lxappearance arc-theme
}

#install i3 recommended
if [ "$DO_INSTALL_RECOMMENDED" == "TRUE" ] ; then
	install_i3_recommended
elif [ "$DO_INSTALL_RECOMMENDED" == "FALSE" ] ; then
	echo "skipping i3 recommended..."
elif [ "$DO_INSTALL_RECOMMENDED" == "PROMPT" ] ; then
	while true; do
		read -p "install i3 recommends? (i3lock, etc, etc) [Y/n]" yn
		case $yn in
			[Nn]* ) break;;
			* ) install_i3_recommended; break;;
		esac
	done
fi

function install_animcogn_recommended {
	#install animcogn recommended
	echo "installing recommended..."
	sudo apt install chromium-browser terminator
	sudo snap install spotify
}

#install animcogn recommended
if [ "$DO_INSTALL_ANIMCOGN_RECOMMENDED" == "TRUE" ] ; then
	install_animcogn_recommended
elif [ "$DO_INSTALL_ANIMCOGN_RECOMMENDED" == "FALSE" ] ; then
	echo "skipping the animcogn recommended..."
elif [ "$DO_INSTALL_ANIMCOGN_RECOMMENDED" == "PROMPT" ] ; then
	while true; do
		read -p "install animcogn's recommends? (chromium, terminator, spotify) [Y/n]" yn
		case $yn in
			[Nn]* ) break;;
			* ) install_animcogn_recommended; break;;
		esac
	done
fi

function install_playerctl {
	curl -L https://github.com/acrisci/playerctl/releases/download/v0.6.1/playerctl-"$PLAYERCTL_VERSION"_amd64.deb -o ~/Downloads/playerctl-"$PLAYERCTL_VERSION".deb
	sudo dpkg -i ~/Downloads/playerctl-"$PLAYERCTL_VERSION".deb
	sudo apt install -f
}

#install playerctl
if [ "$DO_INSTALL_PLAYERCTL" == "TRUE" ] ; then
	install_playerctl
elif [ "$DO_INSTALL_PLAYERCTL" == "FALSE" ] ; then
	echo "skipping playerctl"
elif [ "$DO_INSTALL_PLAYERCTL" == "PROMPT" ] ; then
	while true; do
		read -p "install playerctl (used to pause music)? [Y/n]" yn
		case $yn in
			[Nn]* ) break;;
			* ) install_playerctl; break;;
		esac
	done
fi

#download wallpapers
function get_wallpapers {
	echo "fetching wallpapers!"
	curl -L https://i.redd.it/ehe0afnpx6c11.jpg -o ~/Pictures/wallpaper-left.jpg
	curl -L http://puu.sh/n2zPL/2491975ef3.jpg -o ~/Pictures/wallpaper-right.jpg
}

if [ "$DO_DOWNLOAD_WALLPAPERS" == "TRUE" ] ; then
	get_wallpapers
elif [ "$DO_DOWNLOAD_WALLPAPERS" == "FALSE" ] ; then
	echo "skipping wallpaper download..."
elif [ "$DO_DOWNLOAD_WALLPAPERS" == "PROMPT" ] ; then
	while true; do
		read -p "install cool wallpapers Animcogn found on reddit? [Y/n]" yn
		case $yn in
			[Nn]* ) break;;
			* ) get_wallpapers; break;;
		esac
	done
fi

shutdown_process=(
	'Shutting down thermal reactor...'
	'Cycling down lazzzoorrsss....'
	'Deconstructing unstable bioelectromagnetics...'	
	'Disentangling supercharged phasors...'
	'Dismantling magnetocrystalline anisotrophy...'
	'Beam me up scotty!'
	)
	
function shutdown_cycle {
	#super secret process look away!

	count=0
	while [ "x${shutdown_process[count]}" != "x" ] ; do
		echo ${shutdown_process[count]}
		sleep 3
		count=$(( $count + 1 ))
	done
	
	echo "Uhh oh... I think we're gonna blow!"
	for i in {0..10}
	do
		echo -e "...\a"
		sleep .1
	done
	sudo reboot
}

if [ "$DO_RESTART_AFTERWARDS" == "TRUE" ] ; then
	shutdown_cycle
elif [ "$DO_RESTART_AFTERWARDS" == "FALSE" ] ; then
	echo "skipping shutdown..."
elif [ "$DO_RESTART_AFTERWARDS" == "PROMPT" ] ; then
	#reboot
	while true; do
		read -p "Everything has been installed! Woot woot! Your system needs to reboot now, can I go ahead and restart? [Y/n]" yn
		case $yn in
			[Nn]* ) break;;
			* ) shutdown_cycle; break;;
		esac
	done	
fi
