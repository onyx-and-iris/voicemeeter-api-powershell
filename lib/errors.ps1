class VMRemoteErrors : Exception {
    [string]$msg

    VMRemoteErrors ([string]$msg) {
        $this.msg = $msg
    }

    [string] ErrorMessage () {
        return $this.msg
    }
}

class LoginError : VMRemoteErrors {
    LoginError ([string]$msg) : base ([string]$msg) {
    }
}

class CAPIError : VMRemoteErrors {
    [int]$retval
    [string]$caller

    CAPIError ([int]$retval, [string]$caller) {
        $this.retval = $retval
        $this.caller = $caller
    }

    [string] ErrorMessage () {
        return "ERROR: CAPI return value: {0} in {1}" -f $this.retval, $this.caller
    }
}
