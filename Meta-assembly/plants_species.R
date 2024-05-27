library(dplyr)
library(ggplot2)
library(ggrepel)
library(grid)
library(gridExtra)
library(RColorBrewer)

setwd("//pnas2.stockage.inrae.fr/user_genphyse/non-tit/nteixido/Bureau/mallaurie/mapping/mag_mallaurie/script_PCA_plant_families/script_PCA_plant_families/")
dataPCA=read.table("taxons_mapping_plants_initialfile_Noemie_modifTibo_familymerged.txt",header=T)
dataPCAonly=dataPCA[,2:8]
row.names(dataPCAonly)<-dataPCA[,1]


dataPCAonlyLog=as.matrix(log10(dataPCAonly))
dataPCAonlyLog[dataPCAonlyLog == "-Inf"] <- NA

# highlight the Chestnut samples in the bar (chocolate vs. grey)
colSide <-ifelse(row.names(dataPCAonlyLog)=="GPS220994","chocolate4",
          ifelse(row.names(dataPCAonlyLog)=="GPS221006","chocolate4",
          ifelse(row.names(dataPCAonlyLog)=="GPS221008","chocolate4",
          ifelse(row.names(dataPCAonlyLog)=="GPS221051","chocolate4",
          ifelse(row.names(dataPCAonlyLog)=="GPS221059","chocolate4",
          ifelse(row.names(dataPCAonlyLog)=="GPS221065","chocolate4",
          ifelse(row.names(dataPCAonlyLog)=="GPS221072","chocolate4",
          ifelse(row.names(dataPCAonlyLog)=="GPS221079","chocolate4",
          ifelse(row.names(dataPCAonlyLog)=="GPS221101","chocolate4",
          ifelse(row.names(dataPCAonlyLog)=="GPS221067","chocolate4",
          ifelse(row.names(dataPCAonlyLog)=="GPS221082","chocolate4",
    #Robinier             
          ifelse(row.names(dataPCAonlyLog)=="GPS221086","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221023","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221004","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221018","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221069","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221002","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221107","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221038","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221021","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221035","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221076","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221055","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221049","chocolate",
          ifelse(row.names(dataPCAonlyLog)=="GPS221095","chocolate",
       #lavande 
       ifelse(row.names(dataPCAonlyLog)=="GPS221013","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS220999","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS221090","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS221037","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS220998","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS220997","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS221019","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS221031","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS221011","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS221010","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS221071","pink2",
       ifelse(row.names(dataPCAonlyLog)=="GPS221053","pink2",
      #Euphorbe 
      ifelse(row.names(dataPCAonlyLog)=="GPS221098","#E2EE35",
      #framboisier/ronce
      ifelse(row.names(dataPCAonlyLog)=="GPS221058","#69EE35",
      #jujubier
      ifelse(row.names(dataPCAonlyLog)=="GPS221075","#43BC14",
      #polyfloral
      ifelse(row.names(dataPCAonlyLog)=="GPS221028","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221015","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221084","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS220996","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221005","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221041","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221043","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221061","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221073","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221078","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221080","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221092","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221094","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221100","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221104","#CCA60E",
      ifelse(row.names(dataPCAonlyLog)=="GPS221105","#CCA60E",
      #pissenlit
      ifelse(row.names(dataPCAonlyLog)=="GPS221033","#5DE2E7",
      ifelse(row.names(dataPCAonlyLog)=="GPS221045","#5DE2E7",
      ifelse(row.names(dataPCAonlyLog)=="GPS221103","#5DE2E7",
      #roquette
      ifelse(row.names(dataPCAonlyLog)=="GPS221064","#CCBBF5",
                 "grey"))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))



colSide <- rep("grey", nrow(dataPCAonlyLog))


color_mapping <- list(
  chocolate4 = c("GPS220994", "GPS221006", "GPS221008", "GPS221051", "GPS221059", "GPS221065", "GPS221072", "GPS221079", "GPS221101", "GPS221067", "GPS221082"),
  chocolate = c("GPS221086", "GPS221023", "GPS221004", "GPS221018", "GPS221069", "GPS221002", "GPS221107", "GPS221038", "GPS221021", "GPS221035", "GPS221076", "GPS221055", "GPS221049", "GPS221095"),
  pink2 = c("GPS221013", "GPS220999", "GPS221090", "GPS221037", "GPS220998", "GPS220997", "GPS221019", "GPS221031", "GPS221011", "GPS221010", "GPS221071", "GPS221053"),
  "#E2EE35" = c("GPS221098"),
  "#69EE35" = c("GPS221058"),
  "#43BC14" = c("GPS221075"),
  "#CCA60E" = c("GPS221028", "GPS221015", "GPS221084", "GPS220996", "GPS221005", "GPS221041", "GPS221043", "GPS221061", "GPS221073", "GPS221078", "GPS221080", "GPS221092", "GPS221094", "GPS221100", "GPS221104", "GPS221105"),
  "#5DE2E7" = c("GPS221033", "GPS221045", "GPS221103"),
  "#CCBBF5" = c("GPS221064")
)


for(color in names(color_mapping)) {
  ids <- color_mapping[[color]]
  colSide[row.names(dataPCAonlyLog) %in% ids] <- color
}



heatmap(dataPCAonlyLog,na.rm=TRUE,cexRow=1,cexCol=1, RowSideColors = colSide)


names_list <- c("Fagaceae", "Fabaceae", "Lamiaceae", "Euphorbiaceae", "Rosaceae", "Rhamnaceae", "polyfloral", "Asteraceae", "Brassicaceae")  
colors_list <- c("chocolate4", "chocolate", "pink2", "#E2EE35", "#69EE35", "#43BC14", "#CCA60E", "#5DE2E7", "#CCBBF5")  

egend("left", legend = names_list, fill = colors_list, title = "True plants", text.col = "black")
legend("topleft", legend = names_list, fill = colors_list, title = "True plants", text.col = "black", xpd = TRUE, cex = 0.6, x= 0.001, y = 1.15)



dev.new(width = 25, height = 25)

heatmap(dataPCAonlyLog, na.rm = TRUE, cexRow = 0.9, cexCol = 0.9, RowSideColors = colSide)
