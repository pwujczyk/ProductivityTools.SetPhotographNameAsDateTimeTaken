clear
dir
cd $PSScriptRoot
Import-Module .\Set-ImageNameAsDateTimeTaken.psm1 -Force
cd "d:\zdjecia\zdjecia\2013.09.02 Cypr\"
Set-ImageNameAsDateTimeTaken -verbose
