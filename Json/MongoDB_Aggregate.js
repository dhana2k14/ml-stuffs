
# aggregate more than 1 field

db.getCollection('TelemeteryData_June2016').aggregate(
            [{
                $group:{_id:{'asset':'$telemeteryData.assetName','date':'$customData.date'},'cnt_records':{'$sum':1}}
             },
             {
                 '$sort':{'cnt_records':-1}
             }
             ])

# State have moret than 1million population
db.zipcodes.aggregate(
[
    {$group:{_id:"$state",totalPop:{$sum:"$pop"}}},
    {$match:{totalPop:{$gte:1000000}}}
])


# Return average city population by state
    
db.zipcodes.aggregate(
[
    {		$group:				{			_id:						{				state:"$state",city:"city"			},						totalPop:						{				$sum:"$pop"			}		}	},
    {		$group:				{			_id:"$_id.state",						avgCityPop:						{				$avg:"$totalPop"			}		}	}
])
    

# Return largest and smallest cities by state 
    
db.zipcodes.aggregate( 
[
  {
    $group:{_id:{state:"$state",city:"$city"}, totalPop:{$sum:"$pop"}}
  },
  {
     $sort:{totalPop:1}
  },
  {
     $group:
      {
          _id:"$_id.state",
          biggestCity :{$last:"$_id.city"},
          biggestPop  :{$last:"$totalPop"},
          smallestCity :{$first:"$_id.city"},
          smallestPop  :{$first:"$totalPop"}
      }
  }
])
    
    



