################################# Telechargement des packages ########################################################################
library(ggplot2)
library(ggrepel)
library(corrplot)
library(hrbrthemes)
library(dplyr)

############################### Telechargement des donnees #######################################################################################

setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/mapping/run1/resultats_complets/")

sumstatsrun1_HAV31=read.table("resultat_after_flagstat_HAv31.txt",h=T)
sumstatsrun1_amelmel=read.table("resultat_after_flagstat_amelmel.txt",h=T)

################################### Ajout du type d'echantillon ################################################################################

sumstatsrun1_HAV31$echantillon <- ifelse(sumstatsrun1_HAV31[,1] %in% c("GPS221025", "GPS221046"), "cire", "miel")
sumstatsrun1_amelmel$echantillon <- ifelse(sumstatsrun1_HAV31[,1] %in% c("GPS221025", "GPS221046"), "cire", "miel")
