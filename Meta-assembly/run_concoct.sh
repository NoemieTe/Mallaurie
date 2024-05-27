#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=30G

module load devel/Miniconda/Miniconda3
module load bioinfo/CONCOCT/1.1.0

concoct --composition_file contigs_10K.fa --coverage_file coverage_table.tsv -b concoct_output/
