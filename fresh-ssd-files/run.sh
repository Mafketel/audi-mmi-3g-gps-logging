#!/bin/ksh
#
# 3G H gps logging on sd script modified by Mafketel
#
#

# Remove script temporal files
remove_script(){
    /bin/rm -f /tmp/copie_scr.sh
    echo > /tmp/copie_scr.sh
    /bin/rm -f /tmp/run.sh
    echo > /tmp/run.sh
}

# Try to find the SD Card
sdcard=`ls /mnt|grep sdcard.*t`

if [ -z $sdcard ]; then
  sdcard=`ls /fs|grep sd*`
fi

if [ -z $sdcard ]; then  
    # Remove script
    remove_script

    # Exit
    exit 0
fi

# Define destination path
dstPath=/mnt/$sdcard

# Log file
logfile="$dstPath/install.log"

# Show image and wait to key press
show_screen(){
    $dstPath/utils/showScreen "$dstPath/screens/$1"
}

# Save message log to file
flog(){
    # Timestamp
    local tstamp=`date +"%m/%d/%Y ""%T"`
    echo -ne "$tstamp - $1\r\n" >> $logfile
}


# Mount the SD card for read/write
mount -uw $dstPath
flog "SD mounted in $dstPath"
flog "this is where audi gets their time $(getTime)"

# Setup complete now start exuting or remove sdcard
show_screen "scriptStart.png"

#cp /mnt/efs-system/usr/bin/getTime $dstPath/getTime
#cp /mnt/nav/acios_db.ini $dstPath/acios_db.ini-hdd

gpsindex=`cat "$dstPath/gps-log/gpsindex.txt"`
flog "old index number for gps logging $gpsindex"
gpsindex=$(($gpsindex+1))
flog "start gps logging on sd index $gpsindex"
flog "this is where audi gets their time $(getTime)"
#gpsdate=`grep -m1 "" /dev/ndr/debug/name/sensor/GPS/Date` m not a function
#gpstime=`grep -m1 "" /dev/ndr/debug/name/sensor/GPS/Time`
#gpsdate=`$dstPath/utils/sed -n 1p /dev/ndr/debug/name/sensor/GPS/Date` >>$logfile did something weird maps are blocked during read
#gpstime=`$dstPath/utils/sed -n 1p /dev/ndr/debug/name/sensor/GPS/Time` >>$logfile
#while read line
# do
#	gpsdate=$line
# done < /dev/ndr/debug/name/sensor/GPS/Date
#while read line
# do
#	gpstime=$line
# done < /dev/ndr/debug/name/sensor/GPS/Time
read -r gpsdate < /dev/ndr/debug/name/sensor/GPS/Date
read -r gpstime < /dev/ndr/debug/name/sensor/GPS/Time
#gpsdate=`$dstPath/utils/tail -n1 /dev/ndr/debug/name/sensor/GPS/Date` >> $logfile
#gpstime=`$dstPath/utils/tail -n1 /dev/ndr/debug/name/sensor/GPS/Time` >> $logfile

flog "gpsdate $gpsdate and gpstime $gpstime"

