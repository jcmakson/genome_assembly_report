#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4000M
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --mail-user=jean.makangara@unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jmakangara/exercises_report/errors/output_fastqc_%j.o
#SBATCH --error=/data/users/jmakangara/exercises_report/errors/error_fastqc_%j.e
#SBATCH --partition=pall

#laod module for quality control fastQC and MutliQC
#module avail
module load UHTS/Quality_control/fastqc/0.11.9;
module load UHTS/Analysis/MultiQC/1.8;

#variables
QUALITY_CONTROL_DIR=/data/users/jmakangara/exercises_report/fastqc/fastqc_output
INPUT_DIR=/data/users/jmakangara/exercises_report/raw_reads/participant_4

fastqc  ${INPUT_DIR}/Illumina/*.fastq.gz  ${INPUT_DIR}/pacbio/*.fastq.gz  ${INPUT_DIR}/RNAseq/*.fastq.gz \
 --t 4 \
 --outdir $QUALITY_CONTROL_DIR \

cd $QUALITY_CONTROL_DIR
multiqc .