#!/bin/bash
#SBATCH -p workq
#SBATCH -t 10 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".

#Load modules
module load bioinfo/FastQC/0.12.1

cd ~/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/Run2/RawData/
ls *fastq.gz | sed 's/_/\t/g' | awk '{print $1"_"$2}' | uniq > tmp1_gps # list all the gps

while read line; do
        fastqc -o /home/nteixido/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/Run2/RawData/ /home/nteixido/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/Run2/RawData/"$line"_L001_R1.fastq.gz /home/nteixido/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/Run2/RawData/"$line"_L001_R2.fastq.gz
done < tmp1_gps
