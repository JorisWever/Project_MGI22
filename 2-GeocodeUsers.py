## Geo-scripting WUR
## January 2016
## Joris Wever, Erwin van den Berg
## Group: MGI 22

# Geocode the user list



# Import Libraries
import csv
import requests
import numpy as np
import pandas as pd
from time import sleep

# Import functions
from Python.gmaps_api import *

# Initialize variables
in_users = 'output/users_from_R.csv'
out_location = 'output/locations_from_Py.csv'



## 1 - Import the output CSV-file from the 0-Main.R script.

# Use import from panda's library, since numpy csv-imports results in double quotes around strings (""somestring"")
users_import = pd.read_csv(in_users, quotechar='"', skipinitialspace=True, sep=';', header=None)
# Transfrom the imported data into a numpy arrary
users = np.array(users_import)

# Fetch locations from the complete users array
locations = users[:,1]



## 2 - Geocoding

# Create empty numpy arrays (matching same length as users) which will be filled with spatial data during the main loop
lats = np.empty(shape=[len(users),1], dtype='float32')
lons = np.empty(shape=[len(users),1], dtype='float32')
countries = np.empty(shape=[len(users),1], dtype='object')

# Keep track of the count
iterations = 0
# Set time to prevent the googlemaps api to overload.
pauseTime = 20

# Main loop
for i in locations[0:len(locations)]: # loops over the strings of all the data.
    # Retrieve json data for location i from the google maps api.
    result = requests.get("https://maps.googleapis.com/maps/api/geocode/json?address={}".format(i)).json()

    # Filter the coordinates and Geometry out of the result
    lat, lon = getCoordsFromGoogleMapsJSON(result)
    gmapsCountry = getCountryFromGoogleMapsJSON(result)

    # Write data to memory
    lats[iterations,0] = lat
    lons[iterations,0] = lon
    countries[iterations,0] = gmapsCountry

    # Prevent crash due to overload of requests: pauze after 100 loops for 10 seconds
    if iterations % 100 == 0 and iterations != 0:
        print '\nPausing the script in order to prevent a crash due to an overload of requests.'
        print 'Please wait '+str(pauseTime)+' seconds... \n'
        sleep(pauseTime)

    # Increment the tracker
    iterations += 1

    # View progress
    print 'Progress: '+str(iterations)+' of '+str(len(locations))+' objects.'



## 3 - Write data to a csv-file

# Concatenate the numpy arrays.
resultList = np.concatenate([users,lats,lons,countries],axis=1)

# Filter results that have no location out of the returned list
resultList = resultList[resultList[:,3]!=-999.0]
# Filter results that have no country attribute out of the returned list
resultList = resultList[resultList[:,5]!='']

print 'Writing csv-file...'
# Save the result list as a csv file.
with open(out_location, 'wb') as fp:
	writer = csv.writer(fp, delimiter=';')
	writer.writerows(resultList)

print 'Done'
