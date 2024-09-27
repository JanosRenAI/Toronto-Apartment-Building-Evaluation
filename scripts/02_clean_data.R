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
