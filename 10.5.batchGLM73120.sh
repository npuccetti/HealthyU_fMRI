#!/bin/sh

BaseDir=/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep
cd ${BaseDir}

#Subject loop!
for i in $( ls -d sub-5??? ); do
      subject=`echo ${i} | awk -F/ '{ print $1 }'`
      #subj=`echo ${subject} | cut -c9,10,11,12`

 cd ${BaseDir}/${subject}
 mkdir analysis
 cd analysis
 mkdir GLM_73120
 cd GLM_73120

if [ ! -f GLM73120_func* ]; then
  echo "${subject}'s GLM not yet complete...starting now!"

 3dDeconvolve -input ${BaseDir}/${subject}/func/${subject}_task-wrg_run-*_MNI_preproc_tcat_smooth.nii  \
 -polort 2    \
 -mask ${BaseDir}/${subject}/func/${subject}_task-w*_run-1_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz \
 -censor ${BaseDir}/${subject}/func/${subject}_motion.1D'[6]' \
 -num_stimts 33                                                               \
 -stim_times 1 ${BaseDir}/${subject}/func/${subject}_stimtimes_WorryDis.txt 'SPMG3(16)' -stim_label 1 WorryDisplay        \
 -stim_times 2 ${BaseDir}/${subject}/func/${subject}_stimtimes_WorryFeel.txt 'SPMG3(3)' -stim_label 2 WorryFeelRate        \
 -stim_times 3 ${BaseDir}/${subject}/func/${subject}_stimtimes_WorryInt.txt 'SPMG3(3)' -stim_label 3 WorryIntRate        \
 -stim_times 4 ${BaseDir}/${subject}/func/${subject}_stimtimes_RumDis.txt 'SPMG3(16)' -stim_label 4 RumDisplay    \
 -stim_times 5 ${BaseDir}/${subject}/func/${subject}_stimtimes_RumFeel.txt 'SPMG3(3)' -stim_label 5 RumFeelRate    \
 -stim_times 6 ${BaseDir}/${subject}/func/${subject}_stimtimes_RumInt.txt 'SPMG3(3)' -stim_label 6 RumIntRate    \
 -stim_times 7 ${BaseDir}/${subject}/func/${subject}_stimtimes_NeutralDis.txt 'SPMG3(16)' -stim_label 7 NeutralDisplay   \
 -stim_times 8 ${BaseDir}/${subject}/func/${subject}_stimtimes_NeutralFeel.txt 'SPMG3(3)' -stim_label 8 NeutralFeelRate     \
 -stim_times 9 ${BaseDir}/${subject}/func/${subject}_stimtimes_NeutralInt.txt 'SPMG3(3)' -stim_label 9 NeutralIntRate  \
 -stim_file 10 ${BaseDir}/${subject}/func/${subject}_motion.1D'[0]' -stim_base 10 -stim_label 10 trans_X      \
 -stim_file 11 ${BaseDir}/${subject}/func/${subject}_motion.1D'[1]' -stim_base 11 -stim_label 11 trans_Y     \
 -stim_file 12 ${BaseDir}/${subject}/func/${subject}_motion.1D'[2]' -stim_base 12 -stim_label 12 trans_Z       \
 -stim_file 13 ${BaseDir}/${subject}/func/${subject}_motion.1D'[3]' -stim_base 13 -stim_label 13 roll        \
 -stim_file 14 ${BaseDir}/${subject}/func/${subject}_motion.1D'[4]' -stim_base 14 -stim_label 14 pitch        \
 -stim_file 15 ${BaseDir}/${subject}/func/${subject}_motion.1D'[5]' -stim_base 15 -stim_label 15 yaw        \
 -stim_file 16 ${BaseDir}/${subject}/func/${subject}_motion_deriv.1D'[0]' -stim_base 16 -stim_label 16 drv_trans_X     \
 -stim_file 17 ${BaseDir}/${subject}/func/${subject}_motion_deriv.1D'[1]' -stim_base 17 -stim_label 17 drv_trans_Y     \
 -stim_file 18 ${BaseDir}/${subject}/func/${subject}_motion_deriv.1D'[2]' -stim_base 18 -stim_label 18 drv_trans_Z       \
 -stim_file 19 ${BaseDir}/${subject}/func/${subject}_motion_deriv.1D'[3]' -stim_base 19 -stim_label 19 drv_roll        \
 -stim_file 20 ${BaseDir}/${subject}/func/${subject}_motion_deriv.1D'[4]' -stim_base 20 -stim_label 20 drv_pitch        \
 -stim_file 21 ${BaseDir}/${subject}/func/${subject}_motion_deriv.1D'[5]' -stim_base 21 -stim_label 21 drv_yaw        \
 -stim_file 22 ${BaseDir}/${subject}/func/${subject}_motion_sqrd.1D'[0]' -stim_base 22 -stim_label 22 sq_trans_X      \
 -stim_file 23 ${BaseDir}/${subject}/func/${subject}_motion_sqrd.1D'[1]' -stim_base 23 -stim_label 23 sq_trans_Y     \
 -stim_file 24 ${BaseDir}/${subject}/func/${subject}_motion_sqrd.1D'[2]' -stim_base 24 -stim_label 24 sq_trans_Z        \
 -stim_file 25 ${BaseDir}/${subject}/func/${subject}_motion_sqrd.1D'[3]' -stim_base 25 -stim_label 25 sq_roll        \
 -stim_file 26 ${BaseDir}/${subject}/func/${subject}_motion_sqrd.1D'[4]' -stim_base 26 -stim_label 26 sq_pitch        \
 -stim_file 27 ${BaseDir}/${subject}/func/${subject}_motion_sqrd.1D'[5]'  -stim_base 27 -stim_label 27 sq_yaw        \
 -stim_file 28 ${BaseDir}/${subject}/func/${subject}_motion_deriv_sqrd.1D'[0]' -stim_base 28 -stim_label 28 sqdrv_trans_X      \
 -stim_file 29 ${BaseDir}/${subject}/func/${subject}_motion_deriv_sqrd.1D'[1]' -stim_base 29 -stim_label 29 sqdrv_trans_Y      \
 -stim_file 30 ${BaseDir}/${subject}/func/${subject}_motion_deriv_sqrd.1D'[2]' -stim_base 30 -stim_label 30 sqdrv_trans_Z        \
 -stim_file 31 ${BaseDir}/${subject}/func/${subject}_motion_deriv_sqrd.1D'[3]' -stim_base 31 -stim_label 31 sqdrv_roll       \
 -stim_file 32 ${BaseDir}/${subject}/func/${subject}_motion_deriv_sqrd.1D'[4]' -stim_base 32 -stim_label 32 sqdrv_pitch       \
 -stim_file 33 ${BaseDir}/${subject}/func/${subject}_motion_deriv_sqrd.1D'[5]'  -stim_base 33 -stim_label 33 sqdrv_yaw       \
 -gltsym 'SYM: WorryDisplay -RumDisplay' -glt_label 1 W-R                       \
 -gltsym 'SYM: WorryDisplay -NeutralDisplay' -glt_label 2 W-N                       \
 -gltsym 'SYM: RumDisplay -NeutralDisplay' -glt_label 3 R-N                       \
 -gltsym 'SYM: WorryFeelRate -NeutralFeelRate' -glt_label 4 Wf-Nf               \
 -gltsym 'SYM: RumFeelRate -NeutralFeelRate' -glt_label 5 Rf-Nf              \
 -gltsym 'SYM: +0.5*WorryDisplay +0.5*RumDisplay' -glt_label 6 W+R \
 -gltsym 'SYM: +0.5*WorryDisplay +0.5*RumDisplay -NeutralDisplay' -glt_label 7 W+R-N \
 -tout -x1D GLM73120.xmat.1D -xjpeg GLM73120_X.jpg                     \
 -fitts GLM73120_fitts -bucket GLM73120_func                             \
 -jobs 4

fi

done #close the subject loop
