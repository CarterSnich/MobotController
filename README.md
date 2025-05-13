# MobotController

Remote controller app for my RC car develop with Arduino on a Lolin D1 Mini ESP8266 development board. It uses Wi-Fi for connectivity and UDP for communication. It has inputs for several parameters to accomodate tuning of the RC mobot.

## The RC Mobot

![mobot](docs/2.jpg)

The core part of the mobot is a Lolin D1 Mini. It also uses SG90 servo for steering. DRV8833 for driving the motor, which has coasting and braking feature. LEDs for the headlights and reverse lights. A simple active buzzer as the horn.

## Tuning

![tuning page](docs/3.jpg)

There are several adjustable parameters, max, min, and center values for the serve and max and min PWM values for limiting speed for both forward and reverse. Additionally, you can set the IP address and port, if ever needed. All of the values are save and are automatically restored the next time you open the app.

## Controller

![controller page](docs/4.jpg)

I tried to copy the controlls for an actual automatic vehicle. There are toggles for Park, Drive and Reverse. There are also buttons for the Horn and turning on/off the Headlights. Two sliders for the acceleration and the steering. And, a button for Brake.
