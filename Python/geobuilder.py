from shapely.geometry import Point


def point(lon, lat, srs="EPSG:4326"):
    """Create a shapely Point geometry from lat and lon strings.

    Args:
        lat (str): lattitude
        lon (str): longitude
    Returns:
        shapely point object
    """
    return Point(float(lat), float(lon))
