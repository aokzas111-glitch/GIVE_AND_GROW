param([string]$Root = $PSScriptRoot)
$ErrorActionPreference = 'Stop'
function Get-AssetFolder([string]$Name,[string]$Extension) {
    if ($Name -match '^location-') { return 'assets/backgrounds/locations' }
    if ($Name -match '^(river-fishing-scene|mini-pond-background)') { return 'assets/backgrounds/scenes' }
    if ($Name -match '^holo-(warning|laser)') { return 'assets/effects/holo-water' }
    if ($Name -match '^ancient-') { return 'assets/fish/ancient-cave' }
    if ($Name -match '^holo-') { return 'assets/fish/holo-water' }
    if ($Name -match '^(give-and-grow-reference|transparent-preview)') { return 'assets/design-reference' }
    if ($Name -match '^(game|register|share)\.png$') { return 'assets/ui' }
    if ($Name -match '^(music-|gone-fishing)') { return 'assets/audio/music' }
    if ($Name -match '^abyss-black-(hammer|slash)') { return 'assets/effects/abyss' }
    if ($Name -match '^(boss-mouth|boss-face-mouth|boss-blood-slash)') { return 'assets/effects/polluted-lake' }
    if ($Name -match '^boss-crocodile') { return 'assets/fish/canal' }
    if ($Name -match '^boss-(fire-shark|frost-serpent)') { return 'assets/fish/sea' }
    if ($Name -match '^boss-(arian|ground|sea)-dragon|^legend-') { return 'assets/fish/magic-river' }
    if ($Name -match '^(boss-face|boss-blood|polluted-)') { return 'assets/fish/polluted-lake' }
    if ($Name -match '^abyss-') { return 'assets/fish/abyss-sea' }
    if ($Extension -in '.png','.jpg','.jpeg','.webp','.gif') { return 'assets/unclassified/images' }
    if ($Extension -in '.mp3','.wav','.ogg','.m4a') { return 'assets/unclassified/audio' }
    return $null
}
$media = Get-ChildItem -LiteralPath $Root -File | Where-Object { $_.Extension.ToLowerInvariant() -in '.png','.jpg','.jpeg','.webp','.gif','.mp3','.wav','.ogg','.m4a' }
foreach ($file in $media) {
    $folder = Get-AssetFolder $file.Name $file.Extension.ToLowerInvariant()
    if (-not $folder) { continue }
    $targetFolder = Join-Path $Root ($folder -replace '/', '\')
    New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
    $target = Join-Path $targetFolder $file.Name
    if (Test-Path -LiteralPath $target) {
        $stem = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        $ext = $file.Extension
        $n = 2
        do { $target = Join-Path $targetFolder ("$stem-$n$ext"); $n++ } while (Test-Path -LiteralPath $target)
    }
    Move-Item -LiteralPath $file.FullName -Destination $target
}
Write-Output "จัดไฟล์สื่อเรียบร้อย: ย้าย $($media.Count) ไฟล์"
