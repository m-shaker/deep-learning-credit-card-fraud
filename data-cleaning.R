
## Loading the dataset
data <- read.csv('./creditcard.csv', stringsAsFactors = F)
head(data)


## Data Cleaning

### Verifying the number of classes

#Printing distinct values in the feature Class
unique(data$Class)


### Checking the timestamps to count the number of days they correspond to

#Record the smallest timestamp in the dataset
first_timestamp <- min(data$Time)

#Record the last timestamp in the dataset
last_timestamp <- max(data$Time)

#Find the difference between the first timestamp in the dataset and the last
#timestamp in the dataset
last_timestamp - first_timestamp

#Since the elapsed seconds between the first transaction and the last transaction in 
#the dataset are less than 172,800, which is the number of seconds in two days, 
#then the transactions in the dataset all occurred within two days. This verifies what 
#is in the dataset description on Kaggle.


### Checking if there are any missing values in the dataset 

#We know that all the features in our dataset are numeric values. In R, the arithmetic 
#function on missing values returns an NA. So we will use the arithmetic mean 
#function to check if there are any missing values in the dataset

arithmetic_mean <- sapply(data, FUN=mean)
arithmetic_mean

#There were no returned NA values. Therefore, we don't have any missing values in our 
#dataset. 