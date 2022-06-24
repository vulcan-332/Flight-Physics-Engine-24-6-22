D:
cd D:\FlightGear 2018.1.1

SET FG_ROOT=D:\FlightGear 2018.1.1\data
.\\bin\fgfs --aircraft=c172p --fdm=network,localhost,5501,5502,5503 --fog-fastest --disable-clouds --start-date-lat=2004:06:01:09:00:00 --disable-sound --in-air --enable-freeze --airport=PHNL --runway=26L --altitude=1000 --heading=260 --offset-distance=0 --offset-azimuth=0 --enable-terrasync --prop:/sim/rendering/shaders/quality-level=0
