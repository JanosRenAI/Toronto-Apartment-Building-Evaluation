#### Preamble ####
# Purpose: Analyzes the Toronto Apartment Building Evaluation data and generates visualizations.
# Author: Xuanang Ren
# Date: 26 September 2024
# Contact: [Your Email Address]
# License: MIT
# Pre-requisites: The `tidyverse` package should be installed.
# Any other information needed: The script assumes that the raw data file has been downloaded and saved in the `data/raw_data` directory.

#### Workspace setup ####
library(tidyverse)
library(ggplot2)

#### Load the data ####
# Load the downloaded data
data <- raw_data


# Check the structure of the data
glimpse(data)

#### Data Exploration ####

# Summary statistics
summary(data)

# Check for NA values
na_summary <- sapply(data, function(x) sum(is.na(x)))
print(na_summary)  

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

# Calculate building age if not already defined
data1$building_age <- data1$YEAR.EVALUATED - data1$YEAR.BUILT

# Assuming 'num_complaints' is the correct column name for the number of complaints
# Replace 'num_complaints' with the actual column name if different
data1$num_complaints <- data1$CURRENT.REACTIVE.SCORE  # Example, replace with correct variable

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