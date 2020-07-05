$ccleanerWebsiteUrl = "https://www.ccleaner.com/de-de/ccleaner/builds"
$outputDirectory = "C:\Tools\"

# Parsing Website
echo "Parsing Website now!"
$CcleanerWebsite = Invoke-WebRequest -uri $ccleanerWebsiteUrl -UseBasicParsing

# Search for downlaod link
echo "Searching for download link now!"
$lastIndexOfZip = $CcleanerWebsite.rawcontent.LastIndexOf(".zip")
$startOfDownloadLink = $CcleanerWebsite.rawcontent.LastIndexOf("https", $lastIndexOfZip)
$downloadLink = $CcleanerWebsite.rawcontent.Substring($startOfDownloadLink, $lastIndexOfZip + 4 - $startOfDownloadLink)

# Parse filename/version number
echo "Parsing filename now!"
$filenameIncludingVersionNumber = $downloadLink.Substring($downloadLink.LastIndexOf("ccsetup"))

# Dowbload archive
echo "Downloading archive now!"
$downloadDestination = $outputDirectory + $filenameIncludingVersionNumber
Invoke-WebRequest -Uri $downloadLink -OutFile $downloadDestination

# Extract archive
echo "Extracting archive now!"
$filenameWithoutFileExtension = $filenameIncludingVersionNumber.Remove($filenameIncludingVersionNumber.LastIndexOf("."), 4)
$destinationDirectory = $outputDirectory + $filenameWithoutFileExtension
Expand-Archive $downloadDestination -DestinationPath $destinationDirectory

# Clean up
echo "Deleting archive now!"
Remove-Item $downloadDestination
