clearscreen.

runOncePath("0:HopCode/AscentPID").

declare hoverAlt is 20.

declare startTime is time:seconds.
lock currentTime to time:seconds - startTime.

global xPos is 0.
global xVel is 0.
global yPos is 0.
global yVel is 0.
global zPos is 0.
global zVel is 0.

global deltaTime is 0.
global lastInterval is 1.

global lastXVelError is 0.
global xAccErrorIntegral is 0.
global lastYVelError is 0.
global yAccErrorIntegral is 0.
global lastZVelError is 0.
global zAccErrorIntegral is 0.

lock steering to heading(0, 90).

function stepForward {
    local tempTime is currentTime.
    wait until currentTime > tempTime.
    set deltaTime to currentTime - tempTime.
}

function updateState {
    set xPos to xPos + xVel * deltaTime.
    set xVel to xVel + ship:sensors:acc:x * deltaTime.
    set yPos to yPos + yVel * deltaTime.
    set yVel to yVel + ship:sensors:acc:y * deltaTime.
    set zPos to zPos + zVel * deltaTime.
    set zVel to zVel + ship:sensors:acc:z * deltaTime.
}

until currentAlt >= hoverAlt {
    stepForward().
    updateState().
    ascentPID(hoverAlt).
    print currentTime at (0, 9).
    print currentAlt at (0, 10).
}
declare climbTime is currentTime.
until currentTime >= climbTime + 5 {
    stepForward().
    updateState().
    ascentPID(hoverAlt).
    print currentTime at (0, 9).
    print currentAlt at (0, 10).
}
until currentAlt < 2 {
    stepForward().
    updateState().
    ascentPID(0).
    print currentTime at (0, 9).
    print currentAlt at (0, 10).
}