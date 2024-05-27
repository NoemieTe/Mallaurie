library(stringr)
library(ggplot2)
library(ggthemes)
library(ggrepel)

#################################################### data ##################################################################

#Run1
setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/mapping/resultats_MAPQ/run1")
fichiers = list.files(pattern = "\\.txt$")

all_data_MAPQ_run1 = NULL

for (i in fichiers) { 
  

  nom_tableau = sub("\\.txt", "", i)
  assign(nom_tableau, read.table(i, header = T)) 
  
  mapq = as.numeric(str_extract(nom_tableau, "\\d+$"))
  
  assign(nom_tableau, transform(get(nom_tableau), MAPQ = mapq))

  if (is.null(all_data_MAPQ_run1)) {
    all_data_MAPQ_run1 = get(nom_tableau)
  } else {
    all_data_MAPQ_run1 = rbind(all_data_MAPQ_run1, get(nom_tableau))
  }
}
all_data_MAPQ_run1 = subset(all_data_MAPQ_run1, MAPQ != 256)
all_data_MAPQ_run1$projet = "Mallaurie"

all_data_MAPQ_run1$echantillon <- ifelse(all_data_MAPQ_run1[,1] %in% c("GPS221025", "GPS221046"), "cire", "miel")

setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/mapping/run1/resultats_complets/")
sumstatsrun1_amelmel=read.table("resultat_after_flagstat_amelmel.txt",h=T)
sumstatsrun1_amelmel$MAPQ = 0
sumstatsrun1_amelmel$projet = "Mallaurie"
sumstatsrun1_amelmel$echantillon <- ifelse(sumstatsrun1_amelmel[,1] %in% c("GPS221025", "GPS221046"), "cire", "miel")

all_data_MAPQ_run1 = rbind.data.frame(all_data_MAPQ_run1,sumstatsrun1_amelmel )

all_data_MAPQ_run1 <- merge(all_data_MAPQ_run1, sumstatsrun1_amelmel[, c("identifiant", "in_total")], by = "identifiant", all.x = TRUE)
all_data_MAPQ_run1 = cbind.data.frame(all_data_MAPQ_run1$identifiant, all_data_MAPQ_run1$echantillon, all_data_MAPQ_run1$primary_mapped, all_data_MAPQ_run1$properly_paired, all_data_MAPQ_run1$mapped, all_data_MAPQ_run1$MAPQ, all_data_MAPQ_run1$in_total.y, all_data_MAPQ_run1$projet)
colnames(all_data_MAPQ_run1) = c("ID", "echantillons", "primary_mapped", "properly_paired", "mapped", "MAPQ", "in_total", "projet")

#Calculs des PC_primary_mapped et PC_properly_paired
all_data_MAPQ$PC_primary_mapped = (all_data_MAPQ$primary_mapped*100)/all_data_MAPQ$in_total
all_data_MAPQ$PC_properly_paired = (all_data_MAPQ$properly_paired*100)/all_data_MAPQ$in_total

#Fusion de tous les échantillons
all_data = rbind.data.frame(all_data, all_data_MAPQ)

################################################################## Figure properly_paired ################################################################################################################

ggplot(all_data_MAPQ, aes(x = MAPQ, y = PC_properly_paired, group = ID, color = echantillons)) +
  geom_point(size=1) +
  theme_bw()+
  labs(x = "MAPQ",
       y = "% reads properly paired") +
  geom_line()+
  scale_x_continuous(breaks = c(5,10,15,20), labels = c("5", "10", "15", "20"), limits = c(0, 20))+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(hjust = 0.5, face = "bold"))+
  theme(axis.line.x = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line.y = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line = element_line(colour = 'black', size = 1), axis.ticks = element_line(colour = 'grey30', size = 1), 
        axis.text.x = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),  
        axis.title.x = element_text(colour="black",size=16,angle=0,hjust=.5,vjust=.2,face="plain"),
        axis.title.y = element_text(colour="black",size=16,angle=90,hjust=.5,vjust=.5,face="plain"))+
  theme(legend.position=c(0.8,0.9),legend.background = element_rect(fill="white",size=0.2, linetype="longdash",colour ="black"), legend.box = "horizontal" )+
  geom_label_repel( aes(label = factor(ID)), color = 'black', size = 2,segment.color = 'black', subset(all_data_MAPQ, MAPQ == 0))
