#!/usr/bin/env nextflow

// functional annotation of Guaymas and public Asgard MAGs

//import modules
include { prodigal } from '../modules/prodigal.nf'
include { separate_mags as guaymas_separate_mags} from '../modules/separate_mags.nf'
include { separate_mags as public_separate_mags} from '../modules/separate_mags.nf'

//include { comparem } from '../modules/comparem.nf'
//include { mebs } from '../modules/mebs.nf'
//include { metabolic } from '../modules/metabolic.nf'
//include { diamond } from '../modules/diamond.nf'
//
//workflow
workflow asgard_functional_annotation{

    take: 
    asgard_mags_ch
    public_mags_ch

    main:

    // gene prediction with Prodigal
    prodigal(asgard_mags_ch)
    predicted_mag_ch = prodigal.out[0]

    // separate mags into Loki and Heimdall folders based on gtdbtk results
    guaymas_gtdbtk = Channel.fromPath("results/guaymas_assessment_results/gtdbtk_results/guaymas_gtdbtk.ar53.summary.tsv")
    public_gtdbtk = Channel.fromPath("results/public_assessment_results/gtdbtk_results/public_gtdbtk.ar53.summary.tsv")

    guaymas_separate_mags(predicted_mag_ch,guaymas_gtdbtk)
    public_separate_mags(public_mags_ch,public_gtdbtk)

    // merge separated mags from guaymas and public datasets
    all_loki = guaymas_separate_mags.out.loki.mix(public_separate_mags.out.loki)
    all_heimdall = guaymas_separate_mags.out.heimdall.mix(public_separate_mags.out.heimdall)

    // ani comparisons with comparem2
    //comparem(predicted_mag_ch)

    // mebs annotation
    //mebs(predicted_mag_ch)

    // METABOLIC-G annotation
    //metabolic(predicted_mag_ch)

    // diamond search against hydrogenase database
    //diamond(predicted_mag_ch)
} 