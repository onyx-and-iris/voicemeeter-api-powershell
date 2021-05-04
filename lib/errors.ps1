class VBPathError : Exception {
    [String]$msg

    VBPathError([String]$msg) {
        $this.msg = $msg
    }

    [String] ErrorMessage() {
        return $this.msg
    }
}

class LoginError : Exception {
    [String]$msg

    LoginError([String]$msg) {
        $this.msg = $msg
    }

    [String] ErrorMessage() {
        return $this.msg
    }
}

class CAPIError : Exception {
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
