Function Get-DiskSpaceData {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true,
            Position = 0)]
        [string[]]$ComputerName
    )

    Get-WmiObject -Class Win32_LogicalDisk -ComputerName $ComputerName | Select-Object PSComputerName, DriveType, DeviceID, VolumeName, Size, FreeSpace
}

