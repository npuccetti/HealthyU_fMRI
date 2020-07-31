#!/bin/sh

bidsdir=/deep/heller/work/Healthyu/bids

for i in $( ls -d sub-50?? ); do
      subject=`echo ${i} | awk -F/ '{ print $1 }'`
      subdir=${bidsdir}/${subject}
      cd ${subdir}
      cd anat
      #move .png to subject directory
      mv *.png ${subdir}

      #change task names from 'worryrum' to 'wrg'
      cd ${subdir}/func
      for i in $(ls -f ${subject}_task* ); do
          file=`echo ${i} | awk -F/ '{ print $1 }'`
          echo ${file}
          oldname=`echo "$file" | cut -d'.' -f1`
          extension=`echo "$file" | cut -d'.' -f2`
          newfilename=${subject}_task-wrg_run-
          runnum=`echo "$oldname" | cut -c28`
          cp ${i} ${subdir}/func/${newfilename}${runnum}_bold.${extension}
          #rm *worryrum*
          #do rm manually/carefully
      done

      #change fmap names from 'sub-5xxx-AP or PA' to 'sub-5xxx_dir-pa_run-1_epi'
      cd ${subdir}/fmap
      for i in $(ls -f *${subject}* ); do
          file=`echo ${i} | awk -F/ '{ print $1 }'`
          echo ${file}
          oldname=`echo "$file" | cut -d'.' -f1`
          extension=`echo "$file" | cut -d'.' -f2`
          newfilename=${subject}_dir-
          direction=`echo "$oldname" | cut -c10,11 | tr '[:upper:]' '[:lower:]'`
          cp ${i} ${subdir}/fmap/${newfilename}${direction}_run-1_epi.${extension}
      done

done

#remove unneeded niftis from 5300s
for i in $( ls -d sub-53?? ); do
      subject=`echo ${i} | awk -F/ '{ print $1 }'`
      subdir=${bidsdir}/${subject}
      cd ${subdir}
      pwd
      ls
      echo "removing niis and jsons that have been reformatted to bids"
      rm *.nii
      rm *.json
      ls
done


#move 'extra files' from bids to extra_data folder
cd /deep/heller/work/Healthyu/bids
  for i in $( ls -d */calibration ); do
    cd /deep/heller/work/Healthyu/bids
        folder=`echo ${i} | awk -F/ '{ print $1 }'`
        cd ${folder}/calibration
        pwd
        ls
        echo "moving niis and jsons from calibration"
        mv *.nii /deep/heller/work/Healthyu/extra_data
        mv *.json /deep/heller/work/Healthyu/extra_data

        ls
  done

  for i in $( ls -d */localizer ); do
    cd /deep/heller/work/Healthyu/bids
        folder=`echo ${i} | awk -F/ '{ print $1 }'`
        cd ${folder}/localizer
        pwd
        ls
        echo "moving niis and jsons from localizer"
        mv *.nii /deep/heller/work/Healthyu/extra_data
        mv *.json /deep/heller/work/Healthyu/extra_data

        ls
  done

  for i in $( ls -f */*.txt ); do           #.png
    cd /deep/heller/work/Healthyu/bids
        folder=`echo ${i} | awk -F/ '{ print $1 }'`
        cd ${folder}
        pwd
        ls
        echo "moving .png and .txt files that are not bids compliant"
        #mv *.png /deep/heller/work/Healthyu/extra_data
        mv abbreviated_readme.txt /deep/heller/work/Healthyu/extra_data/${folder}_abbreviated_readme.txt
        mv scan_parameters.txt /deep/heller/work/Healthyu/extra_data/${folder}_scan_parameters.txt
        ls
  done


##Change the .json files from phase encoding axis to direction so fmri prep will read them
cd /deep/heller/work/Healthyu/bids

for i in $( ls -f */func/*bold*.json ); do     
  boldfile=`echo ${i}`
  echo ${boldfile}
  sed -i 's/PhaseEncodingAxis/PhaseEncodingDirection/' ${boldfile}
done


for i in $( ls -f */fmap/*.json ); do
  fmapfile=`echo ${i}`
  echo ${fmapfile}
  sed -i 's/PhaseEncodingAxis/PhaseEncodingDirection/' ${fmapfile}
done


