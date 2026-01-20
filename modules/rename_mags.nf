process rename_mags {
    label 'r_script'
    
    input:
    path "mags/*"
    path "gtdbtk.tsv"
    
    output:
    path 'renamed_mags/*'
    
    script:
    """
    Rscript ${projectDir}/bin/rename_mags.R mags gtdbtk.tsv
    """
}