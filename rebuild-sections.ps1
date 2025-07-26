# git add .
# git commit -m "Snapshot of everything before running rebuild-sections.ps1"

$oldPartNumber = 0

Get-ChildItem -Path . -Filter *.md | Sort-Object Name | ForEach-Object {
	$oldFilename = $_.BaseName
	if ($oldFilename -match '^(\d+)-(\d+)[a-z]?-(.*)$') {
		$newPartNumber = $matches[1]
		if ($newPartNumber -eq $oldPartNumber) {
			$newSectionNumber = $newSectionNumber + 1
		} else {
			$oldPartNumber = $newPartNumber
			$newSectionNumber = 1
		}
		$title = $matches[3]
		$newFileName = "{0}{1:00}-$title.md" -f [int]$newPartNumber, [int]$newSectionNumber
		Rename-Item -Path "$oldFilename.md" -NewName $newFileName

		if (Test-Path "examples\$oldFilename") {
			Rename-Item -Path "examples\$oldFilename" -NewName "examples\$newFileName" -Force
		}
		Write-Host "$oldFileName.md > $newFileName"
	} else {
		Write-Host "Filename does not match expected pattern: $($_.Name)"
	}
}