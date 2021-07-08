## code to prepare `DATASET` dataset goes here

# usethis::use_data(DATASET, overwrite = TRUE)

library(readxl)
library(tidyverse)
library(here)
library(janitor)

df_raw_fm <- read_excel(here("data-raw/SAPE22DT2-mid-2019-lsoa-syoa-estimates-unformatted.xlsx"),
                        sheet = "Mid-2019 Persons",
                        range = "A5:CT34758")


df_raw_m <- read_excel(here("data-raw/SAPE22DT2-mid-2019-lsoa-syoa-estimates-unformatted.xlsx"),
                       sheet = "Mid-2019 Males",
                       range = "A5:CT34758")


df_raw_f <- read_excel(here("data-raw/SAPE22DT2-mid-2019-lsoa-syoa-estimates-unformatted.xlsx"),
                       sheet = "Mid-2019 Females",
                       range = "A5:CT34758")


rename_age_vars <- setNames(paste0("x", 0:90), c(paste0("age", 0:89), "age90plus"))

df_fm_wide <- df_raw_fm %>%
  clean_names() %>%
  rename(rename_age_vars) %>%
  write_csv(here("data-raw/2019-lsoa-syoa-fm-wide.csv"))

df_f_wide <- df_raw_f %>%
  clean_names() %>%
  rename(rename_age_vars) %>%
  write_csv(here("data-raw/2019-lsoa-syoa-f-wide.csv"))

df_m_wide <- df_raw_m %>%
  clean_names() %>%
  rename(rename_age_vars) %>%
  write_csv(here("data-raw/2019-lsoa-syoa-m-wide.csv"))

df_f_long <- df_f_wide %>%
  pivot_longer(cols = all_of(c(paste0("age", 0:89), "age90plus")),
               names_to = "age",
               values_to = "n_female") %>%
  mutate(age = str_extract(age, "\\d+")) %>%
  rename(n_all_ages_female = all_ages) %>%
  relocate(n_all_ages_female, .after = n_female)


df_m_long <- df_m_wide %>%
  pivot_longer(cols = all_of(c(paste0("age", 0:89), "age90plus")),
               names_to = "age",
               values_to = "n_male") %>%
  mutate(age = str_extract(age, "\\d+")) %>%
  rename(n_all_ages_female = all_ages) %>%
  relocate(n_all_ages_female, .after = n_female)
