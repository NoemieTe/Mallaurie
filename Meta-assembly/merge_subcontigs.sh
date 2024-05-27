#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=30G

module load devel/Miniconda/Miniconda3
module load bioinfo/CONCOCT/1.1.0

merge_cutup_clustering.py ~/work/Assemblage/concoct_output/clustering_gt1000.csv > ~/work/Assemblage/concoct_output/clustering_merged.csv
