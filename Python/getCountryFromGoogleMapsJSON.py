def getCountryFromGoogleMapsJSON(google_maps_Json_object):    
    # initialize
    json_obj = google_maps_Json_object 
    
    # target address components
    address = json_obj['results'][0]['address_components']
    
    # from the dictionaries in address, retrieve the 'country, political' dictionary
    for i in address:
        if i['types'] == [ "country", "political" ]:
            
            # get country name in string format
            country = str(i['long_name'])
        else:
            country = ''

    return country