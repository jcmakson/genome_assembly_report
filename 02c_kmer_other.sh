#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=50G
#SBATCH --time=04:00:00
#SBATCH --job-name=fastqc_kmer_counting
#SBATCH --mail-user=jean.makangara@unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jmakangara/exercises_report/errors/output_jellyfish_%j.o
#SBATCH --error=/data/users/jmakangara/exercises_report/errors/error_jellyfish_%j.e
#SBATCH --partition=pall

cd /data/users/jmakangara/exercises_report
#mkdir kmer # (create an output folder if it does not exist)
cd kmer

# run the module after checking if the module is available

#moudele avail 
module load UHTS/Analysis/jellyfish/2.3.0

# run the kmer-counting using jellyfish, precise the number of kmer -m option, size of data base -s option, -t the number of cpus

#jellyfish count -C -m 21 -s 5G -o Illumina.jf -t 4 <(zcat /data/users/jmakangara/exercises_report/raw_reads/participant_4/Illumina/ERR3624574_1.fastq.gz) <(zcat /data/users/jmakangara/exercises_report/raw_reads/participant_4/Illumina/ERR3624574_2.fastq.gz)
jellyfish count -C -m 100 -s 5G -o pacbio_100.jf -t 64 <(zcat /data/users/jmakangara/exercises_report/raw_reads/participant_4/pacbio/ERR3415825.fastq.gz) <(zcat /data/users/jmakangara/exercises_report/raw_reads/participant_4/pacbio/ERR3415826.fastq.gz)
jellyfish count -C -m 100 -s 5G -o RNAseq_100.jf -t 64 <(zcat /data/users/jmakangara/exercises_report/raw_reads/participant_4/RNAseq/SRR1734309_1.fastq.gz) <(zcat /data/users/jmakangara/exercises_report/raw_reads/participant_4/RNAseq/SRR1734309_2.fastq.gz)

# run the jellyfish histo to generate an histogramm using genome

#jellyfish histo -t 10 Illumina.jf > ../fastqc/kmer_counting/Illumina.histo
jellyfish histo -t 10 pacbio_100.jf > ../fastqc/kmer_counting/pacbio_100.histo
jellyfish histo -t 10 RNAseq_100.jf > ../fastqc/kmer_counting/RNAseq.histo