clear
cd $PSScriptRoot
Import-Module .\Set-PhotographNameAsDateTimeTaken.psm1 -Force
cd "d:\Trash\robyg\"
#Set-PhotographNameAsDateTimeTaken -Recurse -Replace
Set-PhotographNameAsDateTimeTaken -Directory "d:\Photographs\Processing\komorska\zdjecia z onedrive\publiczny\2010.06.29 Zakopane - Rysy [wt] @\2010.06.29 Zakopane - Rysy [wt] @\" -Replace
