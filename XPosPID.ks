function xPosPID {
    declare parameter posSetpoint.

    //Altitude P controller
    local maxVelocity is 5.
    local minVelocity is -5.
    local posKP is 1.

    lock posPV to xPos.
    local posError is posSetpoint - posPV.

    local posP is posKP * posError.
    local posU is posP.

    if posU > maxVelocity {
        set posU to maxVelocity.
    }
    else if posU < minVelocity {
        set posU to minVelocity.
    }

    //Velocity PD controller
    local velSetpoint is posU.
    local velKP is 0.1.
    local velKD is 0.1.

    lock velPV to xVel.
    local velError is velSetpoint - velPV.

    local velP is velKP * velError.

    local velErrorSlope is (velError - lastXVelError) / lastInterval.
    local velD is velKD * velErrorSlope.
    set lastXVelError to velError.

    local velU is velP + velD.

    //Acceleration PI controller
    local accSetpoint is velU.
    local accKP is 0.01.
    local accKI is 0.01.

    lock accPV to ship:sensors:acc:x.
    local accError is accSetpoint - accPV.

    local accP is accKP * accError.

    set xAccErrorIntegral to xAccErrorIntegral + accError * deltaTime.
    local accI is accKI * xAccErrorIntegral.

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