function GerResultDirectory()
{
	[cmdletbinding()]
	param ([string]$directory)
	
	$path=Split-Path -Path $directory
	$directoryName=Split-Path $directory -leaf

	$resultName="_Result"
	$resultPath=Join-Path "$path" $directoryName$resultName
	return $resultPath
}

function CreateGetResultDirectory()
{
	[cmdletbinding()]
	param ([string]$directory)
	
	$resultPath=GerResultDirectory $directory
	
	Write-Verbose "The result of the script will be placed in the directory: [$resultPath]"
	if (Test-Path $resultPath)
	{
		throw "Result directory [$resultPath] exists, please remove it."	
	}
	else
	{
		New-Item -ItemType directory -Path $resultPath |Out-Null
		return $resultPath
	}
}

function GetDateAndTimeFromImage($imagePath)
{
    $image = New-Object System.Drawing.Bitmap("$imagePath")
    try{
	    $date = $image.GetPropertyItem(36867).value[0..9]
	    $arYear = [Char]$date[0],[Char]$date[1],[Char]$date[2],[Char]$date[3]  
	    $arMonth = [Char]$date[5],[Char]$date[6]  
	    $arDay = [Char]$date[8],[Char]$date[9]  
	    $strYear = [String]::Join('',$arYear)  
	    $strMonth = [String]::Join('',$arMonth)   
	    $strDay = [String]::Join('',$arDay)  
	    $DateTaken =$strYear+"."+$strMonth + "." + $strDay
	    
	    $time = $image.GetPropertyItem(36867).value[11..18]
	    $arHour = [Char]$time[0],[Char]$time[1]
	    $arMinute = [Char]$time[3],[Char]$time[4]  
	    $arSecond = [Char]$time[6],[Char]$time[7]  
	    $strHour = [String]::Join('',$arHour)  
	    $strMinute = [String]::Join('',$arMinute)   
	    $strSecond = [String]::Join('',$arSecond)  
	    $TimeTaken = $strHour + "." + $strMinute + "." + $strSecond
	    $FullDate = $DateTaken + "_" + $TimeTaken
     }
	catch
	{
		$FullDate=(Get-ChildItem $imagePath).BaseName
		Write-Error "Date taken haven't been found, probably picture is image (doesn't have the date taken property) Name set as [$FullDate]"
	}

	$image.Dispose()
     
	return $FullDate
}

function ProcessImage()
{
	[cmdletbinding()]
	param ([string]$imagePath,[string]$resultDirectory,[bool]$replace)
	
	$destinationName=GetDateAndTimeFromImage $imagePath
	$resultFullPath=Join-Path $resultDirectory $destinationName".jpg"
	if ($Replace)
	{
		Write-Verbose "Renaming file from [$imagePath] to [$resultFullPath]"
		Rename-Item -Path $imagePath -NewName $resultFullPath
	}
	else
	{
		Write-Verbose "Copying file from [$imagePath] to [$resultFullPath]"
		Copy-Item -Path $imagePath -Destination $resultFullPath
	}
}

function CreateSubDirectory([string]$startDirectory,[string]$source)
{
	$mainDestPath=GerResultDirectory $startDirectory
	$targetSubDir=$source.Replace($startDirectory,$mainDestPath)
	if (Test-Path $targetSubDir)
	{
		throw "Tareg subresult directory [$targetSubDir] exists, please remove it."	
	}
	else
	{
		New-Item -ItemType directory -Path $targetSubDir |Out-Null
		return $targetSubDir
	}
}

function ProcessDirectory()
{
	[cmdletbinding()]
	param ([string]$startDirectory,[string]$source,[bool]$replace,[bool]$recurse)
	
	Write-Verbose "Processing directory [$source] in the mode Replace:[$replace] Recurse:[$replace]"
	
	if ($Replace -eq $true)
	{
		$destination=$source
	}
	else
	{
		if ($startDirectory -eq $source)
		{
			$destination=CreateGetResultDirectory $startDirectory
		}
		else
		{
			$destination=CreateSubDirectory $startDirectory $source
		}
	}
	
	$images=Get-ChildItem  -Filter "*.jpg" -Path $source 
	foreach($image in $images)
	{
		$imagePath=$image.FullName
		ProcessImage $imagePath $destination $Replace
	}
	
	$dirs=Get-ChildItem -Path $source  | ?{ $_.PSIsContainer }
	foreach($dir in $dirs)
	{
		$directoryFullName=$dir.FullName
		ProcessDirectory $startDirectory $directoryFullName $Replace $recurse
	}
}

function Set-PhotographNameAsDateTimeTaken{
	[cmdletbinding()]
	param ([string]$Directory, [switch]$Replace, [switch]$Recurse)
	Write-Verbose "Loading system drawing assembly"
	[reflection.assembly]::loadfile( "C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Drawing.dll")

	$startDirectory=$Directory
	if ($Directory -eq $null -or $Directory -eq "")
	{
		$startDirectory=Get-Location
	}
	ProcessDirectory $startDirectory $startDirectory $Replace $Recurse
}

Export-ModuleMember Set-PhotographNameAsDateTimeTaken