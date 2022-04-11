pacman::p_load(tidyverse, tidyr, dplyr, readr, stats, car)

#From merge_new, obtain the rows that contain "Shot", "Assist", "Goal" and/or "Key pass".
merge4model_shot <- filter(merge_new, Subevent == "Shot")
merge4model_AGK <- filter(merge_new, Tag1 == "Assist" | Tag1 == "Goal" | Tag1 == "Key pass")

merge_model <- bind_rows(merge4model_shot, merge4model_AGK)
merge_model <- distinct(merge_model) #Removes repeated rows

#Assign a boolean for goal scored (1), or not (0)
merge_model$Tag6 <- ifelse(merge_model$Tag5 == "Accurate" | is.na(merge_model$Tag5) | merge_model$Tag5 == "Not Accurate",
                           "Other", "Accurate")

merge_model$Success <- as.integer(merge_model$Success)
merge_model$Success <- ifelse((merge_model$Tag2 == "Accurate"|
                                merge_model$Tag3 == "Accurate"|
                                merge_model$Tag4 == "Accurate"|
                                merge_model$Tag5 == "Accurate"|
                                merge_model$Tag6 == "Accurate"),1,0)

merge_model$Success <- ifelse(is.na(merge_model$Success),0,1)
unique(merge_model$Success)

#Calculate the distance for each event using Pythagoras theorem:
#Typical dimensions of a field: 120 by 75 yards
merge_model$Distance <- rep(0, times = nrow(merge_model))
merge_model$Distance <- sqrt((1.2*(merge_model$x_end - merge_model$x_start))**2 + 
                               (0.75*(merge_model$y_end - merge_model$y_start))**2)

#Build different models of probability of success
model1 <-glm(Success ~ x_start + y_start, data = merge_model)
model2 <- glm(Success ~ x_start + x_end + y_start + y_end, data = merge_model)
model3 <- glm(Success ~ x_start + x_end + y_start + y_end + Distance, data = merge_model, family = "binomial")

#Summaries of models
summary(model1)
summary(model2)
summary(model3) 

#BIC of models: lower value means better model
BIC(model1)
BIC(model2)
BIC(model3) # model3 is the best fitted.

#Testing
merge_model$Predict <- 0.4905 + 0.002179*merge_model$x_start + 
  0.009305*merge_model$x_end + 0.0002713*merge_model$y_start -
  0.0109*merge_model$y_end - 0.002941*merge_model$Distance
summary(merge_model$Predict)

###################################
### NEW MODELS WITH PROBABILITY ###
###################################

#STEP 1. CHECK THE DATA IS CENTERED: NUMBER OF SUCCESS AND FAILURE ARE MORE OR 
#LESS THE SAME
sum(merge_model$Success == 1) #30,475 observations
sum(merge_model$Success == 0) #33,786 observations. They are similar.

#STEP 2. CENTER VALUES OF INDEPENDENT VARIABLES: SUBTRACT THE MEAN 
#FROM OF EACH VARIABLE FROM EACH OBSERVATION OF THAT VARIABLE.
merge_model2 <- merge_model

merge_model2$x_start <- merge_model$x_start - mean(merge_model$x_start)
merge_model2$x_end <- merge_model$x_end - mean(merge_model$x_end)
merge_model2$y_start <- merge_model$y_start - mean(merge_model$y_start)
merge_model2$y_end <- merge_model$y_end - mean(merge_model$y_end)

#STEP 3. Make the logit model. Obtain the probability vector.
model3 <- glm(Success ~ x_start + x_end + y_start + y_end + Distance, data = merge_model2, family = "binomial")
model4 <- glm(Success ~ x_start*y_start , data = merge_model2, family = "binomial")
model5 <- glm(Success ~ x_end + y_end + x_start*y_start , data = merge_model2, family = "binomial")
model6 <- glm(Success ~ Distance + x_start*y_start , data = merge_model2, family = "binomial")

#STEP 4. EVALUATE THE MODELS
BIC(model3)
BIC(model4)
BIC(model5)
BIC(model6)

vif(model3)
vif(model4)
vif(model5)
vif(model6)

# model6 has a high BIC, but it doesn't show multicollinearity (vif < 2). Thus, 
# this is the model I will use.

#STEP 5. ADD THE PROBABILITY VECTOR TO THE DATABASE FROM THE FITTED VALUES
merge_model2$probability <- model6$fitted.values
summary(merge_model2$probability) #Values here make sense

# STEP 6. MAKE A NEW MODEL WITH THE PROBABILITIES AS DEPENDANT VARIABLE
model6b <- glm(probability ~ Distance + x_start*y_start , data = merge_model2)
summary(model6b)
vif(model6b)



