## About

A simple voicemeeter-cli program. Offers ability to toggle, get and set parameters.

## Use

Toggle with `!` prefix, get by excluding `=` and set by including `=`. Mix and match arguments.

You may pass the following optional flags:

-   -v: (-verbose) to toggle console output.
-   -i: (-interactive) to toggle interactive mode.
-   -k: (-kind) to set the kind of Voicemeeter. Defaults to banana.

for example:

`powershell.exe .\CLI.ps1 -o -k "banana" -s "strip[0].mute", "!strip[0].mute", "strip[0].mute", "bus[2].eq.on=1", "command.lock=1"`

Expected output:

```
Getting strip[0].mute
strip[0].mute = 0
Toggling strip[0].mute
Getting strip[0].mute
strip[0].mute = 1
Setting bus[2].eq.on=1
Setting command.lock=1
```

If running in interactive mode enter `<Enter>` to exit.
