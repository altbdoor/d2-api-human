. ".\util.ps1"

Write-Output 'Loading weapons JSON file...'
$weapons = Get-Content 'source/weapons.json' | ConvertFrom-Json

Write-Output 'Loading other JSON files...'
$sunsetPowercapData = Get-Content 'source/sunset.json' | ConvertFrom-Json
$statsData = Get-Content 'source/stats.json' | ConvertFrom-Json
$statGroupsData = Get-Content 'source/statgroups.json' | ConvertFrom-Json
$socketsData = Get-Content 'source/sockets.json' | ConvertFrom-Json
$plugsetsData = Get-Content 'source/plugsets.json' | ConvertFrom-Json

Write-Output 'Mapping into objects...'
$remappedWeapons = $weapons | ForEach-Object {
    [ordered]@{
        id            = $_.hash;
        name          = $_.displayProperties.name;
        icon          = $_.displayProperties.icon;
        watermark     = $_.quality.displayVersionWatermarkIcons[0];
        screenshot    = $_.screenshot;
        flavor_text   = $_.flavorText;
        weapon_tier   = $_.inventory.tierTypeName.ToLower();
        ammo_type     = Get-AmmoType -Key $_.equippingBlock.ammoType;
        element_class = Get-ElementClass -Key $_.damageTypes[0];
        weapon_type   = Get-WeaponType -TraitIds $_.traitIds;
        powercap      = $sunsetPowercapData.($_.quality.versions[0].powerCapHash);
        stats         = Get-Stats -WeaponStats $_.stats.stats -StatsData $statsData -VisibleStatHashes $statGroupsData.($_.stats.statGroupHash);
        frame         = Get-Frame -SocketsData $socketsData -Entries $_.sockets.socketEntries;
        perks         = Get-Perks -SocketsData $socketsData -PlugsetsData $plugsetsData -Entries $_.sockets.socketEntries;
    }
}

Write-Output 'Writing into JSON files...'
mkdir -Force -Path 'dist/weapons'
Copy-Item 'source/version.txt' 'dist/'

foreach ($weapon in $remappedWeapons) {
    $weapon | ConvertTo-Json -Compress -Depth 100 | Out-File "dist/weapons/$($weapon.id).json"
}
$remappedWeapons | ConvertTo-Json -Compress -Depth 100 | Out-File 'dist/weapons/all.json'

Write-Output 'Done!'
