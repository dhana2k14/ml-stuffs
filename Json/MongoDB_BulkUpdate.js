// db.getCollection('TelemeteryData_June2016_Backup_071116').find({})


var cursor = db.TelemeteryData_June2016_Backup_071116.find({"telemeteryData.date": {"$exists": true, "$type": 2 }}),
    bulkOps = [];

cursor.forEach(function (doc) { 
    var newDate = new Date(doc.telemeteryData.date);
    bulkOps.push(         
        { 
            "updateOne": { 
                "filter": { "_id": doc._id } ,              
                "update": {  "$set": { "telemeteryData.date": newDate }  } 
            }         
        }           
    );   

    if (bulkOps.length === 1000) {
        db.TelemeteryData_June2016_Backup_071116.bulkWrite(bulkOps);
        bulkOps = [];
    }
});         

if (bulkOps.length > 0) { db.TelemeteryData_June2016_Backup_071116.bulkWrite(bulkOps); }    
   
   






