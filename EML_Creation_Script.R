## Script Overview -----------------------------------------------------------------------------------------------------
# Title: NPS EML Creation Script
#
# Summary: This code creates an EML file for a data package by leveraging 
# several functions within the EMLassemblyline package. In this case the example
# inputs are for a EVER Veg Map AA dataset and are meant to either be run as a 
# test of the process or to be replaced with your own content. This is a step by
# step process where each section (indicated by dashed lines) should be
# reviewed, edited if necessary, and run one at a time. After completing a 
# section there is often something to do external to R (e.g. open a text file
# and add content). Several EMLassemblyline functions are decision points and
# may only apply to certain data packages. The 'Create an EML File' section has 
# the make_eml() function to put together a validated EML metadata file. Future 
# updates to this script will help bring in additional functions from the 
# EMLeditor package (part of the NPSdataverse) that are used to populate NPS
# DataStore specific tags.

# Contributors: Judd Patterson (judd_patterson@nps.gov) and Rob Baker 
# (robert_baker@nps.gov)
# Last Updated: November 30, 2022

## Install and Load R Packages -----------------------------------------------------------------------------------------
# Install packages - uncomment the next three lines if you've never installed 
# EMLassemblyline before
install.packages("devtools")
# If you run into errors installing packages from github on NPS computers you
#may first need to run:
# options(download.file.method="wininet")
devtools::install_github("EDIorg/EMLassemblyline")

# Load packages
library(EMLassemblyline)
library(lubridate)
library(tidyverse)

## Set Overall Package Details -----------------------------------------------------------------------------------------
# All of the following items should be reviewed and updated to fit the package 
# at hand. For vectors with more than one item, keep the order the same (i.e. 
# item #1 should correspond to the same file in each vector)

# Metadata filename - becomes the filename, so make sure it ends in _metadata to
# comply with data package specifications
metadata_id <- "TEST_EVER_AA_metadata"

# Overall package title
package_title <- "TEST_Everglades National Park Accuracy Assessment (AA) Data Package"

# Description of data collection status - choose from 'ongoing' or 'complete'
data_type <- "complete"
  
# Path to data file(s)
working_folder <- paste0(str_trim(getwd()),"/","Example_files")
  
# Vector of dataset filenames: 
data_files <- c("qry_Export_AA_Points.csv",
                "qry_Export_AA_VegetationDetail.csv")
# If the only .csv files in your working_folder are datasets for your data 
# package, you can use:
# data_files <- list.files(pattern="*.csv")
  
# Vector of dataset names (brief name for each file)
data_names <- c("TEST_AA Point Data",
                "TEST_AA Vegetation Data")
  
# Vector of dataset descriptions (about 10 words describing each file). 
# Descriptions will be used in auto-generated tables within the ReadMe and DRR. 
# If you need to use more than about 10 words, consider putting that information
# in the abstract, methods, or additional info sections.
data_descriptions <- c("TEST_Everglades Vegetation Map Accuracy Assessment point data",
                       "TEST_Everglades Vegetation Map Accuracy Assessment vegetation data")

# Tell EMLassemblyline where your files will ultimately be located. Create a 
# vector of dataset URLs - for DataStore. I recommend setting this to the main 
# reference page. All data files from a single data package can be accessed from
# the same page so the URLs are the same.

# The code from the draft reference you initiated above (replace 293181 with 
# your code)
DSRefCode<-2293181

# No need to edit this
DSURL<-paste0("https://irma.nps.gov/DataStore/Reference/Profile/", DSRefCode)

# No need to edit this
data_urls <-c(rep(DSURL, length(data_files)))
  
# Single file or Vector (list) of tables and fields with scientific names that 
# can be used to fill the taxonomic coverage metadata. Add additional items as 
# necessary. Comment these out and do not run FUNCTION 5 (below) if your data
# package does not contain species information.
data_taxa_tables <- c("qry_Export_AA_VegetationDetail.csv")
# alternatively, if you have multiple files with taxanomic info:
# data_taxa_tables <-c("qry_Export_AA_VegetationDetails1.csv", 
#                      "qry_Export_AA_VegetationDetails2.csv", 
#                      "etc.csv")

# Tell EMLassemblyline the column name where your scientific names are within
# the data files. We suggest using DarwinCore names for your data columns:
# https://dwc.tdwg.org/terms/
data_taxa_fields <- c("Scientific_Name")

# Table and fields that contain geographic coordinates and site names to fill
# the geographic coverage metadata comment these out and do not run FUNCTION 4 
# (below) if your data package does not contain geographic information.
data_coordinates_table <- "qry_Export_AA_Points.csv"
data_latitude <- "decimalLatitude"
data_longitude <- "decimalLongitude"
data_sitename <- "Point_ID"
    
# Start date and end date. 
# This should indicate the first and last data point in the data package 
# (across all files) and does not include any planning, pre- or post-processing
# time. The format should be one that complies with the International Standards
# Organization's standard 8601. The recommended format for EML is: YYYY-MM-DD, 
# where Y is the four digit year, M is the two digit month code (01 - 12 for 
# example, January = 01), and D is the two digit day of the month (01 - 31).
startdate <- ymd("2010-01-26")
enddate <- ymd("2013-01-04")

