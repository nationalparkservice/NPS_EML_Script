# Script Overview---------------------------------------------------------------
# Title: NPS EML Creation Script
#
# Summary: This code creates an EML file for a data package by leveraging several functions within the EMLassemblyline packages. In this case
# the example inputs are for a EVER Veg Map AA dataset and are meant to either be run as a test of the process or to be replaced with your own
# content. This is a step by step process where each section (indicated by #####) should be reviewed and edited if necessary,and run one by one. 
# Several sections are labeled as OPTIONAL and may only apply to certain data packages. The final section has the make_eml() function to put
# together a validated EML metadata file. Future updates to this script will help bring in additional functions from the EMLeditor (part of the
# NPSdataverse) that are used to populate NPS DataStore specific tags.

# Created By: Judd Patterson (judd_patterson@nps.gov)
# Last Updated: October 7, 2022 (robert_baker@nps.gov)

# Install and Load Packages-----------------------------------------------------
# Uncomment the next three lines if you've never installed EMLassemblyline before
#install.packages("devtools")
#library(devtools)
#install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)
library(lubridate)
library(tidyverse)

# Set Overall Package Details----------------------------------------------------
# Review and update these items. For vectors with more than one item, keep the order the same (i.e. item #1 should correspond to the same file
# in each vector)

#Metadata filename - this becomes the filename, so make sure it ends in _metadata to comply with the NPS data package specifications
metadata_id <- "TEST_EVER_AA_metadata"

#Overall package title (replace with our title)
package_title <- "TEST_Title"

  #Description of data collection status - choose from 'ongoing' or 'complete'
  data_type <- "complete"
  
  #Path to data file(s)
  working_folder <- getwd() #paste0("Example_files")
  
  #Vector of dataset filenames 
  data_files <- c("qry_Export_AA_Points.csv", "qry_Export_AA_VegetationDetail.csv")
  
  #Vector of dataset names (brief name for each file)
  data_names <- c("TEST_AA Point Data","TEST_AA Vegetation Data")
  
  #Vector of dataset descriptions (about 10 words describing each file). Descriptions will be used in auto-generated tables within the ReadMe and DRR. If need to use more than about 10 words, consider putting that information in the abstract, methods, or additional info sections.
  data_descriptions <- c("TEST_Everglades Vegetation Map Accuracy Assessment point data","Everglades Vegetation Map Accuracy Assessment vegetation data")

  #Vector of dataset URLs - for DataStore I recommend setting this to the main reference page. All data files from a single data package can be accessed from the same page so the URLs are the same. Just change the number of reps (in the example, 2) to the number of datafiles in your data package.
  data_urls <-c(rep("https://irma.nps.gov/DataStore/Reference/Profile/2293181", 2))
  
  #Table and field that contains scientific names that can be used to fill the taxonomic coverage metadata.
  #comment these out and do not run OPTIONAL 5 (below) if your data package does not contain species information.
  data_taxa_table <- "qry_Export_AA_VegetationDetail.csv"
  data_taxa_field <- "Scientific_Name"
  
  #Table and fields that contain the geographic coordinates and site names that can be used to fill the geographic coverage metadata
  #Comment these out and do not run OPTIONAL 4 (below) if your data package does not contain geographic information.
  data_coordinates_table <- "qry_Export_AA_Points.csv"
  data_latitude <- "Latitude"
  data_longitude <- "Longitude"
  data_sitename <- "SiteName"
    
  #Start date and end date This should indicate the first and last data point in the data package (across all files) and does not include any planning, pre- or post-processing time.  The format should be one that complies with the International Standards Organization's standard 8601. The recommended format for EML is:
#YYYY-MM-DD, where Y is the four digit year, M is the two digit month code (01 - 12 for example, January = 01), and D is the two digit day of the month (01 - 31).
  startdate <- mdy("2010-01-26")
  enddate <- mdy("2013-01-04")

##### The next set of optional items are meant to be considered one by one and only run if applicable to a particular data package. The first year will typically see all of these run, but if the data format and protocol stays constant over time it may be possible to skip some or all of these in future years.
  
##### OPTIONAL 1 - Creates blank TXT template files for the abstract, additional information, custom units, intellectual rights, keywords, methods, and personnel. Be sure the edit the personnel text file in Excel as it has columns. 
  
#Typically these files can be reused between years. Currently this inserts a Creative Common license but that can be tweaked to something more appropriate for the NPS. Feel free to reach out for the latest text.NOTE that if this already exists from a previous run, it is not overwritten.
  
template_core_metadata(path = working_folder, license = "CC0")

##### OPTIONAL 2 - Creates an "attributes_datafilename.txt" file for each data file. This can be opened in Excel (I recommend against trying to update these in a text editor) and fill in/adjust the columns for attributeDefinition, class, unit, etc. refer to https://ediorg.github.io/EMLassemblyline/articles/edit_tmplts.html for helpful hints and  view_unit_dictionary() for potential units. This will only need to be run again if the attributes (name, order or new/deleted fields) are modified from the previous year. NOTE that if this already exists from a previous run, it is not overwritten.

template_table_attributes(path = working_folder, data.table = data_files, write.file = TRUE)

##### OPTIONAL 3 - Creates a "catvars_datafilename.txt" file for each data file that has columns with a class = categorical. These txt files will include each unique 'code' and allow input of the corresponding 'definition'.NOTE that since the list of codes is harvested from the data itself, it's possible that additional codes may have been relevant/possible but they are not automatically included here. Consider your lookup lists carefully to see if additional options should be included (e.g if your dataset DPL values are all set to "Accepted" this function will not include "Raw" or "Provisional" in the resulting file and you may want to add those manually). NOTE that if this already exists from a previous run, it is not overwritten.

template_categorical_variables(path = working_folder, data.path = working_folder, write.file = TRUE)

##### OPTIONAL 4 - Creates a geographic_coverage.txt file that lists your sites as points as long as your coordinates are in lat/long. If your coordinates are in UTM it is probably easiest to convert them first or create the geographic_coverage.txt file another way (see https://github.com/nationalparkservice/QCkit for R functions that will convert UTM to lat/long).

template_geographic_coverage(path = working_folder, data.path = working_folder, data.table = data_coordinates_table, lat.col = data_latitude, lon.col = data_longitude, site.col = data_sitename, write.file = TRUE)

##### OPTIONAL 5 - Creates a taxonomic_coverage.txt file if you have taxonomic data.In terms of authorities 3 = ITIS, 9 = WORMS, and 11 = GBIF.

template_taxonomic_coverage(path = working_folder, data.path = working_folder, taxa.table = data_taxa_table, taxa.col = data_taxa_field, taxa.authority = c(3,11), taxa.name.type = 'scientific', write.file = TRUE)

##### Make the EML!! - Run this (it may take a little while) and see if it validates (you should see 'Validation passed'). Additionally there could be some issues that review as well. Run the function 'issues()' at the end of the process to get feedback on items that might be missing.

  make_eml(path = working_folder,
           dataset.title = package_title,
           data.table = data_files,
           data.table.name = data_names,
           data.table.description = data_descriptions,
           data.table.url = data_urls,
           temporal.coverage = c(startdate, enddate),
           maintenance.description = data_type,
           package.id = metadata_id)