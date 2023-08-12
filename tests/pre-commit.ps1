Param([String]$tag, [Int]$num = 1, [switch]$log, [string]$kind = "potato")
Import-Module .\lib\Voicemeeter.psm1

Function ParseLog {
    Param([String]$logfile)
    $summary_file = Join-Path $PSScriptRoot "_summary.log"
    if (Test-Path $summary_file) { Clear-Content $summary_file }

    $PASSED_PATTERN = "^PassedCount\s+:\s(\d+)"
    $FAILED_PATTERN = "^FailedCount\s+:\s(\d+)"

    $DATA = @{
        "passed" = 0
        "failed" = 0
    }

    ForEach ($line in `
        $(Get-Content -Path "${logfile}")) {
        if ($line -match $PASSED_PATTERN) {
            $DATA["passed"] += $Matches[1]
        }
        elseif ($line -match $FAILED_PATTERN) {
            $DATA["failed"] += $Matches[1]
        }
    }

    "=========================`n" + `
        "$num tests run:`n" + `
        "=========================" | Tee-Object -FilePath $summary_file -Append
    $DATA | ForEach-Object { $_ } | Tee-Object -FilePath $summary_file -Append
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
        $vban_in = $vmr.kind.vban_in - 1
        $vban_out = $vmr.kind.vban_out - 1

        # skip conditions by kind
        $ifBasic = $vmr.kind.name -eq "basic"
        $ifBanana = $vmr.kind.name -eq "banana"
        $ifPotato = $vmr.kind.name -eq "potato"
        $ifNotBasic = $vmr.kind.name -ne "basic"
        $ifNotBanana = $vmr.kind.name -ne "banana"
        $ifNotPotato = $vmr.kind.name -ne "potato"

        $logfile = Join-Path $PSScriptRoot "_results.log"
        if (Test-Path $logfile) { Clear-Content $logfile }

        1..$num | ForEach-Object {
            if ($log) { 
                "Running test $_ of $num" | Tee-Object -FilePath $logfile -Append
                Invoke-Pester -Tag $tag -PassThru | Tee-Object -FilePath $logfile -Append
            }
            else { 
                "Running test $_ of $num"
                Invoke-Pester -Tag $tag -PassThru
            }
        }

        if ($log) { Parselog -logfile $logfile }
    }
    finally { Disconnect-Voicemeeter }   
}



if ($MyInvocation.InvocationName -ne '.') { main }