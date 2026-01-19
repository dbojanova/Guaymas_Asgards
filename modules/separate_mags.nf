process separate_mags {
    label 'r_script'

    input:
    path "mags/"
    path "gtdbtk.tsv"

    output:
    path 'loki/*', emit: loki
    path 'heimdall/*', emit: heimdall

    script:
    """
    Rscript ${projectDir}/bin/parse_loki_heim.R mags gtdbtk.tsv
    """
}