Function Get-AlertLevel {
    [cmdletbinding()]
    param(
        [parameter()]
        $FreeSpace,
        [parameter()]
        $TotalSpace
    )
    If ($TotalSpace / 1TB -ge 1) {
        If ($FreeSpace / 1GB -lt 200) {
            return 'Red'
        }
        Else {
            return 'Green'
        }
    }
    Else {
        If (($FreeSpace / $TotalSpace * 100) -lt 20) {
            return 'Red'
        }
        Else {
            return 'Green'
        }
    }
}