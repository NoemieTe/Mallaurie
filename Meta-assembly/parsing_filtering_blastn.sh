#!/bin/bash
#SBATCH --mem=20G

# parameters:
identitymin=$(echo "90" | bc)
tolerance=$(echo "0.75")
tolerancescore=$(echo "$tolerance" | bc)
thresholdminscore=$(echo "250" | bc)

# input/output
inputfile=$(echo "$1") # name of the xml file e.g. resultats_101_blastn.xml
outputfile=$(echo "$1.filtered.minidentity$identitymin.minscore$thresholdminscore.tolbestscore$tolerance.resblastn.txt") #

# 1/ parse the xml results using the python script
python3 parsing_blastn_xml.py $inputfile $outputfile.tmp

# 2/ extract the list of unique contigs
awk '{print $1}' $outputfile.tmp | sort | uniq > $outputfile.list.tmp

# 3/ filter the blastn results based on the score and the identity
# print the header
echo -e "queryID\tsubjectID\tpc_identity\tlength_alignment\tmismatches\tgapopens\tquery_start\tquery_end\tsubject_start\tsubject_end\te_value\tscore\tsubject_definition" > $outputfile
# then perform the loop by unique contig
while read contigID; do
        grep "$contigID" $outputfile.tmp > $outputfile.contig.tmp
        while read line; do
                #field=$(echo "$line" | awk '{print $12}' | grep "e")
                #if [ -z "$field ]; then
                #       echo $line > $outputfile.contig.tmp2
                #else
                newfield12=$(echo "$line" | awk -F "\t" '{print $12}' | awk -F"e" 'BEGIN{OFMT="%10.10f"} {print $1 * (10 ^ $2)}' | awk -F"." '{print $1}')
                rest_line=$(echo "$line" | awk -F "\t" '{print $1"      "$2"    "$3"    "$4"    "$5"    "$6"    "$7"    "$8"    "$9"    "$10"   "$11}')
                last_field=$(echo "$line" | awk -F "\t" '{print $13}') # species_name
                echo "$rest_line        $newfield12     $last_field" >> $outputfile.contig.tmp2
                #fi
        done < $outputfile.contig.tmp
        sort -nr -k12  $outputfile.contig.tmp2 > $outputfile.contig.tmp3
        #head $outputfile.contig.tmp
        #echo "###############"
        #head $outputfile.contig.tmp2
        #echo "###############"
        #head $outputfile.contig.tmp3

        scoremax=0
        #echo "#########################################################################"
        #echo "$contigID"
        #head -2 $outputfile.contig.tmp
        #echo "#########################################################################i"
        while read line; do
                currentscore=$(echo "$line" | awk -F "\t" '{print $12}' |  bc)
                currentscore2=$(echo "scale=0; $currentscore / 1" | bc) # round current score
                currentidentity=$(echo "$line" |awk -F "\t"  '{print $3}' | bc)
                currentidentity2=$(echo "scale=0; $currentidentity / 1" | bc) # round current identity
                # if first round of the loop
                if [ "$scoremax" == "0" ]; then
                        scoremax=$(echo "$line" | awk -F "\t" '{print $12}' | bc)
                        #echo "$scoremax $currentscore $currentscore2 $currentidentity $currentidentity2"
                        thresholdscoremax=$(echo "scale=0; ($scoremax * $tolerancescore) / 1" | bc )
                        thresholdminscore=$(echo "250" | bc)
                        #echo "$thresholdscoremax"
                        #echo "$currentidentity $currentidentity2 $identitymin"
                        if [ $currentidentity2 -ge $identitymin ] && [ $scoremax -ge $thresholdminscore ]; then
                                echo "$line" >> $outputfile
                        else
                                #echo "ignored"
                                thresholdscoremax=$(echo "10000000" | bc) # unrealistically high score to exclude the results when the best hit exhibit low identity score
                        fi
                elif [ $currentscore2 -ge $thresholdscoremax ] && [ $currentidentity2 -ge $identitymin ] && [ $scoremax -ge $thresholdminscore ]; then
                        echo "$line" >> $outputfile
                else
                        continue
                fi
        done < $outputfile.contig.tmp3
        rm $outputfile.contig.tmp $outputfile.contig.tmp2 $outputfile.contig.tmp3
done < $outputfile.list.tmp
rm $outputfile.tmp $outputfile.list.tmp
