import requests
from time import sleep
import numpy as np
from Python.getCountryFromGoogleMapsJSON import *
import pandas as pd

# files
in_users = 'data/users_from_R.csv'
out_location = 'data/users_location.csv'

# import csv-file
users_import = pd.read_csv(in_users, quotechar='"', skipinitialspace=True, sep=';', header=None)
users = np.array(users_import)

# fetch locations from numpy array
locations = users[:,1]

locations_2 = locations.astype('U') # convert to Unicode in order to process special characte

# initialize variables
lats = np.empty(shape=[len(users),1], dtype='float32') ### NOG NAAR KIJKEN: doel om numpy array te maken om later makkelijk aan np array users t koppelen
lons = np.empty(shape=[len(users),1], dtype='float32')
countries = np.empty(shape=[len(users),1], dtype='object')
iterations = 0

# main loop
for i in locations_2[0:len(locations_2)]: # loops over the strings of all the data.
    print 'Progress: '+str(iterations)+' of '+str(len(locations_2))+' objects.'
    # use json from:
    result = requests.get("https://maps.googleapis.com/maps/api/geocode/json?address={}&key=AIzaSyBVh7MZLGEIG6reaiYyicZnjsoqFs8p7Ik".format(i)).json()
    if result['results'] != []:
        lat = result['results'][0]['geometry']['location']['lat']
        lon = result['results'][0]['geometry']['location']['lng']
        gmapsCountry = getCountryFromGoogleMapsJSON(result)
        lats[iterations,0] = lat
        lons[iterations,0] = lon        
        countries[iterations,0] = gmapsCountry
    else:
        lats[iterations,0] = -999.0
        lons[iterations,0] = -999.0   
    iterations += 1
    # Prevent crash due to overload of requests: pauze after 100 loops for 10 seconds
    if iterations % 100 == 0:
        sleep(10)
    
resultList = np.concatenate([users,lats,lons,countries],axis=1) # Add the lats and lons to the list

# filter results that have no location out of the returned list
List_filtered = resultList[resultList[:,3]!=-999.0]
# filter results that have no country attribute
List_filtered = resultList[resultList[:,5]!='']

# save the filtered list as a csv file.
with open(out_location, 'wb') as fp:
	writer = csv.writer(fp, delimiter=';')
	writer.writerows(List_filtered)
