### This code reads the data between 1/2/2007 and 2/2/2007 and creates a PNG file containing a Line Chart of Energy_sub_metering
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

## Create Energy Sub Metering Chart and save to plot3.png
png("plot3.png",, width = 480, height = 480)

plot (x= dat_mod$DateTime, dat_mod$Sub_metering_1,type ="l",
      xlab ="",
      ylab = "Energy sub metering")

## add additional lines
lines (dat_mod$DateTime, dat_mod$Sub_metering_2, col ="red")
lines (dat_mod$DateTime, dat_mod$Sub_metering_3, col ="blue")

## Add Legend 
legend("topright",
       c("Sub_metering_1 ","Sub_metering_2","Sub_metering_3"),
       lwd=c(2.5,2.5,2.5),col=c("black", "red","blue"))

dev.off()