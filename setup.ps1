New-Item -ItemType Directory -Force -Path 'source'
Set-Location 'source'

$baseUrl = 'https://www.bungie.net'

# ========================================
# manifest
# ========================================
$response = Invoke-WebRequest "${baseUrl}/Platform/Destiny2/Manifest/" `
    -Headers @{ 'X-API-Key' = '' }

$manifest = ($response.Content | ConvertFrom-Json -AsHashtable).Response

# ========================================
# version
# ========================================
$manifest.version > version.txt

# ========================================
# sunset powercap
# ========================================
$url = $manifest.jsonWorldComponentContentPaths.en.DestinyPowerCapDefinition
$response = Invoke-WebRequest ("${baseUrl}${url}") `
    -Headers @{ 'Accept-Encoding' = 'gzip' }

$powercapData = $response.Content | ConvertFrom-Json -AsHashtable

$sunsetPowercap = @{}
foreach ($cap in $powercapData.Values | Where-Object { $_.powerCap -lt 900000 }) {
    $sunsetPowercap[[string]$cap.hash] = $cap.powerCap;
}

$sunsetPowercap | ConvertTo-Json -depth 100 | Out-File sunset.json

# ========================================
# stats
# ========================================
$url = $manifest.jsonWorldComponentContentPaths.en.DestinyStatDefinition
$response = Invoke-WebRequest ("${baseUrl}${url}") `
    -Headers @{ 'Accept-Encoding' = 'gzip' }

$statsData = $response.Content | ConvertFrom-Json -AsHashtable

$remappedStats = @{}
foreach ($stat in $statsData.Values) {
    $name = $stat.displayProperties.name.ToLower().Replace(' ', '_');
    if ($name -ne '') {
        $remappedStats[$name] = $stat.hash
        $remappedStats[[string]$stat.hash] = $name
    }
}

$remappedStats | ConvertTo-Json -depth 100 | Out-File stats.json

# ========================================
# stat group
# ========================================
$url = $manifest.jsonWorldComponentContentPaths.en.DestinyStatGroupDefinition
$response = Invoke-WebRequest ("${baseUrl}${url}") `
    -Headers @{ 'Accept-Encoding' = 'gzip' }

$groupData = $response.Content | ConvertFrom-Json -AsHashtable

$remappedGroup = @{}
foreach ($group in $groupData.Values) {
    $remappedGroup[[string]$group.hash] = $group.scaledStats | ForEach-Object { $_.statHash }
}

$remappedGroup | ConvertTo-Json -depth 100 | Out-File statgroups.json

# ========================================
# weapons
# ========================================
$url = $manifest.jsonWorldComponentContentPaths.en.DestinyInventoryItemDefinition
$response = Invoke-WebRequest ("${baseUrl}${url}") `
    -Headers @{ 'Accept-Encoding' = 'gzip' }

$items = $response.Content | ConvertFrom-Json -AsHashtable
$items.Values | Where-Object {
    $_.itemCategoryHashes -contains 1 `
        -and $_.itemCategoryHashes -notcontains 3109687656
} | `
    ConvertTo-Json -depth 100 | `
    Out-File weapons.json

# ========================================
# sockets
# ========================================
$sockets = $items.Values | Where-Object {
    $_.itemCategoryHashes -contains 610365472 `
        -and $_.itemCategoryHashes -notcontains 3124752623 `
        -and $_.displayProperties.name -ne 'Empty Mod Socket'
}

$remappedSockets = @{}
foreach ($socket in $sockets) {
    $socketStats = @{}

    if ($null -ne $socket.investmentStats) {
        $socket.investmentStats | Where-Object { $_.value -ne 0 -and $remappedStats.([string]$_.statTypeHash) -ne $null } | `
            Foreach-Object { $socketStats[$remappedStats.([string]$_.statTypeHash)] = $_.value }
    }

    $remappedSockets[[string]$socket.hash] = @{
        name        = $socket.displayProperties.name;
        description = $socket.displayProperties.description;
        icon        = $socket.displayProperties.icon;
        stats       = $socketStats;
    }
}

$remappedSockets | ConvertTo-Json -depth 100 | Out-File sockets.json

# ========================================
# plugsets
# ========================================
$url = $manifest.jsonWorldComponentContentPaths.en.DestinyPlugSetDefinition
$response = Invoke-WebRequest ("${baseUrl}${url}") `
    -Headers @{ 'Accept-Encoding' = 'gzip' } `

$plugsets = $response.Content | ConvertFrom-Json -AsHashtable

$remappedPlugsets = @{}
foreach ($plug in $plugsets.Values) {
    $value = $plug.reusablePlugItems | `
        Where-Object { $_.currentlyCanRoll -eq $true } | `
        ForEach-Object { $_.plugItemHash }

    $remappedPlugsets[[string]$plug.hash] = @($value)
}

$remappedPlugsets | ConvertTo-Json -depth 100 | Out-File plugsets.json
