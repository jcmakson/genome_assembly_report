#!/bin/env bash
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=jean.makangara@unibe.ch
#SBATCH --job-name="flye_assembly"
#SBATCH --output=/data/users/jmakangara/exercises_report/errors/output_assembly_%j.o
#SBATCH --error=/data/users/jmakangara/exercises_report/errors/error_assembly_%j.e
#SBATCH --cpus-per-task=12
#SBATCH --time=23:00:00
#SBATCH --mem=256G

# Move to project directory and set directory variables
cd /data/users/jmakangara/exercises_report
#mkdir assemblies

qc_dir="./raw_reads/participant_4"
assembly_dir="./assemblies"
Illumina_dir="$qc_dir/Illumina"
Pacbio_dir="$qc_dir/pacbio"
RNA_dir="$qc_dir/RNAseq"

# Load modules

module load UHTS/Assembler/flye/2.8.3
module load UHTS/Assembler/trinityrnaseq/2.5.1

# Pacbio assembly with flye
#mkdir $assembly_dir/flye_out

flye --pacbio-raw $Pacbio_dir/ERR3415825.fastq.gz $Pacbio_dir/ERR3415826.fastq.gz --genome-size 127m --threads 12 --out-dir $assembly_dir/flye_out2

# Illumina RNA-seq assembly with Trinity
# mkdir $assembly_dir/trinity_out2

# Trinity --seqType fq --left $RNA_dir/SRR1734309_1.fastq.gz --right $RNA_dir/SRR1734309_2.fastq.gz --CPU 12 --max_memory 44G --output $assembly_dir/trinity_out2