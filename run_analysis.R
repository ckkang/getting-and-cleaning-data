# download dataset and make 2 files which is testset and trainset
library(data.table)
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
        download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
        unzip("UCI HAR Dataset.zip", exdir = getwd())
}

features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
head(features)
str(features)
features <- as.character(features[,2])
head(features)
str(features)
ncol(features)

data.train.x <- read.table('./UCI HAR Dataset/train/X_train.txt')
head(data.train.x)
str(data.train.x)
summary(data.train.x)
ncol(data.train.x)
ncol(features)

data.train.activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
head(data.train.activity)
str(data.train.activity)


summary(data.train.activity)

data.train.subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
head(data.train.subject)
str(data.train.subject)
summary(data.train.subject)

data.train <-  data.frame(data.train.subject, data.train.activity, data.train.x)
head(data.train[,1:7])
tail(data.train[,1:7])
names(data.train) <- c(c('subject', 'activity'), features)
tail(data.train[,1:7])

data.test.x <- read.table('./UCI HAR Dataset/test/X_test.txt')
data.test.activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
data.test.subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

data.test <-  data.frame(data.test.subject, data.test.activity, data.test.x)
names(data.test) <- c(c('subject', 'activity'), features)
head(data.test, 1)

# merge the two dataset
data.all <- rbind(data.train, data.test)
nrow(data.all)

# extract mean and standard deviation
mean_std.select <- grep('mean|std', features)
head(mean_std.select)
str(mean_std.select)
data.sub <- data.all[,c(1,2,mean_std.select + 2)]
str(data.sub)

##use descriptive name to name the activities in the data set
activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
str(activity.labels)
activity.labels <- as.character(activity.labels[,2])
str(activity.labels)
summary(activity.labels)
data.sub$activity <- activity.labels[data.sub$activity]
str(data.sub)

# labels the data set with descriptive variable names
name.new <- names(data.sub)
name.new
name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(data.sub) <- name.new
str(data.sub)

#create second, independent tidy data set
data.tidy <- aggregate(data.sub[,3:81], 
        by = list(activity = data.sub$activity, subject = data.sub$subject),FUN = mean)
head(data.tidy)
data.table(data.tidy)
write.table(x = data.tidy, file = "data_tidy.txt", row.names = FALSE)
