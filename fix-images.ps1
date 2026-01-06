# Set the root directory (adjust if needed)
$root = "d:\Obsidian\Dylan's Obsidian Vault\css4eng"

# Output CMD script file
$cmdScript = Join-Path $root "move_images.cmd"
"" | Set-Content $cmdScript  # Clear or create the file

# Get all .md files recursively
$mdFiles = Get-ChildItem -Path $root -Recurse -Filter *.md

foreach ($mdFile in $mdFiles) {
	$content = Get-Content $mdFile.FullName -Raw
	if (![string]::IsNullOrWhiteSpace($content)) {
		# Regex to match image references: ![alt](images/foo.png) or ![alt](/images/foo.png)
		$matches = [regex]::Matches($content, '!\[[^\]]*\]\((\/?images\/[^)]+)\)', 'IgnoreCase')
		foreach ($match in $matches) {
			$imgPath = $match.Groups[1].Value
			# Remove leading slash if present
			$imgPathRel = $imgPath.TrimStart('/')
			$srcImage = Join-Path $root $imgPathRel
			$mdDir = Split-Path $mdFile.FullName -Parent
			$destDir = Join-Path $mdDir "images"
			$imgName = Split-Path $imgPathRel -Leaf
			$destImage = Join-Path $destDir $imgName
			# Output the move command to the CMD script
			$moveCmd = "move `"$srcImage`" `"$destImage`""
			Add-Content -Path $cmdScript -Value $moveCmd
		}
	}
}


Write-Host "CMD script with move commands written to $cmdScript"