## EMLassemblyline Functions -------------------------------------------------------------------------------------------
# The next set of functions are meant to be considered one by one and only run
# if applicable to a particular data package. The first year will typically see
# all of these run, but if the data format and protocol stay constant over time
# it may be possible to skip some in future years. Additionally some datasets 
#may not have geographic or taxonomic component.

# FUNCTION 1 - Core Metadata Information
# Creates blank TXT template files for the abstract, additional information, 
# custom units, intellectual rights, keywords, methods, and personnel. Be sure
# the edit the personnel text file in Excel as it has columns. Remember that the
# role "creator" is required! EMLassemblyline will also warn you if you do not 
# include a "PI" role, but you can ignore the warning; this role is not
# required. Typically these files can be reused between years. 

# Currently this inserts a Creative Common 0 license. The CC0 license will need 
# to be updated. However, to ensure that the licence meets NPS specifications
# and properly coincides with CUI designations, the best way to update the 
# license information is during a later step using EMLeditor::set_int_rights().
template_core_metadata(path = working_folder, 
                       license = "CC0")

# FUNCTION 2 - Data Table Attributes
# Creates an "attributes_datafilename.txt" file for each data file. This can be
# opened in Excel (we recommend against trying to update these in a text editor)
# and fill in/adjust the columns for attributeDefinition, class, unit, etc. 
# refer to https://ediorg.github.io/EMLassemblyline/articles/edit_tmplts.html 
# for helpful hints and view_unit_dictionary() for potential units. This will
# only need to be run again if the attributes (name, order or new/deleted 
# fields) are modified from the previous year. NOTE that if these files already
# exist from a previous run, they are not overwritten.
template_table_attributes(path = working_folder, 
                          data.table = data_files, 
                          write.file = TRUE)

# FUNCTION 3 - Data Table Categorical Variable
# Creates a "catvars_datafilename.txt" file for each data file that has columns 
# with a class = categorical. These txt files will include each unique 'code' 
# and allow input of the corresponding 'definition'.NOTE that since the
# list of codes is harvested from the data itself, it's possible that additional
# codes may have been relevant/possible but they are not automatically included
# here. Consider your lookup lists carefully to see if additional options should
# be included (e.g if your dataset DPL values are all set to "Accepted" this 
# function will not include "Raw" or "Provisional" in the resulting file and you
# may want to add those manually). NOTE that if these files already exist from a
# previous run, they are not overwritten.
template_categorical_variables(path = working_folder, 
                               data.path = working_folder, 
                               write.file = TRUE)

# FUNCTION 4 - Geographic Coverage
# If the only geographic coverage information you plan on using are park 
#boundaries, you can skip this step. You can add park unit connections using 
#EMLeditor, which will automatically generate properly formatted GPS coordinates
#for the park bounding boxes.

#If you would like to add additional GPS coordinates (such as for specific site 
#locations, survey plots, or bounding boxes for locations within a park, etc) 
#please do. 

#Creates a geographic_coverage.txt file that lists your sites as points as long
# as your coordinates are in lat/long. If your coordinates are in UTM it is 
# probably easiest to convert them first or create the geographic_coverage.txt 
#file another way (see https://nationalparkservice.github.io/QCkit/ for R 
# functions that will convert UTM to lat/long).
template_geographic_coverage(path = working_folder, 
                             data.path = working_folder,
                             data.table = data_coordinates_table, 
                             lat.col = data_latitude, 
                             lon.col = data_longitude,
                             site.col = data_sitename, 
                             write.file = TRUE)

# FUNCTION 5 - Taxonomic Coverage
# Creates a taxonomic_coverage.txt file if you have taxonomic data. 
# Currently supported authorities are 3 = ITIS, 9 = WORMS, and 11 = GBIF.
template_taxonomic_coverage(path = working_folder, 
                            data.path = working_folder, 
                            taxa.table = data_taxa_tables,
                            taxa.col = data_taxa_fields, 
                            taxa.authority = c(3,11),
                            taxa.name.type = 'scientific', 
                            write.file = TRUE)

## Create an EML File --------------------------------------------------------------------------------------------------
# Run this (it may take a little while) and see if it validates (you should see
# 'Validation passed'). Additionally there could be some issues to review as 
# well. Run the function 'issues()' at the end of the process to get feedback on
#items that might be missing or need attention.
make_eml(path = working_folder,
         dataset.title = package_title,
         data.table = data_files,
         data.table.name = data_names,
         data.table.description = data_descriptions,
         data.table.url = data_urls,
         temporal.coverage = c(startdate, enddate),
         maintenance.description = data_type,
         package.id = metadata_id)
  
## EMLeditor Functions (COMING SOON!) ----------------------------------------------------------------------------------
# Now that you have valid EML metadata, you need to add NPS-specific elements 
# and fields. For instance, unit connections, DOIs, referencing a DRR, etc. To
# do that, use the R/EMLeditor package at:
# https://nationalparkservice.github.io/EMLeditor/.

# For guidance on a minimal workflow for using EMLeditor to generate the highest 
# quality compliant metadata for your data package prior to uploading to 
# DataStore, see: 
# https://nationalparkservice.github.io/EMLeditor/articles/EMLeditor.html#a-minimal-workflow 