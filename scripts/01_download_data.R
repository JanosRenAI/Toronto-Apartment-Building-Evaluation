#### Preamble ####
# Purpose: Downloads and saves the Toronto Apartment Building Evaluation data from Open Data Toronto.
# Author: Xuanang Ren
# Date: 26 September 2024
# Contact: [Your Email Address]
# License: MIT
# Pre-requisites: `opendatatoronto` and `tidyverse` packages should be installed.
# Any other information needed: Ensure you have the correct resource ID from Open Data Toronto.

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download data ####

# Replace with the actual resource ID from Open Data Toronto
resource_id <- "4ef82789-e038-44ef-a478-a8f3590c3eb1"
resources <- list_package_resources(resource_id)

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the first datastore resource as a sample
raw_data <- filter(datastore_resources, row_number()==1) %>% get_resource()
raw_data

# Display the first few rows of the data to verify
print(head(raw_data))

#### Save data ####

# Save the raw data as a CSV file in the raw_data directory
write.csv(raw_data, "C:\\Users\\User\\Downloads\\raw_data.csv")
