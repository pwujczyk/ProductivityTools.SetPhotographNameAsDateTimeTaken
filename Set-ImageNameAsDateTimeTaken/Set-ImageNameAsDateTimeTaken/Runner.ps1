clear
dir
cd $PSScriptRoot
Import-Module .\Set-ImageNameAsDateTimeTaken.psm1 -Force
cd "d:\Trash\robyg\"
Set-ImageNameAsDateTimeTaken -verbose -Recurse -Replace
