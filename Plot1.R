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

tot_pm<-NEI %>%
        group_by(year) %>%
        summarise(sum(Emissions, na.rm = TRUE)) 

png(file = "Plot1.png", width = 480,height = 480,units = "px")

barplot(tot_pm$`sum(Emissions, na.rm = TRUE)`,names.arg = tot_pm$year,xlab = "Year", ylab = "PM2.5",
     main = "Total PM2.5 per year",pch = 3,col = "blue",ylim = c(0,8000000))

dev.off()