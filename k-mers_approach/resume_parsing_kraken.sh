#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=10G
#SBATCH -p workq
#SBATCH -t 00-01:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".


cd ~/work/Mallaurie_data/analyses/Assignation_taxonomique_kraken/parser/
#ls *_seq_paired_parser.txt | sed 's/_/\t/g' | awk '{print $3"_"$4}' | uniq > list_id_parser_paired

echo "identifiant Un_or_assigned  Percentage_reads_taxa   Nb_reads_taxa_covered_by_clade  Nb_reads_taxa_assigned_directly_to_this_taxon   Rank_code       NBCI_taxonomy_ID        Domain  Kingdom Phylum  Class   Order   Family  Genus   Species" > res_paired_hymenoptera.txt

for fichier in *_paired_parser.txt ; do
        identifiant=$(echo "$fichier" | awk -F'_' '{print $3}')
        res=$(grep -w "O" "$fichier" | grep -w "Hymenoptera" | awk '{print $0}')
        echo "$identifiant $res" >> res_paired_hymenoptera.txt
done
