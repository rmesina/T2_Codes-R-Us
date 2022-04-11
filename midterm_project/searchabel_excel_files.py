# -*- coding: utf-8 -*-
"""
Created on Wed Dec 29 14:42:07 2021

@author: Michael
"""

###### Creating Searchable Match Data Excel File ######

# Create empty lists for data to extract
nations = ['Italy','England','Germany','France','Spain','European_Championship','World_Cup']
match_ids=[]
match_dates=[]
competition_names=[]
gameweeks=[]
season_ids=[]
results=[]
venues=[]

# Go through all matches and pull out desired data
# append pulled out data to appropriate list
for nation in nations:
    for match in matches[nation]:
        match_id=match['wyId']
        match_ids.append(match_id)
        match_date=match['dateutc']
        match_dates.append(match_date)
        season_id=match['seasonId']
        season_ids.append(season_id)
        gameweek=match['gameweek']
        gameweeks.append(gameweek)
        result=match['label']
        results.append(result)
        venue=match['venue']
        venues.append(venue)
        for competition in competitions:
            if competition['wyId'] == match['competitionId']:
                comp_name=competition['name']
                competition_names.append(comp_name)

# Create dataframe using filled lists
df_matches=pd.DataFrame(
    {'Match ID': match_ids,
     'Match Date': match_dates,
     'Season ID': season_ids,
     'Gameweek': gameweeks,
     'Competition Name': competition_names,
     'Result': results,
     'Venue': venues}
    )

# Create excel file and save dataframe to it
#writer=pd.ExcelWriter('match_database.xlsx')
#df_matches.to_excel(writer)
#writer.save()
#writer.close()

#%%
###### Creating Searchable Team Excel File ######

# Create empty lists for data to extract
team_ids=[]
team_names=[]
cities=[]
team_types=[]

# Go through all matches and pull out desired data
# append pulled out data to appropriate list
for team in teams:
    team_id=team['wyId']
    team_ids.append(team_id)
    team_name=team['officialName']
    team_names.append(team_name)
    city=team['city']
    cities.append(city)
    team_type=team['type']
    team_types.append(team_type)
        
# Create data frame from filled lists
df_teams=pd.DataFrame(
    {'Team ID':team_ids,
     'Name': team_names,
     'City': cities,
     'Team Type':team_types}
    )

# Create excel file and save dataframe to it
writer=pd.ExcelWriter('teams_database.xlsx')
df_teams.to_excel(writer)
writer.save()
writer.close()

#%%
###### Creating Searchable Event Excel File ######

# Create empty lists for data to extract
event_ids=[]
event_names=[]
subevent_ids=[]
subevent_names=[]
match_periods=[]
event_times=[]
x_starts=[]
y_starts=[]
x_ends=[]
y_ends=[]
player_ids=[]
team_ids=[]
match_ids=[]
tag_id_1s=[]
tag_name_1s=[]
tag_id_2s=[]
tag_name_2s=[]
tag_id_3s=[]
tag_name_3s=[]
tag_id_4s=[]
tag_name_4s=[]
tag_id_5s=[]
tag_name_5s=[]
tag_id_6s=[]
tag_name_6s=[]
tag_numbers=[]
position_nums=[]

# Go through all matches and pull out desired data
# append pulled out data to appropriate list
for nation in nations:
    for event in events[nation]:
        event_id=event['eventId']
        event_ids.append(event_id)
        event_name=event['eventName']
        event_names.append(event_name)
        subevent_id=event['subEventId']
        subevent_ids.append(subevent_id)
        subevent_name=event['subEventName']
        subevent_names.append(subevent_name)
        match_period=event['matchPeriod']
        match_periods.append(match_period)
        event_time=event['eventSec']
        event_times.append(event_time)
        player_id=event['playerId']
        player_ids.append(player_id)
        team_id=event['teamId']
        team_ids.append(team_id)
        match_id=event['matchId']
        match_ids.append(match_id)
        x_start=event['positions'][0]['x']
        x_starts.append(x_start)
        y_start=event['positions'][0]['y']
        y_starts.append(y_start)
        try:
            x_end=event['positions'][1]['x']
        except IndexError:
            x_end='null'
        x_ends.append(x_end)
        try:
            y_end=event['positions'][1]['y']
        except IndexError:
            y_end='null'
        y_ends.append(y_end)
        for tag_id_1 in event['tags']:
            try:
                tag_id_1=event['tags'][0]['id']
            except IndexError:
                tag_id_1='null'
            tag_id_1s.append(tag_id_1)
            for tag_id1 in tag_id_1s:
                tag_name_1=[]
                if tag_id1==dict_tags2name.keys():
                    tag_name_1=dict_tags2name.values()
                tag_name_1s.append(tag_name_1)               
    # create dataframe
    df_event_data=pd.DataFrame(
        {'Event ID':event_ids,
         'Event Name': event_names,
         'Subevent ID': subevent_ids,
         'Subevent Name': subevent_names,
         'Match Period': match_periods,
         'Match ID': match_id,
         'Event Time': event_times,
         'x Start': x_starts,
         'y Start': y_starts,
         'x End': x_ends,
         'y End': y_ends,
         'Player ID': player_ids,
         'Team ID': team_ids,
         'Match Id': match_ids,
         })
    df_event=pd.read_json('./Data/events_%s.json' %nation)
    df_event.to_csv('event_%s.csv' %nation)
# write dataframe to excel file
#df_event_data.to_csv('events_database.csv', index=False)
