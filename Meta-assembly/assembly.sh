#!/bin/bash
#SBATCH -p unlimitq
#SBATCH -t 10-00:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".
#SBATCH --mem=50G
#SBATCH --mail-type=BEGIN,FAIL,END
#SABTCH --mail-user=noemie.teixido@inrae.fr

#Load modules
#Need Python
module load devel/python/Python-3.11.1

module load bioinfo/MEGAHIT/1.2.9

cd /home/nteixido/work/Mallaurie_data/Assemblage/Mallaurie
#ls *gz | sed 's/_/\t/g' | awk '{print $1"_"$2"_"$3"_"}' | uniq > list_id

#mkdir /home/nteixido/work/Mallaurie_data/Assemblage/Mallaurie/resultats_assemblage_run1_run2
#cd /home/nteixido/work/Mallaurie_data/Assemblage/Mallaurie
#while read line; do
        #ind=$(echo "$line")
megahit -1 all_samples_R1.pe.fastq -2 all_samples_R2.pe.fastq -r all_samples_R1.unpaired.fastq -r all_samples_R2.unpaired.fastq -r all_samples.unpaired.fastq -o all_samples.megahit_asm
        #megahit -r "$ind"R1.unpaired.fastq.gz -o Run12_R1_unpaired.megahit_asm
        #megahit -r "$ind"R2.unpaired.fastq.gz -o Run12_R2_unpaired.megahit_asm
#done < /home/nteixido/work/Mallaurie_data/Assemblage/Mallaurie/list_id
