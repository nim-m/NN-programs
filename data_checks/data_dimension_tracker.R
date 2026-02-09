## *****************************************************************************
## # Program    : data_dimension_tracker.R
## # Description: This program appends data set dimension in a text file
##
## # Input      : Chosen ADaM and SDTM datasets
## # Output     : utilities/data_checks/data_tracker.txt
##
## # Notes      : Update data set names and output folder location 
## # Programmer : NHMJ
## *****************************************************************************

rm(list = ls())

# load libraries
library(NNaccess)
library(NNBiostat)
library(dplyr)
library(tidyr)
library(lubridate)
library(forcats)
library(admiral)
library(here)
library(conflicted)

# resolve library conflicts


# load data
db <- NNaccess::nnaccess()

# basic configuration
log_file <- "utilities/data_checks/data_tracker.txt"
ist_time <- with_tz(Sys.time(), tzone = "Asia/Kolkata")

adam_names <- c("adae", "adcm", "adec", "adeg", "adlb", "admh", "adpc", "adpp", "adsl", "advs")
sdtm_names <- c("dm", "ds", "ec", "vs", "cm", "eg", "ae")

# append comments to file ----

sink(log_file, append = TRUE)

cat("Run Timestamp (IST):", format(ist_time, "%Y-%m-%d %H:%M:%S"), "\n")

cat("\nADaM datasets:",  "\n")
for (x in adam_names) {
  temp_data <- db$adam(x)
  dims <- dim(temp_data)        # dims is a vector in the format [rows, columns]
  
  cat("Dataset:", toupper(x), 
      "| Rows:", dims[1], 
      "| Columns:", dims[2], "\n")
  
  rm(temp_data)
  gc(verbose = FALSE)
}

cat("\nSDTM datasets:",  "\n")
for (x in sdtm_names) {
  temp_data <- db$external_data(x)
  dims <- dim(temp_data)        # dims is a vector in the format [rows, columns]
  
  cat("Dataset:", toupper(x), 
      "| Rows:", dims[1], 
      "| Columns:", dims[2], "\n")
  
  rm(temp_data)
  gc(verbose = FALSE)
}

cat("--------------------------\n")

sink()

# view file ----
file.show(log_file)
