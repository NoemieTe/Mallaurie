#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=30G

module load devel/Miniconda/Miniconda3
module load bioinfo/CONCOCT/1.1.0

concoct_coverage_table.py contigs_10K.bed ~/work/Assemblage/mapping/*.sorted.bam > coverage_table.tsv
