#!/bin/bash

cd ~/work/Assemblage/concoct_output/fasta_bins/
#ls *.fa > list_bin

while read line; do
        cat "$line" >> ~/work/Assemblage/concoct_output/fasta_bins/all_bins2.fa
done < ~/work/Assemblage/concoct_output/fasta_bins/list_bin
