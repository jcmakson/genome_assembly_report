#!/usr/bin/env bash

#SBATCH --time=23:00:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=jean.makangara@unibe.ch
#SBATCH --job-name="canu_assembly"
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jmakangara/exercises_report/errors/output_assembly_%j.o
#SBATCH --error=/data/users/jmakangara/exercises_report/errors/error_assembly_%j.e


# Move to project directory and set directory variables
cd /data/users/jmakangara/exercises_report

# run the module 

module load UHTS/Assembler/canu/2.1.1

ASSEMBLY_DIR=./assemblies/canu_assembly
INPUT_DIR=./raw_reads/participant_4

canu -d ${ASSEMBLY_DIR} -p pacbio_canu_assembly gridOptions="--mail-user jean.makangara@unibe.ch" \
    genomeSize=126m maxMemory=64 maxThreads=16  -pacbio ${INPUT_DIR}/pacbio/*.fastq.gz  \
    gridEngineResourceOption="--cpus-per-task=THREADS --mem-per-cpu=MEMORY --time=2-00:00:00"