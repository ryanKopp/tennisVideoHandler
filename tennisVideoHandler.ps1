# Make Folder Given cmd line name 
$matchName=$args[0]
New-Item -Path . -Name $args[0] -ItemType "directory"

#In this new Folder, make subfolders for each match
New-Item -Path .\$matchName\ -Name "1Doubles" -ItemType "directory"
New-Item -Path .\$matchName\ -Name "2Doubles" -ItemType "directory"
New-Item -Path .\$matchName\ -Name "3Doubles" -ItemType "directory"
New-Item -Path .\$matchName\ -Name "1Singles" -ItemType "directory"
New-Item -Path .\$matchName\ -Name "2Singles" -ItemType "directory"
New-Item -Path .\$matchName\ -Name "3Singles" -ItemType "directory"
New-Item -Path .\$matchName\ -Name "4Singles" -ItemType "directory"
New-Item -Path .\$matchName\ -Name "5Singles" -ItemType "directory"
New-Item -Path .\$matchName\ -Name "6Singles" -ItemType "directory"

#Once in there, wait until user has moved all files
echo "Move video into folders, then press any key to continue"
[void][System.Console]::ReadKey($true)

#Then do work on each match
foreach ($folder in Get-ChildItem -Path .\$matchName\ -Directory ){
	
	$lineWrite = ""
	#Create list of files to be concatenated
	foreach($file in Get-ChildItem -Path .\$matchName\$folder\* -Include *.MP4){
		$lineWrite = $lineWrite + "file `'$file`'`n"
	}
	
	Out-File -FilePath $matchName\$folder\mylist.txt -InputObject $lineWrite -Encoding ASCII 
	#^Need this bc windows defaults to wrong encoding
#finally concatenate, then encode in background so we can begin next concatenation while encoding occurs
	
#ffmpeg in foreground and handbrake run after in background ensures the file has been fully concatenated before encoding
	ffmpeg -f concat -safe 0 -i $matchName\$folder\mylist.txt -c copy $matchName\$folder\bigboi.MP4

	Start-Process -FilePath "HandBrakeCLI" -ArgumentList "-i $matchName\$folder\bigboi.MP4 -o $matchName\$folder\$folder.mp4 -e x264  -q 18 -E copy:aac -O --align-av -f av_mp4 --encoder-preset medium"
}
