process prodigal {

    input:
    path 'mags/*'

    output:
    path 'faa/*'
    path 'fna/*'
    path 'gbk/*'

    publishDir "${params.output_annotation}/prodigal_results",pattern:'faa/*', mode: 'copy'
    publishDir "${params.output_annotation}/prodigal_results/fna",pattern:'fna/*', mode: 'copy'
    publishDir "${params.output_annotation}/prodigal_results/gtb",pattern:'gbk/*', mode: 'copy'

    script:
    """
    for mag in mags/*; do
        mkdir -p gbk/
        mkdir -p fna/
        mkdir -p faa/
    
        base=\$(basename \$mag)
        prodigal -i \$mag -a faa/\${base%.fa}.faa -d fna/\${base%.fa}.fna -o gbk/\${base%.fa}.gbk -f gbk -p meta

        # clean up headers and remove trailing asterisks
        sed -i '/^>/ s/ .*//' "faa/\${base%.fa}.faa"
        sed -i 's/\\*\$//' "faa/\${base%.fa}.faa"
    done
    """
}