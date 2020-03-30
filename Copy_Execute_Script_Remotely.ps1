$computers = Get-Content D:\Computers.txt
ForEach($Computer in $Computers) {
Copy-Item -Path \\PathtoFolder -Recurse -Destination \\$Computer\C$\Temp -Force
}
Invoke-Command -ComputerName $computers -Command {C:\Temp\whatever.ps1} -AsJob