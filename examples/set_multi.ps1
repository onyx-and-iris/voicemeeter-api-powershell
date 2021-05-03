Import-Module Voicemeeter

try {
    $vmr = Get-RemotePotato

    $hash = @{
        strip_0 = @{mute = $true; mono = $true};
        strip_1 = @{mute = $true; mono = $true};
        strip_2 = @{mute = $true; mono = $true};
        bus_0 = @{mute = $true; mono = $true};
        bus_1 = @{mute = $true; mono = $true};
        bus_2 = @{mute = $true; mono = $true};

        mb_0 = @{state = $true};
        mb_1 = @{stateonly = $true};
        mb_2 = @{trigger = $true}
    }

    $vmr.Set_Multi($hash)

    $hash = @{
        strip_0 = @{mute = $false; mono = $false};
        strip_1 = @{mute = $false; mono = $false};
        strip_2 = @{mute = $false; mono = $false};
        bus_0 = @{mute = $false; mono = $false};
        bus_1 = @{mute = $false; mono = $false};
        bus_2 = @{mute = $false; mono = $false};

        mb_0 = @{state = $false};
        mb_1 = @{stateonly = $false};
        mb_2 = @{trigger = $false}
    }

    $vmr.Set_Multi($hash)
}
finally { $vmr.Logout() }
