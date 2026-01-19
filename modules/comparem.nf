process comparem{
    input:
    path 'faa/*'

    output:
    path 'results/aai/*'

    publishDir "${params.output_comparison}/comparem_results",pattern:'results/aai/*', mode: 'copy'

    script:
    """
    comparem aai_wf --genomes faa --file_ext faa --outdir results --cpus ${task.cpus} --proteins
    """
}