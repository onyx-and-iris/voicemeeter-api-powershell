[cmdletbinding()]
param(
    [switch]$interactive,
    [String]$kind = "banana",
    [String[]]$script = @()
)

Import-Module ..\..\lib\Voicemeeter.psm1

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
        "Toggling " + $line.substring(1) | Write-Debug
        $retval = get-value -vmr $vmr -line $line.substring(1)
        $vmr.Setter($line.substring(1), 1 - $retval)
    }
    elseif ($line.Contains("=")) { 
        "Setting $line" | Write-Debug
        $vmr.SendText($line)
    }
    else {
        "Getting $line" | Write-Debug
        $retval = get-value -vmr $vmr -line $line
        $line + " = " + $retval | Write-Host
    }
}

function read-hostuntilempty {
    param([object]$vmr)
    while (($line = Read-Host) -cne [string]::Empty) { msgHandler -vmr $vmr -line $line }
}


function main {
    [object]$vmr

    try {
        $vmr = Connect-Voicemeeter -Kind $kind
    
        if ($interactive) {
            "Press <Enter> to exit" | Write-Host
            read-hostuntilempty -vmr $vmr
            return
        }
        $script | ForEach-Object {
            msgHandler -vmr $vmr -line $_
        }
    }
    finally { Disconnect-Voicemeeter }
}

main
