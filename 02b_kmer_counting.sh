#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4000M
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc_kmer_counting
#SBATCH --mail-user=jean.makangara@unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jmakangara/exercises_report/errors/output_jellyfish_%j.o
#SBATCH --error=/data/users/jmakangara/exercises_report/errors/error_jellyfish_%j.e
#SBATCH --partition=pall

#laod module for jellyfish
#module avail
module load UHTS/Analysis/jellyfish/2.3.0;

#variables

QUALITY_CONTROL_DIR=/data/users/jmakangara/exercises_report/fastqc/kmer_counting
INPUT_DIR=/data/users/jmakangara/exercises_report/raw_reads/participant_4

# set the desired k-mer length

kmer_length=21 #for illumina

# specify the size of the database (adjust as needed)

db_size=100M

# Loops through all FASTQ.gz files in the input directory

jellyfish count \
-m 21 -s 5G -o "$QUALITY_CONTROL_DIR/Illumina_count.jf" -C \
<(zcat ${INPUT_DIR}/Illumina/*.fastq.gz)
jellyfish histo -t 10 "$QUALITY_CONTROL_DIR/Illumina_report.jf" > "$QUALITY_CONTROL_DIR/Illumina_report.histo" 
