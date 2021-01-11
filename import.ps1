get-date -f MM-dd-yyyy | Out-File -FilePath .\lastimport.txt
 
foreach($user in Get-Content ..\metadata\users.txt) {

    $command = ".\bin\twint -u $user -o ..\data\export.json --json "
    Invoke-Expression $command    
}
