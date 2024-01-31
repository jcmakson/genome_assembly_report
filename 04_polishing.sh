#!/bin/env bash
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=jean.makangara@unibe.ch
#SBATCH --job-name="polishing"
#SBATCH --cpus-per-task=12
#SBATCH --time=1-00:00:00
#SBATCH --mem=53G

# Move to project directory and set directory variables
cd /data/users/jmakangara/exrcises_report

qc_dir="./fastqc/fastqc_output"
assembly_dir="./assemblies"
mapping_dir="./mapping"
Illumina_dir="$qc_dir/"
flye_ass="$assembly_dir/flye_out"
canu_ass="$assembly_dir/canu_assembly"
flye_idx_dir="$mapping_dir/flye_idx"
canu_idx_dir="$mapping_dir/canu_idx"

mkdir $mapping_dir
mkdir $flye_idx_dir
mkdir $canu_idx_dir

# Load modules
module load UHTS/Aligner/bowtie2/2.3.4.1
module load UHTS/Analysis/samtools/1.8

# Rename canu assembly 
mv $canu_ass/pacbio.contigs.fasta $canu_ass/assembly.fasta

# Making indexes
bowtie2-build --threads 12 -f $flye_ass/assembly.fasta $flye_idx_dir/index

bowtie2-build --threads 12 -f $canu_ass/assembly.fasta $canu_idx_dir/index

# Aligning Illumina reads to the two assemblies

bowtie2 -x $flye_idx_dir/index --sensitive-local --threads 12 -1 $Illumina_dir/ERR3624574_1.fastq.gz -2 $Illumina_dir/ERR3624574_2.fastq.gz | samtools view -b -@ 11 | samtools sort -o $mapping_dir/flye.bam
samtools index $mapping_dir/flye.bam

bowtie2 -x $canu_idx_dir/index --sensitive-local --threads 12 -1 $Illumina_dir/ERR3624574_1.fastq.gz -2 $Illumina_dir/ERR3624574_2.fastq.gz | samtools view -b -@ 11 | samtools sort -o $mapping_dir/canu.bam
samtools index $mapping_dir/canu.bam

# Run Pilon for polishing
java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar --genome $flye_ass/assembly.fasta --bam $mapping_dir/flye.bam --threads 12 --output $flye_ass/polished

java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar --genome $canu_ass/assembly.fasta --bam $mapping_dir/canu.bam --threads 12 --output $canu_ass/polished