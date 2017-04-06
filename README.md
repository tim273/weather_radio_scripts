# Streaming to Multiple Icecast2 Servers with RTL SDR and Darkice

### Introduction

This is a guide to set up NOAA streaming weather radio using a Raspberry Pi and an RTL SDR stick.  The advantages to using a Raspberry Pi over Windows is that Raspberry Pi primary runs Linux and Linux is ideal for 24/7 type servers where as Windows is not. Linux can run days, weeks or even months without needing to be restarted as it was designed to be used this way.  It doesn't have the problem of restarting on you or going to sleep and you don't need an entire computer dedicated to streaming.  The Raspberry Pi is also very low power, maybe 5-15 watts at the most and much less depending the load and it is very small, about the size of a deck of cards so it can be put just about anywhere.  The only disadvantage is that is not very powerful, it's about the equivalent of an average smart phone in power, but for the purposes of streaming no GUI is needed, so resources are not needed for that, so it has plenty of power to do what we need. The other big advantage is that all the software is free.

#### Note: You can also stream using a weather radio.

You can also use a Raspberry Pi with just Darkice and a weather radio, the setup is similar, you would just use a weather radio instead of an RTL SDR stick. I used this setup for a few years to stream to Weather Underground (Raspberry Pi/Darkice/Weather Radio), the instructions are the same except you only need to follow the instructions to install the OS and compile/setup Darkice and skip the RTL SDR setup.  You would also need an external sound card such as this one: https://www.amazon.com/Behringer-UCA202-BEHRINGER-U-CONTROL/dp/B000KW2YEI and then an adapter for your weather radio like this: https://www.amazon.com/gp/product/B0052A2LYG and then an RCA left/right cable.  The trick is to find the right ALSA input to stream from, but I believe I used 'plughw:1,0'.

### Equipment

Purchase a Raspberry Pi from Amazon: https://www.amazon.com/CanaKit-Raspberry-Clear-Power-Supply/dp/B01C6EQNNK you'll also need a microSD card, preferably class 10
Micro Center also carries Raspberry Pi's and everything else you'll need:

MicroSD: http://www.microcenter.com/product/366176/16GB_microSDHC_Class_10_Flash_Memory_Card (I've used Micro Center microSD cards in all my Raspberry Pi's without any problems, they're cheap and reliable.  I also have a Micro Center near me though).
Raspberry Pi and Case: http://www.microcenter.com/product/461230/Raspberry_Pi_3_Model_B_Board_and_Case_Kit
Power Supply: http://www.microcenter.com/product/461596/25Amp_51v_Switching_Power_Supply_for_Raspberry_Pi_B_with_Built-in_4ft_Micro-USB_Cable

Since this Pi is going to be streaming 24/7, you'll also want an Ethernet cable to connect to your modem/router as WiFi is not reliable enough.  Amazon or Micro Center has various lengths of Cat 5e cable at reasonable prices.

Nooelec has good RTL SDR kits, this one is fairly small and includes an antenna: http://www.nooelec.com/store/sdr/sdr-receivers/nesdr/nesdr-mini2-rtl2832u-r820t2.html.  If you can't get good reception with the included antenna, you could strip off the jacket of some standard TV coax and expose 17 1/4 inches of bare center wire, then mount that somewhere up high indoors (like an attic).

### OS Install

Once you have all that equipment download Raspbian Jessie Lite from https://www.raspberrypi.org/downloads/raspbian and follow these instructions to put it on the microSD card: https://www.raspberrypi.org/documentation/installation/installing-images/   Once the OS is installed on the microSD card, insert it into the Pi, connect the network cable, HDMI to a monitor or TV, and a USB keyboard (mouse not needed).  You can also plug in the RTL SDR and hook it up to the antenna.  Finally, plug in the power.

Once booted, you will be presented with a log in prompt.  There is no user interface on the lite version of Raspbian because it is not needed since we will be running the Raspberry Pi headless. Log in with username pi and password raspberry, then type:

    sudo raspi-config
    
Select 5 Interfacing Options, hit Enter
Select 2 SSH, hit Enter
Select Yes to enable SSH
At the main menu, select 7 Advanced Options
Select A3 Memory Split
Type in 16 and select Ok

Optional: From the main menu

Select 2 Hostname and slelect Ok
change the hostname from "raspberrypi" to something more meaningful like "weather-radio-streamer" or whatever you choose.
Select 4 Localisation Options then I2 Change Timezone then choose your timezone (GMT is the default timezone).

Then exit out of raspi-config by selecting Finish and hit Enter.  If it ask to reboot, select no or cancel as we will be rebooting later.

Next type:

    ifconfig
    
