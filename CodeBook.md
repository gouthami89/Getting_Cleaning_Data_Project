The following data frames were created by extracting data from the text files in the provided data set (UCI HAR Dataset):

features - contains all the features that were measured
activityType - contains activities engaged by subject. Columns were renamed as "activityId" and "activityType"
subjectTrain - contains subject id of each subject in training set. Column renamed as "subjectId"
xTrain - contains measurements of features for each subject engaged in each activity in the training set. Columns renamed with column names of "features" dataframe
yTrain - contains activityId. Column renamed as "activityId"
subjectTest - contains subject id of each subject in test set. Column renamed as "subjectId"
xTest - contains measurements of features for each subject engaged in each activity in the test set. Columns renamed with column names of "features" dataframe
yTest - contains activityId. Column renamed as "activityId"

These are the other data frames that were created. 

trainingData - contains ytrain, subjectTrain and xTrain data
testData - contains yTest, subjectTest and xTest data

finalData1 - Obtained by merging "trainingData" and "testData" by "activityId"
finalData - Only contains columns providing mean/std.dev of features

finalDatatbl - data frame converted using "tbl_df" in dplyr package
tidyselect - contains all column data in "finalDatatbl" except "activityType"
tidygroup - "tidyselect" is grouped based on "activityId" and "subjectId"
tidysummary - contains mean of all "features" in the 

The following are the vectors that were created
cN - column names of "finalData1"
colNames - column names of "finalData"
logicalVector - contains logical values for column names containing the keywords "mean", "std"
colNames - data vector containing modified column names for the "finalData" dataframe
