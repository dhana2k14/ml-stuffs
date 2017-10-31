
# Install Bigmemory packages from r-forge page

install.packages("bigmemory", repos="http://R-Forge.R-project.org")
install.packages("bigmemory.sri", repos="http://R-Forge.R-project.org")
install.packages("biganalytics", repos="http://R-Forge.R-project.org")
install.packages("bigalgebra", repos="http://R-Forge.R-project.org")

# Install Boost Header and biglm package from CRAN

install.packages(c("BH","biglm"))

# Construct big.matrix object.

A <- big.matrix(m, n, type = 'char', init =0, shared = TRUE)

# Demonstration. The Code.

library(bigmemory)
library(biganalytics)
options(bigmemory.typecast.warning=FALSE)

A <- big.matrix(5000,5000, type = 'char', init=0)

# Fill the matix by randomly picking 20% of the positions for a 1. 

x <- sample(1:5000, size=5000, replace=TRUE)
y <- sample(1:5000, size=5000, replace=TRUE)

for ( i in 1:5000) 
  {
  A[x[i], y[i]] <- 1
  }

# Get the location in RAM of the pointer to A.

desc <- describe(A)

# write it to disk.

dput(desc, file = "C:/A.desc")
sums <- colsum(A, 1:20)

# Read the pointer from disk

desc <- dget("C:/A.desc")

# Attach to the pointer in RAM.

A <- attach.big.matrix(desc)

# check our results 

sums <- colsum(A, 1:20)

# RSqlite

library(RSQLite)

ontime <- dbConnect(dbname = "ontime.sqlite3")

from_db <- function(sql)
{
  dbGetQuery(ontime,sql)
}
































