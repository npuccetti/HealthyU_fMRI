####this will store a list of all of the subject folders & set root
subdirs <- list.dirs(path = "/deep/heller/work/Healthyu/bids", recursive = FALSE)

####load in the larger event file
allevents <- read.csv("/deep/heller/work/Healthyu/datafiles/EventTimingData_long_EM.csv") 

####create a loop through the subject directories in the 'bids' folder
###### start loop at 2 to skip 'derivatives'
for (i in 2:length(subdirs)){
  
  subject <- substr(subdirs[i], 37,41)
  thissubdir <- subdirs[i]
  
  ####Put times into seconds
  subevents <- subset(allevents, allevents$Subject == subject)
  subevents$B1.WaitScanner.OffsetTime <- subevents$B1.WaitScanner.OffsetTime/1000
  subevents$B2.WaitScanner1.OffsetTime <-subevents$B2.WaitScanner1.OffsetTime/1000
  subevents$B3.WaitScanner2.OffsetTime <- subevents$B3.WaitScanner2.OffsetTime/1000
  subevents$B4.WaitScanner3.OffsetTime <- subevents$B4.WaitScanner3.OffsetTime/1000
  subevents$B5.WaitScanner4.OffsetTime <- subevents$B5.WaitScanner4.OffsetTime/1000
  subevents$OnsetTime <- subevents$OnsetTime/1000
  subevents$Duration <- subevents$Duration/1000
  
  ####Make block variable a single number
  subevents$Block <- substr(subevents$Block,6,6)
  
  ####remove wait scanner variables
  subevents <- subevents[-c(2:6)]
  
  ####identify subject's run files 
  funcpath <- paste(thissubdir,"/func", sep = "")
  ####listing all files that contain 'wrg' and '.nii' to grab only the runs we need
  runfiles <- list.files(path = funcpath, pattern = ".+wrg.+.nii", recursive = FALSE)
  
  for (j in 1:length(runfiles)){
  runnum <- substr(runfiles[j], 23,23)
  runevents <- subset(subevents, subevents$Block == runnum)
  
  runevents$onset <- runevents$OnsetTime
  runevents$duration <- runevents$Duration  
  runevents <- runevents[c(21,22,1:11,14:20)]

  runfilename <- paste(funcpath,"/", substr(runfiles[j], 1,23),"_events.tsv", sep = "")
  write.table(runevents, file = runfilename, sep="\t", quote = F, row.names = F)
 
  
  } #closed the run loop
  
} # closing the subject loop  
