Data Science Class 03: Getting and Cleaning Data - Course Project.
==================================================================

What is covered in this code book:
* R script file used to get and clean data and produce a tidy data set.
* Explanation of transformations done by the R script.
* Assumptions made.
* Descriptions of variables used.

### R script:
The script is called run_analysis.R.
It performs the following functions:
* Sets the working directory to a specified location.
* Downloads the specified zip file that contains the project data set, if the file does not exist. The data set is for the following study: [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.
* Unzips the file, if not unzipped already. I decided not to code for checking the timestamps of the file vs. the unzipped directory to see if unzip needs to be re-done in case the zip file is newer than the unzipped directory. My assumption here was that the zip file is not expected to change and this aspect is not what the course project is about.
* Creates a training and test data sets and merges them.
* Assigns logical and intuitive (i.e., not abbreviated) column names in accordance with R naming convention.
* Creates a tidy data set with mean values of certain measurements aggregated by subject and type of activity performed by subject.

### Raw data set structure or brief explanation of my understanding of it:
Overall data set information is explained in the README.txt file in the data set folder.
Data set contains multiple files that are necessary in order to load raw data.
* The measurements themselves are contained in files called test/X_test.txt and train/X_train.txt - these files contain measurements of various (561) parameters over time.
* The explanation of the measurements is done in the file called features_info.txt. The detailed list of the measurements and their order in the record in provided in the file called features.txt.
* Each measurement is done for a particular subject (identified as a number from 1-30) in files called test/subject_test.txt and train/subject_train.txt. The number of records in these files corresponds to the number of measurements in test and train measurement files, respectively.
* Each measurement is done for a particular activity (identified as a number from 1-6) in files called test/y_test.txt and train/y_train.txt. The number of rows in these files corresponds to the number of measurements in test and train measurement files, respectively. The mapping of activity number to activity name or description is contained in a file called activity_labels.txt.

### Assumptions:
* I conciously chose to include only a subset of all the columns that have to do with means and standard deviations. My reasonning is the following: there are 33 mean-related and 33-standard deviation-related columns in the measurement files for a total of 66. Including them all significantly adds to the tedium without adding much value. Also, since we have to give descriptive (read: long) column names, this greatly reduces the number of variables that can be shown on one line, making the thing more difficult to look at. While perusing the discussion forum for this assignment I saw a post from one of the community TAs that there is no right answer on the number of columns included, as long as assumptions are properly documented. Based on this, I chose 12 measurements overall, listed below (number refers to position in features.txt file):
1 tBodyAcc-mean()-X
2 tBodyAcc-mean()-Y
3 tBodyAcc-mean()-Z
41 tGravityAcc-mean()-X
42 tGravityAcc-mean()-Y
43 tGravityAcc-mean()-Z
4 tBodyAcc-std()-X
5 tBodyAcc-std()-Y
6 tBodyAcc-std()-Z
44 tGravityAcc-std()-X
45 tGravityAcc-std()-Y
46 tGravityAcc-std()-Z
The variables above are time domain accelerometer 3-axial measurements taken at a frequency of 50Hz.
These columns were kept and all others dropped.

### Creation of the test data set:
* Load test measurement file (X_test.txt) into a data frame.
* Drop unused columns that did not have anything to do with means or standard deviation measurements (see Assumptions). 
* Add columns for the subject and activity numbers and assign descriptive names to these two columns, based on data in test/subject_test.txt and test/y_test.txt files. This step has to be done before merging to ensure proper mapping of measurements to activity and subject.

### Creation of the train data set:
* Load train measurement file (X_train.txt) into a data frame.
* Drop unused columns that did not have anything to do with means or standard deviation measurements (see Assumptions).
* Add columns for the subject and activity numbers and assign descriptive names to these two columns, based on data in train/subject_train.txt and train/y_train.txt files. This step has to be done before merging to ensure proper mapping of measurements to activity and subject.

### Merge test and training data frames together:
* Merge on all columns.

### Assign descriptive column names:
* The format I used was to use dots as separators in the columnn name, all lower case, no underscores.

### Re-code the numeric activity values to the descriptive values found in activity_labels.txt file.
* Add a new column called activity.name with re-coded level values.
* Drop old activity column (number-based).

### Create a tidy data set that contains the means of the 12 measurements by activity and subject:
* Re-name columns as <previous.column.name>.mean in the tidy data set.
* Write the data set to a file.
