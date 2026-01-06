# Resolve merge conflicts by keeping the "incoming" side (between ======= and >>>>>>>)
# Skips the _site and .git directories.

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$skipPattern = '\\_site\\|\\.git\\|\\node_modules\\|\\gems\\'
$exts = '*.md','*.markdown','*.html'

$files = Get-ChildItem -Path $Root -Recurse -File -Include $exts | Where-Object { $_.FullName -notmatch $skipPattern }

Write-Host "Scanning $($files.Count) files..."

$fixed = @()
foreach ($file in $files) {
    try {
        $text = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        if ($text -notmatch '<<<<<<<') { continue }

        $origPath = "$($file.FullName).orig"
        if (-not (Test-Path $origPath)) { Copy-Item -Path $file.FullName -Destination $origPath }
        else {
            # keep rotating backups
            $t = Get-Date -UFormat %s
            Copy-Item -Path $file.FullName -Destination "${origPath}.${t}"
        }

        # pattern matches from <<<<<<< ... up to >>>>>>> including newlines, captures incoming part
        $pattern = '(?ms)^<<<<<<< .*?^=======\r?\n(.*?)^>>>>>>> .*?$'
        $new = [System.Text.RegularExpressions.Regex]::Replace($text, $pattern, '$1')

        # if still have markers, try again until none left or max iterations
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
