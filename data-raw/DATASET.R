## code to prepare `DATASET` dataset goes here

# usethis::use_data(DATASET, overwrite = TRUE)

library(readxl)
library(tidyverse)
library(here)
library(janitor)

# LSOA 2019 scores ----

# df_raw_fm <- read_excel(here("data-raw/SAPE22DT2-mid-2019-lsoa-syoa-estimates-unformatted.xlsx"),
#                         sheet = "Mid-2019 Persons",
#                         range = "A5:CT34758")


df_raw_m <- read_excel(here("data-raw/SAPE22DT2-mid-2019-lsoa-syoa-estimates-unformatted.xlsx"),
                       sheet = "Mid-2019 Males",
                       range = "A5:CT34758")


df_raw_f <- read_excel(here("data-raw/SAPE22DT2-mid-2019-lsoa-syoa-estimates-unformatted.xlsx"),
                       sheet = "Mid-2019 Females",
                       range = "A5:CT34758")


rename_age_vars <- setNames(paste0("x", 0:90),
                            c(paste0("age", 0:89), "age90plus"))

df_f_wide <- df_raw_f %>%
  clean_names() %>%
  rename(all_of(rename_age_vars))

df_m_wide <- df_raw_m %>%
  clean_names() %>%
  rename(all_of(rename_age_vars))

df_f_long <- df_f_wide %>%
  pivot_longer(cols = all_of(c(paste0("age", 0:89), "age90plus")),
               names_to = "age",
               values_to = "n") %>%
  mutate(age = as.numeric(str_extract(age, "\\d+"))) %>%
  rename(n_all_ages_female = all_ages) %>%
  select(lsoa_code, age, n) %>%
  mutate(year = 2019,
         gender = "f") %>%
  relocate(lsoa_code, year, age, gender, n)

df_m_long <- df_m_wide %>%
  pivot_longer(cols = all_of(c(paste0("age", 0:89), "age90plus")),
               names_to = "age",
               values_to = "n") %>%
  mutate(age = as.numeric(str_extract(age, "\\d+"))) %>%
  rename(n_all_ages_male = all_ages) %>%
  select(lsoa_code, age, n) %>%
  mutate(year = 2019,
         gender = "m") %>%
  relocate(lsoa_code, year, age, gender, n)

lsoa <- df_f_long %>%
  add_row(df_m_long)

usethis::use_data(lsoa, overwrite = TRUE)

