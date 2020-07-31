#!/bin/sh
BaseDir=/deep/heller/work/Healthyu/raw
cd ${BaseDir}

for i in $( ls -d AHEL_HU_5336_???????? ); do
	sub=`echo ${i} | awk -F/ '{ print $1 }'`
	echo ${sub}
	echo "making new directory for niftis (eventually in bids)"
	
	dirname=`echo ${sub} | cut -c9-12`
	echo ${dirname}
	mkdir ${BaseDir}/sub-${dirname}
	cd ${BaseDir}/sub-${dirname}
	echo "moving .nii's from"
	pwd
	echo "to"
	echo "${BaseDir}/sub-${dirname}"
	find . -name \mr*.nii.gz -exec cp {} ${BaseDir}/sub-${dirname} \;
	echo "Done!"
done
