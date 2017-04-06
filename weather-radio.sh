#!/bin/sh

#sleep 5

# Below are some examples of different ways to stream, only the last one is
# un-commented so only it will run.

# Using LAME and EZ Stream
#rtl_fm -f 162.55M -s 48000 -p 14 | lame --bitwidth 16 --signed -s 48000 --lowpass 3500 --abr 64 --scale 9 -r -m m - - | ezstream -c ezstream.xml

# Using SOX and EZ Stream
#rtl_fm -f 162.55M -s 48000 -p 14 | sox -t raw -r 48000 -b 16 -e signed -c 1 -v 5 - -r 48000 -t .mp3 -c 1 -C 64 - sinc -3.3k | ezstream -c ezstream.xml

# Using Sox/Play with ALSA Loopback
#rtl_fm -f 162.55M -s 48000 -p 14 | play -q -r 48000 -t raw -e s -b 16 -c 1 -V1 -v 5 -
rtl_fm -f 162.55M -s 48000 -p 1 | play -q -r 48000 -t raw -e s -b 16 -c 1 -V1 -v 5 - sinc -3.5k

