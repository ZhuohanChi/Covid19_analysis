here::i_am(
  #! TO DO: add appropriate location
  "code/01_make_table1.R"
)

d <- read.csv(
  file = here::here("data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv")
)

library(dplyr)

# Filter out Regions 1 to 10 before summarizing
summary_by_jurisdiction_excluding_1_to_10 <- d %>%
  filter(!Jurisdiction_Residence %in% paste0("Region ", 1:10)) %>%
  group_by(Jurisdiction_Residence) %>%
  summarise(Total_Deaths = sum(COVID_deaths, na.rm = TRUE),
            Average_Death_Rate = mean(crude_COVID_rate, na.rm = TRUE),
            Percent_of_Total_Deaths = mean(COVID_pct_of_total, na.rm = TRUE)) %>%
  arrange(desc(Total_Deaths)) # Order by Total_Deaths descending

saveRDS(
  summary_by_jurisdiction_excluding_1_to_10,
  file = 
    here::here("table/ummary_by_jurisdiction_excluding_1_to_10.rds")
)

  