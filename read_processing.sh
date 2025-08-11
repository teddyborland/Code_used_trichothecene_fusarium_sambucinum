#!/bin/bash

hostname
date

# specify the directory containing the files
RAWREADS_DIR="/path/to/raw_reads_dir"

# The input directory for FASTQ files should be the same as the RAWREADS_DIR set above

# Specify the output directory for cleaned files
CLEANEDREADS_DIR="/path/to/cleaned_reads"
mkdir -p $CLEANEDREADS_DIR

# Iterate over a list of FASTQ files with a common identifier in the specified directory
for file_path in $RAWREADS_DIR/*_001.fastq.gz; do
         # Extract the file name without the directory path
    filename=$(basename "${file_path}")

         # Extract the common identifier from the filename using sed
    identifier=$(echo "${filename}" | sed 's/\([^_]*\).*$/\1/')

   # Set the adapter sequence to match standard nextera adapters
    adapter_sequence="CTGTCTCTTATA"

         # Print a message indicating the current sample being processed
    echo "cleaning sample ${identifier}"

         # Use cutadapt to trim adapters from paired-end reads
    cutadapt -a "${adapter_sequence}" -A "${adapter_sequence}" --nextseq-trim=20 -m 1 -o $CLEANEDREADS_DIR/"${identifier}_R1_cleaned.fastq.gz" -p $CLEANEDREADS_DIR/"${identifier}_R2_cleaned.fastq.gz" $RAWREADS_DIR/"${identifier}_R1_001.fastq.gz" $RAWREADS_DIR/"${identifier}_R2_001.fastq.gz" >> $CLEANEDREADS_DIR/"cutadapt.log"

done

echo "Read cleaning completed"
date

# The directory containing the cleaned-up reads should be the CLEANEDREADS_DIR from above


CLEANEDFASTQC_DIR="/path/to/cleaned_reads_fastqc_results"
mkdir -p $CLEANEDFASTQC_DIR

# Loop over the cleaned-up read files
for file in $CLEANEDREADS_DIR/*.fastq.gz; do
    # Run FastQC on each file
    echo "Running FastQC on $file"

    fastqc --noextract -o $CLEANEDFASTQC_DIR "$file"
done

echo "FastQC analysis completed"
date

hostname
date
