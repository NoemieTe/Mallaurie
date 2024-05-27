
################################### Récuperer les sorties kraken ##################################################################################

setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/Kraken/Assignation_taxonomique/resultats")

######### RUN1
#Tableau des séquences pairées
paired = read.table("res_paired_varroa_run1_col.txt", header = T, sep = " ")
#Tableau des séquences non pairées 
unpaired = read.table("res_unpaired_varroa_run1_col.txt", header = T, sep = " ")


# Séparer la première colonne en deux parties en utilisant le séparateur "_"
N_paire = strsplit(as.character(unpaired$identifiant), "_")

# Extraire la première partie (avant le séparateur "_") et ajouter un nom à la deuxième partie
unpaired$identifiant <- sapply(N_paire, function(x) x[1])
unpaired$N_paire <- sapply(N_paire, function(x) paste( x[2], sep = ""))

# Écrire les données modifiées dans un nouveau fichier
#write.table(data, "nouveau_fichier.txt", sep = "\t", quote = FALSE, row.names = FALSE)

#Séparer les tableau selon R1 et R2
unpaired_R1 <- unpaired[unpaired$N_paire == "R1", ]
unpaired_R2 <- unpaired[unpaired$N_paire == "R2", ]


#Ajouter cette même colonne au fichier de séquences pairées 
paired$N_paire = "R0"

###################RUN2
#Tableau des séquences pairées
paired2 = read.table("res_paired_varroa_run2_col.txt", header = T, sep = " ")
#Tableau des séquences non pairées 
unpaired2 = read.table("res_unpaired_varroa_run2_col.txt", header = T, sep = " ")


# Séparer la première colonne en deux parties en utilisant le séparateur "_"
N_paire = strsplit(as.character(unpaired2$identifiant), "_")

# Extraire la première partie (avant le séparateur "_") et ajouter un nom à la deuxième partie
unpaired2$identifiant <- sapply(N_paire, function(x) x[1])
unpaired2$N_paire <- sapply(N_paire, function(x) paste( x[2], sep = ""))

# Écrire les données modifiées dans un nouveau fichier
#write.table(data, "nouveau_fichier.txt", sep = "\t", quote = FALSE, row.names = FALSE)

#Séparer les tableau selon R1 et R2
unpaired2_R1 <- unpaired2[unpaired2$N_paire == "R1", ]
unpaired2_R2 <- unpaired2[unpaired2$N_paire == "R2", ]


#Ajouter cette même colonne au fichier de séquences pairées 
paired2$N_paire = "R0"

############################# Aditionner les paired et unpaired ########################################################################################

# Fusion des runs 
paired12 = rbind.data.frame(paired, paired2)
unpaired12_R1 = rbind.data.frame(unpaired_R1, unpaired2_R1)
unpaired12_R2 = rbind.data.frame(unpaired_R2, unpaired2_R2)

#Additionner les colonnes 3.4.5
# Effectuer la fusion des deux dataframes sur la colonne "identifiant"
tab_run = merge(paired12, unpaired12_R1, by = "identifiant", suffixes = c("_R0", "_R1"))
names(unpaired12_R2)[-1] <- paste0(names(unpaired12_R2)[-1], "_R2")
tab_run = merge(tab_run, unpaired12_R2, by = "identifiant", suffixes = c("_R0", "_R1", "_R2"))

# Ajouter une nouvelle colonne contenant la somme des valeurs des deux colonnes "Colonne_2"
tab_run$Somme_PC_reads_taxa <- tab_run$Percentage_reads_taxa_R0 + tab_run$Percentage_reads_taxa_R1 + tab_run$Percentage_reads_taxa_R2

#################################### Figure Mapping vs Kraken ##########################################################################################

setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/mapping/run1/resultats_complets")
sumstatsrun1_varroa=read.table("resultat_after_flagstat_Vdes.txt",h=T)
setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/mapping/run2/resultats_complets")
sumstatsrun2_varroa=read.table("resultat_after_flagstat_Vdes.txt",h=T)

#Avec MAPQ20
setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/mapping/resultats_MAPQ/run12/varroa")
run_MAPQ20 = read.table("resultat_after_flagstat_varroa_MAPQ20.txt", h=T)

#Fusion MAPQ20
sumstats_varroa = rbind.data.frame(sumstatsrun1_varroa, sumstatsrun2_varroa)
names(sumstats_varroa)[-1] <- paste0(names(sumstats_varroa)[-1], "_0")

#Tableau avec les in total correspondants
names(run_MAPQ20)[-1] <- paste0(names(run_MAPQ20)[-1], "_20")
run_MAPQ_merge <- merge(run_MAPQ20, sumstats_varroa, by = "identifiant")


