# Optional Steps

### Optional (but recommended): PPM Error Correction

Since the RTL SDR sticks are made with super cheap crystals sometimes the frequency needs to be corrected. Before doing this, stop the RTL SDR script as mentioned above.  Here's a guide to show you how to do that: http://314256.blogspot.com/2015/03/how-to-use-kal-software-to-workout-ppm.html  In addition to the packages it has you install, add these:

    sudo apt-get install librtlsdr-dev usb-1.0

Then modify weather_radio_scripts/weather-radio.sh to look like this:

    rtl_fm -f 162.55M -s 48000 -p 14

Note the addition of "-p 14" use whatever number is calculated from the instructions.  Then restart the RTL SDR script as mentioned above.

### Optional: Purchase a UPS (Uninterruptible Power Supply)

Since power outages often occur with sever weather, a UPS would be a good purchase to keep the weather radio setup running during a power outage.  At minimum, plug in the Raspberry Pi, modem (from whatever type of ISP you have),  and router (if you have one).  It could be that the router and modem are one unit, in which case only the router/modem and Raspberry Pi need to be plugged in.  The power consumption of these two or three units will be fairly low, around 10-20 watts which will allow the UPS to work for 1-3 hours depending on the size.  Search Amazon for Uninterruptible Power Supply to find options, APC is generally a good brand.

### Notes on Reception

If you are finding that you cannot get a good signal, here's some tips to improve that. 

* Make sure the antenna you have is about 17 1/4 inches long.  This is a quarter wave of 162.5 Mhz and should work for all the weather radio frequencies.  There are more advanced antenna designs that are out of scope for this tutorial, but you may need to resort to a Yagi style antenna if you're not able to get a good signal with a monopole design.  You could also search for "quarter wave ground plane antenna" on Google and you'll get lots of info on how to make one, it's fairly simple if you're good with a soldering iron.
* Height matters with antennas, the higher up you can get it, the better reception you'll get.  For example, I have my Raspberry Pi in the basement, but run a coax cable up to the attic which is about 15 feet of the ground.  I happen to live in an area that gets good reception regardless, but if you're having trouble, get the antenna up as high as you can.  You may need to resort to an outdoor antenna, but if you do that, make sure it's made for outdoors, and is grounded.

### Optional: Create a script to monitor the uptime

Sometimes the weather radio will go down for various reasons, network issues, the Icecast server goes down, etc.  One way to monitor this is to create a script to check that the stream is mounted on the Icecast server, and to send an email when it's down.  It would be best to run this script from an outside source.  For exmaple, I have my Icecast server on a Linode instance and I have it checked from a separate Linode instance.  If this is not possible, just run it on your Raspberry Pi, which is better than nothing.

First follow this tutorial:  https://www.howtoforge.com/tutorial/configure-postfix-to-use-gmail-as-a-mail-relay to get Gmail set up as a relay.

Then create a script to check your mount point:

    #!/bin/bash
    
    url="http://your_icecast_url:8000"
    status_code=$(curl -v --silent $url 2>&1 | grep your/moutpoint)
    date=`date`

    if [ "$status_code" == "" ]
    then
        mail -s "Weather Radio is Down" your@email.com <<< "The weather radio is down at $date."
    fi

and save it as check_weather_radio.sh or something similar.  Then make sure to make it executiable:

    chmod +x check_weather_radio.sh

Then add a cron to run every 15 or 30 minutes (mine is every 15):

    crontab -e

and add the following:

    */15 * * * * /path/to/check-weather-radio

This is opened in nano so type Ctrl+o to save (hit enter when it asks what file to save as) and Ctrl+x to exit.  If all went well you should see:

    crontab: installing new crontab

Alternatively, you could copy the script to /etc/cron.hourly where it will get run once an hour.  Then you can type crontab -e again and you should still see the line you added.  You can test this by stopping Darkice and waiting 15-30 minutes to see if there's an email.

### Recommended: Software Updates

Occasionally there are software updates which the repository will handle for you.  To update log in and type:

    sudo apt-get update
    sudo apt-get dist-upgrade

It's usually good to do this about once a week, sometimes the Pi will need to be rebooted, but usually only if there is a kernel update.

### Recommended: Checking Logs

The darkice output will be sent to /var/log/darkice.log and it's good to check this from time to time.  Occasonally you'll see something like this in the log:


    16-Mar-2017 11:45:21 BufferedSink, healed: 0  /  480000
    16-Mar-2017 11:45:23 BufferedSink, healed: 0  /  480000
    16-Mar-2017 11:56:03 BufferedSink, new peak: 169  /  480000
    16-Mar-2017 11:56:03 BufferedSink, new peak: 506  /  480000
    16-Mar-2017 11:56:03 BufferedSink, new peak: 1215  /  480000
    16-Mar-2017 11:56:03 BufferedSink, new peak: 2762  /  480000
    16-Mar-2017 11:56:03 BufferedSink, new peak: 5530  /  480000
    16-Mar-2017 11:56:04 BufferedSink, new peak: 11062  /  480000
    16-Mar-2017 11:56:06 BufferedSink, new peak: 22231  /  480000
    16-Mar-2017 11:56:06 BufferedSink, new peak: 55  /  480000
    16-Mar-2017 11:56:07 BufferedSink, new peak: 198  /  480000
    16-Mar-2017 11:56:07 BufferedSink, new peak: 410  /  480000
    16-Mar-2017 11:56:07 BufferedSink, new peak: 938  /  480000
    16-Mar-2017 11:56:07 BufferedSink, new peak: 1919  /  480000
    16-Mar-2017 11:56:08 BufferedSink, new peak: 3858  /  480000
    16-Mar-2017 11:56:09 BufferedSink, new peak: 44525  /  480000
    16-Mar-2017 11:56:09 BufferedSink, new peak: 7754  /  480000
    16-Mar-2017 11:56:12 BufferedSink, new peak: 15531  /  480000
    16-Mar-2017 11:56:15 BufferedSink, new peak: 89148  /  480000
    16-Mar-2017 11:56:17 BufferedSink, new peak: 31153  /  480000
    16-Mar-2017 11:56:18 TcpSocket :: write, send error 32
    16-Mar-2017 11:56:18 Exception caught in BufferedSink :: write1
    16-Mar-2017 11:56:18 HTTP/1.0 200
    16-Mar-2017 11:56:28 BufferedSink, healed: 0  /  480000
    16-Mar-2017 11:56:32 BufferedSink, healed: 0  /  480000
    16-Mar-2017 12:13:35 BufferedSink, new peak: 347  /  480000
    16-Mar-2017 12:13:35 BufferedSink, healed: 0  /  480000

This is darkice dealing with network issues, but if you see multiple messages that say "buffer overrun" then first restart darikce (see post 1) and if that doesn't fix it, there could be issues with your internet connection.  You may need to restart your router and/or modem to fix these, otherwise contact your ISP.

### Optional: Run Your Icecast Server Externally

If you're worried about your bandwidth or your ISP has limitations Linode (http://www.linode.com/) has a number of inexpensive options that can be used to set up an Icecast server, starting at $5 a month for 1TB of data transfer (both in and out).  When setting up the Linode, choose the latest Ubuntu LTS release.  Setup will be similar to the Raspberry Pi, except there is no raspi-config utility, but it uses the same apt-get utility and has all the same tools.  Icecast can be installed by running this:

    sudo apt-get install icecast2

You'll also need to register a domain and tie it to the IP address. That's not absolutely necessary, but otherwise you would just use your IP address to access the Icecast server, not pretty, but it works.  Then you would just send your stream to your Linode Icecast server.

[Back to Readme](README.md)
