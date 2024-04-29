#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=30G
module load bioinfo/bwa-mem2/2.2.1
module load bioinfo/samtools/1.14
module load devel/java/17.0.6
module load bioinfo/picard-tools/3.0.0

cd /home/nteixido/work/Mallaurie_data/analyses/trimming/
ls *.fastq.gz | sed 's/_/\t/g' | awk '{print $1"_"$2}' | uniq > ~/work/Mallaurie_data/analyses/Mapping_run12/list_id_amelmel

mkdir /home/nteixido/work/Mallaurie_data/analyses/Mapping_run12/mapping_against_amelmel_MAPQ0
cd /home/nteixido/work/Mallaurie_data/analyses/Mapping_run12/mapping_against_amelmel_MAPQ0
while read line; do
        ind=$(echo "$line")
        bwa-mem2 mem ~/work/genome_reference/abeille/GCA_003314205.2_INRA_AMelMel_1.1_genomic.fna ~/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R1.pe.fastq.gz ~/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R2.pe.fastq.gz | samtools view -bS - > "$ind"_paired.bam
        bwa-mem2 mem ~/work/genome_reference/abeille/GCA_003314205.2_INRA_AMelMel_1.1_genomic.fna ~/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R1.unpaired.fastq.gz | samtools view -bS - > "$ind"_unpaired1.bam
        bwa-mem2 mem ~/work/genome_reference/abeille/GCA_003314205.2_INRA_AMelMel_1.1_genomic.fna ~/work/Mallaurie_data/analyses/trimming/"$ind"_L001_R2.unpaired.fastq.gz | samtools view -bS - > "$ind"_unpaired2.bam
        # merging bams
        samtools merge "$ind".bam "$ind"_paired.bam "$ind"_unpaired1.bam "$ind"_unpaired2.bam
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
