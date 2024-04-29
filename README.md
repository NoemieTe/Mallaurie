# Mallaurie
Master's internship.

## Project goals 
The aim of the project is to find et quantify the spiecies present in samples of honey sequenced in low coverage. 
### Samples 
The samples used include samples from Mallaurie project, samples published by Bovo et al, 2018 (ERR2592240, ERR2592241) and by Bovo et al, 2020 (ERR3799299, ERR3799300, ERR3799301). 

## Trimming raw reads (./Quality)
Reads were filtred to remove low quality reads (trimming.sh) with Trimmomatic/0.39 software. The remaining reads then passed quality control (fastqc.sh and multiqc.sh) with FastQC/0.12.1 and MultiQC/1.19 softwares. 

## A priori approach 
### Mapping against reference genomes (./Mapping)
Reference genomes were indexed (index.sh) with bwa-mem2/2.2.1 software.
Reads were aligned against the expected reference genomes (Mapping_against_reference.sh) : 
- two bee genomes (GCF_003254395.2_Amel_HAv3.1_genomic.fna et Genome_abeille_AmelMel_HAv3.1.fna),
- varroa destructor (Varroa_destructor_gca002443255.Vdes_3.0.dna.toplevel.fa),
- lavender (JAPVEC01.2.fsa_nt.gz),
- locust (cihuai.FINAL.fasta),
- chestnut (GCA_000763605.2_ASM76360v2_genomic.fna),
- bee holobiont published by Bovo et al, 2020 (HB_Mop_v2016.1.fasta).

To remove alignment errors, the MAPQ quality parameter has been modified to range from 0 to 50 (Mapping_evaluation_MAPQ.sh).


### Comparison by k-mers approch

## No-priori approach
### Meta-assembly 

### Mapping reads against meta-genomes

### Comparison using k-mers approach
