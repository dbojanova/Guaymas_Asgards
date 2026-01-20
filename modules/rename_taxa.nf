process rename_taxa {
    label 'r_script'

    input:
    path "mags/"
    path "taxa.tsv"

    output:
    path 'renamed_mags/*', emit: loki

    script:
    """
    Rscript ${projectDir}/bin/rename_mags.R mags taxa.tsv
    """
}