# import from twitter 
foreach($user in Get-Content .\metadata\users.txt) {
    cd .\bin
    try {
        $command = "twint -u $user -o ..\data\export.json --json "
        Invoke-Expression $command 
    } catch 
    {
        #ignore exceptions so they dont break the import. 
    }
    cd ..  
}

# write the current date to a file     
get-date -f MM-dd-yyyy | Out-File -FilePath .\lastimport.txt


#Check for duplicates in import file, and remove those
#Do the merge too in this step by just removing duplicates, not deleting not found items like deleted tweets  
$hash = @{}                          
Get-Content -Path .\data\export.json,.\data\database.json -Encoding UTF8 |  
% {                                            
     if ($hash.$_ -eq $null) {      
        $_                          
     };
     $hash.$_ = 1                   
} | Out-File .\data\database_update.json -Encoding UTF8  # redirect the pipe into a new file.

Remove-Item -Path .\data\export.json
Remove-Item -Path .\data\database.json
Rename-Item -Path .\data\database_update.json -NewName database.json


# import pictures from twitter
$exportedDataObject = Get-Content .\data\database.json | ConvertFrom-Json
$exportedDataObject.GetEnumerator() | foreach {
     #WRITE-HOST $_.id #tweet will contain the text #
     #WRITE-HOST $_.username 
     $tweetId = $_.id
     if( Test-Path .\data\pictures\$tweetId ) {
        #we downloaded this already
     } else {
         $pictureId = 0 
         $_.photos.GetEnumerator() | foreach {
            $downloadURL = $_
            $pictureId++;
            $filename = "$($tweetId)_$($pictureId)_$($downloadURL)"
            $filename = $filename.Replace("https://pbs.twimg.com/media/","")
            if($filename.Contains("tweet_video_thumb")) {
                #videos not implemented yet 
            } else {
                #save pictures to filesystem  
                WRITE-HOST $filename
                New-Item -ItemType Directory -Force -Path .\data\pictures\$tweetId
                wget $downloadURL -outfile .\data\pictures\$tweetId\$filename 
            } #end if it is a video or picuture 
         } # end picture enumerator 
     } #end if we already downloaded the pictures 
} # end export




<#
#1144
#>