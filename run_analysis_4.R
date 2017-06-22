

# Load activity labels + features
activityLabels <- read.table("/data/week4/UCI_HAR_Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("/data/week4/UCI_HAR_Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)


# Load the datasets
train <- read.table("/data/week4/UCI_HAR_Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("/data/week4/UCI_HAR_Dataset/train/Y_train.txt")
trainSubjects <- read.table("/data/week4/UCI_HAR_Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("/data/week4/UCI_HAR_Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("/data/week4/UCI_HAR_Dataset/test/Y_test.txt")
testSubjects <- read.table("/data/week4/UCI_HAR_Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy2.txt", row.names = FALSE, quote = FALSE)