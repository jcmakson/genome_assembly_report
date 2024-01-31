#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=QUAST
#SBATCH --mail-user=jean.makangara@unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jmakangara/exercises_report/errors/output_assembly_%j.o
#SBATCH --error=/data/users/jmakangara/exercises_report/errors/error_assembly_%j.e
#SBATCH --partition=pall

# Move to project directory and set directory variables
cd /data/users/jmakangara/exrcises_report

#Variables for directory pathways
MAIN_PATH_ASSEMBLY=./assemblies
MAIN_PATH_ASSEMBLY_POLISH=./polish_output
OUTPUT_DIR=./evaluation/quast
REFERENCE_DIR=/data/courses/assembly-annotation-course/references


# Module to run QUAST assessment
module load UHTS/Quality_control/quast/4.6.0;
SIZE_REFERENCE=133725193

# Run quast for flye and canu (polished or not) with reference
python /software/UHTS/Quality_control/quast/4.6.0/bin/quast.py \
        ${MAIN_PATH_ASSEMBLY}/canu/pacbio_canu_assembly.contigs.fasta ${MAIN_PATH_ASSEMBLY_POLISH}/canu/canu_polished.fasta ${MAIN_PATH_ASSEMBLY}/flye/assembly.fasta ${MAIN_PATH_ASSEMBLY_POLISH}/flye/flye_polished.fasta \
        -R ${REFERENCE_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz \
        -G ${REFERENCE_DIR}/TAIR10_GFF3_genes.gff -l "canu_assembly, canu_polished, flye_assembly, flye_polished"  -o ${OUTPUT_DIR}/canu_flye_with_reference  \
        --eukaryote --min-contig 3000 --min-alignment 500 --extensive-mis-size 7000 --threads 12


# Run quast for flye and canu (polished or not) without reference
python /software/UHTS/Quality_control/quast/4.6.0/bin/quast.py \
        ${MAIN_PATH_ASSEMBLY}/flye/assembly.fasta ${MAIN_PATH_ASSEMBLY_POLISH}/flye/flye_polished.fasta \
        ${MAIN_PATH_ASSEMBLY}/canu/pacbio_canu_assembly.contigs.fasta ${MAIN_PATH_ASSEMBLY_POLISH}/canu/canu_polished.fasta \
        -l "flye_assembly_no_ref, flye_polished_no_ref, canu_assembly_no_ref, canu_polished_no_ref"  -o ${OUTPUT_DIR}/canu_flye_without_reference \
        --threads 12 --eukaryote --no-sv --est-ref-size ${SIZE_REFERENCE} --min-alignment 500 --extensive-mis-size 7000 