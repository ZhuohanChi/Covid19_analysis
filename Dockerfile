FROM rocker/r-ubuntu as base

# install pandoc 
RUN apt-get update
RUN apt-get install -y pandoc

RUN mkdir /project
WORKDIR /project

COPY .Rprofile .Rprofile
COPY Makefile Makefile
COPY render_report.R render_report.R
COPY renv.lock renv.lock
COPY report.Rmd report.Rmd


RUN mkdir /code
RUN mkdir /data
RUN mkdir /figure
RUN mkdir /renv
RUN mkdir /table

COPY code/01_make_table1.R code/01_make_table1.R
COPY code/02_make_table2.R code/02_make_table2.R
COPY code/03_make_plot1.R code/03_make_plot1.R
COPY code/04_make_plot2.R code/04_make_plot2.R

COPY data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv

COPY figure/plot_1.png figure/plot_1.png
COPY figure/plot_2.png figure/plot_2.png

COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

COPY table/ummary_by_jurisdiction_excluding_1_to_10.rds table/ummary_by_jurisdiction_excluding_1_to_10.rds
COPY table/rate_comparison_regions_1_to_10.rds table/rate_comparison_regions_1_to_10.rds

RUN Rscript -e "renv::restore(prompt=FALSE)"

RUN mkdir report

CMD make all && mv report.html report

