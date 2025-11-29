[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Target = "variablename")]
Param([String]$tag, [string]$kind = 'potato')
Import-Module (Join-Path (Split-Path $PSScriptRoot -Parent) 'lib\Voicemeeter.psm1') -Force


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

        Invoke-Pester -Tag $tag -PassThru | Out-Null
    }
    finally { Disconnect-Voicemeeter }   
}


main
