Param(
    [String]$tag, [Int]$num=1
)

try
{
    . ..\lib\voicemeeter.ps1

    $vmr = [Remote]::new('potato')

    1..$num | ForEach-Object {
        Write-Host "Running test $_ of $num"
        Invoke-Pester -Tag $tag
    }
}
finally
{
    $vmr.Logout()
}
