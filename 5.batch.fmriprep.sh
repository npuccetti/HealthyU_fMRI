#!/bin/sh

#fmriprep command to run on a chunk of the fall subjects 
fmriprep-docker /deep/heller/work/Healthyu/bids /var/run/user/21513/fmriprep/ participant --participant-label sub-5331 sub-5332 sub-5333 sub-5334 sub-5335 sub-5336 sub-5338 --fs-license-file /usr/local/freesurfer/6.0.0/license.txt 


