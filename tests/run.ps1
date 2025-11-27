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
        $vban_in = $vmr.kind.vban_in - 1
        $vban_out = $vmr.kind.vban_out - 1
        $insert = $vmr.kind.insert - 1
        $composite = $vmr.kind.composite - 1

        # skip conditions by kind
        $ifBasic = $vmr.kind.name -eq 'basic'
        $ifNotBasic = $vmr.kind.name -ne 'basic'
        $ifNotPotato = $vmr.kind.name -ne 'potato'

        Invoke-Pester -Tag $tag -PassThru | Out-Null
    }
    finally { Disconnect-Voicemeeter }   
}


main
