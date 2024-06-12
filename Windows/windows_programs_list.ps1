function Get-InstalledProgramsFromRegistry {
    $registryLocations = @(
        "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
    )
    $programs = @()

    foreach ($location in $registryLocations) {
        try {
            $key = Get-Item -LiteralPath "HKLM:\$location"
            $subkeyCount = $key.SubKeyCount

            for ($i = 0; $i -lt $subkeyCount; $i++) {
                $subkeyName = $key.GetSubKeyNames()[$i]
                $subkey = Get-Item -LiteralPath "HKLM:\$location\$subkeyName"

                $name = $subkey.GetValue("DisplayName")
                $version = $subkey.GetValue("DisplayVersion")
                $installLocation = $subkey.GetValue("InstallLocation")

                if ($name) {
                    $program = @{
                        "Name" = $name
                        "Version" = $version
                        "InstallLocation" = $installLocation
                    }
                    $programs += $program
                }
            }
        } catch {
            # Handle exceptions if required
        }
    }

    return $programs
}

# Function to get a list of installed programs from the user-specific registry
function Get-InstalledProgramsFromUserRegistry {
    $programs = @()

    try {
        $userHive = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::Users, [Microsoft.Win32.RegistryView]::Default)
        $userSubkeys = $userHive.GetSubKeyNames()

        foreach ($userSubkeyName in $userSubkeys) {
            $userRegistryPath = "$userSubkeyName\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

            try {
                $key = $userHive.OpenSubKey($userRegistryPath)
                $subkeyCount = $key.SubKeyCount

                for ($i = 0; $i -lt $subkeyCount; $i++) {
                    $subkeyName = $key.GetSubKeyNames()[$i]
                    $subkey = $key.OpenSubKey($subkeyName)

                    $name = $subkey.GetValue("DisplayName")
                    $version = $subkey.GetValue("DisplayVersion")
                    $installLocation = $subkey.GetValue("InstallLocation")

                    if ($name) {
                        $program = @{
                            "Name" = $name
                            "Version" = $version
                            "InstallLocation" = $installLocation
                        }
                        $programs += $program
                    }
                }
            } catch {
                # Handle exceptions if required
            }
        }
    } catch {
        # Handle exceptions if required
    }

    return $programs
}

# Function to get a list of installed programs using WMIC
function Get-InstalledProgramsWithWmic {
    try {
        $wmicOutput = wmic product get Name,Version,InstallLocation /format:csv
        $lines = $wmicOutput -split '\r?\n' | ForEach-Object { $_.Trim() }
        $fieldnames = $lines[0] -split ',' | ForEach-Object { $_.Trim() }
        $programs = @()

        for ($i = 1; $i -lt $lines.Count; $i++) {
            $values = $lines[$i] -split ',' | ForEach-Object { $_.Trim() }
            if ($values.Count -eq $fieldnames.Count) {
                $name = $values[$fieldnames.IndexOf("Name")]
                $version = $values[$fieldnames.IndexOf("Version")]
                $installLocation = $values[$fieldnames.IndexOf("InstallLocation")]

                if ($name) {
                    $program = @{
                        "Name" = $name
                        "Version" = $version
                        "InstallLocation" = $installLocation
                    }
                    $programs += $program
                }
            }
        }

        return $programs
    } catch {
        # Handle exceptions if required
    }
}

# Function to get a list of installed UWP apps using PowerShell Get-AppxPackage
function Get-InstalledUwpApps {
    try {
        $uwpApps = Get-AppxPackage | Select-Object Name, Version, InstallLocation
        $programs = @()

        foreach ($app in $uwpApps) {
            if ($app.Name) {
                $program = @{
                    "Name" = $app.Name
                    "Version" = $app.Version
                    "InstallLocation" = $app.InstallLocation
                }
                $programs += $program
            }
        }

        return $programs
    } catch {
        # Handle exceptions if required
    }
}

# Merge and remove duplicates from four lists of installed programs
function Merge-AndRemoveDuplicates {
    param (
        [array]$programs1,
        [array]$programs2,
        [array]$programs3,
        [array]$programs4
    )

    $mergedPrograms = $programs1 + $programs2 + $programs3 + $programs4
    $uniquePrograms = @{}

    foreach ($program in $mergedPrograms) {
        $key = "$($program.Name)-$($program.Version)-$($program.InstallLocation)"
        if (-not $uniquePrograms.ContainsKey($key)) {
            $uniquePrograms[$key] = $program
        }
    }

    return $uniquePrograms.Values
}

# Export the list of installed programs to a CSV file
function Export-ToCsv {
    param (
        [array]$programs,
        [string]$csvFilename
    )

    $programs | Export-Csv -Path $csvFilename -NoTypeInformation -Encoding UTF8
}

# Export the list of installed programs to a TXT file
function Export-ToTxt {
    param (
        [array]$programs,
        [string]$txtFilename
    )

    $content = $programs | ForEach-Object {
        "Name: $($_.Name)`r`nVersion: $($_.Version)`r`nInstallLocation: $($_.InstallLocation)`r`n"
    }

    $content | Out-File -FilePath $txtFilename -Encoding UTF8
}

# Main script
$registryPrograms = Get-InstalledProgramsFromRegistry
$userRegistryPrograms = Get-InstalledProgramsFromUserRegistry
$wmicPrograms = Get-InstalledProgramsWithWmic
$uwpPrograms = Get-InstalledUwpApps
$allPrograms = Merge-AndRemoveDuplicates -programs1 $registryPrograms -programs2 $userRegistryPrograms -programs3 $wmicPrograms -programs4 $uwpPrograms
$txtFilename = "installed_programs.txt"
$csvFilename = "installed_programs.csv"

Export-ToTxt -programs $allPrograms -txtFilename $txtFilename

Write-Host "Exported $($allPrograms.Count) unique installed programs to $txtFilename and $csvFilename."
