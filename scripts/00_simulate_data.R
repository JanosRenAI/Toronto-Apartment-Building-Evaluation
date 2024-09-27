#### Preamble ####
# Purpose: Simulates a dataset for Toronto Apartment Building Evaluations.
# Author: Xuanang Ren
# Date: 26 September 2024
# Contact: ang.ren@mail.utoronto.ca
# License: MIT
# Pre-requisites: None. This script is self-contained and does not require external data.
# Any other information needed: This is mock data for testing and development.

#### Workspace setup ####
#install.packages("tidyverse")
library(tidyverse)

# Set seed for reproducibility
set.seed(123)

#### Simulate data ####

# Number of apartment buildings
num_samples <- 1000

# Simulate data columns
apartment_id <- 1:num_samples
building_age <- sample(10:100, num_samples, replace = TRUE)  # Age of the building in years
rating <- round(runif(num_samples, 1, 5), 1)  # Ratings between 1 and 5
num_complaints <- rpois(num_samples, lambda = 3)  # Number of complaints (average = 3)
num_units <- sample(10:300, num_samples, replace = TRUE)  # Number of units in the building
neighborhood <- sample(c("Downtown", "Midtown", "Uptown", "East End", "West End"), num_samples, replace = TRUE)
recent_renovation <- sample(c("Yes", "No"), num_samples, replace = TRUE)  # Recent renovation status

# Combine into a data frame
simulated_data <- data.frame(
  apartment_id,
  building_age,
  rating,
  num_complaints,
  num_units,
  neighborhood,
  recent_renovation
)

# Print first few rows of simulated data
print(head(simulated_data))

#### Data Validation Tests ####

# Test: Check if the number of rows matches the expected number of samples
stopifnot(nrow(simulated_data) == num_samples)

# Test: Check if ratings are within the expected range
stopifnot(all(simulated_data$rating >= 1 & simulated_data$rating <= 5))

# Test: Check if building age is within the expected range
stopifnot(all(simulated_data$building_age >= 10 & simulated_data$building_age <= 100))

# Save simulated data 
write.csv(simulated_data, "C:\\Users\\User\\Downloads\\simulated_data.csv")
