Function Get_Profiles([String]$kind_id) {
    $basepath = Join-Path -Path $(Split-Path -Path $PSScriptRoot) -ChildPath "profiles"
    if (Test-Path $basepath) {
        $fullpath = Join-Path -Path $basepath -ChildPath $kind_id
    }
    else { return $null }
    $filenames = @(Get-ChildItem -Path $fullpath -Filter *.psd1 -Recurse -File)

    [HashTable]$data = @{}
    if ($filenames) {
        $filenames | ForEach-Object {
            (Join-Path -Path $fullpath -ChildPath $_) | ForEach-Object {
                $filename = [System.IO.Path]::GetFileNameWithoutExtension($_)
                Write-Host ("Importing profile " + $kind_id + "/" + $filename)
                $data[$filename] = Import-PowerShellDataFile -Path $_
            }
        }
        return $data        
    }
    return $null
}

Function Set_Profile {
    param(
        [Object]$DATA, [String]$CONF
    )
    try {
        if ($null -eq $DATA -or -not $DATA.$CONF) {
            throw [VMRemoteErrors]::new("No profile named $CONF was loaded")
        }
        Param_Set_Multi -HASH $DATA.$CONF
        Start-Sleep -m 1        
    }
    catch [VMRemoteErrors] {
        Write-Warning $_.Exception.ErrorMessage()
    }
}