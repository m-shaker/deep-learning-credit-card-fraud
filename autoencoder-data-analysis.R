
## Data Analysis

### Splitting the dataset into a training set and a testing set. Also, dropping Time 
### and Class features from the training set. 

#Setting aside 20% of the data as a testing set and 80% as a training set
index <- sample(nrow(data), size=0.2*nrow(data))
training_set <- data[-index,]
testing_set <- data[index,]

#Setting the response variable for both the testing and training sets. 
#This will be used later #to evaluate the model performance
y_training_set <- training_set$Class
y_testing_set <- testing_set$Class

#Excluding labels (Time and Class) from the X_training and X_testing sets
X_training_set <- training_set %>% select(-one_of(c("Time","Class")))
X_testing_set <- testing_set %>% select(-one_of(c("Time","Class")))

#Turning the data frame into a matrix 
X_training_set <- as.matrix(X_training_set)
X_testing_set <- as.matrix(X_testing_set)


### The first autoencoder neural network architecture

#Based on our dataset the input and output dimensions will be 29. 
#We will just define one #variable and use it for both the outer layer and the 
#inner layer

input_layer_dimension <- 29

#Defining the number of neurons in the outer layer
neurons_in_outer_layer <- 15

#Defining the number of neurons in the inner layer
neurons_in_inner_layer <- 10

#Defining the input layer of the network which is also the first encoder layer
input_layer <- layer_input(shape=c(input_layer_dimension))

#Defining the encoder of the network and using ReLU as an activation function
encoder <- layer_dense(units=neurons_in_outer_layer,activation='relu')(input_layer)
encoder <- layer_dense(units=neurons_in_inner_layer, activation='relu')(encoder)

#Transation from the encoder which is the first decoder layer
decoder <- layer_dense(units=neurons_in_inner_layer)(encoder)

#Defining decoder layers
decoder <- layer_dense(units=neurons_in_outer_layer)(decoder)
decoder <- layer_dense(units=input_layer_dimension)(decoder)

#Defining the neural network using the encoders and decoders we specified above
autoencoder_arch1 <- keras_model(inputs=input_layer, outputs = decoder)


#Compiling the model using mean square error as a loss function and accuracy as a metics
autoencoder_arch1 %>% compile(optimizer='adam',loss='mean_squared_error',
                              metrics=c('accuracy'))

#Fitting the model and saving the results in the variable "steps"
#Here we specified the batch size as 30 and the number of epochs as 10
#Also, the validation split is set to 0.2
steps  <- autoencoder_arch1 %>% fit(X_training_set,X_training_set, epochs = 10, batch_size = 30, validation_split=0.2)


#Plotting the results to show the accuracy and loss values for each epoch
plot(steps)


### Making predictions using the trained network and test data, defining the 
### threshold for reconstruction errors, and plotting the precision-recall curve.

#Making predictions using the trained network and test data
predictions <- autoencoder_arch1 %>% predict(X_testing_set)
predictions <- as.data.frame(predictions)


#Setting the threshold for the reconstruction errors to 40
y_predictions <- ifelse(rowSums((predictions - X_testing_set)**2)/40<1,rowSums((predictions - X_testing_set)**2)/40,1)


#Plotting the precision-recall curve
library(ROCR)
predic <- prediction(y_predictions, y_testing_set)
perform <- performance(predic, measure = "tpr", x.measure = "fpr")
plot(perform, col='blue')


### The second autoencoder neural network architecture

#Based on our dataset the input and output dimensions will be 29. We will just 
#define one #variable and use it for both the outer layer and the inner layer

input_layer_dimension <- 29

#Defining the number of neurons in each inner layer
neurons_in_first_inner_layer <- 20
neurons_in_second_inner_layer <- 12
neurons_in_third_inner_layer <- 6
neurons_in_fourth_inner_layer <- 3

#Defining the input layer of the network
input_layer <- layer_input(shape=c(input_layer_dimension))

#Defining the encoder of the network and using ReLU as an activation function
encoder <- layer_dense(units=neurons_in_first_inner_layer,activation='relu')(input_layer)
encoder <- layer_dense(units=neurons_in_second_inner_layer, activation='relu')(encoder)
encoder <- layer_dense(units=neurons_in_third_inner_layer, activation='relu')(encoder)
encoder <- layer_dense(units=neurons_in_fourth_inner_layer, activation='relu')(encoder)

#The first layer of the decoder
decoder <- layer_dense(units=neurons_in_fourth_inner_layer)(encoder)

#Defining the decoder layers
decoder <- layer_dense(units=neurons_in_third_inner_layer)(decoder)
decoder <- layer_dense(units=neurons_in_second_inner_layer)(decoder)
decoder <- layer_dense(units=neurons_in_first_inner_layer)(decoder)
decoder <- layer_dense(units=input_layer_dimension)(decoder)

#Defining the neural network using the encoders and decoders we specified above
autoencoder_arch2 <- keras_model(inputs=input_layer, outputs = decoder)

#Compiling the model using mean square error as a loss function and accuracy as a metics
autoencoder_arch2 %>% compile(optimizer='adam',loss='mean_squared_error',
                              metrics=c('accuracy'))

#Fitting the model and saving the results in the variable "steps".
#Here we specified the batch size as 30 and the number of epochs as 10
#Also, the validation split is set to 0.2 
steps_2  <- autoencoder_arch2 %>% fit(X_training_set,X_training_set, epochs = 10, batch_size = 30, validation_split=0.2)


#Plotting the results to show the accuracy and loss values for each epoch
plot(steps_2)
```

### Making predictions using the trained network and test data, defining the threshold 
### for reconstruction errors, and plotting the precision-recall curve.

#Making predictions using the trained network and test data
predictions_2 <- autoencoder_arch2 %>% predict(X_testing_set)
predictions_2 <- as.data.frame(predictions_2)


#Setting the threshold for the reconstruction errors to 40
y_predictions_2 <- ifelse(rowSums((predictions_2 - X_testing_set)**2)/40<1,rowSums((predictions_2 - X_testing_set)**2)/40,1)


#Plotting the precision-recall curve
library(ROCR)
predic_2 <- prediction(y_predictions_2, y_testing_set)
perform_2 <- performance(predic_2, measure = "tpr", x.measure = "fpr")
plot(perform_2, col='blue')

