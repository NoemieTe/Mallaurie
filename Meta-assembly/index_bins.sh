#!/bin/bash
#SBATCH -p workq
#SBATCH --mem=30G
#SBATCH -t 01:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".

#Load modules
module load bioinfo/bwa-mem2/2.2.1

cd ~/work/Assemblage/concoct_output/fasta_bins/

bwa-mem2 index ~/work/Assemblage/concoct_output/fasta_bins/all_bins.fa
