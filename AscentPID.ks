function ascentPID {
    declare parameter targetAlt.

    set zVel to zVel + ship:sensors:acc:z * deltaTime.

    //Altitude P controller
    local altSetpoint is targetAlt.
    local maxVelocity is 5.
    local minVelocity is -5.
    local altKP is 1.

    lock altPV to currentAlt.
    local altError is altSetpoint - altPV.

    local altP is altKP * altError.
    local altU is altP.

    if altU > maxVelocity {
        set altU to maxVelocity.
    }
    else if altU < minVelocity {
        set altU to minVelocity.
    }

    //Velocity PD controller
    local velSetpoint is altU.
    local velKP is 0.1.
    local velKD is 0.1.

    lock velPV to zVel.
    local velError is velSetpoint - velPV.

    local velP is velKP * velError.

    local velErrorSlope is (velError - lastVelError) / lastInterval.
    local velD is velKD * velErrorSlope.

    local velU is velP + velD.

    //Acceleration PI controller
    local accSetpoint is velU.
    local accKP is 0.01.
    local accKI is 0.01.

    lock accPV to ship:sensors:acc:z.
    local accError is accSetpoint - accPV.

    local accP is accKP * accError.

    set accErrorIntegral to accErrorIntegral + accError * deltaTime.
    local accI is accKI * accErrorIntegral.

    local accU is accP + accI.

    if throttle + accU > 1 {
        lock throttle to 1.
    }
    else if throttle + accU < 0 {
        lock throttle to 0.
    }
    else {
        local tempThrot is throttle + accU.
        lock throttle to tempThrot.
    }
}