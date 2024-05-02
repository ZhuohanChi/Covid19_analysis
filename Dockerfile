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


RUN mkdir -p code
RUN mkdir -p data
RUN mkdir -p figure
RUN mkdir -p renv
RUN mkdir -p table

COPY code/01_make_table1.R code/01_make_table1.R
COPY code/02_make_table2.R code/02_make_table2.R
COPY code/03_make_plot1.R code/03_make_plot1.R
COPY code/04_make_plot2.R code/04_make_plot2.R

COPY data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv

COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

RUN Rscript -e "renv::restore(prompt=FALSE)"

RUN mkdir report

CMD make && mv report.html report

