class VMRemoteErrors : Exception {
    [String]$msg

    VMRemoteErrors([String]$msg) {
        $this.msg = $msg
    }

    [String] ErrorMessage() {
        return $this.msg
    }
}

class LoginError : VMRemoteErrors {
    LoginError([String]$msg) : Base([String]$msg) {
    }
}

class CAPIError : VMRemoteErrors {
    [Int]$retval
    [String]$caller

    CAPIError([Int]$retval, [String]$caller) {
        $this.retval = $retval
        $this.caller = $caller
    }

    [String] ErrorMessage() {
        return "ERROR: CAPI return value: {0} in {1}" -f $this.retval, $this.caller
    }
}
