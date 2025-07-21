Get-ChildItem -Filter *.md | ForEach-Object {
    $filePath = $_.FullName
    $content = Get-Content $filePath -Raw

    if ($content -match '^---\s*\r?\n(.*?\r?\n?)^---\s*\r?\n' -s) {
        $frontMatter = $matches[1]
        $startOfContent = $matches[0].Length
        $body = $content.Substring($startOfContent)

        # Count words (ignore markdown syntax)
        $plainText = $body -replace '\[.*?\]\(.*?\)', '' -replace '[^a-zA-Z0-9\s]', ''
        $wordCount = ($plainText -split '\s+').Where({ $_ -ne '' }).Count

        # Update or insert word_count in front matter
        if ($frontMatter -match '(^|\n)word_count:.*') {
            $newFrontMatter = $frontMatter -replace '(^|\n)word_count:.*', "`$1word_count: $wordCount"
        } else {
            $newFrontMatter = "$frontMatter`nword_count: $wordCount"
        }

        # Reconstruct the file
        $newContent = "---`n$newFrontMatter`n---`n$body"

        # Write it back
        Set-Content -Path $filePath -Value $newContent -Encoding UTF8
        Write-Host "Updated $($_.Name): $wordCount words"
    } else {
        Write-Host "Skipped $($_.Name): no front matter found"
    }
}
