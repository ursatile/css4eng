# Extract historical word count data from git commits
$progressFile = "progress_data.json"

# Get git log data for commits with "Word count:" in message
$gitLog = git log --grep="Word count:" --pretty=format:"%H|%ai|%s"

# Parse the git log output
$progressData = @()

foreach ($line in $gitLog) {
    if ($line -match "^([a-f0-9]+)\|(.+)\|Word count: (\d+)$") {
        $commitHash = $matches[1]
        $timestamp = $matches[2]
        $wordCount = [int]$matches[3]
        
        # Convert timestamp to ISO format
        $dateTime = [DateTime]::Parse($timestamp)
        $isoDateTime = $dateTime.ToString("yyyy-MM-ddTHH:mm:ss")
        
        $dataPoint = [PSCustomObject]@{
            datetime = $isoDateTime
            wordCount = $wordCount
            commitHash = $commitHash
        }
        
        $progressData += $dataPoint
    }
}

# Sort by datetime (oldest first)
$progressData = $progressData | Sort-Object datetime

# Remove duplicate entries (keep the earliest commit for each word count)
$uniqueData = @()
$lastWordCount = -1
foreach ($item in $progressData) {
    if ($item.wordCount -ne $lastWordCount) {
        # Remove commitHash from final data (optional, for cleaner JSON)
        $cleanItem = [PSCustomObject]@{
            datetime = $item.datetime
            wordCount = $item.wordCount
        }
        $uniqueData += $cleanItem
        $lastWordCount = $item.wordCount
    }
}

# Save to JSON file
$uniqueData | ConvertTo-Json | Set-Content $progressFile

Write-Host "Extracted $($uniqueData.Count) unique progress data points from git history"
Write-Host "Data saved to $progressFile"

# Display the data
Write-Host "`nProgress Data:"
$uniqueData | Format-Table -AutoSize
