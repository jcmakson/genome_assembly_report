#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=BUSCO
#SBATCH --mail-user=jean.makangara@unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jmakangara/exercises_report/errors/output_assembly_%j.o
#SBATCH --error=/data/users/jmakangara/exercises_report/errors/error_assembly_%j.e
#SBATCH --partition=pall

# Move to project directory and set directory variables
cd /data/users/jmakangara/exrcises_report


#Variables for directory pathways
MAIN_PATH_ASSEMBLY=/data/users/jmakangara/exercises_report/assemblies
MAIN_PATH_ASSEMBLY_POLISH=/data/users/jmakangara/exercises_report/polish_output
OUTPUT_DIR=/data/users/jmakangara/exercises_report/evaluation/busco

# Module to run BUSCO assessment
module add UHTS/Analysis/busco/4.1.4;

cd $OUTPUT_DIR

#Make a copy of the augustus config directory to have written permission
cp -r /software/SequenceAnalysis/GenePrediction/augustus/3.3.3.1/config augustus_config
export AUGUSTUS_CONFIG_PATH=./augustus_config

# Run BUSCO for flye, canu and trinity assemblies (not polished)
busco -i ${MAIN_PATH_ASSEMBLY}/flye/assembly.fasta  -o flye_unpolished --lineage brassicales_odb10 -m genome  -f --cpu 16
busco -i ${MAIN_PATH_ASSEMBLY}/canu/pacbio_canu_assembly.contigs.fasta  -o canu_unpolished --lineage brassicales_odb10 -m genome -f --cpu 16
busco -i ${MAIN_PATH_ASSEMBLY}/trinity/Trinity.fasta -o trinity_RNAseq --lineage brassicales_odb10 -m transcriptome  -f --cpu 16

# Run BUSCO for flye and canu (polished)
busco -i ${MAIN_PATH_ASSEMBLY_POLISH}/flye/flye_polished.fasta -o flye_polished --lineage brassicales_odb10 -m genome -f --cpu 16
busco -i ${MAIN_PATH_ASSEMBLY_POLISH}/canu/canu_polished.fasta -o canu_polished --lineage brassicales_odb10 -m genome -f --cpu 16