clear
cd $PSScriptRoot
Import-Module .\Set-PhotographNameAsDateTimeTaken.psm1 -Force
cd "d:\Trash\robyg\"
Set-PhotographNameAsDateTimeTaken -verbose -Recurse -Replace
