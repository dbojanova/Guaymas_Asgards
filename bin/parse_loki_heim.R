#!/usr/bin/env Rscript

## Separate MAGs into Loki and Heimdall folders based on gtdbtk results

library(readr)
library(stringr)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
mag_folder <- args[1]
gtdbtk_file <- args[2]

separate_mags <- function(mag_folder, gtdbtk_file){
  
    # create output folders
    dir.create("loki", showWarnings = FALSE)
    dir.create("heimdall", showWarnings = FALSE)
    
    # filter gtdbtk results for Loki and Heimdall MAGs
    gtdbtk_results <- read_tsv(gtdbtk_file, col_types = "c")[1:2]
    
    gtdbtk_results <- gtdbtk_results %>%
        filter(str_detect(.[[2]], "Lokiarchaeia|Heimdallarchaeia")) %>%
        mutate(class = case_when(
            str_detect(.[[2]], "Lokiarchaeia") ~ "loki",
            str_detect(.[[2]], "Heimdallarchaeia") ~ "heimdall"
        ))
    
    # copy loki and heim mags to appropriate folders
    for(i in 1:nrow(gtdbtk_results)) {
      mag_name <- gtdbtk_results[[1]][i]
      target_folder <- gtdbtk_results$class[i]
      
      original_file <- file.path(mag_folder, paste0(mag_name, ".faa"))
      
      file.copy(original_file, file.path(target_folder, paste0(mag_name, ".faa")))
    }
    
    # Print summary
    cat("\nSummary:\n")
    cat("Loki MAGs:", length(list.files("loki")), "\n")
    cat("Heimdall MAGs:", length(list.files("heimdall")), "\n")
}

separate_mags(mag_folder, gtdbtk_file)