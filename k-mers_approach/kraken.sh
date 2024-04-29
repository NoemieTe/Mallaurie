#!/bin/bash
##SBATCH -p workq
##SBATCH -t 4-00:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".
##SBATCH --mem=30G
##SBATCH --mail-type=BEGIN,FAIL,END
##SABTCH --mail-user=noemie.teixido@inrae.fr

cd /home/nteixido/work/Mallaurie_data/analyses/trimming
ls *L9HHH_L001_R*.fastq.gz | sed 's/_/\t/g' | awk '{print $1"_"$2}' | uniq > ~/work/Mallaurie_data/analyses/list_id_kraken


while read line; do
        ind=$(echo "$line")
        echo "#!/bin/bash" > kraken_${ind}.sh
        echo "#SBATCH -p workq" >> kraken_${ind}.sh
        echo "#SBATCH -t 4-00:00:00" >> kraken_${ind}.sh
        echo "#SBATCH --mem=100G" >> kraken_${ind}.sh
        echo "module load bioinfo/Kraken2/2.1.2" >> kraken_${ind}.sh
        echo "kraken2 --threads 20 --memory-mapping --db /bank/kraken/k2_nt_20231129 --report /home/nteixido/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/resultat_all_${ind}_kraken2_seq_paired_classees.txt --paired /home/nteixido/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R1.pe.fastq.gz /home/nteixido/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R2.pe.fastq.gz --output /home/nteixido/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/Assignation_taxonomique_kraken/"$ind"_paired_output.txt" >> kraken_${ind}.sh
        echo "kraken2 --threads 20 --memory-mapping --db /bank/kraken/k2_nt_20231129 --report /home/nteixido/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/resultat_${ind}_kraken2_unpaired_R1_classees.txt /home/nteixido/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R1.unpaired.fastq.gz --output /home/nteixido/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/"$ind"_R1_unpaired_output.txt" >> kraken_${ind}.sh
        echo "kraken2 --threads 20 --memory-mapping --db /bank/kraken/k2_nt_20231129 --report /home/nteixido/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/resultat_${ind}_kraken2_unpaired_R2_classees.txt /home/nteixido/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R2.unpaired.fastq.gz --output /home/nteixido/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/"$ind"_R2_unpaired_output.txt" >> kraken_${ind}.sh
        sbatch kraken_${ind}.sh
        #sleep 2
done < /home/nteixido/work/Mallaurie_data/analyses/list_id_kraken
