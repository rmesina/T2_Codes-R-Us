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
df_eventid2name=pd.read_csv('./Data/eventid2name.csv')

# create dictionary: eventid=key, event_label=value
ls_eventid=df_eventid2name['event'].to_list()
ls_event_label=df_eventid2name['event_label'].to_list()
dict_eventid2name=dict(zip(ls_eventid, ls_event_label))

# create dictionary: subeventid=key, subevent_label=value
ls_subeventid=df_eventid2name['subevent'].to_list()
ls_subevent_label=df_eventid2name['subevent_label'].to_list()
dict_subeventid2name=dict(zip(ls_subeventid, ls_subevent_label))

# loading tags2name
df_tags2name=pd.read_csv('./Data/tags2name.csv')

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
    