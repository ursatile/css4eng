git add .
git commit -m "Snapshot of everything before running update.ps1"

$oldPartNumber = 0

Get-ChildItem -Path . -Filter *.md | Sort-Object Name | ForEach-Object {
	$oldFilename = $_.BaseName
	if ($oldFilename -match '^(\d)(\d+)[a-z]?-(.*)$') {
		$newPartNumber = $matches[1]
		if ($newPartNumber -eq $oldPartNumber) {
			$newSectionNumber = $newSectionNumber + 1
		}
		else {
			$oldPartNumber = $newPartNumber
			$newSectionNumber = 1
		}
		$title = $matches[3]
		$newFileName = "{0}{1:00}-$title" -f [int]$newPartNumber, [int]$newSectionNumber
		Rename-Item -Path "$oldFilename.md" -NewName "$newFileName.md"
		Write-Host "$oldFileName.md > $newFileName"
		if (Test-Path "examples\$oldFilename") {
			Write-Host "examples\$oldFilename > examples\$newFileName"
			if ($oldFilename -ne $newFileName) {
				Rename-Item -Path "examples\$oldFilename" -NewName $newFileName
			}
		}
	}
 else {
		Write-Host "Filename does not match expected pattern: $($_.Name)"
	}
}

Get-ChildItem -Path . -Filter *.md | ForEach-Object {
	if ($_.Name -match '^(\d+)-(.*)$') {
		$filePath = $_.FullName
		$baseName = $_.BaseName
		$navOrder = $matches[1]
		$content = Get-Content $filePath -Raw
		if ($content -match "(?s)^---\s*(.*?)\s*---\s*(.*)") {
			$frontMatter = $matches[1]
			$body = $matches[2]
			if ($frontMatter -match "nav_order:\s*\d+") {
				$newFrontMatter = $frontMatter -replace "nav_order:\s*\d+", "nav_order: $navOrder"
			}
			else {
				$newFrontMatter = $frontMatter + "`nav_order: $navOrder"
			}
			if ($newFrontMatter -match "examples: [^ ]+") {
				$newFrontMatter = $newFrontMatter -replace "examples: [^ ]+$", "examples: examples/$baseName"
			}
			else {
				$newFrontMatter = $newFrontMatter + "`nexamples: examples/$baseName"
			}
#			Write-Host "========================================================"
#			Write-Host $newFrontMatter

			$newContent = "---`r`n$newFrontMatter`r`n---`r`n$body"
			Set-Content -NoNewline -Path $filePath -Value $newContent
			Write-Host "Updated nav_order for $baseName to $navOrder"
			Write-Host "Updated examples for $baseName to examples/$baseName"
		}
		else {
			Write-Host "No front matter found in $($_.Name)"
		}
	}
}


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
		# Write-Host "Updated word count for $($_.Name)"
	} else {
		# Write-Host "No front matter found in $($_.Name)"
	}
}

Write-Host "Total word count: $totalWordCount"
Write-Host "Total duration: $($totalWordCount / 200) minutes"

# Capture progress data for chart
$progressFile = "progress_data.json"
$currentDateTime = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"

# Read existing data or create empty array
if (Test-Path $progressFile) {
    try {
        $progressData = Get-Content $progressFile | ConvertFrom-Json
        # Ensure it's an array
        if ($progressData -isnot [array]) {
            $progressData = @($progressData)
        }
    } catch {
        $progressData = @()
    }
} else {
    $progressData = @()
}

# Add new data point only if word count has changed
$shouldAddDataPoint = $true
if ($progressData.Count -gt 0) {
    $lastEntry = $progressData[-1]
    if ($lastEntry.wordCount -eq $totalWordCount) {
        $shouldAddDataPoint = $false
        Write-Host "Word count unchanged ($totalWordCount), skipping progress data update"
    }
}

if ($shouldAddDataPoint) {
    $newDataPoint = [PSCustomObject]@{
        datetime = $currentDateTime
        wordCount = $totalWordCount
    }
    
    $progressData += $newDataPoint
    
    # Save updated data
    $progressData | ConvertTo-Json | Set-Content $progressFile
    Write-Host "Progress data saved to $progressFile"
} else {
    Write-Host "Progress data not updated (no change in word count)"
}

git add .
git commit -m "Word count: $totalWordCount"


