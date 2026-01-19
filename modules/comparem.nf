process comparem{
    input:
    path 'mags/*'

    output:
    path 'results/aai/*'

    publishDir "${params.output_comparison}/comparem_results",pattern:'results/aai/*', mode: 'copy'

    script:
    """
    comparem aai_wf mags results --file_ext faa --cpus ${task.cpus} --proteins
    """
}