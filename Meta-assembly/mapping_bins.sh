#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=30G


mkdir ~/work/Assemblage/script/mapping/mapping_bins
cd ~/work/Assemblage/script/mapping/mapping_bins/

while read line; do
        ind=$(echo "$line")
        echo "#!/bin/bash" >> mapping_"$ind"_all_bins.sh
        echo "#SBATCH --mail-type=BEGIN,END,FAIL" >> mapping_"$ind"_all_bins.sh
        echo "#SBATCH --mem=30G" >> mapping_"$ind"_all_bins.sh
        echo "" >> mapping_"$ind"_all_bins.sh
        echo "module load bioinfo/bwa-mem2/2.2.1" >> mapping_"$ind"_all_bins.sh
        echo "module load bioinfo/samtools/1.14" >> mapping_"$ind"_all_bins.sh
        echo "module load devel/java/17.0.6" >> mapping_"$ind"_all_bins.sh
        echo "module load bioinfo/picard-tools/3.0.0" >> mapping_"$ind"_all_bins.sh
        echo "" >> mapping_"$ind"_all_bins.sh
        echo "cd ~/work/Assemblage/mapping/mapping_bins/all_bins/" >> mapping_"$ind"_all_bins.sh
        echo "" >> mapping_"$ind"_all_bins.sh
        echo "bwa-mem2 mem ~/work/Assemblage/concoct_output/fasta_bins/all_bins.fa ~/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R1.pe.fastq.gz ~/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R2.pe.fastq.gz | samtools view -h -q 20 -F 256 > "$ind"_paired.bam" >> mapping_"$ind"_all_bins.sh
        echo "bwa-mem2 mem ~/work/Assemblage/concoct_output/fasta_bins/all_bins.fa ~/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R1.unpaired.fastq.gz | samtools view -h -q 20 -F 256 > "$ind"_unpaired1.bam" >> mapping_"$ind"_all_bins.sh
        echo "bwa-mem2 mem ~/work/Assemblage/concoct_output/fasta_bins/all_bins.fa ~/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R2.unpaired.fastq.gz | samtools view -h -q 20 -F 256 > "$ind"_unpaired2.bam" >> mapping_"$ind"_all_bins.sh
       # merging bams
        echo "samtools merge "$ind".bam "$ind"_paired.bam "$ind"_unpaired1.bam "$ind"_unpaired2.bam" >> mapping_"$ind"_all_bins.sh
       # samtools sort
        echo "samtools sort "$ind".bam > "$ind".sorted.bam" >> mapping_"$ind"_all_bins.sh
       # samtools index
        echo "samtools index "$ind".sorted.bam" >> mapping_"$ind"_all_bins.sh
       # samtools flagstat
        echo "samtools flagstat "$ind".sorted.bam > "$ind".sorted.bam.flagstat_before_dedup" >> mapping_"$ind"_all_bins.sh
       # samtools idxstats
        echo "samtools idxstats "$ind".sorted.bam > "$ind".sorted.bam.idxstats_before_dedup" >> mapping_"$ind"_all_bins.sh
       # picard remove duplicates
        echo "java -Xmx4g -jar $PICARD MarkDuplicates  \ " >> mapping_"$ind"_all_bins.sh
        echo "  I="$ind".sorted.bam \ " >> mapping_"$ind"_all_bins.sh
        echo "  O="$ind".dedup.bam \ " >> mapping_"$ind"_all_bins.sh
        echo "  M="$ind".MarkDuplicates.metrics.txt \ " >> mapping_"$ind"_all_bins.sh
        echo "  REMOVE_DUPLICATES=true" >> mapping_"$ind"_all_bins.sh
       # samtools flagstat
        echo "samtools flagstat "$ind".dedup.bam > "$ind".dedup.bam.flagstat_after_dedup" >> mapping_"$ind"_all_bins.sh
       # samtools idxstats
        echo "samtools idxstats "$ind".dedup.bam > "$ind".dedup.bam.idxstats_after_dedup" >> mapping_"$ind"_all_bins.sh
#rm "$ind".sorted.bam.flagstat_before_dedup "$ind".sorted.bam.idxstats_before_dedup "$ind".bam "$ind"_paired.bam "$ind"_unpaired1.bam "$ind"_unpaired2.bam
        sbatch mapping_"$ind"_all_bins.sh
done < ~/work/Mallaurie_data/analyses/Mapping_run12/list_id_amelmel
