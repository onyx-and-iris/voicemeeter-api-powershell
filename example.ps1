Import-Module .\lib\Voicemeeter.psm1

try {
    $vmr = Get-RemoteBanana

    $hash = @{
        strip_0 = @{mute = $true; mono = $true; A1 = $true; B2 = $true; gain = 2.3};
        strip_1 = @{mute = $true; mono = $true; A1 = $true; B2 = $true; gain = -3.0};
        strip_2 = @{mute = $true; mono = $true; A1 = $true; B2 = $true; gain = 0.3};
        bus_0 = @{mute = $true; mono = $true; solo = $true; gain = -0.3};
        bus_1 = @{mute = $true; mono = $true; solo = $true; gain = -3.3};
        bus_2 = @{mute = $true; mono = $true; solo = $true; gain = 2.3};

        mb_0 = @{state = $true};
        mb_1 = @{stateonly = $true};
        mb_2 = @{trigger = $true}
    }

    $vmr.Set_Multi($hash)

    $hash = @{
        strip_0 = @{mute = $false; mono = $false; A1 = $false; B2 = $false; gain = 0};
        strip_1 = @{mute = $false; mono = $false; A1 = $false; B2 = $false; gain = 0};
        strip_2 = @{mute = $false; mono = $false; A1 = $false; B2 = $false; gain = 0};
        bus_0 = @{mute = $false; mono = $false; solo = $false; gain = 0};
        bus_1 = @{mute = $false; mono = $false; solo = $false; gain = 0};
        bus_2 = @{mute = $false; mono = $false; solo = $false; gain = 0};

        mb_0 = @{state = $false};
        mb_1 = @{stateonly = $false};
        mb_2 = @{trigger = $false}
    }

    $vmr.Set_Multi($hash)
}
finally { $vmr.Logout() }
