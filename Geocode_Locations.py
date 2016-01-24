from numpy import genfromtxt, loadtxt
# from geopy.geocoders import Nominatim
import csv
import requests
from time import sleep
import numpy as np

# files
in_users = 'files/usersR.csv'

# import csv-file
users = genfromtxt(in_users, delimiter=';', dtype='string')

# fetch locations from numpy array
locations = users[:,1]

locations_2 = locations.astype('U') # convert to Unicode in order to process special characte

# initialize variables
lats = np.empty(shape=[len(users),1], dtype='float32') ### NOG NAAR KIJKEN: doel om numpy array te maken om later makkelijk aan np array users t koppelen
lons = np.empty(shape=[len(users),1], dtype='float32')
iterations = 0

# main loop
for i in locations_2[0:(len(locations_2)+1)]: # loops over the strings of all the data.
    print 'Progress: '+str(iterations)+' of '+str(len(locations_2))+' objects.'
    
    #location_string = i[1:-1]
    #print location_string
    
    # use json from:
    result = requests.get("https://maps.googleapis.com/maps/api/geocode/json?address={}".format(i[1:-1]))
    if result.json()['results'] != []:
        lat = result.json()['results'][0]['geometry']['location']['lat']
        lon = result.json()['results'][0]['geometry']['location']['lng']
        lats[iterations,0] = lat
        lons[iterations,0] = lon
    else:
        lats[iterations,0] = -999.0
        lons[iterations,0] = -999.0
        
    iterations += 1
    # Prevent crash due to overload of requests: pauze after 100 loops for 10 seconds
    if iterations % 100 == 0:
        sleep(10)
    
resultList = np.concatenate([users,lats,lons],axis=1) # Add the lats and lons to the list

# filter results that have no location out of the returned list
List_filtered = resultList[resultList[:,3]!='-999.0']

# save the filtered list as a csv file.
with open('files/users_locations.csv', 'wb') as fp:
	writer = csv.writer(fp, delimiter=';')
	writer.writerows(List_filtered)
