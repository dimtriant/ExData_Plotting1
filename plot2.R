### This code reads the data between 1/2/2007 and 2/2/2007 and creates a PNG file containing a Line Chart of Global_active_power
### The text file household_power_consumption.txt needs to be in your working directory

## Read the text file for dates of 1/2/2007 and 2/2/2007
dat_orig <- read.table(pipe('findstr /B /R ^[1-2]/2/2007 household_power_consumption.txt'),header=F, sep=';')

## Read the column names and assign to dat_orig data frame
colnames(dat_orig) <-names(read.table('household_power_consumption.txt', header=TRUE,sep=";",nrows=1))

## Create a copy to preserve original data frame intact
dat_mod <- dat_orig

## Paste the date and time into a single DateTime column
dat_mod$DateTime <- apply( dat_mod[ , c('Date', 'Time') ] , 1 , paste , collapse = " " )

## Remove the redundant date and time columns
dat_mod <- dat_mod[ , !( names( dat_mod ) %in% c('Date','Time') ) ]

## Reorder columns so DateTime is at the beginning
dat_mod <- dat_mod[,c('DateTime','Global_active_power','Global_reactive_power','Voltage','Global_intensity','Sub_metering_1','Sub_metering_2','Sub_metering_3')]

## Change the class of DateTime
dat_mod$DateTime <- strptime(dat_mod$DateTime, "%d/%m/%Y %H:%M:%S")

## Create Global Active Power Chart and set title and axis name and save to plot2.png
png("plot2.png",, width = 480, height = 480)

plot(dat_mod$DateTime,
     dat_mod$Global_active_power,
     ylab="Global Active Power (kilowatts)",
     xlab="", 
     type="l" )

dev.off()