library(tidyverse)
library(dplyr)

# Spart insatall package
# install.packages("sparklyr")
library(sparklyr)

# Spark install function
spark_install()

# Chapter 1. The connect-work-disconnect pattern
# Load sparklyr
library(sparklyr)

# Connect to your Spark cluster
spark_conn <- spark_connect(master = "local")

# Print the version of Spark
spark_version(sc = spark_conn)

# Disconnect from Spark
spark_disconnect(sc = spark_conn)

# Chapter 2. Copying data into Spark
# Load dplyr
library(dplyr)

# Explore track_metadata structure
iris <- tbl_df(iris)
str(iris) 

# Connect to your Spark cluster
spark_conn <- spark_connect("local")

# Copy track_metadata to Spark
iris_metadata_tbl <- copy_to(spark_conn, iris)

# List the data frames available in Spark
src_tbls(spark_conn)

# Disconnect from Spark
spark_disconnect(spark_conn)

# Chapter 3. Big data, tiny tibble
# Link to the track_metadata table in Spark
iris_metadata_tbl <- tbl(spark_conn, "iris")

# See how big the dataset is
dim(iris_metadata_tbl)

# See how small the tibble is
library(pryr)
object_size(iris_metadata_tbl)

# Chapter 4. Exploring the structure of tibbles
# Print 5 rows, all columns
print(iris_metadata_tbl, n = 5, width = Inf)

# Examine structure of tibble
str(iris_metadata_tbl)

# Examine structure of data
glimpse(iris_metadata_tbl)
