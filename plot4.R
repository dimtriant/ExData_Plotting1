### This code reads the data between 1/2/2007 and 2/2/2007 and creates a PNG file containing the 4 plots required
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

## Open a 480x480 PNG file called plot4.png
png("plot4.png",, width = 480, height = 480)

## Set the default for 4 quadrants of 4 different graphs
par(mfrow=c(2,2))

## Create Chart 1-----------------------------------------------------
plot(dat_mod$DateTime,
     dat_mod$Global_active_power,
     ylab="Global Active Power",
     xlab="", 
     type="l" )

## Create Chart 2-----------------------------------------------------
plot(dat_mod$DateTime,
     dat_mod$Voltage,
     ylab="Voltage",
     xlab="datetime", 
     type="l" )

## Create Chart 3-----------------------------------------------------
plot (x= dat_mod$DateTime, dat_mod$Sub_metering_1,type ="l",
      xlab ="",
      ylab = "Energy sub metering")

## add additional lines
lines (dat_mod$DateTime, dat_mod$Sub_metering_2, col ="red")
lines (dat_mod$DateTime, dat_mod$Sub_metering_3, col ="blue")

## Add Legend 
legend("topright",
       c("Sub_metering_1 ","Sub_metering_2","Sub_metering_3"),
       lwd=c(2.5,2.5,2.5),col=c("black", "red","blue"), bty="n")

## Create Chart 4-----------------------------------------------------
plot(dat_mod$DateTime,
     dat_mod$Global_reactive_power,
     ylab="Global_reactive_power",
     xlab="datetime", 
     type="l")

dev.off()
