#!/bin/python

# TL - 060424 script to parse the information from the reports of kraken2
import sys
import re
filekraken = open(sys.argv[1],"r")
outputfile = open(sys.argv[2],"w")

# add a header
header="Un_or_assigned"+"\t"+"Percentage_reads_taxa"+"\t"+"Nb_reads_taxa_covered_by_clade"+"\t"+"Nb_reads_taxa_assigned_directly_to_this_taxon"+"\t"+"Rank_code"+"\t"+"NBCI_taxonomy_ID"
header=header+"\t"+"Domain"+"\t"+"Kingdom"+"\t"+"Phylum"+"\t"+"Class"+"\t"+"Order"+"\t"+"Family"+"\t"+"Genus"+"\t"+"Species"+"\n"
outputfile.write(header)
# read the report and parse it
for line in filekraken:
        line = line.strip()
        #print(line)
        spline= re.split('\s+', line)
        #print(spline)
        pc_reads_taxa=spline[0]
        nb_reads_taxa=spline[1]
        nb_reads_directly_taxa=spline[2]
        current_taxonomy_rank=spline[3]
        NBCI_taxonomy_ID=spline[4]
        current_taxon_name=spline[5]
        # below I read line by line, if I go down in the taxonomy rank, I keep the information from the previous lines, if I go up I remove remove the information by replacing with "---"
        # Reminder, main levels: (D)omain, (K)ingdom, (P)hylum, (C)lass, (O)rder, (F)amily, (G)enus, or (S)pecies
        if current_taxonomy_rank == "U":
                Domain="---"
                Kingdom="---"
                Phylum="---"
                Class="---"
                Order="---"
                Family="---"
                Genus="---"
                Species="---"
                line_to_print="Unassigned"+"\t"+pc_reads_taxa+"\t"+nb_reads_taxa+"\t"+nb_reads_directly_taxa+"\t"+current_taxonomy_rank+"\t"+NBCI_taxonomy_ID
                line_to_print=line_to_print+"\t"+Domain+"\t"+Kingdom+"\t"+Phylum+"\t"+Class+"\t"+Order+"\t"+Family+"\t"+Genus+"\t"+Species+"\n"
                outputfile.write(line_to_print)
        if current_taxonomy_rank == "D":
                Domain=current_taxon_name
                Kingdom="---"
                Phylum="---"
                Class="---"
                Order="---"
                Family="---"
                Genus="---"
                Species="---"
                line_to_print="Assigned"+"\t"+pc_reads_taxa+"\t"+nb_reads_taxa+"\t"+nb_reads_directly_taxa+"\t"+current_taxonomy_rank+"\t"+NBCI_taxonomy_ID
                line_to_print=line_to_print+"\t"+Domain+"\t"+Kingdom+"\t"+Phylum+"\t"+Class+"\t"+Order+"\t"+Family+"\t"+Genus+"\t"+Species+"\n"
                outputfile.write(line_to_print)
