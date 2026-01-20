#!/usr/bin/env nextflow

// Quality and taxonomic assesssments of Guaymas MAGs obtained from Bojanova et al. (2023) Well Hidden Methanogenesis

include { checkm} from '../modules/checkm.nf'
include { gtdbtk } from '../modules/gtdbtk.nf'
//include { rename_mags } from '../modules/gtdbtk.nf'

workflow guaymas_mag_assessment{

    take: guaymas_mags_ch

    main:
    // taxonomic classification
    gtdbtk(guaymas_mags_ch)

    // renaming of mags with proper taxonomic information
    // renamed_mags_ch = rename_mags(gtdbtk.out,guaymas_mags_ch)

    // check genome quality
    //checkm(guaymas_mags_ch)
}