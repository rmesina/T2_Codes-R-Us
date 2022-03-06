pacman::p_load(tidyverse, tidyr, dplyr, readr, ggplot2)

'''
I took the events database, removed some columns, and created a new .csv with 
the unique subevents that took place.

In an exploratory exercise, I: 1) merged all the "clean" databases.
2) merged all databases from the expanded json file (event_data_new).
3) merged the databases created in step 1 and 2.

NOTE: Disregard the commented (#) code. It was useful for me, but maybe not for the project.
NOTE2: The "clean" dataframes are from the older versions of the datasets. They 
are useful because they have infromation the "new" dataframes do not, like matchID.
The "new" dataframes are those recently uploaded by Michael, where the
x,y coordinates are each in their own column.
'''

#England
England <- read_csv("datasets/event_data/event_England.csv")
England_clean <- select(England, -c(...1, tags, playerId, positions)) #Eliminates unwanted columns
#subEvents <- England_clean$subEventName
#subEvents <- unique(England_clean$subEventName) #This will make a horizontal vector containing only the unique values from subEventName
#subEvents <- distinct(England_clean, subEventName, .keep_all = TRUE) #Conserve only the unique values in SubEvent Name.
#write.csv(subEvents, "D:/Master/MA ECON GW/Spring 2022/Data Science/midterm_project/Preliminar_exploration/subEvents.csv", row.names = FALSE)

England_new <- read_csv("datasets/event_data_new/events_England_new.csv")
England_new$Tournament <- rep("England", nrow(England_new))

#Championship
Championship <- read_csv("datasets/event_data/event_European_Championship.csv")
colnames(Championship)
Championship_clean <- select(Championship, -c(...1, tags, playerId, positions))
colnames(Championship_clean)
Championship_clean <- Championship_clean[,c(1,3,6,2,4,5,7)] #Arrange the columns in a better order.
#subEvents_Champ <- distinct(Championship_clean, subEventName, .keep_all = TRUE)
#write.csv(subEvents_Champ, "D:/Master/MA ECON GW/Spring 2022/Data Science/midterm_project/Preliminar_exploration/subEvents_champ.csv", row.names = FALSE)

Championship_new <- read_csv("datasets/event_data_new/events_European_Championship_new.csv")
Championship_new$Tournament <- rep("Championship", nrow(Championship_new))


#France
France <- read_csv("datasets/event_data/event_France.csv")
France_clean <- select(France, -c(...1, tags, playerId, positions))
France_clean <- France_clean[,c(1,3,6,2,4,5,7)]
#subEvents_Fra <- distinct(France_clean, subEventName, .keep_all = TRUE) %>% arrange(subEventId) %>% 
#  arrange(eventId)
#write.csv(subEvents_Fra, "D:/Master/MA ECON GW/Spring 2022/Data Science/midterm_project/Preliminar_exploration/subEvents_fra.csv", row.names = FALSE)

France_new <- read_csv("datasets/event_data_new/events_France_new.csv")
France_new$Tournament <- rep("France", nrow(France_new))


#Germany
Germany <- read_csv("datasets/event_data_old/event_Germany_old.csv")
Germany_clean <- select(Germany, -c(...1, tags, playerId, positions))
Germany_clean <- Germany_clean[,c(1,3,6,2,4,5,7)]
#subEvents_Ger <- distinct(Germany_clean, subEventName, .keep_all = TRUE) %>% arrange(subEventId) %>% 
#  arrange(eventId)
#write.csv(subEvents_Ger, "D:/Master/MA ECON GW/Spring 2022/Data Science/midterm_project/Preliminar_exploration/subEvents_ger.csv", row.names = FALSE)

Germany_new <- read_csv("datasets/event_data_new/events_Germany_new.csv")
Germany_new$Tournament <- rep("Germany", nrow(Germany_new))


#Italy
Italy <- read_csv("datasets/event_data/event_Italy.csv")
Italy_clean <- select(Italy, -c(...1, tags, playerId, positions))
Italy_clean <- Italy_clean[,c(1,3,6,2,4,5,7)]
#subEvents_Ita <- distinct(Italy_clean, subEventName, .keep_all = TRUE) %>% arrange(subEventId) %>% 
#  arrange(eventId)
#write.csv(subEvents_Ita, "D:/Master/MA ECON GW/Spring 2022/Data Science/midterm_project/Preliminar_exploration/subEvents_ita.csv", row.names = FALSE)

