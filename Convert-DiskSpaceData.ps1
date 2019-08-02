Function Convert-DiskSpaceData {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true,
            Position = 0)]
        [ValidateScript( { Test-Path $_ })]
        [string]$DataSourcePath
    )
    $DataSource = Import-Csv $DataSourcePath | Where-Object {$_.DriveType -eq 3}
    Write-Verbose "Adding columns to the source data for Friendly disk sizes"
    Foreach ($entry in $DataSource) {
        $entry | Add-Member -MemberType NoteProperty -Name "TotalSpace" -Value (ConvertTo-MBGBTB -ValueInBytes $entry.Size) -Force
        $entry | Add-Member -MemberType NoteProperty -Name "TotalFreeSpace" -Value (ConvertTo-MBGBTB -ValueInBytes $entry.FreeSpace ) -Force
        $entry | Add-Member -MemberType NoteProperty -Name "UsedPercentage" -Value ([math]::Round(((($entry.Size - $entry.FreeSpace) / $entry.Size) * 100), 2) ) -Force
        $entry | Add-Member -MemberType NoteProperty -Name "Status" -Value (Get-AlertLevel -FreeSpace $entry.FreeSpace -TotalSpace $entry.Size) -Force
    }
    $DataSource | Export-Csv $DataSourcePath -NoTypeInformation
    Write-Verbose "Completed adding columns"
}
