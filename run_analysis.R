
library(dplyr)
# load in all the files
X_test<-tbl_df(read.table("./test/X_test.txt",sep="",stringsAsFactors=F,header=F))
Y_test<-tbl_df(read.table("./test/Y_test.txt",sep="",stringsAsFactors=F,header=F))
subject_test<-tbl_df(read.table("./test/subject_test.txt",sep="",stringsAsFactors=F,header=F))

X_train<-tbl_df(read.table("./train/X_train.txt",sep="",stringsAsFactors=F,header=F))
Y_train<-tbl_df(read.table("./train/Y_train.txt",sep="",stringsAsFactors=F,header=F))
subject_train<-tbl_df(read.table("./train/subject_train.txt",sep="",stringsAsFactors=F,header=F))

features<-tbl_df(read.table("features.txt", sep="", stringsAsFactors=F, header=F))
activity<-tbl_df(read.table("activity_labels.txt", sep="", stringsAsFactors=F, header=F))


#transpose the features list to prep it to name the columns
t_features<-t(features)
r_features<-gsub("-", ".", t_features[2,])
r_features<-sub("tBody", "time.Body.", r_features)
r_features<-sub("fBody", "freq.Body.", r_features)
r_features<-sub("tGravity", "time.Gravity.", r_features)


#extract values from features list
dataNames<-r_features
#name the columns in the X sets
colnames(X_test)<-dataNames
colnames(X_train)<-dataNames

#name the columns in the Y sets
colnames(Y_test)<-c("activityID")
colnames(Y_train)<-c("activityID")
colnames(activity)<-c("activityID", "activity")

# Figure out which columns are mean or std values.  exclude the meanFreq matches.
ImportantColumns<-grep("mean[^Freq]|std", t_features[2,])

#Subset out the columns we're interested in
Xtest_trimmed<-X_test[,ImportantColumns]
Xtrain_trimmed<-X_train[,ImportantColumns]

#join activity with activity name in Train and Test sets.  trim out activityID.
Y_trainactivity<-join(Y_train, activity)
Y_testactivity<-join(Y_test, activity)
Y_traintrimmed<-as.data.frame(Y_trainactivity[,2])
colnames(Y_traintrimmed)<-c("activity")
Y_testtrimmed<-as.data.frame(Y_testactivity[,2])
colnames(Y_testtrimmed)<-c("activity")

#add the Y sets to the X sets for both Train and Test
Train_XY<-cbind(Y_traintrimmed, Xtrain_trimmed)
Test_XY<-cbind(Y_testtrimmed, Xtest_trimmed)

#add in the subject ID
Train<-cbind(subject_train, Train_XY)
#Train<-rename(Train, subject= V1, activity = Y_trainactivity)
Test<-cbind(subject_test, Test_XY)


#combine Train and Test sets into one data frame.
data<-rbind(Test, Train)
data<-rename(data, subject = V1)

#summarize data and write to a text file.
data_averages <- data %>%
        group_by(subject,activity) %>%
        summarize_each(funs(mean))

write.table(data_averages, "data_averages.txt", row.names=FALSE)
