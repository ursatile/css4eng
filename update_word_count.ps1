git add .
git commit -m "Snapshot of everything before running update_word_count.ps1"
$totalWordCount = 0
Get-ChildItem -Path . -Filter *.md | ForEach-Object {
	$file = $_.FullName
	$content = Get-Content $file -Raw
	if ($content -match "(?s)^---\s*(.*?)\s*---\s*(.*)") {
		$frontMatter = $matches[1]
		$body = $matches[2]
		$wordCount = ($body -split '\s+') 
			| Where-Object { $_ -match '\w' } 
			| Measure-Object 
			| Select-Object -ExpandProperty Count

		if ($frontMatter -match "word_count:\s*\d+") {
			$newFrontMatter = $frontMatter -replace "word_count:\s*\d+", "word_count: $wordCount"
		} else {
			$newFrontMatter = $frontMatter + "`nword_count: $wordCount"
		}
		$totalWordCount += $wordCount
		$newContent = "---`r`n$newFrontMatter`r`n---`r`n$body"
		Set-Content -NoNewline -Path $file -Value $newContent
		Write-Host "Updated word count for $($_.Name)"
	} else {
		Write-Host "No front matter found in $($_.Name)"
	}
}

Write-Host "Total word count: $totalWordCount"
Write-Host "Total duration: $($totalWordCount / 200) minutes"

git add .
git commit -m "Word count: $totalWordCount"


