#!/usr/bin/env Rscript

library(readr)
library(stringr)
library(dplyr)

## Add Asgard class to MAG name based on gtdbtk results 

args <- commandArgs(trailingOnly = TRUE)
mag_folder <- args[1]
gtdbtk_file <- args[2]

rename_mags <- function(mag_folder, gtdbtk_file){
  
    # read in gtdbtk results and pull out class level assignment
    gtdbtk_results <- read_tsv(gtdbtk_file, col_types = "c")[1:2]

    # save original names
    original_names <- gtdbtk_results[[1]]

    # extract class level (full name)
    asgard_class <- gtdbtk_results[[2]] %>%
        str_extract("c__[^;]+") %>%
        str_remove("c__")

    # combine new names: class_originalname
    new_names <- paste(asgard_class, original_names, sep = "_")

    # rename files and put in new folder
    dir.create("renamed_mags", showWarnings = FALSE)
    
    for(i in 1:length(original_names)) {
        og_file <- file.path(mag_folder, paste0(original_names[i], ".faa"))
        renamed_file <- file.path("renamed_mags", paste0(new_names[i], ".faa"))
        file.copy(og_file, renamed_file)
    }
}

rename_mags(mag_folder, gtdbtk_file)
