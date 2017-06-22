x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
features<-read.table("./UCI HAR Dataset/features.txt")
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")

#column naming
colnames(x_train)<-features[,2]
colnames(y_train)<-"ActivityID"
colnames(subject_train)<-"SubjectID"
colnames(x_test)<-features[,2]
colnames(y_test)<-"ActivityID"
colnames(subject_test)<-"SubjectID"
colnames(activity_labels)<-c('ActivityID','Activity')

#combining data sets
train<-cbind(y_train,subject_train,x_train)
test<-cbind(y_test,subject_test,x_test)
combineddata<-rbind(train,test)

#labelling the activities with description
header<-colnames(combineddata)
mean_std <- (grepl("ActivityID" , header) | 
               grepl("SubjectID" , header) | 
               grepl("mean.." , header) | 
               grepl("std.." , header))
mean_std_result<-combineddata[,mean_std==TRUE]
mean_std_result_labelled<-merge(mean_std_result,activity_labels,by='ActivityID',all.x=TRUE)

#Creating tidy data set
Tidydata<-aggregate(.~SubjectID + Activity,mean_std_result_labelled,mean)
Tidydata<-Tidydata[order(Tidydata$SubjectID,Tidydata$ActivityID),]
write.table(Tidydata,"Tidydata.txt",row.name=FALSE)

# GettingandCleaningDataWeek4Assignment
# GettingandCleaningDataWeek4Assignment