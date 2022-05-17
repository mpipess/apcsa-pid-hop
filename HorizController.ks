declare lastLongError is 0.
declare lastLatError is 0.

function longController {
    declare parameter long.

    local maxAngle is 5.
    local minAngle is -5.

    local setpoint is long.
    local kP is 0.01.
    local kD is 0.01.

    local error is setpoint - currentLng.
    local errorSlope is (error - lastLongError) / deltaTime.

    local p is kP * error.
    local d is kD * errorSlope.

    local u is p + d.

    if u > maxAngle {
        lock steering to heading(0, 90) + r(maxAngle, 0, 0).
    }
    else if u < minAngle {
        lock steering to heading(0, 90) + r(minAngle, 0, 0).
    }
    else {
        lock steering to heading(0, 90) + r(u, 0, 0).
    }

    set lastLongError to error.
}

function latController {
    declare parameter lat.

    local maxAngle is 5.
    local minAngle is -5.

    local setpoint is lat.
    local kP is 0.01.
    local kD is 0.01.

    local error is setpoint - currentLat.
    local errorSlope is (error - lastLatError) / deltaTime.

    local p is kP * error.
    local d is kD * errorSlope.

    local u is p + d.

    if u > maxAngle {
        lock steering to heading(0, 90) + r(0, maxAngle, 0).
    }
    else if u < minAngle {
        lock steering to heading(0, 90) + r(0, minAngle, 0).
    }
    else {
        lock steering to heading(0, 90) + r(0, u, 0).
    }

    set lastLatError to error.
}