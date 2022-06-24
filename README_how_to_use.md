# Flight-Physics-Engine-24-6-22

This repo contains the files required to run a matlab simulation with linkage to FlightGear.
Made on Matlab2020a and FightGear2018.1.1

Steps to run- 

Open six_dof_simulation.slx dont run it. 

Find the batch script maker. (Blue block)

Specify aircraft from FlightGear script. (Flightgear - tools - view command line)

Enter Airport 

Enter Visualisation System Block

Enter Latitide Longitude and height initial values in the integral blocks. All lat and long values must be in degrees. 

Example: deg2rad(-157.92507222) -157 is in degrees. 

Enter initial height value again into "initial height" integral block attached to Positioning system 

Batch file - generate Script

Close flightgear

Find runfg.bat in current Matlab directory

Run runfg.bat - opens flighgear in required location waits for packet input from simulink

Attach Joystick

In matlab, run initialise.mat.

Wait for flightgear to start responding to simulink data.

Enjoy :)
