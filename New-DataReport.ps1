Function New-DataReport {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true,
            Position = 0)]
        [ValidateScript( { Test-Path $_ })]
        [string]$DataSourcePath
    )
    $DataSource = Import-Csv $DataSourcePath | Group-Object -Property PSComputerName

    $Column1 = $DataSource | Select-Object -First ($DataSource.Length / 3)
    $Column2 = $DataSource | Select-Object -First ($DataSource.Length / 3) -Skip ($Column1.Length)
    $Column3 = $DataSource | Select-Object -Skip ($Column1.Length + $Column2.Length)
    $Columns = @($Column1, $Column2, $Column3)

    $htmltablecode = Table -Attributes @{"style" = "width:100%";"border"=0 } {
        Thead {
            tr {
                th -Attributes @{"colspan" = 3; } {
                    h1 "Disk Space Data"
                }
            }
            tr {
                th -Attributes @{"colspan" = 3 } {
                    (Get-Item $DataSourcePath).LastWriteTime
                }
            }
        }
        Tbody {
            tr {
                foreach ($column in $Columns) {
                    td -Attributes @{"valign"="top";} {
                        Table -Attributes @{"style" = "width:100%;";"border" = 1 } {
                            Thead {
                                tr {
                                    th "ComputerName"
                                    th "Disks" -Attributes @{"colspan" = "8" }
                                }
                            }
                            Tbody {
                                foreach ($entry in $column) {
                                    tr {
                                        td "$($entry.Name)" #ComputerName
                                        foreach ($subentry in $entry.Group) {

                                            $stat = $subentry.PSComputerName + ";" + $subentry.DeviceID + ";" + $subentry.TotalSpace + ";" + $subentry.TotalFreeSpace + ";" + $subentry.UsedPercentage
                                            If ($subentry.Status -eq "Green") {
                                                $alertcolor = "#00FF00" #green
                                            }
                                            else {
                                                $alertcolor = "#FF0000" #red
                                            }
                                            td "$($subentry.DeviceID)" -Attributes @{"Title" = $stat; "bgcolor" = $alertcolor }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    #############################################################################################
    $htmltablecode
}

