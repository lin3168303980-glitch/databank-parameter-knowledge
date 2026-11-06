param(
    [string]$RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'
$sourcePath = Join-Path $RepositoryRoot 'competitor-public-codes.csv'
$brandSourcePath = Join-Path $RepositoryRoot 'sources/brand-id-master.tsv'
$outputPath = Join-Path $RepositoryRoot 'data/competitor-public-pools.json'
$brandOutputPath = Join-Path $RepositoryRoot 'data/brand-ids.json'
$outputDirectory = Split-Path -Parent $outputPath
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

function Convert-JsonValue([string]$Value) {
    if ([string]::IsNullOrWhiteSpace($Value)) { return $null }
    try { return ConvertFrom-Json -InputObject $Value }
    catch { return $Value }
}

function Split-Codes([string]$Value) {
    if ([string]::IsNullOrWhiteSpace($Value)) { return @() }
    return @($Value -split '[;,]' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

$sourceRows = Import-Csv -LiteralPath $sourcePath
$records = foreach ($row in $sourceRows) {
    [ordered]@{
        sourceIndex = [int]$row.index
        sourceCrowdName = $row.sourceName
        sourceCrowdId = $row.sourceCrowdId
        poolArrayIndex = [int]$row.poolArrayIndex
        selectionLv1 = @(Split-Codes ($row.publicField -replace '/', ';'))
        brandIds = @(Split-Codes $row.brandIds)
        behavior = $row.behavior
        dateType = $row.dateType
        dateValue = Convert-JsonValue $row.dateValue
        category = $row.category
        leafCategories = @(Split-Codes $row.leafCategory)
        itemIds = @(Split-Codes $row.itemIds)
        extraFilters = Convert-JsonValue $row.extraFilters
        labelsFile = $row.labelsFile
    }
}

$document = [ordered]@{
    schemaVersion = '1.0.0'
    sourceArchive = 'source-archives/DataBank竞品公域参数沉淀_20261104.zip'
    recordCount = @($records).Count
    records = @($records)
}

$json = $document | ConvertTo-Json -Depth 100
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.UTF8Encoding]::new($false))
Write-Output "Wrote $(@($records).Count) records to $outputPath"

$brandLines = Get-Content -LiteralPath $brandSourcePath -Encoding UTF8
$brandRows = @($brandLines | Select-Object -Skip 1 | ConvertFrom-Csv -Delimiter "`t" -Header @('brandName', 'brandId'))
$brands = foreach ($row in $brandRows) {
    [ordered]@{ name = $row.brandName; id = [string]$row.brandId }
}
$brandDocument = [ordered]@{
    schemaVersion = '1.0.0'
    sourceFile = 'sources/brand-id-master.tsv'
    recordCount = @($brands).Count
    brands = @($brands)
}
$brandJson = $brandDocument | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($brandOutputPath, $brandJson, [System.Text.UTF8Encoding]::new($false))
Write-Output "Wrote $(@($brands).Count) brand IDs to $brandOutputPath"
