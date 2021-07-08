imd_2019_url <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/845345/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv"

library(readr)
library(janitor)
library(dplyr)
library(tidyr)

imd_2019 <- read_csv(imd_2019_url) %>%
  clean_names()

imd <- imd_2019 %>%
  select(lsoa_code = lsoa_code_2011,
         # n_total_pop = total_population_mid_2015_excluding_prisoners,
         # n_0to15_pop = dependent_children_aged_0_15_mid_2015_excluding_prisoners,
         # n_16to59_pop = population_aged_16_59_mid_2015_excluding_prisoners,
         # n_60plus_pop = older_population_aged_60_and_over_mid_2015_excluding_prisoners,
         # lsoa_name = lsoa_name_2011,
         imd_score = index_of_multiple_deprivation_imd_score,
         imd_decile = index_of_multiple_deprivation_imd_decile_where_1_is_most_deprived_10_percent_of_lso_as
         ) %>%
  mutate(year = 2019) %>%
  relocate(lsoa_code, year, imd_score, imd_decile)

# imd %>%
#   pivot_longer(cols = c("imd_score", "imd_decile"),
#                names_sep = "_", names_to = c("index", "statistic"))

usethis::use_data(imd, overwrite = TRUE)

