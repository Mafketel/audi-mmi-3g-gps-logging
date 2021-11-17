# audi-mmi-3g-gps-logging
Logging the position of the car on an sdcard, startup script origin not clear to me, logging setup and time change is what I did.

files to copy on sdcard, insert when mmi is fully done booting (run trough all the screens to be sure)
image will popup and ask to press anykey wait and another image will popup all is done press any key. 
Keep the sdcard in the mmi to keep loggin your position.
You need to do this everytime the mmi starts up.

python2.7 script to copy binary allgps position data to gpx file. use:  python allgps.py allgps1

This W.I.P. and enough for for now. Eventually I would like to be a more permanent logging solution.

I tried to adjust the time in the mmi from the gps time but I can only change the time of the qnx os and the utility provided by audi to read the user shown time seems to be readonly.
