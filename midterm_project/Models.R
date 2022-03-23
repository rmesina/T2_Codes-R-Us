pacman::p_load(tidyverse, tidyr, dplyr, readr, stats)

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
model1 <-lm(Success ~ x_start + y_start, data = merge_model)
model2 <- lm(Success ~ x_start + x_end + y_start + y_end, data = merge_model)
model3 <- lm(Success ~ x_start + x_end + y_start + y_end + Distance, data = merge_model)

#Summaries of models
summary(model1)
summary(model2)
summary(model3) 

#BIC of models: lower value means better model
BIC(model1)
BIC(model2)
BIC(model3) # model3 is the best fitted.
