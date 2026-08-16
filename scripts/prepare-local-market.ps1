param(
    [string]$OutputDirectory = (Join-Path (Split-Path -Parent $PSScriptRoot) "dist-local-market")
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content -LiteralPath (Join-Path $repoRoot "secagent-plugin.json") -Raw | ConvertFrom-Json
$version = $manifest.version
$stageDirectory = Join-Path $OutputDirectory ".package"
$archivePath = Join-Path $OutputDirectory "iccce-connector-$version.zip"
$indexPath = Join-Path $OutputDirectory "index.json"

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
if (Test-Path -LiteralPath $stageDirectory) { Remove-Item -LiteralPath $stageDirectory -Recurse -Force }
New-Item -ItemType Directory -Path $stageDirectory | Out-Null

Copy-Item -Force (Join-Path $repoRoot "main.mjs"), (Join-Path $repoRoot "secagent-plugin.json"), (Join-Path $repoRoot "icon.svg"), (Join-Path $repoRoot "README.md") -Destination $stageDirectory
Copy-Item -Force (Join-Path $repoRoot "skills") -Destination $stageDirectory -Recurse
Compress-Archive -Path (Join-Path $stageDirectory "*") -DestinationPath $archivePath -Force
Remove-Item -LiteralPath $stageDirectory -Recurse -Force

$sha256 = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash
$index = [ordered]@{
    schemaVersion = 1
    generatedAt = (Get-Date).ToUniversalTime().ToString("o")
    plugins = @(
        [ordered]@{
            id = "iccce-connector"
            name = "ICC-CE 联动"
            description = "让 SecAgent 读取画板内容或向画板插入内容"
            repository = "https://github.com/SECTL/ICC-CE-SecAgent-Connector"
            icon = "https://raw.githubusercontent.com/SECTL/ICC-CE-SecAgent-Connector/main/icon.svg"
            versions = @(
                [ordered]@{
                    version = $version
                    minHostApiVersion = 1
                    assetUrl = "http://127.0.0.1:42190/iccce-connector-$version.zip"
                    sha256 = $sha256
                    permissions = @("agent.tools", "agent.skills", "network.http")
                    platforms = @("win32")
                }
            )
        }
    )
}
$index | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $indexPath -Encoding utf8

Write-Host "Created $archivePath"
Write-Host "SHA256: $sha256"
Write-Host "Created $indexPath"
