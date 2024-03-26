here::i_am("code/03_make_plot1.R")

d <- read.csv(
  file = here::here("data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv")
)

library(ggplot2)
library(dplyr)

# Filter for regions 1 to 10 only
d_filtered <- d %>% 
  filter(Jurisdiction_Residence %in% paste('Region', 1:10))

d_filtered$data_period_end <- as.Date(d_filtered$data_period_end, format = "%m/%d/%Y")

# Summarize data by 'data_period_end' and 'Jurisdiction_Residence' for cumulative deaths
d_summarized <- d_filtered %>%
  group_by(data_period_end, Jurisdiction_Residence) %>%
  summarise(COVID_deaths = sum(COVID_deaths, na.rm = TRUE)) %>%
  ungroup()

# Ensure Jurisdiction_Residence is in the correct order
d_summarized$Jurisdiction_Residence <- factor(d_summarized$Jurisdiction_Residence, levels = paste('Region', 1:10))

# Create the stacked area chart
plot1 <-
  ggplot(d_summarized, aes(x = data_period_end, y = COVID_deaths, fill = Jurisdiction_Residence)) + 
    geom_area(position = 'stack') +
    labs(title = "COVID-19 Cumulative Death Trends for Regions 1 to 10", x = "Date", y = "Cumulative COVID-19 Deaths") +
    scale_fill_viridis_d() # Use a color scale that works well for categorical data

ggsave(
  #! TO DO: add appropriate file path to subproject1/output
  here::here("figure/plot_1.png"),
  plot = plot1,
  device = "png"
)