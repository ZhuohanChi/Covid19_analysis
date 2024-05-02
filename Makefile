report.html: report.Rmd render_report.R table/ummary_by_jurisdiction_excluding_1_to_10.rds table/rate_comparison_regions_1_to_10.rds figure/plot_1.png figure/plot_2.png
	Rscript render_report.R

table/ummary_by_jurisdiction_excluding_1_to_10.rds: code/01_make_table1.R data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv
	Rscript code/01_make_table1.R

table/rate_comparison_regions_1_to_10.rds: code/02_make_table2.R data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv
	Rscript code/02_make_table2.R

figure/plot_1.png: code/03_make_plot1.R data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv
	Rscript code/03_make_plot1.R

figure/plot_2.png: code/04_make_plot2.R data/Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence_20240216.csv
	Rscript code/04_make_plot2.R


.PHONY: clean
clean:
	rm -f figure/*.png table/*.rds report.html
	
.PHONY: install
install:
		Rscript -e "renv::restore(prompt=FALSE)"

# Docker(run on local machine)

PROJECTFILES = report.Rmd code/01_make_table1.R code/02_make_table2.R code/03_make_plot1.R code/04_make_plot2.R render_report.R Makefile
REVFILES = renv.lock renv/activate.R renv/settings.json

# rules to build image
project_image: Dockerfile $(PROJECTFILES) $(RENVFILES)
		docker build -t zhuohanchi/project_image .
		touch $@
	
# rule to build the report automatically in container for Windows
report/w_report.html: project_image
		docker run -v "/$$(pwd)/report":/project/report zhuohanchi/project_image 
		
# rule to build the report automatically in container for Mac/Linux
		docker run -v "$$(pwd)/report":/project/report zhuohanchi/project_image 


