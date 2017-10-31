# Distinct method

db.TelemeteryData.distinct("TelemeteryData.assetName")

db.TelemeteryData.distinct("TelemeteryData.telemetry.Crash")

# Find method

db.TelemeteryData.find(
{
    
    "TelemeteryData.telemetry.ignition":{$eq:1}
}).count()


db.TelemeteryData.find(
{
    
    "TelemeteryData.location.address":{$eq:"Chennai Bypass Road, Pozhal, Tamil Nadu, India"}
}).count()


