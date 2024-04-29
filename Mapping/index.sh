#!/bin/bash
#SBATCH -p workq
#SBATCH --mem=30G
#SBATCH -t 01:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".

#Load modules
module load bioinfo/bwa-mem2/2.2.1

bwa-mem2 index GCA_003314205.2_INRA_AMelMel_1.1_genomic.fna
