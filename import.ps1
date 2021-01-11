get-date -f MM-dd-yyyy | Out-File -FilePath .\lastimport.txt

$command = "cd bin"
Invoke-Expression $command   
foreach($user in Get-Content ..\metadata\users.txt) {

    $command = "twint -u $user -o ..\data\export.json --json "
    Invoke-Expression $command    
}
$command = "cd .."
Invoke-Expression $command      