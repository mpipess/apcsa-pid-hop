clearscreen.

runOncePath("0:HopCode/VertController").
runOncePath("0:HopCode/HorizController").

declare hoverAlt is 20.
declare originLng is ship:geoposition:lng.
declare originLat is ship:geoposition:lat.
lock currentLng to ship:geoposition:lng.
lock currentLat to ship:geoposition:lat.

declare kerbinCirc is Kerbin:radius * 2 * pi.
declare metersToDeg is 360 / kerbinCirc.

declare startTime is time:seconds.
lock currentTime to time:seconds - startTime.
declare startAlt is ship:altitude.
lock currentAlt to ship:altitude - startAlt.

global deltaTime is 0.
global lastError is 0.
global lastInterval is 1.

lock steering to heading(0, 90).

function delay {
    local tempTime is currentTime.
    wait until currentTime > tempTime.
    set deltaTime to currentTime - tempTime.
}

until currentAlt >= hoverAlt {
    delay().
    altController(hoverAlt).
    longController(originLng).
    //latController(originLat).
    print currentTime at (0, 9).
    print currentAlt at (0, 10).
}
declare climbTime is currentTime.
until currentTime >= climbTime + 5 {
    delay().
    altController(hoverAlt).
    longController(originLng).
    //latController(originLat).
    print currentTime at (0, 9).
    print currentAlt at (0, 10).
}
until currentLng >= originLong + 10 * metersToDeg {
    delay().
    altController(hoverAlt).
    longController(originLng + 10 * metersToDeg).
    //latController(originLat).
    print currentTime at (0, 9).
    print currentAlt at (0, 10).
}
until currentAlt < 0.1 {
    delay().
    altController(0).
    longController(originLng + 10 * metersToDeg).
    //latController(originLat).
    print currentTime at (0, 9).
    print currentAlt at (0, 10).
}