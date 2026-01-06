# Resolve conflicts inside _site folder only
$Root = "d:\Obsidian\Dylan's Obsidian Vault\css4eng\_site"
$exts = '*.md','*.html','*.ps1'
$files = Get-ChildItem -Path $Root -Recurse -File -Include $exts

$fixed = @()
foreach ($file in $files) {
    try {
        $text = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        if ($text -notmatch '<<<<<<<') { continue }

        $origPath = "$($file.FullName).orig"
        if (-not (Test-Path $origPath)) { Copy-Item -Path $file.FullName -Destination $origPath }
        else { $t = Get-Date -UFormat %s; Copy-Item -Path $file.FullName -Destination "${origPath}.${t}" }

        $pattern = '(?ms)^<<<<<<< .*?^=======\r?\n(.*?)^>>>>>>> .*?$'
        $new = [System.Text.RegularExpressions.Regex]::Replace($text, $pattern, '$1')
        $iter = 0
        while ($new -match '<<<<<<<' -and $iter -lt 10) {
            $new = [System.Text.RegularExpressions.Regex]::Replace($new, $pattern, '$1')
            $iter++
        }
        if ($new -match '<<<<<<<') {
            Write-Warning "Leftover markers in $($file.FullName); skipping"
            continue
        }
        Set-Content -Path $file.FullName -Value $new -Encoding UTF8
        Write-Host "Fixed: $($file.FullName)"
        $fixed += $file.FullName
    } catch {
        Write-Warning "Error processing $($file.FullName): $_"
    }
}

Write-Host "\nSummary: Fixed $($fixed.Count) files"
$fixed | ForEach-Object { Write-Host " - $_" }
