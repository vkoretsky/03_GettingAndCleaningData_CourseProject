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
Data set contains multiple files that are necessary in order to load raw data.
* The measurements themselves are contained in files called test/X_test.txt and train/X_train.txt - these files contain measurements of various (561) parameters over time.
* The explanation of the measurements is done in the file called features_info.txt. The detailed list of the measurements and their order in the record in provided in the file called features.txt.
* Each measurement is done for a particular subject (identified as a number from 1-30) in files called test/subject_test.txt and train/subject_train.txt. The number of records in these files corresponds to the number of measurements in test and train measurement files, respectively.
* Each measurement is done for a particular activity (identified as a number from 1-6) in files called test/y_test.txt and train/y_train.txt. The number of rows in these files corresponds to the number of measurements in test and train measurement files, respectively. The mapping of activity number to activity name or description is contained in a file called activity_labels.txt.

### Assumptions:
* I conciously chose to include all the columns based on having references to mean or std (standard deviation) in their names, rather than deep and thorough understanding of researchers' intent and data.There are a total of 86 such colunmns out of 561.
* The variables above are time domain accelerometer 3-axial measurements taken at a frequency of 50Hz.
* For a more detailed explanation of variable descriptions, please refer to features_info.txt and features.txt files under the project folder.

### A: Identification of relevant columns:
* Load features.txt file into R. Field position and name are loaded.
* Create a new column in data frame that would contain the descriptive name.
* Transform name values into descriptive names and assign these value to a new column based on the following criteria:
1. Lower case.
2. No spaces.
3. No hyphens.
4. No parentheses.
* Categorize records based on whether they are related to mean or standard deviation.
* Create a vector of indexes of such feild names.

### B1: Creation of the test data set:
* Load test measurement file (X_test.txt) into a data frame.
* Drop unused columns that did not have anything to do with means or standard deviation measurements (see step A). 
* Add columns for the subject and activity numbers and assign descriptive names to these two columns, based on data in test/subject_test.txt and test/y_test.txt files. This step has to be done before merging to ensure proper mapping of measurements to activity and subject.

### B2: Creation of the train data set:
* Load train measurement file (X_train.txt) into a data frame.
* Drop unused columns that did not have anything to do with means or standard deviation measurements (see step A).
* Add columns for the subject and activity numbers and assign descriptive names to these two columns, based on data in train/subject_train.txt and train/y_train.txt files. This step has to be done before merging to ensure proper mapping of measurements to activity and subject.

### C: Merge test and training data frames together:
* Merge on all columns.

### D: Assign descriptive column names:
* The format I used was to use dots as separators in the columnn name, all lower case, no underscores.

### E: Re-code the numeric activity values to the descriptive values found in activity_labels.txt file.
* Add a new column called activity.name with re-coded level values.
* Drop old activity column (number-based).

### F: Tidy data set:
* Create a tidy data set that contains the means of the 86 measurements by activity and subject.
* Write the data set to a file tidy.txt.
