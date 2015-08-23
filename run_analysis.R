Names <- read.table("UCI HAR Dataset/features.txt")
Labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

TrainData1 <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
TrainData2 <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
TrainData3 <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

TestData1 <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
TestData2 <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
TestData3 <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

subjectData <- rbind(TrainData1, TestData1)
activityData <- rbind(TrainData2, TestData2)
featuresData <- rbind(TrainData3, TestData3)

colnames(featuresData) <- t(Names[2])
names(subjectData) <- "Subject"
names(activityData) <- "Activity"
MergeData <- cbind(featuresData,activityData,subjectData)

MeanandStd <- grep(".*Mean.*|.*Std.*", names(MergeData), ignore.case=TRUE)
columnIndices <- c(MeanandStd, 562, 563)
FinalData <- MergeData[,columnIndices]


FinalData$Activity <- as.character(FinalData$Activity)
for (i in 1:6){
  FinalData$Activity[FinalData$Activity == i] <- as.character(Labels[i,2])
}

FinalData$Activity <- as.factor(FinalData$Activity)

names(FinalData)<-gsub("Acc", "Accelerometer", names(FinalData))
names(FinalData)<-gsub("Gyro", "Gyroscope", names(FinalData))
names(FinalData)<-gsub("BodyBody", "Body", names(FinalData))
names(FinalData)<-gsub("Mag", "Magnitude", names(FinalData))
names(FinalData)<-gsub("^t", "Time", names(FinalData))
names(FinalData)<-gsub("^f", "Frequency", names(FinalData))
names(FinalData)<-gsub("tBody", "TimeBody", names(FinalData))
names(FinalData)<-gsub("-mean()", "Mean", names(FinalData), ignore.case = TRUE)
names(FinalData)<-gsub("-std()", "STD", names(FinalData), ignore.case = TRUE)
names(FinalData)<-gsub("-freq()", "Frequency", names(FinalData), ignore.case = TRUE)
names(FinalData)<-gsub("angle", "Angle", names(FinalData))
names(FinalData)<-gsub("gravity", "Gravity", names(FinalData))



FinalTidyData <- aggregate(. ~Subject + Activity, FinalData, mean)
FinalTidyData <- FinalTidyData[order(FinalTidyData$Subject,FinalTidyData$Activity),]
write.table(FinalTidyData, file = "Tidy_Data.txt", row.names = FALSE)

