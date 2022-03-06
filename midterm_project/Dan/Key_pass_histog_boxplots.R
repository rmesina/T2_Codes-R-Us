########################################################################
### KEY PASSES ###### KEY PASSES ###### KEY PASSES ###### KEY PASSES ###
########################################################################
pacman::p_load(tidyverse, tidyr, dplyr, readr, ggplot2)

Key_pass <- filter(merge_new, Tag1 == 'Key pass' )
summary(Key_pass)

########################################################################################
### SCATTER PLOTTS ###### SCATTER PLOTTS ###### SCATTER PLOTTS ###### SCATTER PLOTTS ###
########################################################################################

#POINTS: Key passes begin
ggplot(Key_pass, mapping = aes(x = x_start, y = y_start))+ 
  geom_point()+
  labs(title = "Distribution of Key Passes on the field", 
       subtitle = "Showing where the Key Pass begins\nFor all Tournaments")

#Key pass is received
ggplot(Key_pass, mapping = aes(x = x_end, y = y_end))+
  geom_point()+
  labs(title = "Distribution of Key Passes on the field", 
       subtitle = "Showing where the Key Pass is received (ends)\nFor all Tournaments")

########################################################################################
### Histograms & Box plots ###### Histograms & Box plots ###### Histograms & Box plots 
########################################################################################

#Histogram & Boxplot of x_start
ggplot(Key_pass, mapping = aes(x = x_start))+
  geom_histogram(fill = 'blue')+
  labs(title = "Histogram of where a Key Pass begins in the X coordinate", 
       subtitle = "For all Tournaments")

ggplot(data = Key_pass, mapping = aes(y = x_start))+
  geom_boxplot(fill = 'blue')+
  labs(y = "x_start",
       title = "Boxplot: x_start of Key Passes")

#Histogram  & Boxplot of y_start
ggplot(Key_pass, mapping = aes(x = y_start))+
  geom_histogram(fill = 'green')+
  labs(title = "Histogram of where a Key Pass begins in the Y coordinate", 
       subtitle = "For all Tournaments")

ggplot(data = Key_pass, mapping = aes(y = y_start))+
  geom_boxplot(fill = 'green')+
  labs(y = "y_start",
       title = "Boxplot: y_start of Key Passes", 
       subtitle = "For all Tournaments")

#Histogram & boxplot of x_end
ggplot(Key_pass, mapping = aes(x = x_end))+
  geom_histogram(fill = 'blue')+
  labs(title = "Histogram: x_end of Key Passes", 
       subtitle = "For all Tournaments")

ggplot(data = Key_pass, mapping = aes(y = x_end))+
  geom_boxplot(fill = 'blue')+
  labs(y = "x_end",
       title = "Boxplot of x_end in Key Passes")

#Histogram & boxplot of y_end
ggplot(Key_pass, mapping = aes(x = y_end))+
  geom_histogram(fill = 'green')+
  labs(title = "Histogram: y_end in Key Passes", 
       subtitle = "For all Tournaments")

ggplot(data = Key_pass, mapping = aes(y = y_end))+
  geom_boxplot(fill = 'green')+
  labs(y = "x_end",
       title = "Boxplot of y_end in Key Passes", 
       subtitle = 'For all Tournaments')
