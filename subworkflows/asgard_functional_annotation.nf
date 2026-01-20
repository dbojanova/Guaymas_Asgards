#!/usr/bin/env nextflow

// functional annotation of Guaymas and public Asgard MAGs

//import modules
include { prodigal } from '../modules/prodigal.nf'
include { rename_mags } from '../modules/rename_mags.nf'
include { rename_taxa } from '../modules/rename_taxa.nf'
include { separate_mags as guaymas_separate_mags} from '../modules/separate_mags.nf'
include { separate_mags as public_separate_mags} from '../modules/separate_mags.nf'
include { comparem as comparem_loki } from '../modules/comparem.nf'
//include { mebs } from '../modules/mebs.nf'
//include { metabolic } from '../modules/metabolic.nf'
//include { build_diamond_db } from '../modules/diamond.nf'
//include { diamond_search} from '../modules/diamond.nf'
//include { diamond_search as diamond_asgard_guaymas } from '../modules/diamond.nf'

include { hmmer_search_ko } from '../modules/hmmer.nf'
include { hmmer_search_ko as hmmer_ko_asgard_guaymas } from '../modules/hmmer.nf'

include { hmmer_search_pfam } from '../modules/hmmer.nf'
include { hmmer_search_pfam as hmmer_pfam_asgard_guaymas } from '../modules/hmmer.nf'

include { combine_presence_absence as combine_public } from '../modules/hmmer.nf'
include { combine_presence_absence as combine_guaymas } from '../modules/hmmer.nf'


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

    // pull gtdbtk results
    asgard_taxa = Channel.fromPath("${projectDir}/bin/asgard_tax.tsv")
    guaymas_taxa = Channel.fromPath("${projectDir}/bin/gtdbtk.ar122.summary.tsv")

    // add class to name of public mags
    public_mags_ch = rename_taxa(public_mags_ch, asgard_taxa)
    guaymas_mags_ch = rename_mags(predicted_mag_ch, guaymas_taxa)

    //guaymas_separate_mags(predicted_mag_ch,guaymas_gtdbtk)
    //public_separate_mags(public_mags_ch,public_gtdbtk)

    // merge separated mags from guaymas and public datasets
    //all_loki = guaymas_separate_mags.out.loki.mix(public_separate_mags.out.loki)
        //.flatten().collect()
    //all_heimdall = guaymas_separate_mags.out.heimdall.mix(public_separate_mags.out.heimdall)
        //.flatten().collect()

    // aai comparisons with comparem2
    //comparem_loki(all_loki)
    //comparem_heimdall(all_heimdall)

    // mebs annotation
    //mebs(predicted_mag_ch)

    // METABOLIC-G annotation
    //metabolic(predicted_mag_ch)

    // diamond search against hydrogenase database
   //ref_db = build_diamond_db(Channel.fromPath("${projectDir}/bin/nmo_refs.faa"), 'nmo')
    //diamond_search(ref_db, public_mags_ch)
    //diamond_asgard_guaymas(ref_db, predicted_mag_ch)

    //look for ko value of nmo
    ko_public = hmmer_search_ko(Channel.fromPath("${projectDir}/bin/K00459.hmm"), public_mags_ch)
    ko_guaymas = hmmer_ko_asgard_guaymas(Channel.fromPath("${projectDir}/bin/K00459.hmm"), guaymas_mags_ch)

    //look for pfam values of nmo
    pfam_public = hmmer_search_pfam(Channel.fromPath("${projectDir}/bin/PF03060.hmm"), public_mags_ch)
    pfam_guaymas = hmmer_pfam_asgard_guaymas(Channel.fromPath("${projectDir}/bin/PF03060.hmm"), guaymas_mags_ch)

    //combine the presence/absence matrices
    combine_public(
        ko_public.matrix,
        pfam_public.matrix,
        'public'
    )

    combine_guaymas(
        ko_guaymas.matrix,
        pfam_guaymas.matrix,
        'guaymas'
    )
} 