#!/bin/bash
##SBATCH -p workq
##SBATCH -t 0-04:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".
##SBATCH --mem=20G
##SBATCH --mail-type=BEGIN,FAIL,END
##SABTCH --mail-user=noemie.teixido@inrae.fr

cd /home/nteixido/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/
ls *classees.txt | sed 's/_/\t/g' | awk '{print $1"_"$2"_"$3"_"$4"_"$5"_"$6}' | uniq > list_id_parser

while read line; do
        ind=$(echo "$line")
        python3 ~/work/Mallaurie_data/scripts/script_parser_kraken.py ~/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/"$line"_classees.txt ~/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/parser/"$line"_parser.txt
done < /home/nteixido/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/list_id_parser
