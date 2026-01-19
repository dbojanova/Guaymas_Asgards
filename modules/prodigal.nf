process prodigal {

    input:
    path 'mags/*'

    output:
    path 'faa/*'
    path 'fna/*'
    path 'gbk/*'

    publishDir "${params.output_annotation}/prodigal_results",pattern:'faa/*', mode: 'copy'
    publishDir "${params.output_annotation}/prodigal_results/fna",pattern:'fna/*', mode: 'move'
    publishDir "${params.output_annotation}/prodigal_results/gtb",pattern:'gbk/*', mode: 'move'

    script:
    """
    for mag in mags/*; do
        mkdir -p gbk/
        mkdir -p fna/
        mkdir -p faa/
    
        base=\$(basename \$mag)
        prodigal -i \$mag -a faa/\${base}.faa -d fna/\${base}.fna -o gbk/\${base%.fa}.gbk -f gbk -p anon
    done
    """
}