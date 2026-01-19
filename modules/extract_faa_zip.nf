process extract_faa {
    input:
    path zip_file

    output:
    path 'extracted/01_faa/*.faa', emit: mags

    script:
    """
    mkdir -p extracted
    unzip ${zip_file} -d extracted/

    for f in extracted/01_faa/*.faa; do

        # rename if it has .fna.faa suffix
        if [[ "\$f" == *.fna.faa ]]; then
            newname=\${f/.fna.faa/.faa}
            mv "\$f" "\$newname"
            f="\$newname"
        fi
        
        # clean up headers and remove trailing asterisks
        sed -i '/^>/ s/ .*//' "\$f"
        sed -i 's/\\*\$//' "\$f"
    done
    """
}