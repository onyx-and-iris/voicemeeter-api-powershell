## About

A basic command-line interface

## Use

```
Voicemeeter CLI

Usage:
  CLI.ps1 [-interactive] [-kind <basic|banana|potato>] [-script <command1>, <command2>, ...]

Options:
  -help               Display this help message.
  -interactive        Start in interactive mode.
  -kind <type>        Specify the Voicemeeter type (basic, banana or potato). Default is banana.
  -script <commands>  Provide a list of commands to execute in sequence.

Commands can be of the form:
  Parameter=Value     Set a parameter to a specific value.
  !Parameter          Toggle a boolean parameter.
  Parameter           Get the current value of a parameter.
```

for example:

```powershell
.\CLI.ps1 -script strip[0].mute, !strip[0].mute, strip[0].mute, bus[2].eq.on=1, command.lock=1
```

should produce the output:

```console
strip[0].mute = 1
Toggled strip[0].mute to 0
strip[0].mute = 0
Set bus[2].eq.on=1
Set command.lock=1
```