# NPS EML Creation

Creating Ecological Metadata Language (EML) metadata for NPS data packages is a two-step process. 

The first step is to generate an EML formatted .xml file. There are a number of tools for generating this initial file. This repo contains an R script, instructions, and an example of how to use EMLassemblyline to generate an initial EML metadata file while taking into consideration NPS data package specifications and requirements for uploading to DataStore. 

No matter the method of generating the initial EML file, the second step is to add NPS-specific information to the EML metadata (for instance, the data pacakge DOI, links to the DRR, information about CUI, producing units and unit connections). Currently, the only tool for adding NPS-specific metadata is the [R/EMLeditor](https://github.com/nationalparkservice/EMLeditor) package. Editing EML by hand is not advised.

This is an early version of the NPS EML creation script. Please request enhancements and bug fixes through [Issues](https://github.com/nationalparkservice/NPS_EML_Template/issues).


# Comprehensive Guide 

For a comprehensive guide to generating EML via EMLassemblyline for NPS data packages, please consult the accompanying NPS [EML Creation github website](https://nationalparkservice.github.io/NPS_EML_Script/).

# Quickstart

### Prior to generating EML you will need the following:

1) Data: A set of fully QA/QC'd data files in .csv format using UTF-8 encoding. 

2) Internet access: for downloading software and packages. A strong internet connection is necessary, particularly if you have taxonomic information as EMLassemblyline will use scientific names to populate taxonomic coverage fields from Kingdom down to species (and beyond)

3) Software: R (and probably Rstudio) installed on your computer. These are both available in Software Center. See the [R Advisory Group's website](https://doimspp.sharepoint.com/sites/nps-nrss-imdiv/SitePages/R-Adv.aspx) for more information. You will also need to install the R package [EMLassemblyline](https://github.com/EDIorg/EMLassemblyline) from github as well as some other packages from CRAN:

```r
install.packages(c("devtools", "lubridate", "tidyverse", "stringr")
devtools::install_github("EDIorg/EMLassemblyline")
```

4) Access to MS excel (or any spreadsheet type programs) and Notepad (or any text editor). These will facilitate editing tab-delimited files. 


### Download the Script 

A stand-alone version of the NPS [EML Creation script](https://downgit.github.io/#/home?url=https://github.com/nationalparkservice/NPS_EML_Script/blob/main/EML_Creation_Script.R) is available for download. You don't have to download the entire repository to make EML.

### Generate EML

1) Edit the *EML_Creation_Script.R* file as necessary and run each line or set of code (except the `r make_eml` function). 

2) Edit the auto-generated .txt files using a text editor or spreadsheet application as necessary. For details, look at the NPS [template editing guideline](https://nationalparkservice.github.io/NPS_EML_Script/edit_tmplts.htmll). 

3) Run the `r make_eml` function (this could take a little while - particularly if you have a lot of taxonomic data).

4) Be sure to read and address any Issues or Warnings after running the `r make_eml` function

### Next steps

The EML you have created is not the final step in NPS EML creation. To fully utilize DataStore's new capabilities and to make sure your data are easily discoverable and reusable, you still need to edit the EML file to provide NPS-specific information (e.g. publisher, unit connections, DOIs, etc). 

Currently, the only tool available to add NPS-specific information to EML is [R/EMLeditor](https://github.com/nationalparkservice/EMLeditor). Manually editing your metadata by hand is not recommended.

### Additional documentation

1) The [guide to using the NPS EML creation script](https://nationalparkservice.github.io/NPS_EML_Script/) for creating EML using EMLassemblyline on github.
2) The original [EDI guidelines](https://ediorg.github.io/EMLassemblyline/articles/edit_tmplts.html) for creating EML.

# Acknowledgements

EMLassemblyline and much of the excellent original documentation was developed by the Environmental Data Initiative. We have modified and annotated that documentation to make it more relevant to NPS.


