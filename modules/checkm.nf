process checkm {
    input:
    path 'mags/*'

    output:
    path 'asgard_checkm_results.tsv'

    publishDir "${params.output_assessment}/checkm_results", mode: 'move'

    script:
    """
    checkm lineage_wf mags/ . -x fa -f asgard_checkm_results.tsv --tab_table -t ${task.cpus}
    """
}