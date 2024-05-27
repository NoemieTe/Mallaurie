#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=30G

module load devel/Miniconda/Miniconda3
module load bioinfo/CONCOCT/1.1.0

cut_up_fasta.py ~/work/Assemblage/all_samples.megahit_asm/final.contigs.fa -c 10000 -o 0 --merge_last -b ~/work/Assemblage/contigs_10K.bed > ~/work/Assemblage/contigs_10K.fa
