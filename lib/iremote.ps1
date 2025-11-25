class IRemote {
    [Nullable[int]]$index
    [Object]$remote

    IRemote ([Object]$remote) {
        $this.remote = $remote
    }
    
    IRemote ([int]$index, [Object]$remote) {
        $this.index = $index
        $this.remote = $remote
    }

    [single] Getter ($param) {
        $this.ToString() + " Getter: $($this.Cmd($param))" | Write-Debug
        return $this.remote.Getter($this.Cmd($param))
    }

    [string] Getter_String ($param) {
        $this.ToString() + " Getter_String: $($this.Cmd($param))" | Write-Debug
        return $this.remote.Getter_String($this.Cmd($param))
    }

    [void] Setter ($param, $val) {
        $this.ToString() + " Setter: $($this.Cmd($param))=$val" | Write-Debug
        if ($val -is [Boolean]) {
            $this.remote.Setter($this.Cmd($param), $(if ($val) { 1 } else { 0 }))
        }
        else {
            $this.remote.Setter($this.Cmd($param), $val)
        }
    }

    [string] Cmd ($param) {
        if ([string]::IsNullOrEmpty($param)) {
            return $this.identifier()
        }
        return "$($this.identifier()).$param"
    }

    # Must be overridden by derived classes
    [string] identifier () {
        throw [System.NotImplementedException]::new("$($this.GetType().Name) must override identifier()")
    }

    [string] ToString() {
        if ($this.index.HasValue) {
            return $this.GetType().Name + $this.index
        }
        return $this.GetType().Name
    }
}