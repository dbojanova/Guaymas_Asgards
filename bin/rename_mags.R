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

    # remove everything after second _ of mag name
    prefix <- original_names %>%
        str_replace("^([^_]+_[^_]+)_.*", "\\1")

    # extract class level
    asgard_class <- gtdbtk_results[[2]] %>%
        str_extract("c__[^;]+") %>%
        str_remove("c__") %>%
        str_replace("Lokiarchaeia", "Loki") %>% 
        str_replace("Heimdallarchaeia", "Heimdall")


    # combine new names
    new_names <- paste(prefix, asgard_class, sep = "_")

    # rename files
    for(i in 1:length(original_names)) {
      file.rename(
        file.path(mag_folder, paste0(original_names[i], ".fa")),
        file.path(mag_folder, paste0(new_names[i], ".fa"))
      )
    }
}

rename_mags(mag_folder, gtdbtk_file)
