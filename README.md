# pi_plant

![pi_plant screenshot](https://raw.github.com/rringler/pi_plant/master/public/images/screenshot.png "pi_plant screenshot")


## Overview
(Long) weekend project to monitor and water my plant with a Raspberry Pi.  The
app was developed for Raspbian Wheezy with an [arduino two-prong soil moisture sensor](http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=arduino%20soil%20sensor) via a MCP3008 analog-to-digital converter, and an [arduino relay board](http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=arduino%20relay%20board) to control a 110 VAC water pump.

It makes a couple of assumptions:

### Moisture Sensor:
* Assumes there is a power pin to activate the sensor.  Leaving these two-prong type of sensors powered 24/7 can lead to galvanic corrosion, so I have mine wired up to a 2N3904 transistor so it can be powered on only when taking a measurement:

  ![NPN-Transistor Network](https://raw.github.com/rringler/pi_plant/master/public/images/npn_switch.png "NPN-Transistor Network")

* Assumes the soil sensor's analog output is wired to a MCP3008 (or equivalent) 10-bit SPI Analog-to-Digital Converter.  The Pi talks to ADC via it's SPI interface.

### Water Pump:
* Assumes there is a power pin to activate the pump.  My Pi's 3.3V GPIO was able to activate/deactivate my relay board directly, but if you're having issues you could always use a NPN-transistor network as shown above.


## Dependencies
pi_plant was developed on Ruby v2.1 and Rails v4.0.  Several gems were utilized to make development easier:

```ruby
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'
gem 'figaro'
gem 'draper'
gem 'lazy_high_charts'
```


## Installation
1. Clone the repository.
2. Create a `/config/application.yml` file with environmental variables holding all your secret keys (see [figaro's](https://github.com/laserlemon/figaro) documentation for more details) and add it to your `.gitignore` file.

   ```ruby
   RAILS_SECRET_KEY_BASE: '<rails secret key>'
   ```

3. Schedule the pi_plant:sample rake task to take periodic soil measurements.

   ```ruby
   crontab -e
   00 00, 06, 12, 18 * * * * cd /path/to/pi_plant && sudo /path/to/rake RAILS_ENV=production pi_plant:sample
   ```
   Note: the Pi requires root access to interact with hardware

4. Start the webserver
5. Create a plant with the GPIO pins used in your circuit.


## TODO
* ???  It's pretty complete at this point.  Maybe email alerts?


## Credits
pi_plant is the product of [Ryan Ringler](http://github.com/rringler).  It was developed as a weekend project to continue to learn and better understand rails.


## License
pi_plant is licensed under the MIT License.  Please see the [LICENSE](http://github.com/rringler/pi_plant/LICENSE) file for additional details.
