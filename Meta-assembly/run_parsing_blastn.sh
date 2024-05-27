#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=30G


mkdir ~/work/Assemblage/script/manip_fichiers/parsing/

cd ~/work/Assemblage/Blastn/
# resultats_*_blastn.xml | sed 's/_/\t/g' | awk '{print $2}' | uniq > ~/work/Assemblage/Blastn/list_id_blast_xml

while read line; do
        ind=$(echo "$line")
        echo "#!/bin/bash" >> ~/work/Assemblage/script/manip_fichiers/parsing/parse_blastn_"$ind"_modif1904.sh
        echo "#SBATCH --mail-type=BEGIN,END,FAIL" >> ~/work/Assemblage/script/manip_fichiers/parsing/parse_blastn_"$ind"_modif1904.sh
        echo "#SBATCH --mem=20G" >> ~/work/Assemblage/script/manip_fichiers/parsing/parse_blastn_"$ind"_modif1904.sh
        echo "python3" >> ~/work/Assemblage/script/manip_fichiers/parsing/parse_blastn_"$ind"_modif1904.sh
        echo "bash script_parsing_filtering_blastn_outputs_modif1904_main.sh resultats_"$ind"_blastn.xml" >> ~/work/Assemblage/script/manip_fichiers/parsing/parse_blastn_"$ind"_modif1904.sh
        sbatch ~/work/Assemblage/script/manip_fichiers/parsing/parse_blastn_"$ind"_modif1904.sh
done < ~/work/Assemblage/Blastn/list_id_blast_xml3
