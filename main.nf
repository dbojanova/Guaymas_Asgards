#!/usr/bin/env nextflow

// Analysis pipeline for Asgard paper 2026

// Import subworkflows
// 1. Guaymas Asgard MAG quality and taxonomic assessment
include { guaymas_mag_assessment } from './subworkflows/guaymas_mag_assessment.nf'
// 2. Functional annotations of Guaymas and public Asgard MAGs
//include { asgard_functional_annotation } from './subworkflows/asgard_functional_annotation.nf'


workflow {
    //pull in Guaymas Asgard MAGs
    guaymas_mags_ch = Channel.fromPath('guaymas_mags/*')
        .collect()

    // assess quality and taxonomy of Guaymas Asgard MAGs + rename MAGs with Asgard taxonomy
    guaymas_mag_assessment(guaymas_mags_ch)

    // combine renamed Guaymas Asgard MAGs with public Asgard MAGs
    //asgard_mags_ch = Channel.fromPath('public_asgard_mags/*'))
    //    .mix(guaymas_mag_assessment.out)
    //    .collect()
//
    //// functional annotation of all Asgard MAGs
    //asgard_functional_annotation(asgard_mags_ch)

}