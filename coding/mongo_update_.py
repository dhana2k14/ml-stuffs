from pymongo import MongoClient
from datetime import datetime

def fixTime(host, port, database, collection, attr, date_format):
    #host is where the mongodb is hosted eg: "localhost"
    #port is the mongodb port eg: 27017
    #database is the name of database eg : "test"
    #collection is the name of collection eg : "test_collection"
    #attr is the column name which needs to be modified
    #date_format is the format of the string eg : "%Y-%m-%d %H:%M:%S.%f"
    #http://docs.python.org/2/library/datetime.html#strftime-and-strptime-behavior
    client = MongoClient(host, port)
    db = client[database]
    col = db[collection]
    for obj in col.find():
        if obj[attr]:
            if type(obj[attr]) is not datetime:
                time = datetime.strptime(obj[attr],date_format)
                col.update({'_id':obj['_id']},{'$set':{attr : time}})
                      
fixTime('172.25.116.200',27017,'Telemetry','TelemeteryData_June2016_Backup_07112016', 'telemeteryData.date','%Y-%m-%d')