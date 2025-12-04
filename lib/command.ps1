class Special : IRemote {
    Special ([Object]$remote) : base ($remote) {
        AddActionMembers -PARAMS @('restart', 'shutdown', 'show', 'lock', 'reset')
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

    [void] Hide () {
        $this.Setter('show', $false)
    }

    [void] Unlock () {
        $this.Setter('lock', $false)
    }

    [void] ShowVBANChat () {
        $this.Setter('DialogShow.VBANCHAT', $true)
    }

    [void] HideVBANChat () {
        $this.Setter('DialogShow.VBANCHAT', $false)
    }

    [void] Load ([string]$filename) {
        $this.Setter('load', $filename)
    }

    [void] Save ([string]$filename) {
        $this.Setter('save', $filename)
    }

    [void] StorePreset () {
        $this.Setter('updatepreset', '')
    }

    [void] StorePreset ([string]$name) {
        $this.Setter('updatepreset', $name)
    }

    [void] StorePreset ([int]$index) {
        $this.Setter('preset[{0}].store' -f $index, '')
    }

    [void] StorePreset ([int]$index, [string]$name) {
        $this.Setter('preset[{0}].store' -f $index, $name)
    }

    [void] RecallPreset () {
        $this.Setter('recallpreset', '')
    }

    [void] RecallPreset ([string]$name) {
        $this.Setter('recallpreset', $name)
    }

    [void] RecallPreset ([int]$index) {
        $this.Setter('preset[{0}].recall' -f $index, 1)
    }
}

function Make_Command([Object]$remote) {
    return [Special]::new($remote)
}
