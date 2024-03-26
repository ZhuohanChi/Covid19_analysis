here::i_am(
  #! TO DO: add appropriate location
  "code/02_make_table2.R"
)

d <- read.csv(
  file = here::here("data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv")
)

library(dplyr)

# Filter for Regions 1 to 10 only and then compare rates
rate_comparison_regions_1_to_10 <- d %>%
  filter(Jurisdiction_Residence %in% paste0("Region ", 1:10)) %>%
  select(Jurisdiction_Residence, crude_COVID_rate, aa_COVID_rate) %>%
  group_by(Jurisdiction_Residence) %>%
  summarise(Average_Crude_Rate = mean(crude_COVID_rate, na.rm = TRUE),
            Average_Age_Adjusted_Rate = mean(aa_COVID_rate, na.rm = TRUE)) %>%
  ungroup()


saveRDS(
  rate_comparison_regions_1_to_10,
  file = 
    here::here("table/rate_comparison_regions_1_to_10.rds")
)

