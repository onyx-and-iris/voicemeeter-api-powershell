class Special : IRemote {
    Special ([Object]$remote) : base ($remote) {
        AddActionMembers -PARAMS @('restart', 'shutdown', 'show')
    }

    [string] identifier () {
        return 'Command'
    }

    [void] RunMacrobuttons() {
        'Launching the MacroButtons app' | Write-Verbose
        Start-Process -FilePath $(Join-Path -Path $this.remote.vmpath -ChildPath 'VoicemeeterMacroButtons.exe')
    }

    [void] CloseMacrobuttons() {
        'Closing the MacroButtons app' | Write-Verbose
        Stop-Process -Name 'VoicemeeterMacroButtons'
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
