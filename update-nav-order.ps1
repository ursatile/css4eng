Get-ChildItem -Path . -Filter *.md | ForEach-Object {
	$file = $_.FullName
	if ($file -match '^(\d+)-(.*)$') {
		$navOrder = $matches[1]
		$content = Get-Content $file -Raw
		Write-Host $content
		if ($content -match "(?s)^---\s*(.*?)\s*---\s*(.*)") {
			$frontMatter = $matches[1]
			$body = $matches[2]
			if ($frontMatter -match "nav_order:\s*\d+") {
				$newFrontMatter = $frontMatter -replace "nav_order:\s*\d+", "nav_order: $navOrder"
			}	else {
				$newFrontMatter = $frontMatter + "`nav_order: $navOrder"
			}
			$newContent = "---`r`n$newFrontMatter`r`n---`r`n$body"
			Set-Content -NoNewline -Path $file -Value $newContent
			Write-Host "Updated nav_order for $file to $navOrder"
		}	else {
			Write-Host "No front matter found in $($_.Name)"
		}
	}
}