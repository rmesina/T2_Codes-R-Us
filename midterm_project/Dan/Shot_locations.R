####################################################################################
### SHOT LOCATION ###### SHOT LOCATION ###### SHOT LOCATION ###### SHOT LOCATION ###
####################################################################################

pacman::p_load(tidyverse, tidyr, dplyr, readr, ggplot2)
Shot <- filter(merge_new, Event == 'Shot' )
summary(Shot)



