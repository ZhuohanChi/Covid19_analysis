here::i_am("code/04_make_plot2.R")

d <- read.csv(
  file = here::here("data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv")
)

library(ggplot2)
library(dplyr)
library(lubridate)

dates <- seq(as.Date("2020-01-01"), as.Date("2021-12-31"), by="month")
crudeRates <- cumsum(runif(length(dates), min=0, max=5))  # Simulated crude death rates
ageAdjustedRates <- cumsum(runif(length(dates), min=0, max=5))  # Simulated age-adjusted death rates

data <- data.frame(Date=dates, CrudeRate=crudeRates, AgeAdjustedRate=ageAdjustedRates)

# Plotting the line chart for "Region 1"
plot2 <-
  ggplot(data, aes(x=Date)) +
    geom_line(aes(y=CrudeRate, color="Crude Death Rate"), size=1) +
    geom_line(aes(y=AgeAdjustedRate, color="Age-Adjusted Death Rate"), size=1) +
    scale_color_manual(values=c("Crude Death Rate"="blue", "Age-Adjusted Death Rate"="red")) +
    labs(title="Comparison of Crude and Age-Adjusted Death Rates for Region 1",
         x="Date", y="Death Rate per 100,000 Population",
         color="Rate Type") +
    theme_minimal() +
    theme(axis.text.x=element_text(angle=45, hjust=1))

ggsave(
  #! TO DO: add appropriate file path to subproject1/output
  here::here("figure/plot_2.png"),
  plot = plot2,
  device = "png"
)
