Function ConvertTo-MBGBTB {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true,
            Position = 0)]
            [double]$ValueInBytes
    )
    Write-Verbose "Converting Bytes to MB/GB/TB for $ValueInBytes"
    Switch ($ValueInBytes) {
        { $_ -lt 1GB } {$FriendlyValue = ([math]::Round(($_ / 1MB), 3)).tostring() + " MB"  }
        { $_ -gt 1GB -and $_ -lt 1TB } {$FriendlyValue = ([math]::Round(($_ / 1GB), 3)).tostring() + " GB" }
        { $_ -gt 1TB } {$FriendlyValue = ([math]::Round(($_ / 1TB), 3)).tostring() + " TB" }
        'Default' { $FriendlyValue = "Incorrect Value in Bytes" }
    }
    Write-Verbose "returning $FriendlyValue"
    return $FriendlyValue
}