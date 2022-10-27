param(
    [switch]$interactive,
    [Parameter(Mandatory)]
    [String]$kind,
    [String[]]$script = @()
)

Import-Module Voicemeeter

function get-value {
    param([object]$vmr, [string]$line)
    try {
        $retval = $vmr.Getter($line)
    }
    catch {
        $retval = $vmr.Getter_String($line)
    }
    $retval
}

function msgHandler {
    param([object]$vmr, [string]$line)
    $line + " passed to handler" | Write-Debug
    if ($line[0] -eq "!") {
        $retval = get-value -vmr $vmr -line $line.substring(1)
        $vmr.Setter($line.substring(1), 1 - $retval)
    }
    elseif ($line.Contains("=")) { 
        "Setting value $line" | Write-Debug
        $vmr.SendText($line)
    }
    else {
        "Getting value $line" | Write-Debug
        $retval = get-value -vmr $vmr -line $line
        $line + " = " + $retval | Write-Host
    }
}

function read-hostuntilflag {
    param([object]$vmr)
    while (($line = Read-Host) -cne [string]::Empty) { msgHandler -vmr $vmr -line $line }
}


function main {
    [object]$vmr

    try {
        switch ($kind) {
            "basic" { $vmr = Get-RemoteBasic }
            "banana" { $vmr = Get-RemoteBanana }
            "potato" { $vmr = Get-RemotePotato }
        }
    
        if ($interactive) {
            "Press <Enter> to exit" | Write-Host
            read-hostuntilflag -vmr $vmr
            return
        }
        $script | ForEach-Object {
            msgHandler -vmr $vmr -line $_
        }
    }
    finally { $vmr.Logout() }
}

if ($MyInvocation.InvocationName -ne '.') { main }
