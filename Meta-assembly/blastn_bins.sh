#!/bin/bash
#SBATCH -p unlimitq
#SBATCH -t 10-00:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".
#SBATCH --mem=50G

cd ~/work/Assemblage/concoct_output/fasta_bins/
ls *.fa | sed 's/\./\t/g' | awk '{print $1}' | uniq > ~/work/Assemblage/list_id_blastn

cd ~/work/Assemblage/script/

while read line; do
        ind=$(echo "$line")
        echo "#!/bin/bash" > blastn_${ind}.sh
        echo "#SBATCH -p workq" >> blastn_${ind}.sh
        echo "#SBATCH -t 04-00:00:00" >> blastn_${ind}.sh
        echo "#SBATCH --mem=50G" >> blastn_${ind}.sh
        echo "module load bioinfo/NCBI_Blast+/2.10.0+" >> blastn_${ind}.sh
        echo "blastn -query /home/nteixido/work/Assemblage/concoct_output/fasta_bins/${ind}.fa -db nt -out /home/nteixido/work/Assemblage/resultats_${ind}_blastn.txt -outfmt 6" >> blastn_${ind}.sh
        echo "blastn -query /home/nteixido/work/Assemblage/concoct_output/fasta_bins/${ind}.fa -db nt -out /home/nteixido/work/Assemblage/resultats_${ind}_blastn.xml -outfmt 5" >> blastn_${ind}.sh
        sbatch blastn_${ind}.sh
done < ~/work/Assemblage/list_id_blastn
