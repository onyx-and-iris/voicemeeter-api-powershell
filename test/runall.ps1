Param([String]$tag, [Int]$num=1)
Import-Module ..\lib\Voicemeeter.psm1
. ..\lib\base.ps1

try
{
    $vmr = Get-RemotePotato

    1..$num | ForEach-Object {
        Write-Host "Running test $_ of $num"
        Invoke-Pester -Tag $tag
    }
}
finally
{
    $vmr.Logout()
}
