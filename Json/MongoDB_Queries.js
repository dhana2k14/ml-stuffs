db.test_collection.find()

db.Data_Collection.find({telemetry :{$elemMatch :{'assetName':'Atrack Test'}}}).count()

db.Data_Collection.aggregate([{$match :{'telemetry.assetName' : "Atrack Test"}},{$group:{_id:'date', count : {$sum:1}}}])

db.test_collection.aggregate([{$match :{'telemetry.assetName' : "Hexaware Toyota Innova2"}},{$group:{_id:'date', count : {$sum:1}}}])
