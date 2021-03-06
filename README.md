# pi_plant

![pi_plant screenshot](https://raw.github.com/rringler/pi_plant/master/public/images/screenshot.png "pi_plant screenshot")


## Overview
(Long) weekend project to monitor and water my plant with a Raspberry Pi.  The
app was developed for Raspbian Wheezy with an
[arduino two-prong soil moisture sensor](http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=arduino%20soil%20sensor)
via a MCP3002 analog-to-digital converter, and an
[arduino relay board](http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=arduino%20relay%20board)
to control a 110 VAC water pump.

It makes a couple of assumptions:

### Moisture Sensor:
* Now includes a [Kicad](http://kicad-pcb.org/) PCB design for interfacing with
a MCP3002 10-bit SPI Analog-to-Digital Converter. The Pi talks to the ADC via
its SPI interface.  Includes all the manufacturing files required to fab the
board (which I had [OSH Park](https://oshpark.com/) make for me for $7.85
shipped, which required about $15 in components from
[Digi-key](http://www.digikey.com/).)

  ![Custom PCB Layout](https://raw.github.com/rringler/pi_plant/master/public/images/mcp3002_v1.png "Custom PCB Layout")

* Includes three 2N3904 transistors to allow the Pi to control the power
provided to the MCP3002 & the two analog sensors:

  ![NPN-Transistor Network](https://raw.github.com/rringler/pi_plant/master/public/images/npn_switch.png "NPN-Transistor Network")

(Leaving these two-prong type of sensors powered on 24/7 can lead to galvanic
corrosion, so it's probably better to turn them on when needed.)

* Provides two analog measurement channels.  Also supplies VCC & GND (in case
the moisture sensor requires it) for each.


### Water Pump:
* Assumes there is a power pin to activate the pump.  My Pi's 3.3V GPIO was able
to activate/deactivate my relay board directly, but if you're having issues you
could always use a NPN-transistor network as shown above.


## Dependencies
pi_plant was developed on Ruby v2.1 and Rails v4.0.  Several gems were utilized
to make development easier:

```ruby
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'
gem 'figaro'
gem 'draper'
gem 'lazy_high_charts'
```


## Installation
1. Clone the repository.
2. Create a `/config/application.yml` file with environmental variables holding
all your secret keys (see [figaro's](https://github.com/laserlemon/figaro)
documentation for more details) and add it to your `.gitignore` file.

   ```ruby
   RAILS_SECRET_KEY_BASE: '<rails secret key>'
   ```

3. Schedule the `sample` rake task to take periodic soil measurements.

   ```ruby
   crontab -e
   00 00, 12, * * * * rvmsudo rake RAILS_ENV=production sample
   ```
   Note: the Pi requires root access to interact with hardware

4. Start the webserver
5. Create a plant with the GPIO pins used in your circuit.


## Bill of Materials
| Find No. | Qty | Part Number    | Description | Approx. Extended Cost |
|---------:|----:|:---------------|:------------|----------------------:|
| 1        |   1 | 756-8308       | [Raspberry Pi v2](https://www.adafruit.com/products/2358) | $40 |
| 2        |   1 | SDC10/8GBET    | [Kingston 8GB microSD Card](http://www.amazon.com/gp/product/B008EODGHS) | $8 |
| 3        |   1 | EW-7811Un      | [Edimax 802.11n USB Adapter](http://www.amazon.com/gp/product/B003MTTJOY) | $10 |
| 4        |   1 | B00E0NTPP4     | [SunFounder 2 Channel 5V Relay Shield for Arduino](http://www.amazon.com/SunFounder-Channel-Shield-Arduino-Raspberry/dp/B00E0NTPP4/) | $7 |
| 5        |   1 | B00AYCNEKW     | [sunkee Soil Moisture Sensor](http://www.amazon.com/gp/product/B00AYCNEKW) | $3 |
| 6        |   1 | B001BOD9JI     | [TOM 3.5gph Aquarium Pump](http://www.amazon.com/gp/product/B001BOD9JI) | $16 |
| 7        |   1 | kTJJCOss       | [OSH Park Custom PCB](https://oshpark.com/shared_projects/kTJJCOss) | $8 |
| 8        |   1 | MCP3002-I/P    | [MCP3002 2-Channel 10-bit ADC](http://www.digikey.com/scripts/DkSearch/dksus.dll?Detail&itemSeq=186693142&uq=635870217430541403) | $2 |
| 9        |   3 | 2N3904BU       | [40V NPN Transistor](http://www.digikey.com/scripts/DkSearch/dksus.dll?Detail&itemSeq=186700114&uq=635870217430551404) | $1 |
| 10       |   3 | CF14JT1K00     | [1kOhm 1/4W Carbon Through Hole Resistor](http://www.digikey.com/scripts/DkSearch/dksus.dll?Detail&itemSeq=186693725&uq=635870217430551404) | $1 |
| 11       |   2 | 0022288363     | [Molex 36pos Right-Angle Pin Header](http://www.digikey.com/scripts/DkSearch/dksus.dll?Detail&itemSeq=186693603&uq=635870217430541403) | $4 |


## TODO
 - [X] Custom PCB for interfacing with the MCP3002 (experimenting with Kicad)


## Keywords
 - Raspberry Pi
 - RPi
 - Ruby on Rails
 - Kicad
 - MCP3002
 - Home Automation


## Credits
pi_plant is the product of [Ryan Ringler](http://github.com/rringler).  It was
developed as a (long) weekend project to experiment with the Raspberry Pi,
Rails, and Kicad.


## License
pi_plant is licensed under the MIT License.  Please see the
[LICENSE](http://github.com/rringler/pi_plant/LICENSE) file for additional
details.
