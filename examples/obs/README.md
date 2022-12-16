## About

Demonstrates how to sync Voicemeeter states with OBS scene switches.

## Requirements

-   [OBS Studio 28+](https://obsproject.com/)
-   [OBS-Powershell](https://github.com/StartAutomating/obs-powershell)

## Use

This example assumes the following:

-   OBS connection info saved in `config.psd1`, placed next to `Vm-Obs-Sync.ps1`:

```psd1
@{
    hostname = "localhost"
    port     = 4455
    password = "mystrongpassword"
}
```

-   OBS scenes named `START`, `BRB`, `END` and `LIVE`

Simply run the script and change current OBS scene.

Closing OBS will end the script.
