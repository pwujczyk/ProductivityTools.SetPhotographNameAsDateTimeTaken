clear
cd $PSScriptRoot
Import-Module .\ProductivityTools.SetPhotographNameAsDateTimeTaken.psm1 -Force
#Set-PhotographNameAsDateTimeTaken -Recurse -Replace
Set-PhotographNameAsDateTimeTaken -Directory d:\Trash\Magda\ 
