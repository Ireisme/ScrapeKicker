from geopy import geocoders
from pymongo import MongoClient
from time import sleep

dbip = 'mongodb://71.80.124.122:27017' #database ip goes here

client = MongoClient(dbip)
db = client.Kickstarter
collection = db.users

def geo(location):
	g = geocoders.GoogleV3()
	place, (lat, lng) = g.geocode(location, exactly_one=False)[0]
	return lat, lng

while True:
	try:
		user = collection.find_one(
			{"$and": 
				[
				{"loc": {"$exists": False}}, 
				{"location": {"$ne": ""}}
				]
			}
			)
		lat, lng = geo(user['location'])
		user["loc"] = [lat,lng]
		collection.save(user)
		sleep(.1) #this just prevents the stupid "too fast" error
	except geocoders.googlev3.GTooManyQueriesError:
		sleep(86400) #sit for 24 hours