Then take note of the IP address of eth0.  From there, you no longer need the monitor/TV or keyboard and you can SSH using Putty (http://www.putty.org/) and perform the rest of this guide remotely with SSH from a desktop/laptop.

Optional step: Create an SSH key pair so that you don't have to enter your username or password when you log in: http://www.tecmint.com/ssh-passwordless-login-with-putty/

Next update your pi:

    sudo apt-get update
    sudo apt-get dist-upgrade
    
This will take a few minutes depending on the number of updates.  Once finished reboot just in case there are any kernel updates.

    sudo reboot

### Install Packages

Wait a couple minutes and then ssh in again.  Install necessary packages:

    sudo apt-get install build-essential devscripts autotools-dev fakeroot dpkg-dev debhelper autotools-dev dh-make quilt ccache libsamplerate0-dev libpulse-dev libaudio-dev lame libjack-jackd2-dev libasound2-dev libtwolame-dev libfaad-dev libflac-dev libmp4v2-dev libshout3-dev libmp3lame-dev vim htop screen git icecast2 libtool-bin rtl-sdr sox libsox-fmt-mp3 ezstream iftop

When it asks about configuring Icecast, just choose the default values for now.  Installing these packages will take several minutes, now would be a good time to get a coffee or take a walk or something.

### Download and Compile Darkice

Clone Darkice from GitHub:

    git clone https://github.com/rafael2k/darkice
    
And clone this respository:

    git clone https://github.com/tim273/weather_radio_scripts

Compile and install Darkice (one command at a time):

    cd darkice/darkice/trunk
    ./autogen.sh --prefix=/usr --sysconfdir=/usr/share/doc/darkice/examples --with-vorbis-prefix=/usr/lib/arm-linux-gnueabihf/ --with-jack-prefix=/usr/lib/arm-linux-gnueabihf/ --with-alsa-prefix=/usr/lib/arm-linux-gnueabihf/ --with-faac-prefix=/usr/lib/arm-linux-gnueabihf/ --with-aacplus-prefix=/usr/lib/arm-linux-gnueabihf/ --with-samplerate-prefix=/usr/lib/arm-linux-gnueabihf/ --with-lame-prefix=/usr/lib/arm-linux-gnueabihf/ CFLAGS='-march=armv6 -mfpu=vfp -mfloat-abi=hard'
    make
    sudo make install

### Setup Darkice

I like using vim for text editing, that's just me I'm old school, :grin: you can also use nano if you'd like. More on nano here: https://www.howtogeek.com/howto/42980/the-beginners-guide-to-nano-the-linux-command-line-text-editor and you want to read about vim vs nano vs emacs, here you go: http://downtoearthlinux.com/posts/clash-of-the-text-editors-nano-vim-and-emacs/

Here's a quick vim rundown:

vim test.txt
i (i for insert or a for add)
Type: "Here's my text"
Esc (takes you out of insert/add mode)
:wq (w for write q for quit)

If you don't know what's going on hit Esc a few times and start over.  If you make changes and screw up and don't want to save type

:q!

This will quit without saving changes. Typing : will allow you to search and do other things as well.  Here's more info: https://www.linux.com/learn/vim-101-beginners-guide-vim

Copy darkice.cfg from weather_radio_scripts to /etc

    sudo cp ~/weather_radio_scripts/darkice.cfg /etc
    
The default is to point to your local Icecast server, you can leave this for now and come back to it to change it.  To do so, edit it this way:

    sudo vim /etc/darkice.cfg
    
Darkice allows you to stream to up to 8 Icecast/Shoutcast servers from a single source and each can have its own bitrate, sampleRate, etc and it will reencode from the source, they are labeled icecast2-0, icecast2-1, icecast2-2, etc. You shouldn't need more than 2, but you never know.  For more info type:

    man darkice.cfg

Next, add an copy the init script for Darkice so it starts on boot:

    sudo cp ~/weather_radio_scripts/darkice /etc/init.d
    
Then add Darice to the service mechanism so that it runs automatically at boot:

    sudo chmod +x /etc/init.d/darkice
    sudo update-rc.d darkice defaults

### Setup for RTL SDR

The next half of this how-to is for setting up the RTL SDR stick to listen to your local weather radion station and then send it to the loopback ALSA sound card.  Then Darkice stream from the virutal sound card that gets created.  First add the ALSA loopback plugin to the kernel modules by copying modules to the etc directory (we'll backup the existing one first):

    sudo cp /etc/modules /etc/modules.backup
    sudo cp ~/weather_radio_scripts/modules /etc

Next move the asound.conf to the etc folder:

    sudo cp ~/weather_radio_scripts/asound.conf /etc
    
Next copy the rules file for RTL SDR which allows the correct kernel driver to be used:

    sudo cp ~/weather_radio_scripts/20.rtlsdr.rules /etc/udev/rules.d
    
The included script which starts the RTL SDR (weather-radio.sh) has three options for streaming.  The first two are commented out, but the last one will pipe to the loopback virtual sound card.  Edit the last line of the script and modify the frequency to match you local weather radio frequency:

    vim ~/weather_radio_scripts/weather-radio.sh
    
The first section of that line looks like this:

    rtl_fm -f 162.55M

Change 162.55 to match what your local frequency is.  If you are unsure of your local frequency, you can look it up here: http://www.nws.noaa.gov/nwr/coverage/station_listing.html

Next make the script executable:

    chmod +x ~/weather_radio_scripts/weather-radio.sh

Next copy rc.local to to etc make our script it run at boot in a screen session (we'll backup the existing one first):

    sudo cp /etc/rc.local /etc/rc.local.backup
    sudo cp ~/weather_radio_scripts/rc.local /etc
    
That's it!  Well almost, reboot your Pi and you should have a functioning mount point:

    sudo reboot
    
Wait a few minutes and if all goes well, you should be able to go to http://raspberry.pi.ip:8000 (or whatever Icecast server you are pointing to) and see your mount point and hear your weather radio stream!

[Stopping and Starting Services](SERVICES.md)

