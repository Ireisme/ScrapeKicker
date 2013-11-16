from geopy import geocoders
from pymongo import MongoClient
from time import sleep
from sys import argv

script, ip = argv
dbip = 'mongodb://'
dbip += ip

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
		sleep(3600) #sleep and hour, then check again