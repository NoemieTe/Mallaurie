#!/bin/bash
#SBATCH -p workq
#SBATCH -t 100 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".

cd ~/work/Assemblage/concoct_output/fasta_bins/
ls *.fa > list_bin

cd ~/work/Assemblage/script/stats/

while read line; do
        ind=$(echo "$line")
        echo "#!/bin/bash" > bin_"$ind".fa.assemblathon.stats.sh
        echo "#SBATCH -p workq" >> bin_"$ind".fa.assemblathon.stats.sh
        echo "#SBATCH -t 100" >> bin_"$ind".fa.assemblathon.stats.sh
        echo "module load statistics/R/4.2.2" >> bin_"$ind".fa.assemblathon.stats.sh
        echo "module load bioinfo/assemblathon2/d1f044b" >> bin_"$ind".fa.assemblathon.stats.sh
        echo "assemblathon_stats.pl ~/work/Assemblage/concoct_output/fasta_bins/"$ind" > ~/work/Assemblage/statsbins/bin_"$ind".fa.assemblathon.stats" >> bin_"$ind".fa.assemblathon.stats.sh
        sbatch bin_"$ind".fa.assemblathon.stats.sh
done < ~/work/Assemblage/concoct_output/fasta_bins/list_bin
