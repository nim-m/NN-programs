## *****************************************************************************
## # Program    : 8088_data_checks.R
## # Description: Tracks dataset changes in a text file
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
library(purrr) 

# resolve library conflicts


# load data
db <- NNaccess::nnaccess()
adam_names <- c("adae", "adcm", "adec", "adeg", "adlb", "admh", "adpc", "adpp", "adsl", "advs")
sdtm_names <- c("dm", "ds", "ec", "vs", "cm", "eg", "ae")



# helper function to obtain dimensions
get_dims <- function(name, source_type) {
  # Logic to pull data based on source
  temp_data <- if(source_type == "ADaM") db$adam(name) else db$external_data(name)
  
  # Return a single-row dataframe
  data.frame(
    timestamp    = format(ist_time, "%Y-%m-%d %H:%M:%S"),
    domain_type  = source_type,
    dataset_name = toupper(name),
    rows         = dim(temp_data)[1],
    cols         = dim(temp_data)[2],
    stringsAsFactors = FALSE
  )
}

# 2. Process both lists and combine into one dataframe
adam_tracker <- map_df(adam_names, ~get_dims(.x, "ADaM"))
sdtm_tracker <- map_df(sdtm_names, ~get_dims(.x, "SDTM"))

final_tracker <- bind_rows(adam_tracker, sdtm_tracker)

# 3. Save the output
# For CSV (Easy for R/Excel)
# write.csv(final_tracker, "utilities/data_checks/data_tracker.csv", row.names = FALSE)

# OR: Append to an existing CSV if you want to keep history
write.table(final_tracker, "data_tracker.csv",
            append = FALSE, sep = ",", col.names = !file.exists("data_tracker.csv"), row.names = FALSE)





