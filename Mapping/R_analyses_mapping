################################# Packages ########################################################################
library(ggplot2)
library(ggrepel)
library(corrplot)
library(hrbrthemes)
library(dplyr)

############################### data #######################################################################################

setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/mapping/run1/resultats_complets/")

sumstatsrun1_amelmel=read.table("resultat_after_flagstat_amelmel.txt",h=T)

################################### Type of samples ################################################################################

sumstatsrun1_amelmel$echantillon <- ifelse(sumstatsrun1_HAV31[,1] %in% c("GPS221025", "GPS221046"), "cire", "miel")

############################# Mapping against Amelmel ################################################################################

#Plot 1 : PC_mapped VS total reads

ggplot(sumstatsrun1_amelmel, aes(in_total, PC_mapped, color = echantillon)) + 
  geom_point(size=5) +
  theme_ipsum() +
  geom_vline(xintercept = 200000,color="darkred",lwd=1.4)+ aes(size=3)+
  theme_bw()+
  xlab("Number of reads")+
  ylab("%reads")+
  scale_fill_manual(values=c("#E69F00", "yellow2"))+
  scale_x_continuous(trans='log10',position = "bottom",breaks = c(100,1000,10000,100000,1000000,10000000), labels = c("100","1,000","10,000","100,000","1,000,000","10.000.000"),limits=c(100,20000000))+
  scale_y_continuous(trans='log10',position = "left", breaks=c(0.01,0.1,1,10,100),limits=c(0.02,100))+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(hjust = 0.5, face = "bold"))+
  theme(axis.line.x = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line.y = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line = element_line(colour = 'black', size = 1), axis.ticks = element_line(colour = 'grey30', size = 1), 
        axis.text.x = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),  
        axis.title.x = element_text(colour="black",size=16,angle=0,hjust=.5,vjust=.2,face="plain"),
        axis.title.y = element_text(colour="black",size=16,angle=90,hjust=.5,vjust=.5,face="plain"))+
  theme(legend.position=c(0.9,0.2),legend.background = element_rect(fill="white",size=0.75, linetype="longdash",colour ="black")) +
  labs(color = "Echantillon") +
  ggtitle("Percentage of reads aligned against Amelmel") +
  geom_label_repel(aes(label = factor(identifiant)), color = 'black', size = 3,segment.color = 'black')


#Plot 2 : PC_primary_mapped VS total reads 

ggplot(sumstatsrun1_amelmel, aes(in_total, PC_primary_mapped, color = echantillon)) + 
  geom_point(size=5) +
  theme_ipsum() +
  geom_vline(xintercept = 200000,color="darkred",lwd=1.4)+ aes(size=3)+
  theme_bw()+
  xlab("Number of reads")+
  ylab("%reads")+
  scale_fill_manual(values=c("#E69F00", "yellow2"))+
  scale_x_continuous(trans='log10',position = "bottom",breaks = c(100,1000,10000,100000,1000000,10000000), labels = c("100","1,000","10,000","100,000","1,000,000","10.000.000"),limits=c(100,20000000))+
  scale_y_continuous(trans='log10',position = "left", breaks=c(0.01,0.1,1,10,100),limits=c(0.02,100))+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(hjust = 0.5, face = "bold"))+
  theme(axis.line.x = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line.y = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line = element_line(colour = 'black', size = 1), axis.ticks = element_line(colour = 'grey30', size = 1), 
        axis.text.x = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),  
        axis.title.x = element_text(colour="black",size=16,angle=0,hjust=.5,vjust=.2,face="plain"),
        axis.title.y = element_text(colour="black",size=16,angle=90,hjust=.5,vjust=.5,face="plain"))+
  theme(legend.position=c(0.9,0.2),legend.background = element_rect(fill="white",size=0.75, linetype="longdash",colour ="black")) +
  labs(color = "Echantillon") +
  ggtitle("Percentage of reads aligned une fois contre l'abeille Amelmel") +
  geom_label_repel(aes(label = factor(identifiant)), color = 'black', size = 3,segment.color = 'black')

