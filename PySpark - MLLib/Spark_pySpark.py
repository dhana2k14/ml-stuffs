## Start pyspark as follows
# Navigate to Spark Distribution, for example 'C:\spark-1.6.1-bin-hadoop2.4\bin'
# Setup SC and SparkContext

from pyspark import SparkContext
sc = SparkContext('local) # Single-node Cluster

# to read csv files from a local disk 
df = sc.textFile('D:\\Kaggle\\Titanic\\train.csv')

df.count() # number of records 
df.take(5) # obtain first 5 records of a data
df.first() # obtain the header row
type(df) # check the type of dataset 'pyspark.rdd.'

# remove the header row 
dfNoHead = df.filter(lambda l:'PassengerId' in l)
df_nhead = df.subtract(dfNoHead)
df_nhead.count()

df_temp = df_nhead.map(lambda k:k.split(',')).map(lambda p:(p[0],p[1], p[2], str(p[3]),p[4],p[5], p[6], p[7], p[8], p[9], p[10], p[11]))

# Obtain schema of dataset 
from pyspark.sql import SQLContext
from pyspark.sql.types import *
sqlContext = SQLContext(sc)

header = df.first()
schemaString = header
fields = [StructField(field_name, StringType(), True) for field_name in schemaString.split(',')]
fields

# modify the datatype of fields

fields[0].dataType = IntegerType()
... # other field name
... # other field name
... # other field name

# Construct the schema (new)

schema = StructType(fields)
schema

# Convert RDD to Spark Dataframe in SQL Context
train_df = sqlContext.createDataFrame(df_nhead, schema)
type(train_df) # to check the type
train_df.dtypes # to check the data types of each attributes 
train_df.printSchema() # to obtain schema info

# Convert Spark SQL Context dataframe to Pandas Data Frame
train_pd_df = train_df.toPandas()
type(train_pd_df) # to check the type

# select columns and store in a pandas dataframe
train_pd_df = sqlContext.sql('Select * from train').toPandas()

# pandas-like queries

train_df.groupBy('Survived').count().show()

# Register as a named temporary table - 'train'
train_df.registerTempTable('train')

# Run SQL equivalent of Pandas like queries -- table and column names are case-sensitive

sqlContext.sql('select Survived, count(*) from train group by Survived').show()


















