library(dplyr)
library(tidyr)
library(ggplot2)

directory <- "./Graph"
file_name <- "exdata_data_NEI_data.zip"
dir <- paste(directory,"/",file_name,sep = '')

unzip(zipfile = dir)

NEI<-readRDS("summarySCC_PM25.rds")
NEI <- as.tbl(NEI)
head(NEI)
NEI$Emissions<-as.numeric(NEI$Emissions)

SCC <- readRDS("Source_Classification_Code.rds")
SCC <- as.tbl(SCC)
head(SCC)

coal<-grepl("Fuel Comb.*Coal",SCC$EI.Sector)
coal_scc<-SCC[coal,]

NEI_coal<-NEI[(NEI$SCC %in% coal_scc$SCC),]

NEI_coal_tot<- NEI_coal %>%
        group_by(year) %>%
        summarise(sum(Emissions))

colnames(NEI_coal_tot)[2]<-"pm"

png(file = "Plot4.png", width = 960,height = 480,units = "px")

g<-ggplot(NEI_coal_tot,aes(factor(year),pm))
g+geom_bar(stat = "identity",width = 0.5,fill = "#FF6666") +
        ggtitle("Yearly PM2.5 Emissions coal") +
        theme(plot.title = element_text(hjust = 0.5)) +
        xlab("Year") + 
        ylab("Total PM2.5") +
        geom_text(aes(label = round(pm,digits = 1)), vjust = 1.0, colour = "white",size = 2)
        

dev.off()

