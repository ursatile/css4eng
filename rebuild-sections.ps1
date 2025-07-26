$oldPartNumber = 0

Get-ChildItem -Path . -Filter *.md | Sort-Object Name | ForEach-Object {
	$oldFilename = $_.BaseName
	if ($oldFilename -match '^(\d+)-(\d+)[a-z]?-(.*)$') {
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
			Rename-Item -Path "examples\$oldFilename" -NewName $newFileName
		}
	}
 else {
		Write-Host "Filename does not match expected pattern: $($_.Name)"
	}
}