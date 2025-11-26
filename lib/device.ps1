class Device : IRemote {
    Device ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    hidden $_name = $($this | Add-Member ScriptProperty 'name' `
        {
            $this.Getter_String('name')
        } `
        {
            return Write-Warning ("ERROR: $($this.identifier()).name is read only")
        }
    )

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            [int]$this.Getter('sr')
        } `
        {
            return Write-Warning ("ERROR: $($this.identifier()).sr is read only")
        }
    )

    hidden $_wdm = $($this | Add-Member ScriptProperty 'wdm' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).wdm is write only")
        } `
        {
            param($arg)
            return $this.Setter('wdm', $arg)
        }
    )

    hidden $_ks = $($this | Add-Member ScriptProperty 'ks' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).ks is write only")
        } `
        {
            param($arg)
            return $this.Setter('ks', $arg)
        }
    )

    hidden $_mme = $($this | Add-Member ScriptProperty 'mme' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).mme is write only")
        } `
        {
            param($arg)
            return $this.Setter('mme', $arg)
        }
    )
}

class BusDevice : Device {
    BusDevice ([int]$index, [Object]$remote) : base ($index, $remote) {
        if ($this.index -eq 0) {
            $this.AddASIO()
        }
    }

    [string] identifier () {
        return 'Bus[' + $this.index + '].Device'
    }

    hidden [void] AddASIO () {
        Add-Member -InputObject $this -MemberType ScriptProperty -Name 'asio' `
            -Value {
            return Write-Warning ("ERROR: $($this.identifier()).asio is write only")
        } -SecondValue {
            param($arg)
            return $this.Setter('asio', $arg)
        } -Force
    }
}

class StripDevice : Device {
    StripDevice ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Device'
    }
}