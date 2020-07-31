#Script to write the motion 1D files for afni (part 1)

subdirs <- list.dirs(path = "/deep/heller/work/Healthyu/bids/derivatives/fmriprep/fmriprep", recursive = FALSE)
####create a loop through the subject directories in the 'bids' folder
###### start loop at 2 to skip 'derivatives'
subsum <- as.data.frame(matrix(NA, nrow = (39), ncol = 7))
colnames(subsum) <- c("avgXtr","avgYtr","avgZtr", "avgXrot","avgYrot","avgZrot","numTRcensor")

for (i in 2:10){ #2-10 is worry, 11-40 is wrg
  
    subject <- substr(subdirs[i], 67,70)
    thissubdir <- subdirs[i]
    setwd(thissubdir)
    setwd('func')
    
    regressfiles <- list.files(pattern = ".+worry.+_desc-confounds_regressors.tsv", recursive = FALSE)
    #regressfiles <- list.files(pattern = ".+wrg.+_desc-confounds_regressors.tsv", recursive = FALSE)
    
    #Df to hold all of the subs motion across 5 runs
    allMotion <- as.data.frame(matrix(NA, nrow = (193*5), ncol = 7))
    colnames(allMotion) <- c("trans_x","trans_y","trans_z","rot_x","rot_y","rot_z","outliers")
    
    for (jj in 1:5) {
      motion <- read.table(regressfiles[jj], header = T)
      
      #concat 6 standard params
      TrRot <- as.data.frame(cbind(motion$trans_x, motion$trans_y, motion$trans_z, motion$rot_x, motion$rot_y, motion$rot_z))
      TrRot$outlier <- NA
      #are there outlier variables and if so which colums??
      outlier <- grep("outlier", names(motion))
      
      if (length(outlier) == 0 ){  #if there are no outlier variables, 
          TrRot$outlier <- 0 #then set the outlier variable to ALL 0's with no 1's
          
        } else if (length(outlier) == 1 ){ #if there is just one outlier variable,
          TrRot$outlier <- (motion[,outlier]) #simply move the 0's and 1's to the new variable 
           #TrRot$outlier <- singleoutlier
        } else if (length(outlier) > 1 ){ #if there are more than one outlier variables,
          outlierdf <- motion[grep("outlier", names(motion))] #sum them first
          outlierdf$sums <- rowSums(outlierdf)
          TrRot$outlier <- outlierdf$sums #then move the new 0's and 1's variable 
        }
      
        empties <- which(is.na(allMotion$trans_x))
        firstempty <- empties[1]
        allMotion[c(firstempty:(firstempty+192)),c(1:7)] <- TrRot[c(16:208),c(1:7)]
        
    } #close the jj run loop
    
    #converting the radians from fmriprep to degrees for afni
    allMotion[,4] <- allMotion[,4]*57.3
    allMotion[,5] <- allMotion[,5]*57.3
    allMotion[,6] <- allMotion[,6]*57.3
    
    #swap the values for the censoring
    allMotion$outliers <- ifelse(allMotion$outliers == 0, 1, 0)  
    
    #filling summary table
    # row = (i-1)
    # subsum[row,1] <- mean(allMotion[,1], na.rm = T)
    # subsum[row,2] <- mean(allMotion[,2], na.rm = T)
    # subsum[row,3] <- mean(allMotion[,3], na.rm = T)
    # subsum[row,4] <- mean(allMotion[,4], na.rm = T)
    # subsum[row,5] <- mean(allMotion[,5], na.rm = T)
    # subsum[row,6] <- mean(allMotion[,6], na.rm = T)
    # subsum[row,7] <- tally(allMotion[,7] , na.rm = T)
    
    #write out the motion and squared motion files that will need addition -deriv processing
    filename <- paste("sub-",subject, "_motion.1D",sep = "")
    write.table(allMotion, filename, append = FALSE, dec = ".", row.names = FALSE, col.names = FALSE)
    
    allMotion_sqrd <- allMotion^2
    
    filename <- paste("sub-",subject, "_motion_sqrd.1D",sep = "")
    write.table(allMotion_sqrd, filename, append = FALSE, dec = ".", row.names = FALSE, col.names = FALSE)
    
    
} #close the i subject loop

subsum$percentCensor <- (subsum$numTRcensor/965)
#write.csv(subsum, "/deep/heller/work/Healthyu/datafiles/motionsummary_72720.csv")


