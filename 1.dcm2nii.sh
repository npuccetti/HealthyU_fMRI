#!/bin/sh
BaseDir=/deep/heller/work/Healthyu
cd ${BaseDir}
for i in $( ls -d AHEL_HU_????_???????? ); do
	sub=`echo ${i} | awk -F/ '{ print $1 }'`

	echo ${sub}

	cd ${BaseDir}/${sub}

	for k in $( ls -d mr_* ); do
		dcm2niix -b y -z y ${k}
	done

done
