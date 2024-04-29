#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=30G

module load bioinfo/bwa-mem2/2.2.1
module load bioinfo/samtools/1.14
module load devel/java/17.0.6
module load bioinfo/picard-tools/3.0.0

cd ~/work/Mallaurie_data/analyses/trimming/
ls *gz | sed 's/_/\t/g' | awk '{print $1"_"$2}' | uniq > ~/work/Mallaurie_data/analyses/Mapping_run12/list_id_amelmel

for ((q_value=21; q_value<=50; q_value++))
do
        mkdir ~/work/Mallaurie_data/analyses/Mapping_run12/mapping_against_Amelmel_MAPQ"${q_value}"_F256/
        cd ~/work/Mallaurie_data/analyses/Mapping_run12/mapping_against_Amelmel_MAPQ"${q_value}"_F256/
        while read line; do
                ind=$(echo "$line")
                samtools view -h -q "${q_value}" -F 256 ~/work/Mallaurie_data/analyses/Mapping_run12/mapping_against_amelmel_MAPQ0/"$ind"_paired.bam > "$ind"_paired_quality"${q_value}"_uniqmapped.bam
                samtools view -h -q "${q_value}" -F 256 ~/work/Mallaurie_data/analyses/Mapping_run12/mapping_against_amelmel_MAPQ0/"$ind"_unpaired1.bam > "$ind"_unpaired1_quality"${q_value}"_uniqmapped.bam
                samtools view -h -q "${q_value}" -F 256 ~/work/Mallaurie_data/analyses/Mapping_run12/mapping_against_amelmel_MAPQ0/"$ind"_unpaired2.bam > "$ind"_unpaired2_quality"${q_value}"_uniqmapped.bam
        # merging bams
        samtools merge "$ind".bam "$ind"_paired_quality"${q_value}"_uniqmapped.bam "$ind"_unpaired1_quality"${q_value}"_uniqmapped.bam "$ind"_unpaired2_quality"${q_value}"_uniqmapped.bam
        # samtools sort
        samtools sort "$ind".bam > "$ind".sorted.bam
        # samtools index
        samtools index "$ind".sorted.bam
        # samtools flagstat
        samtools flagstat "$ind".sorted.bam > "$ind".sorted.bam.flagstat_before_dedup
        # samtools idxstats
        samtools idxstats "$ind".sorted.bam > "$ind".sorted.bam.idxstats_before_dedup
        # picard remove duplicates
        java -Xmx4g -jar $PICARD MarkDuplicates  \
                I="$ind".sorted.bam \
                O="$ind".dedup.bam \
                M="$ind".MarkDuplicates.metrics.txt \
                REMOVE_DUPLICATES=true
        # samtools flagstat
        samtools flagstat "$ind".dedup.bam > "$ind".dedup.bam.flagstat_after_dedup
        # samtools idxstats
        samtools idxstats "$ind".dedup.bam > "$ind".dedup.bam.idxstats_after_dedup
        done < ~/work/Mallaurie_data/analyses/Mapping_run12/list_id_amelmel
done
