
## Exploratory data analysis

### Looking into classes distribution 

#Loading ggplot2 and dplyr libraries
library(ggplot2)
library(dplyr)

#Plotting the count of each class on a bar chart
data %>% ggplot(aes(Class))+geom_bar()


###Correlation matrix and correlogram 

#Calculating the correlation matrix 
data.cor = cor(data)

#Installing the corrplot package
install.packages("corrplot")

#Loading the carrplot library
library(corrplot)

#Plotting a correlogram
corrplot(data.cor)


### The pattern between time and the transaction amount 

#Plotting transaction amount versus time by class 
data %>% ggplot(aes(Time,Amount))+geom_point()+facet_grid(Class~.)


### Filtering out transactions less than 400 and plotting transaction amounts by class
data$Class <- as.factor(data$Class)
data %>% filter(Amount<400) %>% ggplot(aes(Class,Amount))+geom_violin()
