from pymongo import * #lazy
from sys import argv

script, dbip = argv

client = MongoClient('mongodb://',dbip)
db = client.Kickstarter
collection = db.users

for user in collection.find({"loc": {"$exists": True}})
	print user