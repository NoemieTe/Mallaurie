# Mallaurie
Master's internship of Noémie Teixido, supervised by Thibault Leroy : thibault.leroy@inrae.fr.

## Project goals 
The aim of the project is to identify et quantify the spiecies present in honey samples sequenced at low coverage. 
### Samples 
The samples used include those from the Mallaurie project, as well as samples published by Bovo et al., 2018 (ERR2592240, ERR2592241) and Bovo et al., 2020 (ERR3799299, ERR3799300, ERR3799301).

## Trimming raw reads (./Quality)
Reads were filtered to remove low-quality reads (trimming.sh) using Trimmomatic/0.39 software. The remaining reads then underwent quality control (fastqc.sh and multiqc.sh) with FastQC/0.12.1 and MultiQC/1.19 software.

## A priori approach 
### Mapping against reference genomes (./Mapping)
Reference genomes were indexed (index.sh) with bwa-mem2/2.2.1 software.
Reads were aligned against the expected reference genomes (Mapping_against_reference.sh) using bwa-mem2/2.2.1, samtools/1.14, java/17.0.6, and picard-tools/3.0.0 software:

- two bee genomes (GCF_003254395.2_Amel_HAv3.1_genomic.fna and Genome_abeille_AmelMel_HAv3.1.fna),
- varroa destructor (Varroa_destructor_gca002443255.Vdes_3.0.dna.toplevel.fa),
- lavender (JAPVEC01.2.fsa_nt.gz),
- locust (cihuai.FINAL.fasta),
- chestnut (GCA_000763605.2_ASM76360v2_genomic.fna),
- bee holobiont published by Bovo et al, 2020 (HB_Mop_v2016.1.fasta).

Mapping was analyzed in R to determine the percentage of aligned reads versus the total number of sequenced reads in each sample, and the correlation between the alignment against bee and Varroa destructor (R_analyses_mapping.R).

Furthermore, to determine the best mapping between two genomes, an analysis in R was performed using the difference in alignment percentages between pairs of genomes (R_analyses_by_paires.R).  

To remove alignment errors, the MAPQ quality parameter was modified to range from 0 to 50 (Mapping_evaluation_MAPQ.sh).
 
Evaluations of the MAPQ quality parameter were analyzed in R (R_analyses_MAPQ.R).


### Comparison by k-mers approch (./k-mers_approach)
In parallel, reads were compared to a reference k-mers database (kraken.sh) using Kraken2/2.1.2 software. 
Outputs of Kraken were parsed with the script parser_all_samples.sh using the parser_kraken.py script. 
Results were summarized by order for Apidae, Hymenoptera, and Fagales (resume_parsing_kraken.sh) and compared with mapping results (comparison_with_mapping.R).

## No-priori approach
### Meta-assembly (./Meta_assembly)
Reads from all samples were assembled into contigs by MEGAHIT/1.2.9 software (assembly.sh). Then, a meta-assembly was conducted by CONCOCT software. Contigs were indexed (index_contigs.sh) with bwa-mem2/2.2.1 software and reads were mapped against contigs (mapping_contigs.sh) using bwa-mem2/2.2.1, samtools/1.14, java/17.0.6, and picard-tools/3.0.0 software. Contigs were cut into subcontigs (cut_contigs.sh). A coverage table was then generated (coverage_table.sh) from subcontigs and mapping results. Subcontigs were grouped (run_concoct.sh) by coverage and nucleotide composition. Contigs clustering into bins was achieved through subcontigs clustering (merge_subcontigs.sh), and bins were extracted into fasta files (extract_bins.sh).

To assign each bin to a taxon, contigs were aligned against the NCBI nucleotide database (Blastn alignment) using NCBI_Blast+/2.10.0+ software (blastn_bins.sh). Results of the Blastn alignment were parsed using the run_parsing_blastn.sh script and the parsing_filtering_blastn.sh script.

In parallel, statistics for bins were computed using statistics/R/4.2.2 and assemblathon2/d1f044b software (statistics_bins.sh).

A table grouping bins, species, and statistics was created manually.

### Mapping reads against meta-genome (./Meta_assembly)
Bins were merged into one file (merge_bins.sh) and indexed by bwa-mem2/2.2.1 software (index_bins.sh). 
All samples were aligned against the meta-genome using bwa-mem2/2.2.1, samtools/1.14, java/17.0.6, and picard-tools/3.0.0 software (mapping_bins.sh).

Outputs were analyzed in R to:

Describe the diversity of species in the meta-genome (diversity_MAG.R),
Assign a plant species for each sample (plants_species.R).


