def getCountryFromGoogleMapsJSON(google_maps_Json_object):
    """Get the country from a google maps API search.

    Args:
        google_maps_Json_object (str): input the json object retrieved from the google maps api.

    Returns:
        Country full_name
    """
    # Initialize
    json_obj = google_maps_Json_object

    if json_obj['results'] != []:
        # Target address components
        address = json_obj['results'][0]['address_components']

        # From the dictionaries in address, retrieve the 'country, political' dictionary
        for i in address:
            if i['types'] == [ "country", "political" ]:
    
                # get country name in string format
                country = str(i['long_name'])
    else:
        country = ''

    return country



def getCoordsFromGoogleMapsJSON(google_maps_Json_object):
    """Get the latitude and longitude from a google maps API search.

    Args:
        google_maps_Json_object (str): input the json object retrieved from the google maps api.

    Returns:
        latitude and longitude
    """
    # Initialize
    json_obj = google_maps_Json_object

    if json_obj['results'] != []:
        # Retrieve the latitude and the longitude from the json-object.
        latitude = json_obj['results'][0]['geometry']['location']['lat']
        longitude = json_obj['results'][0]['geometry']['location']['lng']
    else:
        latitude = -999.0
        longitude = -999.0

    return latitude, longitude
