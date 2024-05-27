library(ggplot2)
library(ggplot2)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(grid)
library(gridExtra)
library(RColorBrewer)

setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/mapping/mag_mallaurie")
statstab = read.table("taxons_stats_mag2.txt", h=T)

tabmodif = statstab
summary(tabmodif)
#Enlever les taxons non assignés
which(is.na(tabmodif$esp_majoritaire)) 
tabmodif = tabmodif[-c(13, 14, 18, 29, 47, 48, 60, 77, 85),]
rownames(tabmodif) = NULL

grep("Bacteria", tabmodif$Domain_esp_primaire.secondaire)
tabmodif$domaine = "Bacteria"

grep("Eukaryota", tabmodif$Domain_esp_primaire.secondaire)
tabmodif$domaine <- ifelse(
  tabmodif$Domain_esp_primaire.secondaire %in% c("Eukaryota", "Eukaryota|Eukaryota", "Eukaryota|Eukaryota|Eukaryota|Eukaryota", "Eukaryota|Eukaryota|Eukaryota|Eukaryota|Eukaryota|Eukaryota", "Eukaryota|Bacteria", "Eukaryota|Eukaryota|Eukaryota", "Eukaryota|Eukaryota|Eukaryota|Eukaryota|Eukaryota"),
  "Eukaryota",
  ifelse(
    tabmodif$Domain_esp_primaire.secondaire %in% c("Viruses", "Viruses|Viruses", "Viruses|Bacteria", "Viruses|Eukaryota|Eukaryota", "Viruses|Viruses|Bacteria|Bacteria|Bacteria|Bacteria", "Viruses|Bacteria|Viruses"),
    "Viruses",
    "Bacteria"
  )
)



counts = table(tabmodif$domaine)
#Diagramme
barplot(counts, main="Distribution des valeurs de Dom", xlab="Domaines", ylab="Fréquence")
pie(counts)

diag_dom = as.data.frame(counts)
colnames(diag_dom) = c("domaine", "nombre")
diag_dom$total = (65+47+12)
diag_dom$PC = diag_dom$nombre * 100 / diag_dom$total
PC = table(diag_dom$PC)

