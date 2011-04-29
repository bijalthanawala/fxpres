#####################################################################
# PROJECT: Fix Preserve 
#          [Fix ownership and permission if you forgot to preserve]
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

function usage() {
	echo "";
	echo "USAGE:";
	echo "fxpres <src or model directory> <destination directory>";
	echo "";
	echo "eg:";
	echo "fxpres /ubuntu10.10/usr/bin /usr/bin";
}

dirtomodel=$1
dirtofix=$2

if [ "$dirtofix" == "" -o "$dirtomodel" == "" ] ; then
	usage;
	exit 1;
fi

if [ ! -d $dirtofix -o ! -d $dirtomodel ]; then
	echo "Invalid source/model or destination directory";
	exit 1;
fi	

for fn in $dirtofix/*; do 
   badgrp=$(stat -c%G $fn); 
   badusr=$(stat -c%U $fn);
   filemodel=$dirtomodel/$(basename $fn); 
   if [ -e $filemodel ] ; then 
   	goodgrp=$(stat -c%G $filemodel); 
	goodusr=$(stat -c%U $filemodel);
	if [ "$badgrp" != "$goodgrp" ] ; then
		#echo $filemodel $fn $badgrp $goodgrp;   
    	ls -la $filemodel
		ls -la $fn
	fi;
	if [ "$badusr" != "$goodusr" ] ; then
		#echo $filemodel $fn $badusr $goodusr;   
    	ls -la $filemodel
		ls -la $fn
    fi;
   fi;  
done 
