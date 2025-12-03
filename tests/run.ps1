[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Target = "variablename")]
Param([String]$tag, [string]$kind = 'potato', [string]$recDir = (Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Voicemeeter'))
Import-Module (Join-Path (Split-Path $PSScriptRoot -Parent) 'lib\Voicemeeter.psm1') -Force


function Test-RecDir ([object]$vmr, [string]$recDir) {
    $prefix = 'temp'
    $filetype = 'wav'
    $vmr.recorder.prefix($prefix)
    $vmr.recorder.filetype($filetype)

    
    try {
        $vmr.recorder.record()
        $stamp = '{0:yyyy-MM-dd} at {0:HH}h{0:mm}m{0:ss}s' -f (Get-Date)
        Start-Sleep -Milliseconds 2000

        $tmp = Join-Path $recDir ("{0} {1}.{2}" -f $prefix, $stamp, $filetype)

        $vmr.recorder.stop()
        $vmr.recorder.eject()
        Start-Sleep -Milliseconds 500
    }
    catch {
        Write-Warning "Failed to record pre-check clip: $_"
    }

    if (Test-Path $tmp) {
        Remove-Item -Path $tmp -Force
        return $false
    }
    else {
        Write-Warning "Recorder output not found at given path: $tmp"
        Write-Warning "Skipping Recording/Playback tests. Provide custom path with -recDir"
        return $true
    }
}

function main() {
    try {
        $vmr = Connect-Voicemeeter -Kind $kind
        $vmr.command.RunMacrobuttons()  # ensure macrobuttons is running before we begin
        Write-Host "Running tests for $vmr"

        # test boundaries by kind
        $phys_in = $vmr.kind.p_in - 1
        $virt_in = $vmr.kind.p_in + $vmr.kind.v_in - 1
        $phys_out = $vmr.kind.p_out - 1
        $virt_out = $vmr.kind.p_out + $vmr.kind.v_out - 1
        $vban_inA = $vmr.kind.vban.in - 1
        $vban_inM = $vmr.kind.vban.in + $vmr.kind.vban.midi - 1
        $vban_inT = $vmr.kind.vban.in + $vmr.kind.vban.midi + $vmr.kind.vban.text - 1
        $vban_outA = $vmr.kind.vban.out - 1
        $vban_outM = $vmr.kind.vban.out + $vmr.kind.vban.midi - 1
        $insert = $vmr.kind.insert - 1
        $composite = $vmr.kind.composite - 1
        $strip_ch = $vmr.kind.eq_ch['strip'] - 1
        $bus_ch = $vmr.kind.eq_ch['bus'] - 1
        $cells = $vmr.kind.cells - 1

        # skip conditions by kind
        $ifBasic = $vmr.kind.name -eq 'basic'
        $ifNotBasic = $vmr.kind.name -ne 'basic'
        $ifNotPotato = $vmr.kind.name -ne 'potato'

        # recording directory: default ~/My Documents/Voicemeeter, override if custom
        $recDir = [System.IO.Path]::GetFullPath($recDir)
        if ($ifBasic) {
            $ifCustomDir = $ifBasic # basic can't record, so skip the test
        }
        else {
            $ifCustomDir = Test-RecDir -vmr $vmr -recDir $recDir # avoid creating files we can't delete
        }

        Invoke-Pester -Tag $tag -PassThru | Out-Null
    }
    finally { Disconnect-Voicemeeter }   
}


main
