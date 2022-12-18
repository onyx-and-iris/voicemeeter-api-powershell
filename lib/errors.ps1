class VMRemoteError : Exception {
    [string]$msg

    VMRemoteError ([string]$msg) {
        $this.msg = $msg
    }

    [string] ErrorMessage () {
        return $this.msg
    }
}

class LoginError : VMRemoteError {
    LoginError ([string]$msg) : base ([string]$msg) {
    }
}

class CAPIError : VMRemoteError {
    [int]$retval
    [string]$caller

    CAPIError ([int]$retval, [string]$caller) {
        $this.retval = $retval
        $this.caller = $caller
    }

    [string] ErrorMessage () {
        return "CAPI return value: {0} in {1}" -f $this.retval, $this.caller
    }
}
