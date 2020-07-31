#!/bin/sh

####Defining pathways
echo "Step 1: Defining pathways"
toplvl=/deep/heller/work/Healthyu
dcmdir=/deep/heller/work/Healthyu/raw
  ###dcm2niidir=/Users/franklinfeingold/Desktop/dcm2niix_3-Jan-2018_mac
niidir=${toplvl}/bids

###Create dataset_description.json
echo "Step 2: Create dataset_description.json"
#jo -p "Name"="HealthyU Scanning Dataset"
#"BIDSVersion"="1.0.2" >> ${niidir}/dataset_description.json

###Convert dcm to nii
echo "Step 3: Convert Dicom to bids Nii..."
cd ${dcmdir}
pwd
for i in $( ls -d AHEL_HU_53??_???????? ); do
      subject=`echo ${i} | awk -F/ '{ print $1 }'`
      subj=`echo ${subject} | cut -c9,10,11,12`
         echo "converting ${subject}'s dcms..."
         cd ${dcmdir}/${subject}
         pwd
	 cp *.txt ${niidir}/sub-${subj}
         for k in $( ls -d mr_* ); do
           dcm2niix -b y -o ${niidir}/sub-${subj} -f ${subj}_%p ${k}
         done
done

### Loop through subjects to rename and reorg
cd ${niidir}

echo "Step 4: Looping through converted files to rename and reorg"
for i in $( ls -d sub-53?? ); do
  subj=`echo ${i} | cut -c5,6,7,8 `
	echo "Processing subject ${subj}'s nii/json files...'"


    #move to the nifti directory
    cd ${niidir}/sub-${subj}

    #remove any lingering .nii.gz files that aren't necesary
    rm *.nii.gz

    #### Anatomical Organization & Renaming ####

    #pure filtered T1 images -- pureT1files=$(ls -f *PU_3D_T1* )
    mkdir anat
    for i in $(ls -f *PU_3D_T1* ); do
        file=`echo ${i} | awk -F/ '{ print $1 }'`
        echo ${file}
        oldname=`echo "$file" | cut -d'.' -f1`
        extension=`echo "$file" | cut -d'.' -f2`
        newfilename=sub-${subj}_rec-pure_T1w.
        cp ${i} anat/${newfilename}${extension}
    done

    #pure filtered T2 images -- pureT1files=$(ls -f *PU_Sag_CUBE_T2* )
    for i in $(ls -f *PU_Sag_CUBE_T2* ); do
        file=`echo ${i} | awk -F/ '{ print $1 }'`
        echo ${file}
        oldname=`echo "$file" | cut -d'.' -f1`
        extension=`echo "$file" | cut -d'.' -f2`
        newfilename=sub-${subj}_rec-pure_T2w.
        cp ${i} anat/${newfilename}${extension}
    done

    #UNfiltered T1 images --
    for i in $(ls -f ${subj}_3D_T1* ); do
        file=`echo ${i} | awk -F/ '{ print $1 }'`
        echo ${file}
        oldname=`echo "$file" | cut -d'.' -f1`
        extension=`echo "$file" | cut -d'.' -f2`
        newfilename=sub-${subj}_T1w.
        cp ${i} anat/${newfilename}${extension}
    done

    #pure filtered T2 images -- pureT1files=$(ls -f *PU_Sag_CUBE_T2* )
    for i in $(ls -f ${subj}_Sag_CUBE_T2* ); do
        file=`echo ${i} | awk -F/ '{ print $1 }'`
        echo ${file}
        oldname=`echo "$file" | cut -d'.' -f1`
        extension=`echo "$file" | cut -d'.' -f2`
        newfilename=sub-${subj}_T2w.
        cp ${i} anat/${newfilename}${extension}
    done

    #### Task: WRG BOLD Organization & Renaming ####
    mkdir func
    for i in $(ls -f ${subj}_BOLD_?.* ); do
        file=`echo ${i} | awk -F/ '{ print $1 }'`
        echo ${file}
        oldname=`echo "$file" | cut -d'.' -f1`
        extension=`echo "$file" | cut -d'.' -f2`
        newfilename=sub-${subj}_task-wrg_run-
        runnum=`echo "$oldname" | cut -c11`
        cp ${i} func/${newfilename}${runnum}_bold.${extension}
    done

    #### Task: IAPS viewing BOLD
    for i in $(ls -f ${subj}_IAPS_?.* ); do
        file=`echo ${i} | awk -F/ '{ print $1 }'`
        echo ${file}
        oldname=`echo "$file" | cut -d'.' -f1`
        extension=`echo "$file" | cut -d'.' -f2`
        newfilename=sub-${subj}_task-iaps_run-
        runnum=`echo "$oldname" | cut -c11`
        cp ${i} func/${newfilename}${runnum}_bold.${extension}
    done

    #### Localizer Organization & Renaming ####
    mkdir localizer
    for i in $(ls -f ${subj}_3Plane_Loc_*.* ); do
        file=`echo ${i} | awk -F/ '{ print $1 }'`
        echo ${file}
        oldname=`echo "$file" | cut -d'.' -f1`
        extension=`echo "$file" | cut -d'.' -f2`
        newfilename=sub-${subj}_1
        runnum=`echo "$oldname" | cut -c22`
        cp ${i} localizer/${newfilename}${runnum}.${extension}
    done

    #### Fieldmaps Organization & Renaming #### sub-5XXX_dir-ap_run-1_epi.json
    ##be careful if there are multiple runs.....slash if "run 1" is accurate...
    mkdir fmap
    for i in $(ls -f ${subj}*Field-Maps* ); do
        file=`echo ${i} | awk -F/ '{ print $1 }'`
        echo ${file}
        oldname=`echo "$file" | cut -d'.' -f1`
        extension=`echo "$file" | cut -d'.' -f2`
        newfilename=sub-${subj}_dir-
        direction=`echo "$oldname" | cut -c24,25 | tr '[:upper:]' '[:lower:]'`
        cp ${i} fmap/${newfilename}${direction}_run-1_epi.${extension}
    done

    #### Calibration Organization & Renaming ####
    mkdir calibration
    for i in $(ls -f ${subj}_ASSET_* ); do
        file=`echo ${i} | awk -F/ '{ print $1 }'`
        
        oldname=`echo "$file" | cut -d'.' -f1`
        extension=`echo "$file" | cut -d'.' -f2`
        newfilename=sub-${subj}_calibration
        cp ${i} calibration/${newfilename}.${extension}
    done

    ####list the sub's directories for confirmation
    ls -d


done
