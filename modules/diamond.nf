process build_diamond_db {
    label 'diamond'
    
    input:
    path reference_faa
    val gene_name
    
    output:
    path "${gene_name}_db.dmnd"
    
    script:
    """
    diamond makedb --in ${reference_faa} -d ${gene_name}_db
    """
}

process diamond_search {
    label 'diamond'
    
    input:
    path diamond_db            
    path 'mags/*'
    
    output:
    path 'results/*'
    
    script:
    """
    mkdir -p results
    
    for mag in mags/*.faa; do
        base=\$(basename \$mag .faa)
        diamond blastp \
            -d ${diamond_db} \
            -q \$mag \
            -o temp_\${base}_hits.tsv \
            --outfmt 6 \
            --id 70 \
            --max-target-seqs 10 \
            --evalue 1e-5 \
            --threads 4

        #only keep files with hits
        if [ -s temp_\${base}_hits.tsv ]; then
            mv temp_\${base}_hits.tsv results/\${base}_hits.tsv
        else
            rm temp_\${base}_hits.tsv
        fi
        
    done

    echo "MAGs with hits: \$(ls results/ 2>/dev/null | wc -l)"
    """
}