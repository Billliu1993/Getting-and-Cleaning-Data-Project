## The dataset has been downloaded from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## The dataset has been unzipped into the working directory

## First, reading the data
# Reading the training data
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
trainY <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
# Reading the test data
testX <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
testY <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
# Reading the feature data
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
# Reading the activity labels data
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

## Second, assigning the column names
# Assigning column names to the training data
colnames(trainX) <- features[, 2]
colnames(trainY) <- "activityID"
colnames(trainSubject) <- "subjectID"
# Assigning column names to the test data
colnames(testX) <- features[, 2]
colnames(testY) <- "activityID"
colnames(testSubject) <- "subjectID"
# Assigning column names to the activity labels
colnames(activityLabels) <- c("activityID", "activityType")

## Third, merging the training and test data
# Creating individual data table for training and test data
trainDT <- cbind(trainY, trainSubject, trainX)
testDT <- cbind(testY, testSubject, testX)
# Combing these two data tables
train_test_DT <- rbind(trainDT, testDT)

## Fourth, extracting the mean and standard deviation for each measurement
# Subsetting the mean and standard deviation data with the corresponding activity and subject ID
col_names <- colnames(train_test_DT)
mean_std <- (grepl("activityID", col_names) | grepl("subjectID", col_names) | grepl("mean..", col_names) |grepl("std..", col_names))
mean_std_set <- train_test_DT[, mean_std == TRUE]

## Fifth, adding descriptive activity names to the activities in the data set
mean_std_set_withActivityName <- merge(mean_std_set, activityLabels, by = "activityID", all.x = TRUE)

## Finally, creating a second, independent tidy data set with the average of each variable for each activity and each subject
# Generating tidy data with the average of each values and ordering based upon subject and activity ID
tidyData <- aggregate(. ~subjectID + activityID, mean_std_set_withActivityName, mean)
tidyData <- tidyData[order(tidyData$subjectID,tidyData$activityID),]
# Exporting the tidy data into a text file
write.table(tidyData, "tidyData.txt", row.name=FALSE)

