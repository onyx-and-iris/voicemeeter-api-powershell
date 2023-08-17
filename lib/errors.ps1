class VMRemoteError : Exception {
    VMRemoteError ([string]$msg) : base ($msg) {
    }
}

class LoginError : VMRemoteError {
    LoginError ([string]$msg) : base ($msg) {
    }
}

class CAPIError : VMRemoteError {
    [int]$code
    [string]$function

    CAPIError ([int]$code, [string]$function) : base ("$function returned $code") {
        $this.code = $code
        $this.function = $function
    }
}