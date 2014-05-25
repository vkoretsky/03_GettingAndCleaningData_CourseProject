###################################################################################################
## The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
## The goal is to prepare tidy data that can be used for later analysis.
## You will be graded by your peers on a series of yes/no questions related to the project.
## You will be required to submit:
##  1) a tidy data set as described below,
##  2) a link to a Github repository with your script for performing the analysis, and
##  3) a code book that describes the variables, the data, and any transformations or work 
##      that you performed to clean up the data called CodeBook.md.
## You should also include a README.md in the repo with your scripts.
## This repo explains how all of the scripts work and how they are connected. 
## 
## One of the most exciting areas in all of data science right now is wearable computing - see for example 
## this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms 
## to attract new users. The data linked to from the course website represent data collected from 
## the accelerometers from the Samsung Galaxy S smartphone.
## A full description is available at the site where the data was obtained:
##     
##      http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## 
## Here are the data for the project:
## 
##      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## 
## You should create one R script called run_analysis.R that does the following. 
## 
## * Merges the training and the test sets to create one data set.
## * Extracts only the measurements on the mean and standard deviation for each measurement. 
## * Uses descriptive activity names to name the activities in the data set
## * Appropriately labels the data set with descriptive activity names. 
## * Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
## Good luck!
###################################################################################################
setwd("C:\\Users\\Vadim\\Documents\\LikBez\\Coursera\\03_GettingAndCleaningData\\PeerAssessment")

#################
## Download file:
#################
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "getdata_projectfiles_UCI HAR DataSet.zip"
dirName <- "UCI HAR DataSet"

if(!file.exists(fileName)){
    download.file(fileUrl, fileName, method="curl")
}

#################################
## Unzip the file (if necessary):
#################################
if(!file.exists(dirName)){
    unzip(fileName)
}

################################################
## Load file with activity names (features.txt):
################################################
featureNames <- read.delim(paste(dirName, "/features.txt", sep=""), sep="", header=F)
colnames(featureNames) <- c("index", "name")

##############################################################################
## Filter-out/transform elements that should not be present in variables names
## (Upper case, spaces, commas, parentheses, hyphens):
##############################################################################
tmp <- gsub("\\(\\)", "", featureNames$name)
tmp <- gsub("\\(|\\)|-|,|\\s", ".", tmp, perl=T)
tmp <- tolower(tmp)

featureNames$descriptive.name <- tmp

###################################################################################################################
## Categorize the variable names according to whether they have anything to do with the mean or standard deviation:
###################################################################################################################
## I am looking for all variables that have "mean" or "std" in their name.
## Assumption made is that there are no "trick" variables names, such as "meaningful".
regexp <- "^(?:.*?)(?:mean|std)(?:.*?)$"
featureNames$isMeanOrStd <- ifelse(grepl(regexp, featureNames$name, perl=T, ignore.case=T), TRUE, FALSE)
## Take index values of mean or std-related columns:
meanStdColumns <- featureNames[featureNames$isMeanOrStd==TRUE,1]

##################################
### Prepare training data set: ###
##################################
# This changes the precision and notation of numeric variables (scientific to normal):
train <- read.delim(paste(dirName, "/train/X_train.txt", sep=""), sep="", header=F)
## Drop the extra columns (not having to do with mean or median):
train <- train[,meanStdColumns]

## Get subject vector:
strain <- read.delim(paste(dirName, "/train/subject_train.txt", sep=""), sep="", header=F)
## Get activity vector:
ytrain <- read.delim(paste(dirName, "/train/y_train.txt", sep=""), sep="", header=F)

## Add missing columns to a single training data set:
train <- cbind(strain[[1]], train)
colnames(train)[1] <- "subject"
train <- cbind(ytrain[[1]], train)
colnames(train)[1] <- "activity"
##########################################
### END OF: Prepare training data set: ###
##########################################

##############################
### Prepare test data set: ###
##############################
test <- read.delim(paste(dirName, "/test/X_test.txt", sep=""), sep="", header=F)
## Drop the extra columns (not having to do with mean or median):
test <- test[,meanStdColumns]

## Get subject vector:
stest <- read.delim(paste(dirName, "/test/subject_test.txt", sep=""), sep="", header=F)
## Get activity vector:
ytest <- read.delim(paste(dirName, "/test/y_test.txt", sep=""), sep="", header=F)

## Add missing columns to a single training data set:
test <- cbind(stest[[1]], test)
colnames(test)[1] <- "subject"
test <- cbind(ytest[[1]], test)
colnames(test)[1] <- "activity"
######################################
### END OF: Prepare test data set: ###
######################################

##################################
## Merge test and train data sets:
##################################
merge <- merge(test, train, all=T)

#################################
## Give descriptive column names:
#################################
colnames(merge) <- c("subject", "activity", featureNames[featureNames$index %in% meanStdColumns,3])

## Replace numeric activity values with name values (based on activity labels):
merge <- cbind(factor(merge$activity), merge)
colnames(merge)[1] <- "activity.name"
levels(merge$activity.name) <- list(
    WALKING=1, WALKING_UPSTAIRS=2, WALKING_DOWNSTAIRS=3, SITTING=4, STANDING=5, LAYING=6)

## Drop numeric activity column:
merge$activity <- NULL

#########################################################################################
## Produce a tidy data set with averages of all the measurements by activity and subject:
#########################################################################################
tidy <- aggregate(. ~ activity.name + subject, FUN=mean, data=merge)
write.table(tidy, file="tidy.txt", quote=F, col.names=colnames(tidy))

