# Load packages ----
library(readxl)
library(tidyverse)
library(here)
library(janitor)

# URL to zipped data
# url_lsoa <- "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fpopulationandmigration%2fpopulationestimates%2fdatasets%2flowersuperoutputareamidyearpopulationestimates%2fmid2019sape22dt2/sape22dt2mid2019lsoasyoaestimatesunformatted.zip"
# dont know how to unzip without saving file, so just downloading it and adding it to the folder, alltho this is really large and annoying

# LSOA 2019 scores ----
## Estimates for male
df_raw_m <- read_excel(here("data-raw/SAPE22DT2-mid-2019-lsoa-syoa-estimates-unformatted.xlsx"),
  sheet = "Mid-2019 Males",
  range = "A5:CT34758"
)

## Estimates for female
df_raw_f <- read_excel(here("data-raw/SAPE22DT2-mid-2019-lsoa-syoa-estimates-unformatted.xlsx"),
  sheet = "Mid-2019 Females",
  range = "A5:CT34758"
)

# Create vector with better names
rename_age_vars <- setNames(
  paste0("x", 0:90),
  c(paste0("age", 0:89), "age90plus")
)

# Rename both data objects
df_f_wide <- df_raw_f %>%
  clean_names() %>%
  rename(all_of(rename_age_vars))

df_m_wide <- df_raw_m %>%
  clean_names() %>%
  rename(all_of(rename_age_vars))

# Pivot data longer
df_f_long <- df_f_wide %>%
  pivot_longer(
    cols = all_of(c(paste0("age", 0:89), "age90plus")),
    names_to = "age",
    values_to = "n"
  ) %>%
  mutate(age = as.numeric(str_extract(age, "\\d+"))) %>%
  rename(n_all_ages_female = all_ages) %>%
  select(lsoa_code,
    lsoa_name,
    la_code = la_code_2019_boundaries,
    la_name = la_name_2019_boundaries,
    age,
    n
  ) %>%
  mutate(
    lsoa_year = 2019,
    la_year = 2019,
    est_year = 2019,
    gender = "f"
  ) %>%
  relocate(lsoa_year, lsoa_code, lsoa_name, la_year, la_code, la_name, age, gender, est_year, n)

df_m_long <- df_m_wide %>%
  pivot_longer(
    cols = all_of(c(paste0("age", 0:89), "age90plus")),
    names_to = "age",
    values_to = "n"
  ) %>%
  mutate(age = as.numeric(str_extract(age, "\\d+"))) %>%
  rename(n_all_ages_male = all_ages) %>%
  select(lsoa_code,
    lsoa_name,
    la_code = la_code_2019_boundaries,
    la_name = la_name_2019_boundaries,
    age,
    n
  ) %>%
  mutate(
    lsoa_year = 2019,
    la_year = 2019,
    est_year = 2019,
    gender = "m"
  ) %>%
  relocate(lsoa_year, lsoa_code, lsoa_name, la_year, la_code, la_name, age, gender, est_year, n)

# Join data and arrange by code
lsoa <- df_f_long %>%
  add_row(df_m_long) %>%
  arrange(lsoa_year, lsoa_code, est_year, gender)

usethis::use_data(lsoa, overwrite = TRUE)
