
db.polo_filter.find().forEach(function(doc) { 
    doc.customData.dt=new Date(doc.telemeteryData.date);
    db.polo_filter.save(doc); 

    })
    db.polo_filter.find({});

db.polo_filter.find(
{ 
    'customData.dt':
    {
        '$lte':new Date(),
        '$gte':new Date(new Date().setDate(new Date().getDate()-60))
    }
})

