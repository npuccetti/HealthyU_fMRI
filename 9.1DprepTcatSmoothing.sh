#!/bin/sh

####Defining pathways
echo "Step 1: Defining pathways"
prepr=/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep


###Loop through each subject
echo "Step 2: Loop through all subjects"
cd /deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/
for i in $( ls -d sub-5??? ); do
      subject=`echo ${i} | awk -F/ '{ print $1 }'`
      #subj=`echo ${subject} | cut -c9,10,11,12`

      cd /deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/${subject}/func

      if [ -f ${subject}_task-wrg_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz ]; then

          echo "using WRG scans, removing the first 15 TRs of dead scan for ${subject}..."
          3dTcat -prefix ${subject}_task-wrg_run-1_MNI_preproc_tcat.nii -verb ${subject}_task-wrg_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold.nii[15..$]
          3dTcat -prefix ${subject}_task-wrg_run-2_MNI_preproc_tcat.nii -verb ${subject}_task-wrg_run-2_space-MNI152NLin2009cAsym_desc-preproc_bold.nii[15..$]
          3dTcat -prefix ${subject}_task-wrg_run-3_MNI_preproc_tcat.nii -verb ${subject}_task-wrg_run-3_space-MNI152NLin2009cAsym_desc-preproc_bold.nii[15..$]
          3dTcat -prefix ${subject}_task-wrg_run-4_MNI_preproc_tcat.nii -verb ${subject}_task-wrg_run-4_space-MNI152NLin2009cAsym_desc-preproc_bold.nii[15..$]
          3dTcat -prefix ${subject}_task-wrg_run-5_MNI_preproc_tcat.nii -verb ${subject}_task-wrg_run-5_space-MNI152NLin2009cAsym_desc-preproc_bold.nii[15..$]
      fi

      if [ -f ${subject}_task-worryrum_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz ]; then

          echo "using worryrum scans, removing the first 15 TRs of dead scan for ${subject}..."
          3dTcat -prefix ${subject}_task-wrg_run-1_MNI_preproc_tcat.nii -verb ${subject}_task-worryrum_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz[15..$]
          3dTcat -prefix ${subject}_task-wrg_run-2_MNI_preproc_tcat.nii -verb ${subject}_task-worryrum_run-2_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz[15..$]
          3dTcat -prefix ${subject}_task-wrg_run-3_MNI_preproc_tcat.nii -verb ${subject}_task-worryrum_run-3_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz[15..$]
          3dTcat -prefix ${subject}_task-wrg_run-4_MNI_preproc_tcat.nii -verb ${subject}_task-worryrum_run-4_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz[15..$]
          3dTcat -prefix ${subject}_task-wrg_run-5_MNI_preproc_tcat.nii -verb ${subject}_task-worryrum_run-5_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz[15..$]
      fi
    
      echo "Smoothing the epi runs for ${subject}..."

	3dBlurToFWHM -FWHM 6 -prefix ${subject}_task-wrg_run-1_MNI_preproc_tcat_smooth.nii -input ${subject}_task-wrg_run-1_MNI_preproc_tcat.nii
      3dBlurToFWHM -FWHM 6 -prefix ${subject}_task-wrg_run-2_MNI_preproc_tcat_smooth.nii -input ${subject}_task-wrg_run-2_MNI_preproc_tcat.nii
      3dBlurToFWHM -FWHM 6 -prefix ${subject}_task-wrg_run-3_MNI_preproc_tcat_smooth.nii -input ${subject}_task-wrg_run-3_MNI_preproc_tcat.nii
      3dBlurToFWHM -FWHM 6 -prefix ${subject}_task-wrg_run-4_MNI_preproc_tcat_smooth.nii -input ${subject}_task-wrg_run-4_MNI_preproc_tcat.nii
      3dBlurToFWHM -FWHM 6 -prefix ${subject}_task-wrg_run-5_MNI_preproc_tcat_smooth.nii -input ${subject}_task-wrg_run-5_MNI_preproc_tcat.nii

      echo "Creating the motion derivative files for ${subject}..."
      1d_tool.py \
      -infile ${subject}_motion.1D \
      -set_nruns 5 \
      -derivative \
      -overwrite
      -write ${subject}_motion_deriv.1D

      1d_tool.py \
      -infile ${subject}_motion_sqrd.1D \
      -set_nruns 5 \
      -derivative \
      -overwrite
      -write ${subject}_motion_deriv_sqrd.1D

done #close subject loop
