# -*- coding: utf-8 -*-
"""
Created on Mon Dec 20 09:29:13 2021

@author: Michael
"""

#Import required libraries for dealing with figshare match data
import json
from collections import Counter
import numpy as np
import operator
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
from matplotlib.patches import Ellipse
from matplotlib.patches import Arc
from matplotlib.gridspec import GridSpec
import seaborn as sns
import pandas as pd
import networkx as nx
import base64
from collections import defaultdict
import sys,os
import math
import random
import operator
import csv
import matplotlib.pylab as pyl
import itertools
import scipy as sp
from scipy import stats
from scipy import optimize
from scipy.integrate import quad
from tkinter.filedialog import askopenfilenames

import warnings
warnings.filterwarnings('ignore')

#%%
###### Load all data from figshare ######
# loading the events data
events={}
nations = ['Italy','England','Germany','France','Spain','European_Championship','World_Cup']
for nation in nations:
    with open('./Data/events_%s.json' %nation) as json_data:
        events[nation] = json.load(json_data)
        
# loading the match data
matches={}
nations = ['Italy','England','Germany','France','Spain','European_Championship','World_Cup']
for nation in nations:
    with open('./Data/matches_%s.json' %nation) as json_data:
        matches[nation] = json.load(json_data)

# loading the players data
players={}
with open('./Data/players.json') as json_data:
    players = json.load(json_data)

# loading the competitions data
competitions={}
with open('./Data/competitions.json') as json_data:
    competitions = json.load(json_data)
    
# loading the team data
teams={}
with open('./Data/teams.json') as json_data:
    teams=json.load(json_data)

#%%
###### Loading Mapped Data Files ######

# loading eventid2name
df_eventid2name=pd.read_csv('./event_tag_ids/eventid2name.csv')

# create dictionary: eventid=key, event_label=value
ls_eventid=df_eventid2name['event'].to_list()
ls_event_label=df_eventid2name['event_label'].to_list()
dict_eventid2name=dict(zip(ls_eventid, ls_event_label))

# create dictionary: subeventid=key, subevent_label=value
ls_subeventid=df_eventid2name['subevent'].to_list()
ls_subevent_label=df_eventid2name['subevent_label'].to_list()
dict_subeventid2name=dict(zip(ls_subeventid, ls_subevent_label))

# loading tags2name
df_tags2name=pd.read_csv('./event_tag_ids/tags2name.csv')

# create dictionary: tagid=key, tag_label=value
ls_tagid=df_tags2name['Tag']
ls_tag_label=df_tags2name['Description']

dict_tags2name=dict(zip(ls_tagid, ls_tag_label))

# bring event, subevent, and tag dicts into one dict
dict_eventIds={'eventid2name':dict_eventid2name,
               'subeventid2name':dict_subeventid2name,
               'tags2name':dict_tags2name}

with open('event_map.json', 'w') as fp:
    json.dump(dict_eventIds, fp)
    
#%%
###### Creating Searchable Event Excel File ######

# Create empty lists for data to extract
event_names=[]
subevent_names=[]
match_periods=[]
event_times=[]
x_starts=[]
y_starts=[]
x_ends=[]
y_ends=[]
player_names=[]
team_names=[]
match_ids=[]
tag_name_1s=[]
tag_name_2s=[]
tag_name_3s=[]
tag_name_4s=[]
tag_name_5s=[]
tag_name_6s=[]


nation='World_Cup'
# Go through all matches and pull out desired data
# append pulled out data to appropriate list
for event in events[nation]:
    event_name=event['eventName']
    event_names.append(event_name)
    subevent_name=event['subEventName']
    subevent_names.append(subevent_name)
    match_period=event['matchPeriod']
    match_periods.append(match_period)
    event_time=event['eventSec']
    event_times.append(event_time)
    player_id=event['playerId']
    for player in players:
        if player_id==player['wyId']:
            player_name=player['lastName']
    player_names.append(player_name)
    team_id=event['teamId']
    for team in teams:
        if team_id==team['wyId']:
            team_name=team['name']
    team_names.append(team_name)
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
    try:
        tag_id_1=event['tags'][0]['id']
        tag_name_1=dict_tags2name.get(tag_id_1)
    except IndexError:
        tag_name_1='null'
    tag_name_1s.append(tag_name_1)        
    try:
        tag_id_2=event['tags'][1]['id']
        tag_name_2=dict_tags2name.get(tag_id_2)
    except IndexError:
        tag_name_2='null'
    tag_name_2s.append(tag_name_2)         
    try:
        tag_id_3=event['tags'][2]['id']
        tag_name_3=dict_tags2name.get(tag_id_3)
    except IndexError:
        tag_name_3='null'
    tag_name_3s.append(tag_name_3)
    try:
        tag_id_4=event['tags'][3]['id']
        tag_name_4=dict_tags2name.get(tag_id_4)
    except IndexError:
        tag_name_4='null'
    tag_name_4s.append(tag_name_4)
    try:
        tag_id_5=event['tags'][4]['id']
        tag_name_5=dict_tags2name.get(tag_id_5)
    except IndexError:
        tag_name_5='null'
    tag_name_5s.append(tag_name_5)   
    try:
        tag_id_6=event['tags'][5]['id']
        tag_name_6=dict_tags2name.get(tag_id_6)
    except IndexError:
        tag_name_6='null'
    tag_name_6s.append(tag_name_6)         
             
# create dataframe
df_event_data=pd.DataFrame(
    {'Event Name': event_names,
     'Subevent Name': subevent_names,
     'Match Period': match_periods,
     'Event Time': event_times,
     'x Start': x_starts,
     'y Start': y_starts,
     'x End': x_ends,
     'y End': y_ends,
     'Player': player_names,
     'Team': team_names,
     'Match Id': match_ids,
     'Tag 1':tag_name_1s,
     'Tag 2':tag_name_2s,
     'Tag 3':tag_name_3s,
     'Tag 4':tag_name_4s,
     'Tag 5':tag_name_5s,
     'Tag 6':tag_name_6s,
     })  

# Write event dataframe to cvs file.
df_event_data.to_csv('event_%s.csv' %nation)