clearscreen.

runOncePath("0:HopCode/AscentPID").

declare hoverAlt is 20.

declare startTime is time:seconds.
lock currentTime to time:seconds - startTime.
declare startAlt is ship:altitude.
lock currentAlt to ship:altitude - startAlt.
global zVel is 0.

global deltaTime is 0.
global lastVelError is 0.
global lastInterval is 1.
global accErrorIntegral is 0.

lock steering to heading(0, 90).

function delay {
    local tempTime is currentTime.
    wait until currentTime > tempTime.
    set deltaTime to currentTime - tempTime.
}

until currentAlt >= hoverAlt {
    delay().
    ascentPID(hoverAlt).
    print currentTime at (0, 9).
    print currentAlt at (0, 10).
}
declare climbTime is currentTime.
until currentTime >= climbTime + 5 {
    delay().
    ascentPID(hoverAlt).
    print currentTime at (0, 9).
    print currentAlt at (0, 10).
}
until currentAlt < 0.1 {
    delay().
    ascentPID(0).
    print currentTime at (0, 9).
    print currentAlt at (0, 10).
}