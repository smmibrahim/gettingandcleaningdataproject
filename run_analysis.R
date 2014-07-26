#This R file takes a raw data set dealing with Human Activity Recognition using
#Smartphones and provides a tidy data set for analysis.
#Most commands use the base packages provided with R
#In addition the reshape2 package is used to melt and dcast the final data
library("reshape2", lib.loc="C:/Users/pc2/Documents/R/win-library/3.1")
#The data is first read into several dataframes using the read.table command
#There were two sets of data - test and training and the same measurements were
#available for both sets of data. For each, there were three data sets - one 
# for various measures, these files begin with X, one for activities - these
#files begin with y and a third identifying the subject id - fittingly starting
#subject. Two additional files, one for identifying the column variables in the X file
# and the other for the list of descriptive values used for the activity id in file y.
samsung_test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
samsung_test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
samsung_test_X <- read.table("./UCI HAR Dataset/test/X_test.txt")
samsung_train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
samsung_train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
samsung_train_X <- read.table("./UCI HAR Dataset/train/X_train.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features_names <- read.table("./UCI HAR Dataset/features.txt")
#After reading all the files into several data.frames as listed above, the column
#names for the main three files for each set - train and test, were set using
#the colnames command.
colnames(samsung_test_X) <- features_names$V2
colnames(samsung_train_X) <- features_names$V2
colnames(samsung_test_y)[1] <- "activity"
colnames(samsung_train_y)[1] <- "activity"
colnames(samsung_test_subject)[1] <- "subjectid"
colnames(samsung_train_subject)[1] <- "subjectid"
#All the three data frames for either test or train consisted of the same
#numebr of rows.
#Hence the three data frames were combined into one data frame using cbind
samsung_test <- cbind(samsung_test_subject,samsung_test_y,samsung_test_X)
samsung_train <- cbind(samsung_train_subject,samsung_train_y,samsung_train_X)
#After combining all three data frames for both test and train, they now became 
#two data frames, one for test and another for train. They were now combined
#as they contained the same number of columns.
samsung <- rbind(samsung_test,samsung_train)
#For the assignment only a few measure variables were requried. The next five
#lines determine the commands that were used to extract only the relevant 
#variables
features <- colnames(samsung_test)
varsforprojectassignment <- grep("subjectid|activity|[Mm]ean|[Ss]td",features,value=TRUE)
samsung_mean_std <- samsung[,varsforprojectassignment]
testmerge <- merge(samsung_mean_std,activity_labels,by.x="activity",by.y="V1")
testmerge$activity <- NULL
#Most of the column names were not suitable for analysis as they contained
#special characters not acceptable to analytical tools like melt and dcast
#Also modifications were made to make the columns human readable.
colnames(testmerge)[88] <- "activity"
colnames(testmerge)[81] <- "angle(tBodyAccMean,gravityMean)"
samsung_col_names <- colnames(testmerge)
samsung_col_names <- gsub("^t","Time",samsung_col_names)
samsung_col_names <- gsub("-mean","-Mean",samsung_col_names)
samsung_col_names <- gsub("-std","-Std",samsung_col_names)
samsung_col_names <- gsub("BodyBody","Body",samsung_col_names)
samsung_col_names <- gsub("\\(t","Between",samsung_col_names)
samsung_col_names[81] <- sub(",","And",samsung_col_names[81])
samsung_col_names[82] <- sub("),","And",samsung_col_names[82])
samsung_col_names[83] <- sub(",","And",samsung_col_names[83])
samsung_col_names[84] <- sub(",","And",samsung_col_names[84])
samsung_col_names[85] <- sub(",","And",samsung_col_names[85])
samsung_col_names[86] <- sub(",","And",samsung_col_names[86])
samsung_col_names[87] <- sub(",","And",samsung_col_names[87])
samsung_col_names <- gsub("Andg","AndG",samsung_col_names)
samsung_col_names <- gsub("-","",samsung_col_names)
samsung_col_names[85] <- sub("\\(","Between",samsung_col_names[85])
samsung_col_names[86] <- sub("\\(","Between",samsung_col_names[86])
samsung_col_names[87] <- sub("\\(","Between",samsung_col_names[87])
samsung_col_names <- gsub(")","",samsung_col_names)
samsung_col_names <- gsub("\\(","",samsung_col_names)
samsung_col_names <- gsub("^a","A",samsung_col_names)
samsung_col_names[1] <- "SubjectId"
colnames(testmerge) <- samsung_col_names
#Once the column names had been cleaned up, the melt operation followed by the 
#dcast oepration was used to get tidy data - the tidy data, each column being 
#a variable and each row being an observation. All the observations are average
#values for each variable across each activity and subject.
measurecolnames <- samsung_col_names[c(-1,-88)]
melttestmerge <- melt(testmerge, id.vars=c(88,1), measure.vars=measurecolnames)
dcastmelttestmerge <- dcast(melttestmerge,Activity + SubjectId ~ variable, mean)
#The resulting data.frame was written to a text file.
write.table(dcastmelttestmerge,"HCRActivityWithSmartphone.txt",col.names=TRUE)