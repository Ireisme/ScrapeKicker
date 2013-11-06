from geopy import geocoders
from pymongo import MongoClient
from time import sleep

def geo(location):
	g = geocoders.GoogleV3()
	place, (lat, lng) = g.geocode(location, exactly_one=False)[0]
	return lat, lng

client = MongoClient('mongodb://71.80.124.122:27017')
db = client.Kickstarter
collection = db.users
x = 0

for user in collection.find()[0:100]: #at 12000 set to however many days you are doing it?
	if len(user['location']) > 0:			
		lat, lng = geo(user['location'])
		user.update({"loc": [lat, lng]})
		print user
		x = x+1
	sleep(.1) #don't hit the limit?
print x