Italy_new <- read_csv("datasets/event_data_new/events_Italy_new.csv")
Italy_new$Tournament <- rep("Italy", nrow(Italy_new))


#Spain
Spain <- read_csv("datasets/event_data/event_Spain.csv")
Spain_clean <- select(Spain, -c(...1, tags, playerId, positions))
Spain_clean <- Spain_clean[,c(1,3,6,2,4,5,7)]
#subEvents_Spa <- distinct(Spain_clean, subEventName, .keep_all = TRUE) %>% arrange(subEventId) %>% 
#  arrange(eventId)
#write.csv(subEvents_Spa, "D:/Master/MA ECON GW/Spring 2022/Data Science/midterm_project/Preliminar_exploration/subEvents_spa.csv", row.names = FALSE)

Spain_new <- read_csv("datasets/event_data_new/events_Spain_new.csv")
Spain_new$Tournament <- rep("Spain", nrow(Spain_new))


#World Cup
WorldCup <- read_csv("datasets/event_data/event_World_Cup.csv")
WorldCup_clean <- select(WorldCup, -c(...1, tags, playerId, positions))
WorldCup_clean <- WorldCup_clean[,c(1,3,6,2,4,5,7)]
#subEvents_WorldCup <- distinct(WorldCup_clean, subEventName, .keep_all = TRUE) %>% arrange(subEventId) %>% 
#  arrange(eventId)
#write.csv(subEvents_WorldCup, "D:/Master/MA ECON GW/Spring 2022/Data Science/midterm_project/Preliminar_exploration/subEvents_WorldCup.csv", row.names = FALSE)

WorldCup_new <- read_csv("datasets/event_data_new/events_World_Cup_new.csv")
WorldCup_new$Tournament <- rep("WorldCup", nrow(WorldCup_new))


### MERGING all "clean" data sets. "Clean" is from the older version of the dataframes.
list_clean <- list(England_clean, France_clean, Germany_clean, Italy_clean, 
                   Spain_clean, Championship_clean, WorldCup_clean)
merge_clean <- list_clean %>% reduce(full_join)
head(merge_clean)

#Remove unnecessary Data from environment
rm(list_clean, Championship, England, France, Germany, Italy, Spain, WorldCup)


### MERGING all "new" data sets:
#list_new <- c("England_new", "France_new", "Germany_new", "Italy_new", 
#                 "Spain_new", "Championship_new", "WorldCup_new") #Vector to use in for loop
#
#for (df in list_new){ #Loop to change column names in each dataframe
#  assign(df, setNames(get(df), c("Delete", "Event", "Subevent", "MatchPeriod", "Event_Time",
#                   "x_start", "y_start", "x_end", "y_end", "Player", "Team", 
#                   "Date", "Tag1", "Tag2", "Tag3", "Tag4", "Tag5", "Tag6", "Tournament")))
#}

Spain_new$x_end <- as.numeric(Spain_new$x_end) 
Spain_new$y_end <- as.numeric(Spain_new$y_end) #These coordinates had "character" format.

list_new <- list(England_new, France_new, Germany_new, Italy_new, 
                 Spain_new, Championship_new, WorldCup_new)

merge_new <- list_new %>% reduce(full_join)
### End of merge_new section ###


#Now we slice and filter both "merge_clean" and "merge_new" to have smaller
#datasets and use for Shot location and Key pass location. 

merge_clean <- select(merge_clean, -c(id)) 
merge_new <- select(merge_new, -c(Delete, Player)) #Deletes unnecessary data
merge_new$matchID <- merge_clean$matchId #Adds the matchID to merge_new
merge_new <- merge_new[,c(17,18,1:16)] #Brings the column "Tournament" and "matchID" 
#to the first position and second positions of the dataframe, respectively.


write.csv(merge_new, "D:/Master/MA ECON GW/Spring 2022/Data Science/midterm_project/Preliminar_exploration/datasets/event_data_new/merge_new.csv", row.names = FALSE)
#Note: DO NOT attempt to open this CSV with Excel. It's too big, and might crash your computer.

#Go to the scripts "Key_pass_histog_boxplots.r" and "Shot_locations.r" 