diag_dom_arr=round(diag_dom$PC, digits = 2)
diag_dom$PC_round = diag_dom_arr
panel1 = ggplot(diag_dom, aes(x="", y=PC_round, fill=domaine)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  theme_void() + 
  #theme(legend.position="none") +
  
  geom_text(aes(y = PC_round, label = PC_round), color = "white") +
  scale_fill_brewer(palette="Set2")

############### Sizes of MAGs ########################################################

tab_taille_tax = tabmodif[,c(1,3,7, 14)]
tab_taille_tax = tab_taille_tax[-c(14,39,93,101,124),]
rownames(tab_taille_tax) = NULL

esp = table(tab_taille_tax$esp_majoritaire)
tab_taille_tax$espece = tab_taille_tax$esp_majoritaire
tab_taille_tax$espece <- ifelse(
  tab_taille_tax$esp_majoritaire %in% c("Quercus_variabilis", "Quercus_robur", "Quercus_sp."),
  "Quercus",
  ifelse(
    tab_taille_tax$esp_majoritaire %in% c("Microbacterium_sp.", "Microbacterium_testaceum"),
    "Microbacterium" ,
    ifelse(
      tab_taille_tax$esp_majoritaire %in% c("Rahnella_aquatilis", "Rahnella_sp."),
      "Rahnella" ,
      ifelse(
        tab_taille_tax$esp_majoritaire %in% c("Gilliamella_apicola", "Gilliamella_sp."),
        "Gilliamella" ,
    ifelse(
      tab_taille_tax$esp_majoritaire %in% c("Penicillium_brevicompactum", "Penicillium_sp."),
      "Penicillium" ,
      ifelse(
        tab_taille_tax$esp_majoritaire %in% c("Apilactobacillus_apinorum", "Apilactobacillus_kunkee", "Apilactobacillus_kunkeei"),
        "Apilactobacillus" ,
        ifelse(
          tab_taille_tax$esp_majoritaire %in% c("Tatumella_ptyseos", "Tatumella_sp."),
          "Tatumella" ,
  ifelse(
    tab_taille_tax$esp_majoritaire %in% c("Apis_mellifera_ligustica", "Apis_mellifera_sp.", "Apis_mellifera"),
    "Apis", tab_taille_tax$esp_majoritaire
  )))))
)) )
count = table(tab_taille_tax$espece)
##################Eukaryota
tab_eucaryote = tab_taille_tax
tab_eucaryote = tab_eucaryote %>% filter(domaine == "Eukaryota")
count = table(tab_eucaryote$espece)
tab_eucaryote2 = tab_eucaryote %>% as.data.frame() %>% arrange(desc(size_contig))
 

total_size_by_species <- aggregate(size_contig ~ espece, data = tab_eucaryote2, sum)
tab_eucaryote2 <- merge(tab_eucaryote2, total_size_by_species, by = "espece", suffixes = c("", "_total"))


library(dplyr)

tab_eucaryote_unique <- tab_eucaryote2 %>%
  distinct(espece, .keep_all = TRUE)

summary(tab_eucaryote_unique)

top3_sizes <- tab_eucaryote_unique %>%
  arrange(desc(size_contig_total)) %>%
  head(3)


panel2 = ggplot(tab_eucaryote_unique, aes(x = "", y = size_contig_total, fill = espece)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar(theta = "y", start = 0) + 
  theme_void() +
  geom_text(data = top3_sizes[1, ], aes(label = size_contig_total), position = position_stack(vjust = 0.5)) +
  geom_text_repel(data = top3_sizes[2:3, ], aes(label = size_contig_total, x= 1.4), 
                  direction = "x", nudge_x = 0.2, segment.color = "black")


###################Bacteria
tab_bact = tab_taille_tax
tab_bact = tab_bact %>% filter(domaine == "Bacteria")
count = table(tab_bact$espece)
sort(tab_bact_unique$size_contig_total)
tab_bact = tab_bact %>% as.data.frame() %>% arrange(desc(size_contig))


total_size_by_species <- aggregate(size_contig ~ espece, data = tab_bact, sum)
tab_bact <- merge(tab_bact, total_size_by_species, by = "espece", suffixes = c("", "_total"))
order(tab_bact_unique$size_contig_total)
tab_bact_unique <- tab_bact %>%
  distinct(espece, .keep_all = TRUE)

summary(tab_bact_unique)
ggplot(tab_bact_unique, aes(x="", y=size_contig_total, fill=espece)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  theme_void() 


panel3 = ggplot(tab_bact_unique, aes(x = factor(1), y = size_contig_total, fill = espece)) +
  geom_bar(stat = "identity", width = 2, color = "white") +
  coord_polar(theta = "y", start = 0) + 
  theme_void() 




######################## Virus
tab_viruse = tab_taille_tax
tab_viruse = tab_viruse %>% filter(domaine == "Viruses")
count = table(tab_viruse$espece)


total_size_by_species <- aggregate(size_contig ~ espece, data = tab_viruse, sum)
tab_viruse <- merge(tab_viruse, total_size_by_species, by = "espece", suffixes = c("", "_total"))

tab_viruse_unique <- tab_viruse %>%
  distinct(espece, .keep_all = TRUE)

ggplot(tab_viruse_unique, aes(x="", y=size_contig_total, fill=espece)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  theme_void() 
  #theme(legend.position="none") +
  
  #geom_text(aes(y = size_contig, label = size_contig), color = "white", hjust=2, vjust=3) 
#scale_fill_brewer(palette="Set2")

panel4 = ggplot(tab_viruse_unique, aes(x = "", y = size_contig_total, fill = espece)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar(theta = "y", start = 0) + 
  theme_void() 

###################################### PANEL
library(gridExtra)
# Arrange the plots with grid.arrange
grid.arrange(panel1, panel2, panel3, panel4, nrow = 2, ncol = 2, widths = c(0.5, 1, 2, 0.5))

grid.newpage()
# Create layout : nrow = 1, ncol = 2
pushViewport(viewport(layout = grid.layout(nrow = 2, ncol = 2)))
# A helper function to define a region on the layout
define_region <- function(row, col, width = 1 , height = 1){
  viewport(layout.pos.row = row, layout.pos.col = col, width = width, height = height)
} 
# Arrange the plots
print(panel1, vp = define_region(row = 1, col = 1, width = 0.25)) 
print(panel2, vp = define_region(row = 1, col = 2, width = 0.25))
print(panel3, vp = define_region(row = 2, col = 1, width = 0.5))
print(panel4, vp = define_region(row = 2, col = 2, width = 0.25))
