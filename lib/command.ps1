class Special {
    [Object]$remote

    Special ([Object]$remote) {
        AddActionMembers -PARAMS @('restart', 'shutdown', 'show')
    
        $this.remote = $remote
    }

    [string] identifier () {
        return "Command"
    }

    [string] ToString() {
        return $this.GetType().Name
    }

    [single] Getter ($param) {
        return $this.remote.Getter("$($this.identifier()).$param")
    }

    [void] Setter ($param, $val) {
        if ($val -is [Boolean]) {
            $this.remote.Setter("$($this.identifier()).$param", $(if ($val) { 1 } else { 0 }))
        }
        else {
            $this.remote.Setter("$($this.identifier()).$param", $val)
        }
    }

    [void] RunMacrobuttons() {
        "Launching the MacroButtons app" | Write-Verbose
        Start-Process -FilePath $(Join-Path -Path $this.remote.vmpath -ChildPath "VoicemeeterMacroButtons.exe")
    }

    [void] CloseMacrobuttons() {
        "Closing the MacroButtons app" | Write-Verbose
        Stop-Process -Name "VoicemeeterMacroButtons"
    }

    hidden $_hide = $($this | Add-Member ScriptProperty 'hide' `
        {
            $this._hide = $this.Setter('show', $false)
        } `
        {}
    )

    hidden $_showvbanchat = $($this | Add-Member ScriptProperty 'showvbanchat' `
        {
            $this.Getter('DialogShow.VBANCHAT')
        } `
        {
            param([bool]$arg)
            $this._showvbanchat = $this.Setter('DialogShow.VBANCHAT', $arg)
        }
    )

    hidden $_lock = $($this | Add-Member ScriptProperty 'lock' `
        {
            $this._lock = $this.Getter('lock')
        } `
        {
            param([bool]$arg)
            $this._lock = $this.Setter('lock', $arg)
        }
    )

    [void] Load ([string]$filename) {
        $this.Setter('load', $filename)
    }
}

function Make_Command([Object]$remote) {
    return [Special]::new($remote)
}
