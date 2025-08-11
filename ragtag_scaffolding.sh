#!/bin/bash

hostname
date

# Path to reference file
REFERENCE_FA="/path/to/reference_genome"

# Path to query directory
QUERY_DIR="/path/to/target_genome"

RAGTAG_OUTPUT="/path/to/ragtag_output_dir"
mkdir -p "$RAGTAG_OUTPUT"

# For loop to iteratively run through each query fasta file
for QUERY_FASTA in $QUERY_DIR/*.fasta; do
    
    # Index the query fasta file (if it hasn't been done already)
    samtools faidx $QUERY_FASTA 

    # Extract filename
    ASSEMBLY_NAME=$(basename "$QUERY_FASTA" _cleaned_contigs.fasta)

    # Output directory
    OUTPUT_DIR="$RAGTAG_OUTPUT/$ASSEMBLY_NAME"
    # Make output dir if it doesn't exist
    mkdir -p "$OUTPUT_DIR"
    
    # Run ragtag
	echo "ragtag.py scaffold $REFERENCE_FA $QUERY_FASTA -o $OUTPUT_DIR -C -t 20"
    ragtag.py scaffold $REFERENCE_FA $QUERY_FASTA -o $OUTPUT_DIR -C -t 20

    echo "ragtag run completed for sample $ASSEMBLY_NAME. Results are in $OUTPUT_DIR"
done

hostname
date
