# Load data sets

setwd("C:/Users/fhol/Documents/data/UCI HAR Dataset")

if (!file.exists("UCI HAR Dataset")){
  dir.create("./UCI HAR Dataset")
}

features <- read.table('features.txt')
activity_labels <- read.table('activity_labels.txt')

subject_train <- read.table('train/subject_train.txt')
x_train <- read.table('train/X_train.txt')
y_train_labels <- read.table('train/y_train.txt')

subject_test <- read.table('test/subject_test.txt')
x_test <- read.table('test/X_test.txt')
y_test_labels <- read.table('test/y_test.txt')



# Merges the training and the test sets to create one data set.
traindata <- cbind(subject_train, y_train_labels, x_train)
testdata <- cbind(subject_test, y_test_labels, x_test)

mergeddata <- rbind(traindata, testdata)

# Appropriately labels the data set with descriptive variable names.
features.names <- as.character(features[,2])
colnames(mergeddata) <- c("subject", "activity", features.names)


# Extracts only the measurements on the mean and standard deviation for each measurement.
a <- mergeddata[,c(1:2)]
b <- mergeddata[grepl("mean", names(mergeddata))]
c <- mergeddata[grepl("std", names(mergeddata))]
mergeddata <- cbind(a, b, c)


# Uses descriptive activity names to name the activities in the data set
mergeddata$activity <- gsub(1, activity_labels$V2[1], mergeddata$activity)
mergeddata$activity <- gsub(2, activity_labels$V2[2], mergeddata$activity)
mergeddata$activity <- gsub(3, activity_labels$V2[3], mergeddata$activity)
mergeddata$activity <- gsub(4, activity_labels$V2[4], mergeddata$activity)
mergeddata$activity <- gsub(5, activity_labels$V2[5], mergeddata$activity)
mergeddata$activity <- gsub(6, activity_labels$V2[6], mergeddata$activity)

as.factor(mergeddata$subject)
as.factor(mergeddata$activity)


# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

install.packages("resphape2")
library(reshape2)
mergeddata_melted <- melt(mergeddata, id = c("subject", "activity"))
mergeddata_mean <- dcast(mergeddata_melted, subject + activity ~ variable, mean)

names(mergeddata_mean) <- tolower(colnames(mergeddata_mean))
names(mergeddata_mean) <- gsub('[[:punct:] ]+','',names(mergeddata_mean))
write.table(mergeddata_mean, "tidyresult.txt", row.names = FALSE, quote = FALSE)
