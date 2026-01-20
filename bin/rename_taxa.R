#!/usr/bin/env Rscript

library(readr)
library(stringr)
library(dplyr)

## Add Asgard class to MAG name based on gtdbtk results 

args <- commandArgs(trailingOnly = TRUE)
mag_folder <- args[1]
taxa_file <- args[2]

rename_mags <- function(mag_folder, taxa_file){
  
    taxa_results <- read_tsv(taxa_file, col_types = "c")[1:2]

    # generate new names
    original_names <- taxa_results[[1]]
    new_names <- paste(taxa_results[[2]], original_names, sep = "_")

    # rename files and put in new folder
    dir.create("renamed_mags", showWarnings = FALSE)
    
    for(i in 1:length(original_names)) {
        og_file <- file.path(mag_folder, paste0(original_names[i], ".faa"))
        renamed_file <- file.path("renamed_mags", paste0(new_names[i], ".faa"))
        file.copy(og_file, renamed_file)
    }
}

rename_mags(mag_folder, gtdbtk_file)
