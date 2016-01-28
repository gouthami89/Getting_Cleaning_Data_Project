#clean up workspace
rm(list=ls())

# 1. Merge the training and the test sets to create one data set.

# Read in the data from files
features     = read.table('./features.txt',header=FALSE); #imports features.txt
activityType = read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
subjectTrain = read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       = read.table('./train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       = read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt

# Assigin column names to the data imported above
colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";

# Create the final training set by merging yTrain, subjectTrain, and xTrain
trainingData = cbind(yTrain,subjectTrain,xTrain);

#Read in test data
subjectTest = read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
xTest       = read.table('./test/x_test.txt',header=FALSE); #imports x_test.txt
yTest       = read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt

# Assigin column names to the data imported above
colnames(subjectTest)  = "subjectId";
colnames(xTest)        = features[,2]; 
colnames(yTest)        = "activityId";

# Create the final test set by merging yTest, subjectTest, and xTest
testData = cbind(yTest,subjectTest,xTest);

# Combine training and test data to create a final data set
finalData = rbind(trainingData, testData);
cN = colnames(finalData);

# 2. Extract only the measurements on the mean and standard deviation for each measurement.

# Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
logicalVector = (grepl("activity..",cN) | grepl("subject..",cN) | grepl("-mean..",cN) & !grepl("-meanFreq..",cN) & !grepl("mean..-",cN) | grepl("-std..",cN) & !grepl("-std()..-",cN));

finalData = finalData[logicalVector == TRUE]

# 3. Descriptive activity names to name activities in the data set

finalData = merge(activityType, finalData, by='activityId', all.x = TRUE);
colNames  = colnames(finalData); 

# 4. Appropriately label the data set with descriptive variable names.

# Cleaning up the variable names
for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","Time",colNames[i])
  colNames[i] = gsub("^(f)","Frequency",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("Acc","Acceleration",colNames[i])
  colNames[i] = gsub("Mag","",colNames[i])
};
 colnames(finalData) <- colNames;

# 5. From the data set in step 4, create a second, independent tidy data set
#    with the average of each variable for each activity and each subject.

  install.packages("dplyr")
  library(dplyr)

  finalDatatbl <- tbl_df(finalData)
  tidyselect <- select(finalDatatbl, -activityType)
  tidygroup <- group_by(tidyselect, activityId, subjectId)
  tidysummary <- summarize_each(tidygroup, funs(mean))
  tidyData <- merge(activityType, tidysummary, by='activityId', all.x = TRUE);
  write.table(tidyData, "tidyData.txt", row.names = FALSE);
  View(tidyData);
