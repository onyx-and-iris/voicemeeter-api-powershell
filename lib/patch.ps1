class Patch : IRemote {
    [System.Collections.ArrayList]$asio
    [System.Collections.ArrayList]$composite
    [System.Collections.ArrayList]$insert
    
    Patch ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('postFaderComposite', 'postFxInsert')
        
        $this.AddASIOOutMembers()
        
        $this.asio = @()
        for ($i = 0; $i -lt $remote.kind.asio_in; $i++) {
            $this.asio.Add([IntArrayMember]::new($i, 'asio', $this))
        }
        
        $this.composite = @()
        for ($i = 0; $i -lt $remote.kind.composite; $i++) {
            $this.composite.Add([IntArrayMember]::new($i, 'composite', $this))
        }
        
        $this.insert = @()
        for ($i = 0; $i -lt $remote.kind.insert; $i++) {
            $this.insert.Add([BoolArrayMember]::new($i, 'insert', $this))
        }
    }
    
    [string] identifier () {
        return 'Patch'
    }
    
    hidden [void] AddASIOOutMembers () {
        $num_A = $this.remote.kind.p_out
        if ($this.remote.kind.name -eq 'basic') {
            $num_A += $this.remote.kind.v_out
        }
        $asio_out  = $this.remote.kind.asio_out
        
        if ($asio_out -le 0) { return }
        
        for ($a = 2; $a -le $num_A; $a++) {
            [System.Collections.ArrayList]$members = @()
            for ($i = 0; $i -lt $asio_out; $i++) {
                $members.Add([IntArrayMember]::new($i, "OutA$a", $this))
            }
            Add-Member -InputObject $this -MemberType NoteProperty -Name "OutA$a" -Value $members -Force
        }
    }
}

function Make_Patch ([Object]$remote) {
    return [Patch]::new($remote)
}