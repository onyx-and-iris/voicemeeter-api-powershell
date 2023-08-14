param(
    [switch]$interactive,
    [switch]$output,
    [String]$kind = "banana",
    [String[]]$script = @()
)

Import-Module ..\..\lib\Voicemeeter.psm1

$VerbosePreference = "Continue"

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
        if ($output) { "Toggling " + $line.substring(1) | Write-Host }
        $retval = get-value -vmr $vmr -line $line.substring(1)
        $vmr.Setter($line.substring(1), 1 - $retval)
    }
    elseif ($line.Contains("=")) { 
        if ($output) { "Setting $line" | Write-Host }
        $vmr.SendText($line)
    }
    else {
        if ($output) { "Getting $line" | Write-Host }
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
