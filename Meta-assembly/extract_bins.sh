#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=30G

module load devel/Miniconda/Miniconda3
module load bioinfo/CONCOCT/1.1.0

mkdir ~/work/Assemblage/concoct_output/fasta_bins
extract_fasta_bins.py ~/work/Assemblage/all_samples.megahit_asm/final.contigs.fa ~/work/Assemblage/concoct_output/clustering_merged.csv --output_path ~/work/Assemblage/concoct_output/fasta_bins
