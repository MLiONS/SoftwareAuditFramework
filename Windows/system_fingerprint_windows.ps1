$outputFile = "system_info.txt"

# Function to write a section header to the output file
function Write-SectionHeader {
    param(
        [string]$header
    )
    Add-Content -Path $outputFile -Value ("`n$header`n" + ("=" * 60) + "`n")
}

# Function to write key-value pair to the output file
function Write-KeyValuePair {
    param(
        [string]$key,
        [string]$value
    )
    Add-Content -Path $outputFile -Value ("${key}: ${value}`n")
}

# Clear the output file
Remove-Item $outputFile -ErrorAction Ignore

# Basic System Information
Write-SectionHeader "Basic System Information"
Write-KeyValuePair "Hostname" (hostname)
Write-KeyValuePair "Operating System" ((Get-CimInstance -ClassName Win32_OperatingSystem).Caption)
Write-KeyValuePair "OS Version" ((Get-CimInstance -ClassName Win32_OperatingSystem).Version)
Write-KeyValuePair "Architecture" ((Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture)

# UUID
Write-SectionHeader "UUID"
Write-KeyValuePair "UUID" ((Get-CimInstance -ClassName Win32_ComputerSystemProduct).UUID)

# Laptop or Desktop
Write-SectionHeader "Type"
$laptopTypes = @("Notebook", "SubNotebook", "Portable", "Laptop", "Hand Held")
$systemEnclosure = Get-CimInstance -ClassName Win32_SystemEnclosure
$chassisType = if ($systemEnclosure.ChassisTypes) { $systemEnclosure.ChassisTypes[0] } else { 0 }

switch ($chassisType) {
    8 { $chassisDescription = "Laptop" }
    9 { $chassisDescription = "Portable" }
    10 { $chassisDescription = "Notebook" }
    12 { $chassisDescription = "Docking Station" }
    14 { $chassisDescription = "SubNotebook" }
    30 { $chassisDescription = "Tablet" }
    default { $chassisDescription = "Unknown" }
}

Write-KeyValuePair "Type" $chassisDescription

# Boot ID (not directly available in Windows, using System Boot Time as an alternative)
Write-SectionHeader "Boot ID"
Write-KeyValuePair "Boot Time" ((Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime)

# BIOS Information
Write-SectionHeader "BIOS Information"
$biosInfo = Get-CimInstance -ClassName Win32_BIOS
Write-KeyValuePair "SMBIOS BIOS Version" $biosInfo.SMBIOSBIOSVersion
Write-KeyValuePair "Manufacturer" $biosInfo.Manufacturer
Write-KeyValuePair "Name" $biosInfo.Name
Write-KeyValuePair "Version" $biosInfo.Version
Write-KeyValuePair "Release Date" $biosInfo.ReleaseDate

# RAM Information
Write-SectionHeader "RAM Information"
$ramInfo = Get-CimInstance -ClassName Win32_PhysicalMemory
foreach ($ram in $ramInfo) {
    Write-KeyValuePair "Capacity" ($ram.Capacity / 1GB -as [int])" GB"
    Write-KeyValuePair "Manufacturer" $ram.Manufacturer
    Write-KeyValuePair "Speed" $ram.Speed
    Write-KeyValuePair "Part Number" $ram.PartNumber
    Write-KeyValuePair "Serial Number" $ram.SerialNumber
}

# Disk Information
Write-SectionHeader "Disk Information"
$diskInfo = Get-CimInstance -ClassName Win32_DiskDrive
foreach ($disk in $diskInfo) {
    Write-KeyValuePair "Model" $disk.Model
    Write-KeyValuePair "Serial Number" $disk.SerialNumber
    Write-KeyValuePair "Size" ($disk.Size / 1GB -as [int])" GB"
}

Write-SectionHeader "Partition Information"
$partitions = Get-Partition
foreach ($partition in $partitions) {
    Write-KeyValuePair "Disk Number" $partition.DiskNumber
    Write-KeyValuePair "Partition Number" $partition.PartitionNumber
    Write-KeyValuePair "Drive Letter" $partition.DriveLetter
    Write-KeyValuePair "Size" ($partition.Size / 1GB -as [int])" GB"
    Write-KeyValuePair "Type" $partition.PartitionType
}

Write-SectionHeader "Volume Information"
$volumes = Get-Volume
foreach ($volume in $volumes) {
    Write-KeyValuePair "Drive Letter" $volume.DriveLetter
    Write-KeyValuePair "File System" $volume.FileSystem
    Write-KeyValuePair "Size" ($volume.Size / 1GB -as [int])" GB"
    Write-KeyValuePair "Free Space" ($volume.SizeRemaining / 1GB -as [int])" GB"
}

# Network Information
Write-SectionHeader "Network Information"
$netAdapters = Get-NetAdapter
foreach ($adapter in $netAdapters) {
    Write-KeyValuePair "Name" $adapter.Name
    Write-KeyValuePair "Description" $adapter.InterfaceDescription
    Write-KeyValuePair "MAC Address" $adapter.MacAddress
    Write-KeyValuePair "Status" $adapter.Status
}

Write-SectionHeader "IP Address Information"
$ipAddresses = Get-NetIPAddress
foreach ($ip in $ipAddresses) {
    Write-KeyValuePair "Interface Alias" $ip.InterfaceAlias
    Write-KeyValuePair "IPAddress" $ip.IPAddress
    Write-KeyValuePair "Address Family" $ip.AddressFamily
    Write-KeyValuePair "Type" $ip.Type
    Write-KeyValuePair "Prefix Length" $ip.PrefixLength
}

Write-SectionHeader "IP Configuration Information"
$ipConfig = Get-NetIPConfiguration
foreach ($config in $ipConfig) {
    Write-KeyValuePair "Interface Alias" $config.InterfaceAlias
    Write-KeyValuePair "IPv4 Address" $config.IPv4Address.IPAddress
    Write-KeyValuePair "IPv6 Address" $config.IPv6Address.IPAddress
    Write-KeyValuePair "Subnet Mask" $config.IPv4Address.PrefixLength
    Write-KeyValuePair "Default Gateway" $config.Ipv4DefaultGateway
    Write-KeyValuePair "DNSServer" ($config.DNSServer | Out-String).Trim()
}

Write-SectionHeader "IP Route Information"
$routes = Get-NetRoute
foreach ($route in $routes) {
    Write-KeyValuePair "Destination" $route.DestinationPrefix
    Write-KeyValuePair "Next Hop" $route.NextHop
    Write-KeyValuePair "Route Metric" $route.RouteMetric
}

Write-SectionHeader "Open Ports and Services - TCP Connections"
$tcpConnections = Get-NetTCPConnection
foreach ($tcp in $tcpConnections) {
    Add-Content -Path $outputFile -Value "Local Address: $($tcp.LocalAddress), Local Port: $($tcp.LocalPort), Remote Address: $($tcp.RemoteAddress), Remote Port: $($tcp.RemotePort), State: $($tcp.State)"
}

Write-SectionHeader "Open Ports and Services - UDP Endpoints"
$udpEndpoints = Get-NetUDPEndpoint
foreach ($udp in $udpEndpoints) {
    Add-Content -Path $outputFile -Value "Local Address: $($udp.LocalAddress), Local Port: $($udp.LocalPort)"
}

# User and Group Information
Write-SectionHeader "Local Users"
$localUsers = Get-LocalUser
foreach ($user in $localUsers) {
    Write-KeyValuePair "Name" $user.Name
    Write-KeyValuePair "Full Name" $user.FullName
    Write-KeyValuePair "Enabled" $user.Enabled
}

Write-SectionHeader "Local Groups"
$localGroups = Get-LocalGroup
foreach ($group in $localGroups) {
    Write-KeyValuePair "Name" $group.Name
    Write-KeyValuePair "Description" $group.Description
}

# Scheduled Tasks
Write-SectionHeader "Scheduled Tasks"
$scheduledTasks = Get-ScheduledTask
foreach ($task in $scheduledTasks) {
    Write-KeyValuePair "Task Name" $task.TaskName
    Write-KeyValuePair "Task Path" $task.TaskPath
}

# OS Installation Date
Write-SectionHeader "OS Installation Date"
$osInstallDate = (Get-CimInstance -ClassName Win32_OperatingSystem).InstallDate
Write-KeyValuePair "OS Installation Date" $osInstallDate

Write-Host "Script executed successfully. Output saved to: $outputFile"

