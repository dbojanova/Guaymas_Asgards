process hmmer_search_ko {
    label 'hmmer'

    input:
    path hmm
    path 'mags/*'
    
    output:
    path 'results/*.tsv', emit: hits
    path 'nmo_seqs_K00459.faa', emit: seqs
    path 'nmo_presence_absence.tsv', emit: matrix

    publishDir "${params.output_annotation}/hmmer_results/", mode: 'copy', pattern: 'nmo_seqs_K00459.faa'
   
    script:
    """
    mkdir -p results

    for mag in mags/*.faa; do
        base=\$(basename \$mag .faa)

        hmmsearch \
            --domtblout results/\${base}_domain_hits.tsv \
            --domT 152.43 \
            --cpu 4 \
            ${hmm} \
            \$mag > /dev/null

        # check for hits
        grep -v "^#" results/\${base}_domain_hits.tsv > temp_filtered.tsv 2>/dev/null || true
        
        if [ -s temp_filtered.tsv ]; then
            awk '!/^#/ {print \$1}' results/\${base}_domain_hits.tsv > hit_ids.txt
            seqtk subseq \$mag hit_ids.txt >> all_hits.faa
            echo "\${base}\t1" >> presence_data.tsv
        else
            echo "\${base}\t0" >> presence_data.tsv
        fi
        
        rm -f temp_filtered.tsv hit_ids.txt
    done

    # create presence/absence matrix
    echo -e "MAG\tK00459" > nmo_presence_absence.tsv
    sort presence_data.tsv >> nmo_presence_absence.tsv

    # extract hit sequences
    if [ -f all_hits.faa ]; then
        mv all_hits.faa nmo_seqs_K00459.faa
    else
        touch nmo_seqs_K00459.faa
    fi

    echo "MAGs with K00459 hits: \$(awk '\$2==1{c++} END{print c+0}' nmo_presence_absence.tsv)"
    """
}

process hmmer_search_pfam {
    label 'hmmer'
    
    input:
    path hmm
    path 'mags/*'
    
    output:
    path 'results/*.tsv', emit:hits
    path 'nmo_seqs_PF03060.faa', emit:seqs
    path 'nmo_presence_absence.tsv', emit:matrix

    publishDir "${params.output_annotation}/hmmer_results/", mode: 'copy', pattern: 'nmo_seqs_PF03060.faa'
    
    script:
    """
    mkdir -p results

    for mag in mags/*.faa; do
        base=\$(basename \$mag .faa)

        # Search with HMMER
        hmmsearch \
            --domtblout results/\${base}_domain_hits.tsv \
            --cut_ga \
            --cpu 4 \
            ${hmm} \
            \$mag > /dev/null

        # Filter out comment lines and check for hits
        grep -v "^#" results/\${base}_domain_hits.tsv > temp_filtered.tsv 2>/dev/null || true
        
        if [ -s temp_filtered.tsv ]; then
            awk '!/^#/ {print \$1}' results/\${base}_domain_hits.tsv > hit_ids.txt
            seqtk subseq \$mag hit_ids.txt >> all_hits.faa
            echo "\${base}\t1" >> presence_data.tsv
        else
            echo "\${base}\t0" >> presence_data.tsv
        fi
        
        rm -f temp_filtered.tsv hit_ids.txt
    done
    
    echo -e "MAG\tPF03060" > nmo_presence_absence.tsv
    sort presence_data.tsv >> nmo_presence_absence.tsv
    
    if [ -f all_hits.faa ]; then
        mv all_hits.faa nmo_seqs_PF03060.faa
    else
        touch nmo_seqs_PF03060.faa
    fi

    echo "MAGs with PF03060 hits: \$(awk '\$2==1{c++} END{print c+0}' nmo_presence_absence.tsv)"
    """
}   

process combine_presence_absence {
    
    input:
    path ko_public
    path ko_guaymas
    path pfam_public
    path pfam_guaymas
    
    output:
    path "nmo_combined_presence_absence.tsv"

    publishDir "${params.output_dir}/hmmer_results", mode: 'copy'
    
    script:
    """
    #!/usr/bin/env python3
    import pandas as pd
    
    # Read all matrices
    ko_pub = pd.read_csv("${ko_public}", sep="\t")
    ko_guy = pd.read_csv("${ko_guaymas}", sep="\t")
    pfam_pub = pd.read_csv("${pfam_public}", sep="\t")
    pfam_guy = pd.read_csv("${pfam_guaymas}", sep="\t")
    
    # Standardize column names (all use same gene names)
    ko_pub.columns = ["MAG", "K00459"]
    ko_guy.columns = ["MAG", "K00459"]
    pfam_pub.columns = ["MAG", "PF03060"]
    pfam_guy.columns = ["MAG", "PF03060"]
    
    # Combine public and guaymas for each gene
    ko_combined = pd.concat([ko_pub, ko_guy], ignore_index=True)
    pfam_combined = pd.concat([pfam_pub, pfam_guy], ignore_index=True)
    
    # Merge on MAG
    combined = ko_combined.merge(pfam_combined, on="MAG", how="outer")
    
    # Fill NAs with 0
    combined = combined.fillna(0).astype({"K00459": int, "PF03060": int})
    
    # Sort by MAG name
    combined = combined.sort_values("MAG")
    
    # Save
    combined.to_csv("nmo_combined_presence_absence.tsv", sep="\t", index=False)
    """
}