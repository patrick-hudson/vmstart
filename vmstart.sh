#!/bin/bash
# Copyright (c) 2014 Patrick Hudson
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

######################################################
#                                                    #
# Enter the root path for your VMWare Fusion Images  #
# Example: "/Volumes/Images/VMWare/" 		             #
#						             #
######################################################

imagepath="/Volumes/Random[[:space:]]Shit"

######################################################
                  STOP EDITING HERE!
######################################################
if [ ! -f "/Applications/VMware Fusion.app/Contents/Library/vmrun" ]; then
	printf "VMWare not found, please ensure you have VMWare installed.\n"
	exit
else
	printf "VMWare Found!\n"
fi
if [ ! -f "/usr/local/bin/vmrun" ]; then
	printf "VMWare vmrun utility not found in /usr/local/bin/vmrun\n"
	while true; do
    		read -p "Would you like to see if we can programagically find it? [Y/N] " yn
    		case $yn in
       		[Yy]* ) sudo ln -s "/Applications/VMware Fusion.app/Contents/Library/vmrun" /usr/local/bin/vmrun; break;;
        	[Nn]* ) exit;;
        	* ) echo "Please answer yes or no.";;
    		esac
	done
else
	printf "VMWare vmrun command line tool found!\n"
fi

vmcount=$(ls $imagepath | grep '\.vmwarevm$' | wc -l)
if [ $vmcount = 0 ]; then
	printf "0 VMWare Images Found :(\n"
	exit
fi
if [ -z $1 ]; then
	printf "You did not supply the name of your Image to start\n"
	exit
else
	location=$(find $imagepath -maxdepth 1 -name $1*.vmwarevm)
fi

if [ -z "$location" ]; then
	printf "No image matching $1 in $imagepath\n"
else
	nohup vmrun -T fusion start "$location" nogui > /dev/null 2>&1 &
	wait %1
	pid=$(ps -ef | grep "$location" | grep -v grep | awk '{print $2}')
	printf "$location Launched! PID: $pid\n\n"
fi
