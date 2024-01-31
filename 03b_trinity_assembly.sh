#!/bin/env bash
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=jean.makangara@unibe.ch
#SBATCH --job-name="assembly"
#SBATCH --output=/data/users/jmakangara/exercises_report/errors/output_assembly_%j.o
#SBATCH --error=/data/users/jmakangara/exercises_report/errors/error_assembly_%j.e
#SBATCH --cpus-per-task=12
#SBATCH --time=23:00:00
#SBATCH --mem=48G

# Move to project directory and set directory variablesfg
cd /data/users/jmakangara/exercises_report
#mkdir assemblies

qc_dir="./raw_reads/participant_4"
assembly_dir="./assemblies"
Illumina_dir="$qc_dir/Illumina"
Pacbio_dir="$qc_dir/pacbio"
RNA_dir="$qc_dir/RNAseq"

# Load modules
# module avail 
module load UHTS/Assembler/trinityrnaseq/2.5.1

# Illumina RNA-seq assembly with Trinity
mkdir $assembly_dir/trinity_output

# Trinity --seqType fq --left $RNA_dir/*1.fastq.gz --right $RNA_dir/*2.fastq.gz --CPU 12 --max_memory 44G --output $assembly_dir/trinity_output
Trinity --seqType fq \
        --left $Illumina_dir/*1.fastq.gz \
        --right $Illumina_dir/*2.fastq.gz --CPU 12 --max_memory 44G \
        --output $assembly_dir/trinity_output