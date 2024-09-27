#### Preamble ####
# Purpose: Downloads, cleans, analyzes, and models the Toronto Apartment Building Evaluation data.
# Author: Xuanang Ren
# Date: 26 September 2024
# Contact: [Your Email Address]
# License: MIT
# Pre-requisites: `opendatatoronto`, `tidyverse`, `janitor`, and `rstanarm` packages should be installed.
# Any other information needed: Ensure you have the correct resource ID from Open Data Toronto.


#Workspace setup
library(opendatatoronto)
library(tidyverse)
library(janitor)
library(rstanarm)

#####SIMULATE DATA###
# Set seed for reproducibility
set.seed(123)

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

## Data Validation Tests ##
# Test: Check if the number of rows matches the expected number of samples
stopifnot(nrow(simulated_data) == num_samples)

# Test: Check if ratings are within the expected range
stopifnot(all(simulated_data$rating >= 1 & simulated_data$rating <= 5))

# Test: Check if building age is within the expected range
stopifnot(all(simulated_data$building_age >= 10 & simulated_data$building_age <= 100))

# Save simulated data 
write.csv(simulated_data, "C:\\Users\\User\\Downloads\\simulated_data.csv")


#### DOWNLOAD DATA ####

# Resource ID from Open Data Toronto
resource_id <- "4ef82789-e038-44ef-a478-a8f3590c3eb1"
resources <- list_package_resources(resource_id)

# Identify datastore resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# Load the first datastore resource as a sample
raw_data <- filter(datastore_resources, row_number() == 1) %>% get_resource()

# Display the first few rows of the data to verify
print(head(raw_data))

# Save the raw data as a CSV file in the raw_data directory
write.csv(raw_data, "C:\\Users\\User\\Downloads\\raw_data.csv")

#### CLEAN DATA ####
cleaned_data <-
  raw_data |>
  janitor::clean_names() |>
  select(current_building_eval_score, year_built, year_evaluated, wardname, current_reactive_score) |>
  filter(!is.na(current_building_eval_score)) |>
  mutate(
    current_building_eval_score = as.numeric(as.character(current_building_eval_score)),
    year_built = as.numeric(as.character(year_built)),
    year_evaluated = as.numeric(as.character(year_evaluated))
  ) |>
  rename(
    building_eval_score = current_building_eval_score,
    reactive_score = current_reactive_score
  ) |>
  drop_na()

# Save cleaned data #
write.csv(cleaned_data, "C:\\Users\\User\\Downloads\\analysis_data.csv")


#### DATA EXPLORATION ####

# Load the downloaded data
data <- raw_data

# Check the structure of the data
glimpse(data)

# Summary statistics
summary(data)

# Check for NA values
na_summary <- sapply(data, function(x) sum(is.na(x)))
print(na_summary)  

#The clean data
data1 <- na.omit(data)

# Convert to numeric if necessary
data1$CURRENT.BUILDING.EVAL.SCORE <- as.numeric(as.character(data1$CURRENT.BUILDING.EVAL.SCORE))

# Check for remaining NAs in the score column
na_count <- sum(is.na(data1$CURRENT.BUILDING.EVAL.SCORE))
print(paste("Remaining NAs in CURRENT.BUILDING.EVAL.SCORE:", na_count))

# Plot distribution of ratings
ggplot(data1, aes(x = CURRENT.BUILDING.EVAL.SCORE)) +
  geom_histogram(bins = 20, fill = "skyblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Apartment Ratings",
       x = "Rating",
       y = "Count")

# Check if WARDNAME is a factor
data1$WARDNAME <- as.factor(data1$WARDNAME)

# Convert the rating variable to numeric if necessary
data1$CURRENT.BUILDING.EVAL.SCORE <- as.numeric(as.character(data1$CURRENT.BUILDING.EVAL.SCORE))

# Check for remaining NAs in the score column
na_count <- sum(is.na(data1$CURRENT.BUILDING.EVAL.SCORE))
print(paste("Remaining NAs in CURRENT.BUILDING.EVAL.SCORE:", na_count))

# Plot average ratings by neighborhood
ggplot(data1, aes(x = WARDNAME, y = CURRENT.BUILDING.EVAL.SCORE, fill = WARDNAME)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Apartment Ratings by Neighborhood",
       x = "Neighborhood",
       y = "Rating") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Adjust x-axis labels for better readability

# Calculate building age
data1$building_age <- data1$YEAR.EVALUATED - data1$YEAR.BUILT


# Replace 'num_complaints' with the actual column name
data1$num_complaints <- data1$CURRENT.REACTIVE.SCORE

# Check for remaining NAs in building_age and num_complaints
na_count_age <- sum(is.na(data1$building_age))
na_count_complaints <- sum(is.na(data1$num_complaints))
print(paste("Remaining NAs in building_age:", na_count_age))
print(paste("Remaining NAs in num_complaints:", na_count_complaints))

# Plot the relationship between building age and number of complaints
ggplot(data1, aes(x = building_age, y = num_complaints)) +
  geom_point(alpha = 0.6, color = "blue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  theme_minimal() +
  labs(title = "Relationship Between Building Age and Number of Complaints",
       x = "Building Age (Years)",
       y = "Number of Complaints")

head(data1)
