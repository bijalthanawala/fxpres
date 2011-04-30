#!/bin/bash

#####################################################################
# PROJECT: Fix Preserve 
#          [Fix ownership and permissions if you forgot to preserve]
# CONTENT: A bash script
# AUTHOR:  Names in the accompanied AUTHORS.txt
# LICENSE: The MIT License
#
#
# QUICK SHORT DESCRIPTION:
# fxpres is a bash script that copies ownership and permission of a 
# set of files and applies the same to another set of files.
# Contents of the files are not changed.
#
# USAGE:
#	 fxpres <src or model directory> <destination directory>
#
#	eg:
#	 fxpres /ubuntu10.10/usr/bin /usr/bin
#
#
#####################################################################

set +x

#######################################
# Constants
#######################################
OFF_PERM=0;
OFF_GID=1;
OFF_UID=2;

#######################################
# Support functions
#######################################
function usage() {
	echo "";
	echo "USAGE:";
	echo "fxpres <src or model directory> <destination directory>";
	echo "";
	echo "eg:";
	echo "fxpres /ubuntu10.10/usr/bin /usr/bin";
}


#######################################
# Script begins here
#######################################

dirtomodel=$1
dirtofix=$2

# Checking parameters and validity
if [ "$dirtofix" == "" -o "$dirtomodel" == "" ] ; then
	usage;
	exit 1;
fi

if [ ! -d $dirtofix -o ! -d $dirtomodel ]; then
	echo "Invalid source/model or destination directory";
	exit 1;
fi	


# For each file in the target directory
for filefix in $dirtofix/*; do 

   filemodel=$dirtomodel/$(basename $filefix); 
	
   #Only if a file with the same name exist in the model 
   #directory
   if [ -e $filemodel ] ; then 

		#Ignore if either is a symbolic link
		if [ -L $filefix -o \
			 -L $filemodel ] ; then
			continue;
		fi

		#Gather file information
		stattofix=($(stat -c'%a %g %u' $filefix));
		permtofix=${stattofix[$OFF_PERM]};
	   	grptofix=${stattofix[$OFF_GID]};
	   	usrtofix=${stattofix[$OFF_UID]};

		stattomodel=($(stat -c'%a %g %u' $filemodel));
		permtomodel=${stattomodel[$OFF_PERM]};
	   	grptomodel=${stattomodel[$OFF_GID]};
	   	usrtomodel=${stattomodel[$OFF_UID]};

		#Check if ownership is different, and take action
		if [ "$grptofix" != "$grptomodel" -o \
		     "$usrtofix" != "$usrtomodel" ] ; then
			 	#ls -la $filemodel $filefix
				chown --reference=$filemodel $filefix;
		fi;
		
		#Check if permission is different, and take action
		if [ "$permtofix" != "$permtomodel" ] ; then
				#ls -la $filemodel $filefix
				chmod --reference=$filemodel $filefix;
		fi;
   fi;  
done 

