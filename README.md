## BehaviorBox


###Summary:

A Matlab GUI to control the hardware and analyze the performance during a behavior experiment discriminating different shapes and contours.


![MATLAB BehaviorBox GUI](http://i.imgur.com/S49fVbU.jpg)

The GUI allows for complete control over the parameters of the stimuli, the amount of juice rewards and timing of stimulus
presentation and difficulty levels.

Difficulty can be automatically adjusted depending on performance, which gets calculated online and plotted within the GUI window. Data and settings are automatically saved.

The GUI supports several input devices, from rotational devices (balls, wheels, etc) to infrared beams and push buttons.

The stimuli are currently focusing on finding contours and shapes in complex random backgrounds, where a choice has to be made between the contour being present on the left or right, and a reward is given if the input device is moved to the correct side.


The GUI also includes training modes to learn the interaction with the hardware (such as levers or ports).




The hardware interfaces using Arduino micro controllers, an example for wiring using the rotary encoders of a computer mouse is illustrated below.


![MATLAB BehaviorBox Arduino Wiring](http://i.imgur.com/wFxbukv.jpg)


![MATLAB BehaviorBox Arduino Wiring](http://i.imgur.com/XTIWKps.jpg)




```MATLAB
%Start the GUI
BehaviorBox;
```

All else via the buttons.


####(MORE DOCUMENTATION TO FOLLOW)

CONTACT:
- <fuschro@gmail.com>
