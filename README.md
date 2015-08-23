# Getting-Cleaning-Data
Repo created for getting and cleaning data course work

### Download the data required for this project from the below link
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
unzip the contents in the R working directory

### As the training, subject, lable data are present in different files, read the data into R using the below commands
Names <- read.table("UCI HAR Dataset/features.txt")
Labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

TrainData1 <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
TrainData2 <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
TrainData3 <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

TestData1 <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
TestData2 <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
TestData3 <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

### Merge the training and subject data

subjectData <- rbind(TrainData1, TestData1)
activityData <- rbind(TrainData2, TestData2)
featuresData <- rbind(TrainData3, TestData3)

###change the column names and bind the data frames achieved in the previous steps

colnames(featuresData) <- t(Names[2])
names(subjectData) <- "Subject"
names(activityData) <- "Activity"
MergeData <- cbind(featuresData,activityData,subjectData)

###get the columns of mean, standard deviation, activity and subject

MeanandStd <- grep(".*Mean.*|.*Std.*", names(MergeData), ignore.case=TRUE)
columnIndices <- c(MeanandStd, 562, 563)
FinalData <- MergeData[,columnIndices]

## change the lables of activities as in the activity_labels txt
FinalData$Activity <- as.character(FinalData$Activity)
for (i in 1:6){
  FinalData$Activity[FinalData$Activity == i] <- as.character(Labels[i,2])
}

###change the data type of activity as factor variable

FinalData$Activity <- as.factor(FinalData$Activity)

###change the names of column names into meaningful names

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

### calculate the mean of each variable grouped by subject and activity. this step creates a text file name "Tidy_Data.txt"     in your R working directory

FinalTidyData <- aggregate(. ~Subject + Activity, FinalData, mean)
FinalTidyData <- FinalTidyData[order(FinalTidyData$Subject,FinalTidyData$Activity),]
write.table(FinalTidyData, file = "Tidy_Data.txt", row.names = FALSE)



