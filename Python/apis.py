import requests


def get_latlong(query):
    """Get lattitude and longitude from Google api for a place
    Args:
        query (str): place to geocode

    Returns:
        location in latlon
    """
    
    result = requests.get("https://maps.googleapis.com/maps/api/geocode/json?address={}".format(query))
    location = result.json()['results'][0]['geometry']['location']
    return location

def get_height_ahn2(wkt_geom):
    """Get AHN2 height for WKT geometry

    Args:
        wkt_geom: geometry as WKT
    Results:
        Height in mNAP
    """
    result = requests.get("https://nxt.staging.lizard.net/api/v2/raster-aggregates/?agg=curve&geom={}%29&raster_names=dem%2Fnl&srs=EPSG:4326&start=2016-01-22T12:11:18&stop=2016-01-22T18:11:18&window=300000".format(wkt_geom), verify=False)
    height = result.json()['data'][0]
    return height
