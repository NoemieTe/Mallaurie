# Mallaurie
Master's internship.

## Project goals 
The aim of the project is to find et quantify the spiecies present in samples of honey sequenced in low coverage. 
### Samples 
The samples used include samples from Mallaurie project, samples published by Bovo et al, 2018 (ERR2592240, ERR2592241) and by Bovo et al, 2020 (ERR3799299, ERR3799300, ERR3799301). 

## Trimming raw reads (./Quality)
Reads were filtred to remove low quality reads (trimming.sh) with the software Trimmomatic/0.39. The remaining reads then passed quality control (fastqc.sh et multiqc.sh) with the softwares FastQC/0.12.1 and MultiQC/1.19. 

## Approche avec a priori 
### Mapping contre des génomes de référence (./Mapping)
Les génomes de référence ont été indexé (index.sh) avec le software bwa-mem2/2.2.1.
Les lectures ont été alignées contre les génomes de référence attendus (Mapping_against_reference.sh) : 
- deux génomes de l'abeille (GCF_003254395.2_Amel_HAv3.1_genomic.fna et Genome_abeille_AmelMel_HAv3.1.fna),
- le varroa destructeur (Varroa_destructor_gca002443255.Vdes_3.0.dna.toplevel.fa),
- la lavande (JAPVEC01.2.fsa_nt.gz),
- le robinier (cihuai.FINAL.fasta),
- le châtaignier (GCA_000763605.2_ASM76360v2_genomic.fna),
- l'holobionte de l'abeille publié par Bovo et al, 2020 (HB_Mop_v2016.1.fasta). 


### Comparaison par approche k-mers 

## Approche sans a priori
### Méta-assemblage 

### Mapping des lectures contre les méta-génomes

### Comparaison par approche k-mers