gpsyear=$((16#`echo $gpsdate | $dstPath/utils/cut -c22,23,19,20`))
flog "gpsyear $gpsyear"
typeset -Z2 gpsmonth=$((16#`echo $gpsdate | $dstPath/utils/cut -c25,26`))
typeset -Z2 gpsday=$((16#`echo $gpsdate | $dstPath/utils/cut -c28,29`))
typeset -Z2 gpshour=$((16#`echo $gpstime | $dstPath/utils/cut -c19,20`))
typeset -Z2 gpsmin=$((16#`echo $gpstime | $dstPath/utils/cut -c22,23`))
typeset -Z2 gpssec=$((16#`echo $gpstime | $dstPath/utils/cut -c25,26`))

changedate=$gpsyear$gpsmonth$gpsday$gpshour$gpsmin.$gpssec
flog "$changedate"
date $changedate >> $logfile

flog "$gpsyear-$gpsmonth-$gpsday-$gpshour:$gpsmin:$gpssec"
rtc >> $logfile

echo -ne "$gpsindex" > $dstPath/gps-log/gpsindex.txt


cat /dev/ndr/name/sensor/Accelerometer/Internal3Daccelerometer >> "$dstPath/gps-log/Internal3Daccelerometer$gpsindex" &
cat /dev/ndr/name/sensor/GPS/AllGps >> "$dstPath/gps-log/AllGps$gpsindex" &
#cat /dev/ndr/name/sensor/GPS/AntennaState >> "$dstPath/ndrnamesensor/AntennaState" &
#cat /dev/ndr/name/sensor/GPS/Date >> "$dstPath/ndrnamesensor/Date" &
#cat /dev/ndr/name/sensor/GPS/EastSpeed >> "$dstPath/ndrnamesensor/EastSpeed" &
#cat /dev/ndr/name/sensor/GPS/Fix >> "$dstPath/ndrnamesensor/Fix" &
#cat /dev/ndr/name/sensor/GPS/HDOP >> "$dstPath/ndrnamesensor/HDOP" &
#cat /dev/ndr/name/sensor/GPS/Heading >> "$dstPath/ndrnamesensor/Heading" &
#cat /dev/ndr/name/sensor/GPS/Height >> "$dstPath/ndrnamesensor/Height" &
#cat /dev/ndr/name/sensor/GPS/HorizontalPositionError >> "$dstPath/ndrnamesensor/HorizontalPositionError" &
#cat /dev/ndr/name/sensor/GPS/Latitude >> "$dstPath/ndrnamesensor/Latitude" &
#cat /dev/ndr/name/sensor/GPS/Longitude >> "$dstPath/ndrnamesensor/Longitude" &
#cat /dev/ndr/name/sensor/GPS/LowLevel >> "$dstPath/ndrnamesensor/LowLevel" &
#cat /dev/ndr/name/sensor/GPS/NorthSpeed >> "$dstPath/ndrnamesensor/NorthSpeed" &
#cat /dev/ndr/name/sensor/GPS/PDOP >> "$dstPath/ndrnamesensor/PDOP" &
#cat /dev/ndr/name/sensor/GPS/SatelliteInfo >> "$dstPath/ndrnamesensor/SatelliteInfo" &
#cat /dev/ndr/name/sensor/GPS/SatellitesUsed >> "$dstPath/ndrnamesensor/SatellitesUsed" &
#cat /dev/ndr/name/sensor/GPS/SatellitesVisible >> "$dstPath/ndrnamesensor/SatellitesVisible" &
#cat /dev/ndr/name/sensor/GPS/SignalQuality >> "$dstPath/ndrnamesensor/SignalQuality" &
#cat /dev/ndr/name/sensor/GPS/Speed >> "$dstPath/ndrnamesensor/Speed" &
#cat /dev/ndr/name/sensor/GPS/Time >> "$dstPath/ndrnamesensor/Time" &
#cat /dev/ndr/name/sensor/GPS/VDOP >> "$dstPath/ndrnamesensor/VDOP" &
#cat /dev/ndr/name/sensor/GPS/VerticalPositionError >> "$dstPath/ndrnamesensor/VerticalPositionError" &
#cat /dev/ndr/name/sensor/GPS/VerticalSpeed >> "$dstPath/ndrnamesensor/VerticalSpeed" &
cat /dev/ndr/name/sensor/Gyro/InternalGyro >> "$dstPath/gps-log/InternalGyro$gpsindex" &
#cat /dev/ndr/name/sensor/Version/Date >> "$dstPath/ndrnamesensor/versiondate" &
#cat /dev/ndr/name/sensor/Version/Identifier >> "$dstPath/ndrnamesensor/versionIdentifier" &
cat /dev/ndr/name/sensor/WheelCounter/AllWheels >> "$dstPath/gps-log/AllWheels$gpsindex" &
cat /dev/ndr/name/sensor/ReverseGear >> "$dstPath/gps-log/ReverseGear$gpsindex" &
cat /dev/ndr/name/sensor/Temperature >> "$dstPath/gps-log/Temperature$gpsindex" &


#information logged
#sloginfo > "$dstPath/systemsloginfo.txt"

# Shows final screen
show_screen "scriptDone.png"

# Write to log
flog "copying successful"


# Remove script
remove_script