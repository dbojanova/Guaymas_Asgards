process separate_mags {
    label 'r_script'

    input:
    path mags
    path gtdbtk_results

    output:
    path 'loki/*', emit: loki
    path 'heimdall/*', emit: heimdall

    script:
    """
    parse_loki_heim.R ${mags} ${gtdbtk_results}
    """
}