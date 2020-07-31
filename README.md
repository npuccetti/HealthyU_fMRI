# HealthyU_fMRI

This respository is to document and share the work that is done on the HealthyU Worry and Rumination fMRI project. The primary purpose of the README is to index each of the scripts with a brief summary of their purpose. The scripts are numbered by the order in which they were executed. A corollary set of scripts involving the behavioral responses from the scan as well as the Worry and Rumination survey will be included and tagged as "bhvr_#.scriptname". More information can/will be added to the README as needed.

## Script index 

0.tarUnzip.sh -unzips all of the tar files 

~~1.dcm2nii.sh -see description below 
1.dcm2niix.bids -two versions of dcm to nifti converters, currently not needed as its built into the 3.BIDSreorg script~~

~~2.makeDir.mvNii.sh -moves the converted niftis to the folder for bids, currently not needed as its built into 3.BIDSreorg~~

3.BIDSreorg.sh -replaces scripts 1 & 2 and converts the dcms to nii with .json sidecars. Also renames and creates org structure necesary for BIDS (last updated 5.26.20) 

4.prePrep_cleanup.sh -some miscellanneous cleaning that had to happen before fmriprep could run. Namely, renaming old task files (bold and fmaps), removing unnecessary niis, and moving non-bids files into a new extra_data file. I would recommend that this file be opened up and the relevant for loop be copy/pasted; its highly idosynchratic so blind rerunning is probably not helpful. Still, it documents the step taken to prepare this data for fmriprep. Also now edits all bold .json files to "PhaseEncodingDirection" (last updated 6.23.20)

5.batch.fmriprep.sh -file to batch process the subjects in fmriprep (5301-5307 as of 6.23.20, 5310-5320 starting 6.24.20)

6.WriteEventTSVs.R -script to create the BIDS format by sub/by run event .tsv files (date )

7.TSVtoTXTtimingfiles.R -script to draw out the AFNI-formatted condition text files to feed to 3dDeconvolve as "stim_times" (date)

8.fMRIprepMotionto1D.R -script for the first step in converting the fmriprep motion output into .1D files for AFNI; including the "censored" TRs to be thrown out (7.29.20 I believe this was updated)

9.1DprepTcatSmoothing.sh -this is a sort of hodge-podge of commands to get 1) the derivatives motion files, 2) the first 15 TRs chopped off of the BOLD runs and, 3) some smoothing for the GLM which is NOT done in fmriprep

~~10.3dDeconvolve.sh -a script for our basic GLM on one subject; more for demonstration purposes as the scripts is incomplete/differs from the final GLM that we run on everyone; AKA this is DECOMISSIONED and should not be used~~

10.5.batchGLM73120.sh -a subject loop throught the complete GLM (mask, motion, and contrasts are updated/confirmed; 9 conditions W/R/N and feeling and intensity ratings for each.
