process gtdbtk {

    input:
    path 'mags/*'

    output:
    path 'gtdbtk.ar53.summary.tsv'
    path 'gtdbtk.bac120.summary.tsv'

    publishDir "${params.output_assessment}/gtdbtk_results",pattern:'gtdbtk.ar53.summary.tsv', mode: 'copy'

    script:
    """
    # set gtdbtk database location
    export GTDBTK_DATA_PATH=${params.gtdbtk_db}

    gtdbtk classify_wf --genome_dir mags --out_dir . --cpus ${task.cpus} --extension fa --skip_ani_screen
    """
}

process rename_mags {
    label 'r_script'

    input:
    path gtdbtk_results
    path 'mags/*'

    output:
    path 'mags/*'

    script:
    """
    rename_mags.R mags ${gtdbtk_results}
    """
}