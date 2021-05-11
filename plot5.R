library("data.table")
library(ggplot2)
path <- getwd()

# get data
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

# read data
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Gather the subset of the NEI data which corresponds to vehicles
NEISCC <- merge(NEI, SCC, by="SCC")
str(NEISCC)

# Subset the vehicles NEI data to Baltimore's fip
subsetNEI  <- NEI[NEI$fips=="24510"  & NEI$type=="ON-ROAD", ]


AggregatedTotalYear <- aggregate(Emissions ~ year, subsetNEI, sum)

png("plot5.png")

g <- ggplot(AggregatedTotalYear, aes(factor(year), Emissions))
g <- g + geom_bar(stat = "identity") + xlab("time (year)") + ylab(expression("Total PM"[2.5]*" Emissions (10^5 ton)")) +
  ggtitle("Total Emissions of motor vehicles in Baltimore City, Maryland over years")
print(g)

dev.off()