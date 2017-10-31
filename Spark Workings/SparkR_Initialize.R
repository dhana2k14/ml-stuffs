
## Running Spark in R Studio
## Setting up the system environment variables
Sys.setenv(SPARK_HOME = "C:\\spark-1.6.1-bin-hadoop2.4")

## set the library path
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"),.libPaths()))

# load SparkR library
library(SparkR)

# Create spark context and sql context
sc <- sparkR.init(master = 'local')
sqlContext <- sparkRSQL.init(sc)

# Create a sparkR DataFrame

df <- createDataFrame(sqlContext, faithful)
head(df)

printSchema(df)

# Create a DataFrame from JSON file

path <- file.path(Sys.getenv("SPARK_HOME"), "cax_bigdata.json")
# telemetry <- jsonFile(sqlContext, path)

allTele <- read.json(sqlContext, path) ## jsonFile is deprecated

printSchema(allTele)

# Register this datafrme as table
registerTempTable(allTele, "allTele")

allTeleLocal <- sql(sqlContext, "SELECT * FROM allTele")

allTeleLocalDF <- collect(allTeleLocal)

print(zipLocalDF)

sparkR.stop()

# Create a DataFrame from CSV file

sc <- sparkR.init(sparkHome = "C:\\spark-1.6.1-bin-hadoop2.4\\", master = "local", 
                  sparkPackages="com.databricks:spark-csv_2.10:1.2.0")

sqlContext <- sparkRSQL.init(sc)

df_spark <- read.df(sqlContext, "C:\\spark-1.6.1-bin-hadoop2.4\\CAX_Train_2014_Jan_to_Jun.csv","com.databricks.spark.csv", header = "true")

allCax <- createDataFrame(sqlContext, path) ## jsonFile is deprecated

printSchema(allCax)

# Register this datafrme as table
registerTempTable(allCax, "allCax")

allCaxTeleLocal <- sql(sqlContext, "SELECT * FROM allCax")

allCaxTeleLocalDF <- collect(allCaxTeleLocal)

sparkR.stop()


## Data analysis - an Exercise
## First download the datafiles 
install.packages("RCurl")
library(RCurl)

pop_data_url <- 'http://www2.census.gov/acs2013_1yr/pums/csv_pus.zip'
house_data_url <- 'http://www2.census.gov/acs2013_1yr/pums/csv_hus.zip'

pop_data <- getBinaryURL(pop_data_url)
house_data <- getBinaryURL(house_data_url)


sc <- sparkR.init(master = 'local', sparkPackages = "com.databricks:spark-csv_2.11:1.2.0")
sqlContext <- sparkRSQL.init(sc)

hus_a_file_path <- file.path("C:\\Users\\33093\\Downloads\\csv_hus\\ss13husa.csv")
hus_b_file_path <- file.path("C:\\Users\\33093\\Downloads\\csv_hus\\ss13husb.csv")

hus_a_df <- read.df(sqlContext, 
                        hus_a_file_path, 
                        header='false',
                        source = "com.databricks.spark.csv" 
#                         inferSchema='true'
                    )


hus_b_df <- read.df(sqlContext, 
                        hus_b_file_path, 
                        header='true', 
                        source = "com.databricks.spark.csv", 
                        inferSchema='true')













