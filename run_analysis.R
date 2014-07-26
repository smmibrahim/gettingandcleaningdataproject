library("reshape2", lib.loc="C:/Users/pc2/Documents/R/win-library/3.1")
samsung_test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
samsung_test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
samsung_test_X <- read.table("./UCI HAR Dataset/test/X_test.txt")
samsung_train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
samsung_train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
samsung_train_X <- read.table("./UCI HAR Dataset/train/X_train.txt")
features_names <- read.table("./UCI HAR Dataset/features.txt")
colnames(samsung_test_X) <- features_names$V2
colnames(samsung_train_X) <- features_names$V2
colnames(samsung_test_y)[1] <- "activity"
colnames(samsung_train_y)[1] <- "activity"
colnames(samsung_test_subject)[1] <- "subjectid"
colnames(samsung_train_subject)[1] <- "subjectid"
samsung_test <- cbind(samsung_test_subject,samsung_test_y,samsung_test_X)
samsung_train <- cbind(samsung_train_subject,samsung_train_y,samsung_train_X)
samsung <- rbind(samsung_test,samsung_train)
features <- colnames(samsung_test)
varsforprojectassignment <- grep("subjectid|activity|[Mm]ean|[Ss]td",features,value=TRUE)
samsung_mean_std <- samsung[,varsforprojectassignment]
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
testmerge <- merge(samsung_mean_std,activity_labels,by.x="activity",by.y="V1")
testmerge$activity <- NULL
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
measurecolnames <- samsung_col_names[c(-1,-88)]
melttestmerge <- melt(testmerge, id.vars=c(88,1), measure.vars=measurecolnames)
dcastmelttestmerge <- dcast(melttestmerge,Activity + SubjectId ~ variable, mean)
write.table(dcastmelttestmerge,"HCRActivityWithSmartphone.txt",col.names=TRUE)