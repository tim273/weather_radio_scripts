# Starting and Stopping Services

There will be two things started at boot, one is Darkice which can be started, stopped and restarted with the following commands:

    sudo service darkice start
    sudo service darkice stop
    sudo service darkice restart

Log output for Darkice is sent to /var/log/darkice.log and can be monitored using less or tail:

    tail -f /var/log/darkice.log
    
or
    
    less -n +F /var/log/darkice.log

I prefer less as it has more features because it is an extension of vim, so it allows for searching and scrolling up and down, for more information on less vs tail see: http://www.brianstorti.com/stop-using-tail/

The second service is the screen instance with the RTL_SDR script.  Darkice will stream silence to your mount point if it is running and the RTL SDR script is not, so keep that in mind if you stop or start that script. Screen is used as a "poor mans service" for the RTL SDR script (more on screen here  https://www.rackaid.com/blog/linux-screen-tutorial-and-how-to/). You can access the RTL SDR script in the screen instance by typing this:

    sudo screen -r
    
This will bring you into the screen and you should see something like this:

    Found 1 device(s):
      0:  Realtek, RTL2838UHIDIR, SN: 00000001

    Using device 0: Generic RTL2832U OEM
    Found Rafael Micro R820T tuner
    Tuner gain set to automatic.
    Tuner error set to 14 ppm.
    Tuned to 162802000 Hz.
    Oversampling input by: 21x.
    Oversampling output by: 1x.
    Buffer size: 8.13ms
    Exact sample rate is: 1008000.009613 Hz
    Sampling at 1008000 S/s.
    Output at 48000 Hz.
    
To stop the script type Ctrl+C and this will stop the script and exit screen at the same time.  You will know it exited screen when you see something like this:

    [screen is terminating]

If you don't see the above then you are still in the screen instance, but have just stopped the script.  If that is the case, skip the next command as it will just start a second screen instance.  Otherwise to start the RTL SDR script again, type this to start a new screen instance:

    sudo screen

There will be some text, and just hit enter.  Then navigate (cd /home/pi or wherever you put it) to the folder with the script and execute it by typing (you should already be in the weather_radio_scripts directory):

    ./weather-radio.sh

This will bring you back to where you were and send the output of RTL SDR to the alsa loopback device.  To detach from screen type Ctrl+a, d.  So Ctrl+a and then d, and you should see something like this:

    [detached from 3318.pts-0.weather-radio-server]

Then you can reattach the same way as mentioned above:

    sudo screen -r
    
Don't type Ctrl+c unless you want to stop the RTL SDR script.  If you want to exit out of screen completely, type Ctrl+c.

[Optional Steps](OPTIONAL.md)
