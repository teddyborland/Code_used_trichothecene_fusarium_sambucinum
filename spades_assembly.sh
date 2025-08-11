#!/bin/bash

# Spades portion of the script
# Directory where your paired-end reads are stored
READS_DIR="/path/to/cleaned_reads"

# Output directory for SPAdes assemblies
SPADES_DIR="/path/to/spades_output_dir"
mkdir -p "$SPADES_DIR"

# Loop through the read pairs in the READS_DIR; for running 1 sample, specify sample name in place of *_cleaned.fastq.gz
for read_pair in ${READS_DIR}/*_R1_cleaned.fastq.gz; do
    # Extract the sample name based on the read file naming convention
    sample_name=$(basename "${read_pair}")
    sample_name="${sample_name%%_*}"
    
    # Define the paths for R1 and R2 reads
    r1_reads="${READS_DIR}/${sample_name}_R1_cleaned.fastq.gz"
    r2_reads="${READS_DIR}/${sample_name}_R2_cleaned.fastq.gz"

    echo "Running assembly for ${sample_name}..."
    echo "R1 reads: ${r1_reads}"
    echo "R2 reads: ${r2_reads}"

    # Define the output directory for the current sample
    sample_output="${SPADES_DIR}/${sample_name}_assembly"
    
    # Create the output directory if it doesn't exist
    mkdir -p "${sample_output}"
    
    # Run SPAdes
    spades.py --isolate -1 "${r1_reads}" -2 "${r2_reads}" -o "${sample_output}" -t 8 -m 150
    
    echo "Assembly for ${sample_name} completed."
done

 echo "All assemblies completed."
