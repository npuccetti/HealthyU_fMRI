####this will store a list of all of the subject folders & set root
subdirs <- list.dirs(path = "/deep/heller/work/Healthyu/bids", recursive = FALSE)

####loop through subject directories
for (i in 2:length(subdirs)){
  
  subject <- substr(subdirs[i], 37,41)
  thissubdir <- subdirs[i]
  
  #this will grab any relevant .tsv stimfiles (theyre in the /func dir but this searches all of the subjects subdirectories)
  stimfiles <- list.files(path = thissubdir, pattern = "_events.tsv", recursive = TRUE,
                          ignore.case = FALSE, include.dirs = FALSE)
  
  ####create empty matrices to store data 
  # this will be changed for HU to reflect our 9 conditions, still with 5 rows but the number of columns (aka number of stimuli of that type per run) will change - 4 per worry rum and 3 per neutrals
  worry_stim <- matrix(NA, nrow = 5, ncol = 4)
  rum_stim <- matrix(NA, nrow = 5, ncol = 4)
  neutral_stim <- matrix(NA, nrow = 5, ncol = 3)
  worry_feel_stim <- matrix(NA, nrow = 5, ncol = 4)
  rum_feel_stim <- matrix(NA, nrow = 5, ncol = 4)
  neutral_feel_stim <- matrix(NA, nrow = 5, ncol = 3)
  worry_int_stim <- matrix(NA, nrow = 5, ncol = 4)
  rum_int_stim <- matrix(NA, nrow = 5, ncol = 4)
  neutral_int_stim <- matrix(NA, nrow = 5, ncol = 3)
 
  #create a loop for each of the runs
  for (jj in 1:5) {
    filename <- paste(thissubdir,"/", stimfiles[jj], sep="")
    stimdat <- read.delim(file = filename, header = TRUE, sep = '\t', dec = ".")
    
    ####adjust timing of onset to reflect the first 15 TRs being dropped (the first 30 seconds)
    stimdat$onset <- (stimdat$onset - 30)
    
   #### separate the data into the condition categories
    worry.e <- subset(stimdat, stimdat$EventType == "worry" & stimdat$DataType == "EventDisplay") 
    rum.e <- subset(stimdat, stimdat$EventType == "rum" & stimdat$DataType == "EventDisplay") 
    neutral.e <- subset(stimdat, stimdat$EventType == "neutral" & stimdat$DataType == "EventDisplay") 
    worry.f <- subset(stimdat, stimdat$EventType == "worry" & stimdat$DataType == "FeelingRate") 
    rum.f <- subset(stimdat, stimdat$EventType == "rum" & stimdat$DataType == "FeelingRate")
    neutral.f <- subset(stimdat, stimdat$EventType == "neutral" & stimdat$DataType == "FeelingRate")
    worry.i <- subset(stimdat, stimdat$EventType == "worry" & stimdat$DataType == "IntensityRate")
    rum.i <- subset(stimdat, stimdat$EventType == "rum" & stimdat$DataType == "IntensityRate")
    neutral.i <- subset(stimdat, stimdat$EventType == "neutral" & stimdat$DataType == "IntensityRate")
    
    
    worry_stim[jj,1:4] <- t(worry.e[1])
    rum_stim[jj,1:4] <- t(rum.e[1])
    neutral_stim[jj,1:3] <- t(neutral.e[1])
    worry_feel_stim[jj,1:4] <- t(worry.f[1])
    rum_feel_stim[jj,1:4] <- t(rum.f[1])
    neutral_feel_stim[jj,1:3] <- t(neutral.f[1])
    worry_int_stim[jj,1:4] <- t(worry.i[1])
    rum_int_stim[jj,1:4] <- t(rum.i[1])
    neutral_int_stim[jj,1:3] <- t(neutral.i[1])
    
  } #close the "run" loop
  

  filepath <- paste("/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/sub-", subject,"/func/sub-", subject, "_stimtimes_WorryDis.txt", sep = "")
  write.table(worry_stim, filepath, append = FALSE, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE)
  
  filepath <- paste("/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/sub-", subject,"/func/sub-", subject, "_stimtimes_RumDis.txt", sep = "")
  write.table(rum_stim, filepath, append = FALSE, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE)
  
  filepath <- paste("/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/sub-", subject,"/func/sub-", subject, "_stimtimes_NeutralDis.txt", sep = "")
  write.table(neutral_stim, filepath, append = FALSE, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE)
  
  filepath <- paste("/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/sub-", subject,"/func/sub-", subject, "_stimtimes_WorryFeel.txt", sep = "")
  write.table(worry_feel_stim, filepath, append = FALSE, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE)
  
  filepath <- paste("/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/sub-", subject,"/func/sub-", subject, "_stimtimes_RumFeel.txt", sep = "")
  write.table(rum_feel_stim, filepath, append = FALSE, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE)
  
  filepath <- paste("/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/sub-", subject,"/func/sub-", subject, "_stimtimes_NeutralFeel.txt", sep = "")
  write.table(neutral_feel_stim, filepath, append = FALSE, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE)
  
  filepath <- paste("/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/sub-", subject,"/func/sub-", subject, "_stimtimes_WorryInt.txt", sep = "")
  write.table(worry_int_stim, filepath, append = FALSE, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE)
  
  filepath <- paste("/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/sub-", subject,"/func/sub-", subject, "_stimtimes_RumInt.txt", sep = "")
  write.table(rum_int_stim, filepath, append = FALSE, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE)
  
  filepath <- paste("/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep/sub-", subject,"/func/sub-", subject, "_stimtimes_NeutralInt.txt", sep = "")
  write.table(neutral_int_stim, filepath, append = FALSE, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE)
  
} #close the "subject" loop
    
