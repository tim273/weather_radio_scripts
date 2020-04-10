# Streaming NOAA Weather Radio to Multiple Icecast2 Servers with RTL SDR and Darkice

### Introduction

This is a guide to set up NOAA streaming weather radio using a Raspberry Pi and an RTL SDR stick.  The advantages to using a Raspberry Pi over Windows is that Raspberry Pi primary runs Linux and Linux is ideal for 24/7 type servers where as Windows is not. Linux can run days, weeks or even months without needing to be restarted as it was designed to be used this way.  It doesn't have the problem of restarting on you or going to sleep and you don't need an entire computer dedicated to streaming.  The Raspberry Pi is also very low power, maybe 5-15 watts at the most and much less depending the load and it is very small, about the size of a deck of cards so it can be put just about anywhere.  The only disadvantage is that is not very powerful, it's about the equivalent of an average smart phone in power, but for the purposes of streaming no GUI is needed, so resources are not needed for that, so it has plenty of power to do what we need. The other big advantage is that all the software is free.

If you use a Raspberry Pi with Darkice, a good internet connection and it is set up correctly, you'll have a very stable stream that is very low maintenance and will not go down unless there is a power outage (see notes about getting a UPS in the optional section), internet outage or some other unusual circumstance like hardware failure or SD card failure.  Otherwise the only time the stream will be interrupted is if it is done manually or there are Linux kernel updates which require a reboot, that can be done when there are no listeners or when there is fair weather.

#### Note: You can also stream using a weather radio.

You can also use a Raspberry Pi with just Darkice and a weather radio, the setup is similar, you would just use a weather radio instead of an RTL SDR stick. I used this setup for a few years to stream to Weather Underground (Raspberry Pi/Darkice/Weather Radio), the instructions are the same except you only need to follow the instructions to install the OS and compile/setup Darkice and skip the RTL SDR setup.  You would also need an external sound card such as this one: https://www.amazon.com/Behringer-UCA202-BEHRINGER-U-CONTROL/dp/B000KW2YEI and then an adapter for your weather radio like this: https://www.amazon.com/gp/product/B0052A2LYG (or this: https://www.bhphotovideo.com/bnh/controller/home?O=&sku=134142&gclid=CKjamunLtdMCFZe1wAodqHQB0w&is=REG&ap=y&m=Y&c3api=1876%2C%7Bcreative%7D%2C%7Bkeyword%7D&Q=&A=details) and then standard stereo RCA cables.  The trick is to find the right ALSA input to stream from, but I believe I used 'plughw:1,0'.

### Equipment

Purchase a Raspberry Pi from Amazon: https://www.amazon.com/CanaKit-Raspberry-Premium-Clear-Supply/dp/B07BC7BMHY you'll also need a microSD card, preferably class 10: https://www.amazon.com/SanDisk-Ultra-Micro-Adapter-SDSQUNC-016G-GN6MA/dp/B010Q57SEE/

Micro Center also carries Raspberry Pi's and everything else you'll need:

MicroSD: http://www.microcenter.com/product/366176/16GB_microSDHC_Class_10_Flash_Memory_Card (I've used Micro Center microSD cards in all my Raspberry Pi's without any problems, they're cheap and reliable.  I also have a Micro Center near me though).  
Raspberry Pi and Case: http://www.microcenter.com/search/search_results.aspx?Ntt=Raspberry+Pi+3+Model+B%2b 
Power Supply: http://www.microcenter.com/product/461596/25Amp_51v_Switching_Power_Supply_for_Raspberry_Pi_B_with_Built-in_4ft_Micro-USB_Cable

Since this Pi is going to be streaming 24/7, you'll also want an ethernet cable to connect to your modem/router as WiFi is generally not reliable enough to work 24/7.  Amazon or Micro Center has various lengths of Cat 5e cable at reasonable prices.

Nooelec has good RTL SDR kits, this one is fairly small and includes an antenna: http://www.nooelec.com/store/sdr/sdr-receivers/nesdr/nesdr-mini2-rtl2832u-r820t2.html.  An optional purchase would be the metal case: http://www.nooelec.com/store/nesdr-enclosure-207.html which helps with radio frequency interference (RFI).

#### Optional: Use Power over Ethernet (PoE)