if current_taxonomy_rank == "K":
                Kingdom=current_taxon_name
                Phylum="---"
                Class="---"
                Order="---"
                Family="---"
                Genus="---"
                Species="---"
                line_to_print="Assigned"+"\t"+pc_reads_taxa+"\t"+nb_reads_taxa+"\t"+nb_reads_directly_taxa+"\t"+current_taxonomy_rank+"\t"+NBCI_taxonomy_ID
                line_to_print=line_to_print+"\t"+Domain+"\t"+Kingdom+"\t"+Phylum+"\t"+Class+"\t"+Order+"\t"+Family+"\t"+Genus+"\t"+Species+"\n"
                outputfile.write(line_to_print)
        if current_taxonomy_rank == "P":
                Phylum=current_taxon_name
                Class="---"
                Order="---"
                Family="---"
                Genus="---"
                Species="---"
                line_to_print="Assigned"+"\t"+pc_reads_taxa+"\t"+nb_reads_taxa+"\t"+nb_reads_directly_taxa+"\t"+current_taxonomy_rank+"\t"+NBCI_taxonomy_ID
                line_to_print=line_to_print+"\t"+Domain+"\t"+Kingdom+"\t"+Phylum+"\t"+Class+"\t"+Order+"\t"+Family+"\t"+Genus+"\t"+Species+"\n"
                outputfile.write(line_to_print)
        if current_taxonomy_rank == "C":
                Class=current_taxon_name
                Order="---"
                Family="---"
                Genus="---"
                Species="---"
                line_to_print="Assigned"+"\t"+pc_reads_taxa+"\t"+nb_reads_taxa+"\t"+nb_reads_directly_taxa+"\t"+current_taxonomy_rank+"\t"+NBCI_taxonomy_ID
                line_to_print=line_to_print+"\t"+Domain+"\t"+Kingdom+"\t"+Phylum+"\t"+Class+"\t"+Order+"\t"+Family+"\t"+Genus+"\t"+Species+"\n"
                outputfile.write(line_to_print)
        if current_taxonomy_rank == "O":
                Order=current_taxon_name
                Family="---"
                Genus="---"
                Species="---"
                line_to_print="Assigned"+"\t"+pc_reads_taxa+"\t"+nb_reads_taxa+"\t"+nb_reads_directly_taxa+"\t"+current_taxonomy_rank+"\t"+NBCI_taxonomy_ID
                line_to_print=line_to_print+"\t"+Domain+"\t"+Kingdom+"\t"+Phylum+"\t"+Class+"\t"+Order+"\t"+Family+"\t"+Genus+"\t"+Species+"\n"
                outputfile.write(line_to_print)
        if current_taxonomy_rank == "F":
                Family=current_taxon_name
                Genus="---"
                Species="---"
                line_to_print="Assigned"+"\t"+pc_reads_taxa+"\t"+nb_reads_taxa+"\t"+nb_reads_directly_taxa+"\t"+current_taxonomy_rank+"\t"+NBCI_taxonomy_ID
                line_to_print=line_to_print+"\t"+Domain+"\t"+Kingdom+"\t"+Phylum+"\t"+Class+"\t"+Order+"\t"+Family+"\t"+Genus+"\t"+Species+"\n"
                outputfile.write(line_to_print)
        if current_taxonomy_rank == "G":
                Genus=current_taxon_name
                Species="---"
                line_to_print="Assigned"+"\t"+pc_reads_taxa+"\t"+nb_reads_taxa+"\t"+nb_reads_directly_taxa+"\t"+current_taxonomy_rank+"\t"+NBCI_taxonomy_ID
                line_to_print=line_to_print+"\t"+Domain+"\t"+Kingdom+"\t"+Phylum+"\t"+Class+"\t"+Order+"\t"+Family+"\t"+Genus+"\t"+Species+"\n"
                outputfile.write(line_to_print)
          if current_taxonomy_rank == "S":
                if len(spline) == 6:
                        Species=spline[5]
                elif len(spline) == 7:
                        Species=spline[5]+" "+spline[6]
                elif len(spline) == 8:
                        Species=spline[5]+" "+spline[6]+" "+spline[7]
                elif len(spline) == 9:
                        Species=spline[5]+" "+spline[6]+" "+spline[7]+" "+spline[8]
                elif len(spline) == 10:
                        Species=spline[5]+" "+spline[6]+" "+spline[7]+" "+spline[8]+" "+spline[9]
                elif len(spline) == 11:
                        Species=spline[5]+" "+spline[6]+" "+spline[7]+" "+spline[8]+" "+spline[9]+" "+spline[10]
                elif len(spline) == 12:
                        Species=spline[5]+" "+spline[6]+" "+spline[7]+" "+spline[8]+" "+spline[9]+" "+spline[10]+" "+spline[11]
                elif len(spline) > 12:
                        Species=spline[5]+" "+spline[6]+" "+spline[7]+" "+spline[8]+" "+spline[9]+" "+spline[10]+" "+spline[11]
                else:
                        print("ERROR: Check the format of the input file")
                        break
                line_to_print="Assigned"+"\t"+pc_reads_taxa+"\t"+nb_reads_taxa+"\t"+nb_reads_directly_taxa+"\t"+current_taxonomy_rank+"\t"+NBCI_taxonomy_ID
                line_to_print=line_to_print+"\t"+Domain+"\t"+Kingdom+"\t"+Phylum+"\t"+Class+"\t"+Order+"\t"+Family+"\t"+Genus+"\t"+Species+"\n"
                outputfile.write(line_to_print)
       
