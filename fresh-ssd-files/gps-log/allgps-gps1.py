import binascii

file = open('allgps', 'rb')
#56 byte string 6 byte timestamp mme3g from unix epoch


b = []
i = 0
while i < 56:
	b.append(binascii.hexlify(file.read(1)))
	i += 1

year = int(b[27] + b[26],16)
month = int(b[28],16)
day = int(b[29],16)
hour = int(b[30],16)
minutes = int(b[31],16)
seconds = int(b[32],16)

outfile = open('allgps' + repr(year) + repr(month).zfill(2) + repr(day).zfill(2) + repr(hour).zfill(2) + '.gpx', 'w')
outfile.write("""<?xml version="1.0" encoding="UTF-8" standalone="no" ?>

<gpx xmlns="http://www.topografix.com/GPX/1/1" creator="AudiBUS" version="1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
  <metadata>
    <time>""")

outfile.write(repr(year) + "-" + repr(month).zfill(2) + "-" + repr(day).zfill(2) + "T" + repr(hour).zfill(2) + ":" + repr(minutes).zfill(2) + ":" + repr(seconds).zfill(2) + """Z</time>
  </metadata>
  <trk>
    <name>AudiBUS trip """ + repr(year) + repr(month).zfill(2) + repr(day).zfill(2) + repr(hour).zfill(2) + """</name>
    <trkseg>
""")

while b[0] != "" :
#	c = "0x" + b[5] + b[4] + b[3] + b[2] + b[1] + b[0]
#	timestampdate = int(c,16)
	
	year = int(b[27] + b[26],16)
	month = int(b[28],16)
	day = int(b[29],16)
	hour = int(b[30],16)
	minutes = int(b[31],16)
	seconds = int(b[32],16)
	height = float(int(b[19] + b[18] + b[17] + b[16],16)) / 10
	#deal with negative height as it is a signed int   - (1 << 32)
	latitude = float(int(b[11] + b[10] + b[9] + b[8],16)) / 1000000
	longitude = float(int(b[15] + b[14] + b[13] + b[12],16) - (1 << 32)) / 1000000
	outfile.write("""      <trkpt lat=""" + '"' + repr(latitude) + '" lon="' + repr(longitude) + '"' + """>
        <ele>""" + repr(height) + """</ele>
        <time>""" + repr(year) + "-" + repr(month).zfill(2) + "-" + repr(day).zfill(2) + "T" + repr(hour).zfill(2) + ":" + repr(minutes).zfill(2) + ":" + repr(seconds).zfill(2) + """Z</time>
      </trkpt>
""")
	
	i = 0
	b = []
	while i < 56:
		b.append(binascii.hexlify(file.read(1)))
		i += 1
		
	

file.close()

outfile.write("""    </trkseg>
  </trk>
</gpx>
""")
outfile.close()