The Raspberry Pi works very well with Power Over Ethernet (PoE), in the case where you want to put it somewhere where there is no power outlet available or in a closet or somewhere else out of sight.  You'll need a PoE injector: https://www.amazon.com/TP-LINK-TL-PoE150S-Injector-Adapter-compliant/dp/B001PS9E5I/ and a splitter: https://www.amazon.com/gp/product/B019BLMWWW.  There are also PoE switches available such as this one: https://www.amazon.com/dp/B01MRO4M73 If you get a PoE switch, you will not need the injector, but will still need the splitter. Using PoE will combine the power and ethernet into one cable and you will not need a power supply for the Raspberry Pi.

Starting with the Raspberry Pi 3 B+ model, there is built in support for PoE with the official PoE hat (https://www.raspberrypi.org/products/poe-hat/ coming soon as of this writing), this would eliminate the need for a splitter and if you have a PoE switch (see link above), you could plug your cable directly from the switch to the Raspberry Pi.

### The Antenna

If you can't get good reception with the included antenna, you could strip off the jacket of some standard TV coax and expose 17 1/4 inches of bare center wire, then mount that somewhere up high indoors (like an attic), or build a 1/4 wave ground plane antenna (more on that here: http://www.hamuniverse.com/2metergp.html) and that can be mounted using 1 or 1 1/2 inch PVC pipe with a cap.  Just drill a hole in the cap to fit the threaded end of the SO 239 connector and the connect the coax from the other side.  Here the parts you need to build a 1/4 ground plane antenna:

SO 239: https://www.amazon.com/Female-Chassis-Flange-Solder-Connector/dp/B007Q8JH4Y  
Wire: You can use a couple things #12/#10 copper house wiring or galvanzed steel wire  
Soldering Iron: You'll want a good soldering iron like this one: https://www.amazon.com/Weller-D650-Industrial-Soldering-Gun/dp/B000JEGEC0

Alternatively you could purchase this anteanna if you're not comfortable building your own: http://www.jpole-antenna.com/shop/product-category/weather-band/

If you build or purchase an external antenna, you'll need these adapters:

Coax Cable: https://www.amazon.com/50ft-Rg8x-Pl259-Antenna-Cable/dp/B00D66RDYQ (you can get a shorter length if need be)  
Adapters: http://www.nooelec.com/store/male-mcx-to-male-sma-pigtail-rg316-0-5-length.html and https://www.amazon.com/LINGLING-ONE-Coaxial-Adapter-Female/dp/B06XF7W38M

### OS Install

Once you have all that equipment download the latest Raspbian Lite image from https://www.raspberrypi.org/downloads/raspbian and follow these instructions to put it on the microSD card: https://www.raspberrypi.org/documentation/installation/installing-images/   Once the OS is installed on the microSD card, insert it into the Pi, connect the network cable, HDMI to a monitor or TV, and a USB keyboard (mouse not needed).  You can also plug in the RTL SDR and hook it up to the antenna.  Finally, plug in the power.

#### Tip: Use the tab key for statement completion.
For example start typing a command like 'ser' and then hit the tab key and it will fill in the rest which is 'service'.  You can also do this with files and directories so if you are about to edit a file you can start typing 'vim /et\<tab\>(it will fill in 'etc')/ini\<tab\>(it will fill in init.d or give you a list of options if there is more than one).  Whenever typing, use tab and it makes things go a lot faster.  I use it ALL the time.

Once booted, you will be presented with a log in prompt.  There is no user interface on the lite version of Raspbian because it is not needed since we will be running the Raspberry Pi headless. Log in with username pi and password raspberry, then type:

    sudo raspi-config
    
* Select 5 Interfacing Options, hit Enter
* Select 2 SSH, hit Enter
* Select Yes to enable SSH
* At the main menu, select 7 Advanced Options
* Select A3 Memory Split
* Type in 8 and select Ok

#### Optional: From the main menu

* Select 2 Hostname and slelect Ok 
* Change the hostname from "raspberrypi" to something more meaningful like "weather-radio-streamer" or whatever you choose.
* Select 4 Localisation Options
* Select I2 Change Timezone then choose your timezone (GMT is the default timezone).

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

    sudo apt-get install build-essential devscripts autotools-dev fakeroot dpkg-dev debhelper autotools-dev dh-make quilt ccache libsamplerate0-dev libpulse-dev libaudio-dev lame libjack-jackd2-dev libasound2-dev libtwolame-dev libfaad-dev libflac-dev libmp4v2-dev libshout3-dev libmp3lame-dev vim htop screen git icecast2 libtool-bin rtl-sdr sox libsox-fmt-mp3 ezstream iftop bc

Installing these packages will take several minutes, now would be a good time to get a coffee or take a walk or something.  When it asks about configuring Icecast2, just choose the default values for now.  If you plan to expose your Icecast2 server by opening a port, you'll want to change the passwords which you can do by editing /etc/icecast2/icecast.xml and you'll find an authorization section that contains the passwords.  You'll then want to match the source password with the one you use in darkice.cfg. There is more on editing files later. 

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

Next, copy the init script for Darkice so it starts on boot and make it executable:

    sudo cp ~/weather_radio_scripts/darkice /etc/init.d
    sudo chmod +x /etc/init.d/darkice
    
Then add Darice to the service mechanism so that it runs automatically at boot:

    sudo systemctl enable darkice

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

## Setting up SSL for Your Stream

There's a couple ways to do this, but I'm going to describe how to do it with a proxy pass using Nginx.  This is going to assume that you have a domain that you have pointed to the IP address of your local/home network and have port forwarded ports 80 and 443 to your Raspberry Pi (or other machine).  Start by installing Nginx on the same machine as your Icecast server:

    sudo apt install nginx
    
Then you should be able to go to http://your.domain and see something like this:

### Welcome to nginx!

If you see this page, the nginx web server is successfully installed and working. Further configuration is required.

For online documentation and support please refer to nginx.org.
Commercial support is available at nginx.com.

*Thank you for using nginx.*

Next edit /etc/nginx/sites-enables/default and find the following:

    location / {
        # First attempt to serve request as file, then
        # as directory, then fall back to displaying a 404.
        try_files $uri $uri/ =404;
    }

This is the main location directive.  Add this below it:

    location /some/path {
            proxy_pass http://127.0.0.1:8000/your/mount/url;
    }

Change "/some/path" to whatever you would like so for example the proxied URL would be http://your.domain/some/path You can also add .mp3 to the end if you would like (http://your.domain/some/path.mp3).  Then change "/your/mount/url" to whatever your Icecast mount URL is.  Also the semi-colon is important, without it there will be an error and Nginx won't restart.

Next restart Nginx:

    sudo service nginx restart
    
Then test your url by going to http://your.domain/some/path (using your domain and the path you created).  You should be able to listen to your stream.  Congratulations!! You just proxied your Icecast server through Nginx!  You can also do this with Apache, but it's way easier this way.

### Create an SSL certificate

You can get a free SSL certificate from Let's Encrypt using Certbot which will automate the process for you and makes it really easy.  Start by going to https://certbot.eff.org/ and where it says "My HTTP website is running" choose Nginx and choose "Debian 10 (buster)" (if you have a Raspberry Pi, or other OS depending on what you have installed.) for the "on" section.  Then follow the instructions to install Certbot under the default tab.

Once the all the software is installed choose first instruction under #3 to get and install your certificates. 

    sudo certbot --nginx
    
It will ask for your email address, this is for expiration notifications, enter that in and then agree to the terms of service.  It will ask if you are willing to share your email address, you can choose either yes or no here.

Next enter your full registered registered domain name.  This would be the same domain as used for the above URL, so if you entered http://www.mydomain.com, enter "www.mydomain.com" for the domain (without the quotes).

Then it will create and install the certificate.  Once that is done it will ask you if you want an automatic redirect to https (usually #2).  I suggest choosing that and if you enter www.mydomain.com it will automatically redirect to https://www.mydomain.com

Then restart nginx:

    sudo service nginx restart
    
Then enter your url http://www.mydomain.com/some/path in a browser.  It should automatically redirect to https and if you click on the lock icon you should see your certificate information.  

That's it!  You've got a secure radio stream!  

### Certificate Renewal

The certificate from Let's Encrypt only lasts 3 months, but certbot installs a cron job that runs every 12 hours to check your certificate and renew if needed.  If for some reason that doesn't work, you'll get an email a month or so in advance letting you know it's time to renew.  But this shouldn't be an issue with certbot.

You can also run this command to make sure it works:

    sudo certbot renew --dry-run
    
On the certbot website mentioned above step 4 talks about automatic renewal and where the cron job is.  And then there's  step 5 to test your certificate.

The other option to achive an SSL stream is to compile Icecast from source, but that is problematic.  I find this way much eaiser as Nginx is used primarly as a load balancer so proxying is what it does best.

## Extras

There are a couple extra files, ezstream.xml, if you wish to use Ezsteam instead of Darkice and then temp.sh which will display the temperature of the CPU and GPU.  More on that here: https://www.cyberciti.biz/faq/linux-find-out-raspberry-pi-gpu-and-arm-cpu-temperature-command/

[Stopping and Starting Services](SERVICES.md)

