function altController {
    declare parameter targetAlt.

    //Altitude P controller
    local outerSetpoint is targetAlt.
    local maxVelocity is 5.
    local minVelocity is -5.
    local outerKP is 1.

    lock outerPV to currentAlt.
    local outerError is outerSetpoint - outerPV.

    local outerP is outerKP * outerError.
    local outerU is outerP.

    if outerU > maxVelocity {
        set outerU to maxVelocity.
    }
    else if outerU < minVelocity {
        set outerU to minVelocity.
    }

    //Velocity PD controller
    local innerSetpoint is outerU.
    local innerKP is 0.1.
    local innerKI is 0.
    local innerKD is 0.1.

    lock innerPV to ship:verticalspeed.
    local innerError is innerSetPoint - innerPV.

    local innerP is innerKP * innerError.

    set integral to integral + innerError * deltaTime.
    local innerI is innerKI * integral.

    local errorSlope is (innerError - lastError) / lastInterval.
    local innerD is innerKD * errorSlope.

    local innerU is innerP + innerI + innerD.

    lock throttle to (ship:mass / ship:maxthrust * 9.81) + innerU.

    if throttle > 1 {
        lock throttle to 1.
    }
    else if throttle < 0 {
        lock throttle to 0.
    }
}