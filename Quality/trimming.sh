#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL

module load bioinfo/Trimmomatic/0.39

cd ~/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/RawData/
ls *fastq.gz | sed 's/_/\t/g' | awk '{print $1"_"$2}' | uniq > tmp_gps # list all the gps

while read line; do
        java -jar /usr/local/bioinfo/src/Trimmomatic/Trimmomatic-0.39/trimmomatic.jar PE -threads 1 -phred33 ~/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/RawData/"$line"_L001_R1.fastq.gz ~/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/RawData/"$line"_L001_R2.fastq.gz ~/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/RawData/Trimmomatic2/"$line"_L001_R1.pe.fastq.gz ~/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/RawData/Trimmomatic2/"$line"_L001_R1.unpaired.fastq.gz ~/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/RawData/Trimmomatic2/"$line"_L001_R2.pe.fastq.gz ~/work/Mallaurie_data/Project_MALLAURIE.2145/Run_GENO-Mallaurie-run-test.21285/RawData/Trimmomatic2/"$line"_L001_R2.unpaired.fastq.gz ILLUMINACLIP:/usr/local/bioinfo/src/Trimmomatic/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50
done < tmp_gps