#Calculs des PC_primary_mapped et PC_properly_paired
run_MAPQ_merge$PC_primary_mapped_20 = (run_MAPQ_merge$primary_mapped_20*100)/run_MAPQ_merge$in_total_0
run_MAPQ_merge$PC_properly_paired_20 = (run_MAPQ_merge$properly_paired_20*100)/run_MAPQ_merge$in_total_0

# Fusionner les dataframes sur la colonne "ID"
tab_merge <- merge(tab_run, run_MAPQ_merge, by = "identifiant")

# Sélectionner uniquement les colonnes nécessaires
tab_merge <- tab_merge[, c("identifiant", "Somme_PC_reads_taxa", "PC_properly_paired_20")]

#Ajout des échantillons 
tab_merge$echantillon <- ifelse(tab_merge$identifiant %in% c("GPS221025", "GPS221046"), "cire",
                         ifelse(tab_merge$identifiant %in% c("GPS221073", "GPS221106"), "propolis", "miel"))
#Faire apparaitre les point NA --> 0.0
# Remplacer les NA dans la colonne B par 0.0
tab_merge$Somme_PC_reads_taxa <- ifelse(is.na(tab_merge$Somme_PC_reads_taxa), 0.0, tab_merge$Somme_PC_reads_taxa)

#Figure 
library(ggplot2)
library(ggrepel)
summary(tab_merge)

ggplot(tab_merge, aes(x=Somme_PC_reads_taxa, y=PC_properly_paired_20, color = echantillon)) + 
  geom_point(size=2) +
  #theme_ipsum() +
  #geom_vline(xintercept = 200000,color="darkred",lwd=1.4)+ aes(size=3)+
  theme_bw()+
  xlab("PC_reads_taxa")+
  ylab("PC_properly_paired")+
 # scale_fill_manual(values=c("tomato", "green", "#66ffff", "black"))+
  #scale_x_continuous(trans='log10',position = "bottom",breaks = c(100,1000,10000,100000,1000000,10000000,100000000), labels = c("100","1,000","10,000","100,000","1,000,000","10.000.000","100.000.000"),limits=c(100,200000000))+
  scale_x_continuous(position = "bottom", breaks=c(0,0.05,0.1,0.15,0.2),limits=c(0,0.2))+
  scale_y_continuous(position = "left", breaks=c(0,5,10,15,20),limits=c(0,20))+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
  theme(axis.line.x = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line.y = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line = element_line(colour = 'black', size = 1), axis.ticks = element_line(colour = 'grey30', size = 1), 
        axis.text.x = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),  
        axis.title.x = element_text(colour="black",size=16,angle=0,hjust=.5,vjust=.2,face="bold"),
        axis.title.y = element_text(colour="black",size=16,angle=90,hjust=.5,vjust=.5,face="bold"))+
  scale_shape_manual(values=c(15, 16, 17, 18)) +
  geom_label_repel(aes(label = factor(identifiant)), color = 'black', size = 3,segment.color = 'black')+
  theme(legend.position=c(0.9,0.85),legend.background = element_rect(fill="white",size=0.70, linetype="longdash",colour ="black"))+
  geom_abline(intercept = 0, slope = 1, color = "red")

ggplot(tab_merge, aes(x=Somme_PC_reads_taxa, y=PC_properly_paired_20, color = echantillon)) + 
  geom_point(size=2) +
  #theme_ipsum() +
  #geom_vline(xintercept = 200000,color="darkred",lwd=1.4)+ aes(size=3)+
  theme_bw()+
  xlab("PC_reads_taxa")+
  ylab("PC_properly_paired")+
  # scale_fill_manual(values=c("tomato", "green", "#66ffff", "black"))+
  #scale_x_continuous(trans='log10',position = "bottom",breaks = c(100,1000,10000,100000,1000000,10000000,100000000), labels = c("100","1,000","10,000","100,000","1,000,000","10.000.000","100.000.000"),limits=c(100,200000000))+
  scale_x_continuous(position = "bottom", breaks=c(0,10,20,30,40),limits=c(0,40))+
  scale_y_continuous(position = "left", breaks=c(0,10,20,30,40),limits=c(0,40))+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
  theme(axis.line.x = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line.y = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line = element_line(colour = 'black', size = 1), axis.ticks = element_line(colour = 'grey30', size = 1), 
        axis.text.x = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),  
        axis.title.x = element_text(colour="black",size=16,angle=0,hjust=.5,vjust=.2,face="bold"),
        axis.title.y = element_text(colour="black",size=16,angle=90,hjust=.5,vjust=.5,face="bold"))+
  scale_shape_manual(values=c(15, 16, 17, 18)) +
  geom_label_repel(aes(label = factor(identifiant)), color = 'black', size = 3,segment.color = 'black')+
  theme(legend.position=c(0.9,0.85),legend.background = element_rect(fill="white",size=0.70, linetype="longdash",colour ="black"))+
  geom_abline(intercept = 0, slope = 1, color = "red")
