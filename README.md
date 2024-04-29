# Mallaurie
Master's internship.

## Project goals 
The aim of the project is to find et quantify the spiecies present in samples of honey sequenced in low coverage. 
### Samples 
The samples used include samples from Mallaurie project, samples published by Bovo et al, 2018 (ERR2592240, ERR2592241) and by Bovo et al, 2020 (ERR3799299, ERR3799300, ERR3799301). 

## Trimming raw reads (./Quality)
Reads were filtred to remowe low quality reads (trimming.sh). The remaining reads then passed quality control (fastqc.sh et multiqc.sh). 

## Approche avec a priori 
### Mapping contre des génomes de référence (./Mapping)
Les lectures ont été alignées (Mapping_against_reference.sh) contre les génomes de référence attendus (deux génomes de l'abeille, le varroa destructeur, la lavande, le robinier, le châtaignier et l'holobionte de l'abeille publié par Bovo et al, 2020). 


### Comparaison par approche k-mers 

## Approche sans a priori
### Méta-assemblage 

### Mapping des lectures contre les méta-génomes

### Comparaison par approche k-mers
