#Read in the dataset, pulling only the rows for the days that we need, handle the "?" as NAs.
dat<-read.table(pipe('grep "^[1-2]/2/2007" "household_power_consumption.txt"'), na.strings="?", sep=";")

#That approach creates a file with data only, so add in a header row for each column
names(dat)[1]<-paste("Date")
names(dat)[2]<-paste("Time")
names(dat)[3]<-paste("Global_active_power")
names(dat)[4]<-paste("Global_reactive_power")
names(dat)[5]<-paste("Voltage")
names(dat)[6]<-paste("Global_intensity")
names(dat)[7]<-paste("Sub_metering_1")
names(dat)[8]<-paste("Sub_metering_2")
names(dat)[9]<-paste("Sub_metering_3")

#Do the date conversions necessary to show days on the x axis while still being date values.
dat<-within(dat, {timestamp=paste(Date,Time)})
dat<-within(dat, {timestamp2=strptime(timestamp, '%d/%m/%Y %H:%M:%S')})

#Open a PNG device first, then close it at the end.  This gets chart 3 to work for some reason.
png("plot4.png")
par(mfrow=c(2,2)) #set up a 2x2 grid of plots
with(dat, {
  plot(dat$timestamp2, dat$Global_active_power, type="line", ylab="Global Active Power (kilowatts)", xlab="")
  plot(dat$timestamp2, dat$Voltage, type="line", ylab="Voltage", xlab="")
  plot(dat$timestamp2, dat$Sub_metering_1, type="line", ylab="Energy sub metering", xlab="")
  lines(dat$timestamp2, dat$Sub_metering_2, col="red")
  lines(dat$timestamp2, dat$Sub_metering_3, col="blue")
  legend("topright", lty=c(1,1,1), col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(dat$timestamp2, dat$Global_reactive_power, type="line", ylab="Global_reactive_power", xlab="")
  dev.off()
})