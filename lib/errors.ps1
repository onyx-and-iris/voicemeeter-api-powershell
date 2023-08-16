class VMRemoteError : Exception {
    VMRemoteError ([string]$msg) : base ($msg) {
    }
}

class LoginError : VMRemoteError {
    LoginError ([string]$msg) : base ($msg) {
    }
}

class CAPIError : VMRemoteError {
    [int]$retval
    [string]$caller

    CAPIError ([int]$retval, [string]$caller) : base ("$caller returned $retval") {
        $this.retval = $retval
        $this.caller = $caller
    }
}