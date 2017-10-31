db.getCollection('vehicleHistory').find({})

db.vehicleHistory.updateOne(
{"AssetName":"Honda City"},
{
    $set:{"date":new Date("date")}
}
)


db.vehicleHistory.aggregate(
[
{$project:
    {
    Year:{$substr:['$date',5,-1]},
    month:{$substr:['$date',0,2]},
    date:{$substr:['$date',2,2]}
    }
}
])

# Group by two fields

db.vehicleHistory.group(
{
    key:{'AssetName':1, 'date':1},
    cond:{'date':{$eq: '3/28/2016'}},
    reduce: function(curr, result){},
    initial:{}
}
)

# Group by two fields and sum & Count

db.vehicleHistory.group(
{
    key:{'AssetName':1, 'date':1},
    cond:{'date':{$eq: '3/28/2016'}},
    reduce: function(curr, result){
            result.totalBrakes += curr.harsh_brake,
            result.totalAccl += curr.harsh_accel,
            result.count++},
    initial:{totalBrakes:0, totalAccl:0, count:0}
}
)
db.getCollection('vehicleHistory').find({"AssetName":"Polo GT",'date':{$eq:'3/28/2016'}}).count()


