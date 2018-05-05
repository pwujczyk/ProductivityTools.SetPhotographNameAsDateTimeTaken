clear
dir
cd $PSScriptRoot
Import-Module .\Set-ImageNameAsDateTimeTaken.psm1 -Force
cd "d:\zdjecia\zdjecia\2017.12.24 Wigilia w Bukowinie\"
Set-ImageNameAsDateTimeTaken -verbose -Replace
