Param([String]$tag, [Int]$num=1)
Import-Module ..\lib\Voicemeeter.psm1
. ..\lib\base.ps1

Function ParseLog {
    Param([String]$logfile)
    $summary_file = "_summary.log"
    if (Test-Path $summary_file) { Clear-Content $summary_file }

    $PASSED_PATTERN = "^PassedCount\s+:\s(\d+)"
    $FAILED_PATTERN = "^FailedCount\s+:\s(\d+)"

    $DATA = @{
        "passed" = 0
        "failed" = 0
    }

    ForEach ($line in `
    $(Get-content -Path "${logfile}")) {
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


try
{
    $vmr = Get-RemotePotato

    $logfile = "_results.log"
    if (Test-Path $logfile) { Clear-Content $logfile }

    1..$num | ForEach-Object {
        "Running test $_ of $num" | Tee-Object -FilePath $logfile -Append
        Invoke-Pester -Tag $tag -PassThru | Tee-Object -FilePath $logfile -Append
    }

    Parselog -logfile $logfile
}
finally
{
    $vmr.Logout()
}