#Plot 3 : PC_properly_paired VS total reads

ggplot(sumstatsrun1_amelmel, aes(in_total, PC_properly_paired, color = echantillon)) + 
  geom_point(size=5) +
  theme_ipsum() +
  geom_vline(xintercept = 200000,color="darkred",lwd=1.4)+ aes(size=3)+
  theme_bw()+
  xlab("Number of reads")+
  ylab("%reads")+
  scale_fill_manual(values=c("#E69F00", "yellow2"))+
  scale_x_continuous(trans='log10',position = "bottom",breaks = c(100,1000,10000,100000,1000000,10000000), labels = c("100","1,000","10,000","100,000","1,000,000","10.000.000"),limits=c(100,20000000))+
  scale_y_continuous(trans='log10',position = "left", breaks=c(0.01,0.1,1,10,100),limits=c(0.02,100))+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(hjust = 0.5, face = "bold"))+
  theme(axis.line.x = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line.y = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line = element_line(colour = 'black', size = 1), axis.ticks = element_line(colour = 'grey30', size = 1), 
        axis.text.x = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),  
        axis.title.x = element_text(colour="black",size=16,angle=0,hjust=.5,vjust=.2,face="plain"),
        axis.title.y = element_text(colour="black",size=16,angle=90,hjust=.5,vjust=.5,face="plain"))+
  theme(legend.position=c(0.9,0.2),legend.background = element_rect(fill="white",size=0.75, linetype="longdash",colour ="black")) +
  labs(color = "Echantillon") +
  ggtitle("Pourcentage des couples de lectures pairées alignées contre l'abeille Amelmel") +
  geom_label_repel(aes(label = factor(identifiant)), color = 'black', size = 3,segment.color = 'black')
############################ Abeille VS Varroa #################################################################################

data_abeille_varroa = cbind(sumstatsrun1_abeille$identifiant, sumstatsrun1_abeille$PC_properly_paired, sumstatsrun1_Vdes$PC_properly_paired, sumstatsrun1_abeille$echantillon)
colnames(data_abeille_varroa) = c("ID", "PC_Abeille", "PC_Varroa", "Echantillon")

data_abeille_varroa = as.data.frame(data_abeille_varroa)

############################# Droite abeille vs Varroa ##########################################################################

#Plot : droite passant par 0 

ggplot(data_abeille_varroa, aes(x=PC_Varroa, y=PC_Abeille, color=Echantillon)) + 
  geom_point(size=5) +
  theme_ipsum() +
  #geom_point(aes(), shape=23, show.legend = FALSE) +
  theme_bw()+
  xlab("% lectures Varroa")+
  ylab("% lectures Abeille")+
  scale_fill_manual(values=c("#E69F00", "yellow2"))+
  scale_x_continuous(limits=c(0,40))+
  scale_y_continuous(limits=c(0,60))+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
  #theme(plot.margin = margin(0, 1.5, 0.5, 0, "cm"))+ # add margin: top, right, bottom, left
  theme(axis.line.x = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line.y = element_line(arrow = grid::arrow(length = unit(0.2, "cm"), ends = "last",type="closed")))+ # ends controls the position of the arrows  could be first, last or both
  theme(axis.line = element_line(colour = 'black', size = 1), axis.ticks = element_line(colour = 'grey30', size = 1), 
        axis.text.x = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="grey30",size=10,angle=0,hjust=.5,vjust=.5,face="plain"),  
        axis.title.x = element_text(colour="black",size=16,angle=0,hjust=.5,vjust=.2,face="bold"),
        axis.title.y = element_text(colour="black",size=16,angle=90,hjust=.5,vjust=.5,face="bold"))+
  theme(legend.position=c(0.1,0.9),legend.background = element_rect(fill="white",size=0.75, linetype="longdash",colour ="black"))+
  geom_abline(intercept = 0, slope = 1, color = "red")
