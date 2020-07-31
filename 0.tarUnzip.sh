#!/bin/sh
BaseDir=/deep/heller/work/Healthyu
cd ${BaseDir}
for i in $( ls -f AHEL_HU_????_????????.tgz ); do
	sub=`echo ${i} | awk -F/ '{ print $1 }'`

	echo ${sub}

	tar -xvf ${i}	

done
