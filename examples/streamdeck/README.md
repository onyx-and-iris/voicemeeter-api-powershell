# About

Thanks to the guys at [Start Automating](https://startautomating.com/) it's possible to use this module straight from your Stream Deck.

## Requirements

### ScriptDeck

*Windows Powershell*

-   [Windows ScriptDeck](https://marketplace.elgato.com/product/windows-scriptdeck-857f01dd-8fd4-44d5-8ec7-67ac850b21d3)

*Powershell core*

-   [ScriptDeck](https://marketplace.elgato.com/product/scriptdeck-927e59aa-b42d-4da7-84cc-8c78f4dd7e18)

Note, even though one of them is named Windows they both work on Windows for different powershell versions, see [this issue](https://github.com/StartAutomating/ScriptDeck/issues/120)

### Voicemeeter API Powershell

-   Install it as a module, see [Installation](https://github.com/onyx-and-iris/voicemeeter-api-powershell?tab=readme-ov-file#installation)

## How

Once ScriptDeck is installed create a button using *Powershell Script*, then:

### On one button

Due to the design of Voicemeeter's API you may only login/logout once per session so in order to program multiple buttons you must do the following for just ONE button (it can be any button).

#### Button 1

*When Loaded*

```powershell
$global:vmr = Connect-Voicemeeter -Kind "banana"
```

*When Unloaded*

```powershell
Disconnect-Voicemeeter
```

*When Pressed*

```powershell
if ($vmr.strip[0].mute) {
$vmr.bus[0].mute=1
$vmr.bus[1].mute=1
} else {
$vmr.bus[0].mute=0
$vmr.bus[1].mute=0
}
```

### Other buttons

Then your other buttons can have any scripts using the `$vmr` object:

#### Button 2

*When Pressed*

```powershell
$vmr.strip[1].mute=1
$vmr.strip[2].mute=1

if (-not $vmr.strip[0].mute) {
$vmr.strip[0].mute=1
}
```

#### Button 3

*When Pressed*

```powershell
$vmr.strip[0].mute=$(-not $vmr.strip[0].mute)
$vmr.strip[1].mute=$(-not $vmr.strip[1].mute)
$vmr.strip[2].mute=$(-not $vmr.strip[2].mute)
```

---

Then let's say you have zillions of buttons you want to program, for each Stream Deck window configure ONE button as described above and the other buttons of the same window as described above.

If this explanation is unclear or you'd like me to add some screenshots just ask.