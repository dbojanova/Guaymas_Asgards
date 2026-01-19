#!/usr/bin/env nextflow

// Analysis pipeline for Asgard paper 2026

// Import subworkflows
// 1. Guaymas Asgard MAG quality and taxonomic assessment
//include { guaymas_mag_assessment } from './subworkflows/guaymas_mag_assessment.nf'
// 2. Functional annotations of Guaymas and public Asgard MAGs
include { asgard_functional_annotation } from './subworkflows/asgard_functional_annotation.nf'
include { extract_faa } from './modules/extract_faa_zip.nf'


workflow {
    //pull in Guaymas Asgard MAGs
    guaymas_mags_ch = Channel.fromPath('guaymas_mags/*')
        .collect()

    // assess quality and taxonomy of Guaymas Asgard MAGs + rename MAGs with Asgard taxonomy
    //guaymas_mag_assessment(guaymas_mags_ch)

    // pull public mags into channel
    public_zip_mags_ch = Channel.fromPath('public_mags/*')
    public_mags_ch = extract_faa(public_zip_mags_ch).collect()

    //// functional annotation of all Asgard MAGs
    asgard_functional_annotation(guaymas_mags_ch,public_mags_ch)

}