################################ Packages ########################################################################
library(ggplot2)
library(ggrepel)
library(corrplot)
library(hrbrthemes)
library(dplyr)

############################### Data #######################################################################################

setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/mapping/run1/resultats_complets/")

sumstatsrun1_HAV31=read.table("resultat_after_flagstat_HAv31.txt",h=T)
sumstatsrun1_amelmel=read.table("resultat_after_flagstat_amelmel.txt",h=T)

################################### Type of sample ################################################################################

sumstatsrun1_HAV31$echantillon <- ifelse(sumstatsrun1_HAV31[,1] %in% c("GPS221025", "GPS221046"), "cire", "miel")
sumstatsrun1_amelmel$echantillon <- ifelse(sumstatsrun1_HAV31[,1] %in% c("GPS221025", "GPS221046"), "cire", "miel")

################################# Name of genomes #######################################################################################
sumstatsrun1_amelmel$genome = "Amelmel"
sumstatsrun1_HAV31$genome = "HAv31"

################################### mapping Amelmel VS HAV31 ##################################################################################

#Filter
#tableau amelmel et hav31 du run1
data_abeillerun1 = cbind.data.frame(sumstatsrun1_amelmel$identifiant, sumstatsrun1_amelmel$echantillon, sumstatsrun1_amelmel$projet, sumstatsrun1_amelmel$PC_primary_mapped, sumstatsrun1_amelmel$in_total, sumstatsrun1_HAV31$PC_primary_mapped, sumstatsrun1_HAV31$in_total)
colnames(data_abeillerun1) = c("ID", "Echantillon", "Projet", "PC_Amelmel", "Total_Amelmel", "PC_HAv31", "Total_HAv31")

#Compute : Amelmel - HAv31
all_data_abeille$DPC_primary_mapped = all_data_abeille$PC_Amelmel - all_data_abeille$PC_HAv31
summary(all_data_abeille)

# Plot 1 : PC_primary_mapped
ggplot(all_data_abeille, aes(x = Total_Amelmel, y = DPC_primary_mapped, color = Echantillon)) +
  geom_point(size=3) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "darkred",lwd=1.4) + 
  theme_ipsum() +
  geom_vline(xintercept = 200000,color="darkred",lwd=1.4)+ 
  theme_bw()+
  labs(x = "Nombre de lectures",
       y = "% lectures properly paired") +
  scale_y_continuous(breaks = c(-0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8), labels = c("-0.6", "-0.4", "-0.2", "0", "0.2", "0.4", "0.6", "0.8"), limits = c(-0.6,0.8))+
  #scale_y_continuous(labels = function(x) ifelse(x >= 0, paste0(x, "% Amelmel"), paste0(x, "% HAv31"))) +
  scale_x_continuous(trans='log10',breaks = c(100,1000,10000,100000,1000000,10000000), labels = c("100","1,000","10,000","100,000","1,000,000","10.000.000"),limits=c(100,20000000))+
  scale_shape_manual(values=c(16, 17, 18)) +
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(hjust = 0.5, face = "bold"))+
  theme(axis.line.x = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line.y = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line = element_line(colour = 'black', size = 1), axis.ticks = element_line(colour = 'grey30', size = 1), 
        axis.text.x = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),  
        axis.title.x = element_text(colour="black",size=16,angle=0,hjust=.5,vjust=.2,face="plain"),
        axis.title.y = element_text(colour="black",size=16,angle=90,hjust=.5,vjust=.5,face="plain"))+
  theme(legend.position=c(0.23,0.2, 0.2),legend.background = element_rect(fill="white",size=0.1, linetype="longdash",colour ="black"), legend.box = "horizontal" )+
  geom_label_repel(aes(label = factor(ID)), color = 'black', size = 3,segment.color = 'black')

