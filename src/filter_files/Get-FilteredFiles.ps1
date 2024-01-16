Write-Output ""
Write-Output "Welcome to ${PSCommandPath}!`nThanks for stopping by."
Write-Output ""

while ($true) {
    # 2>$null redirects the error stream to hide the error 
    # message if $response does not exist:
    Remove-Variable response 2>$null
    while (-Not $response) {
        $response = $(Read-Host -Prompt "What string should be used to filter the filenames? ")
        if ($response) {
            $filter = '*' + $response + '*'
        }
    }

    Write-Output ""
    Write-Output "What field should be used to sort the data?"
    Write-Output ""
    
    Write-Output "F - Filename"
    Write-Output "L - Filename Length"
    Write-Output "V - Filename Vowel Count"
    
    Remove-Variable response 2>$null
    Write-Output ""
    while ($true) {
        $response = $(Read-Host -Prompt "Please enter the letter of your choice from the list above ")
        
        if ($response -in "F", "L", "V") {
            break
        }
        else {
            Write-Output ("Error: {0} is not a valid choice." -f $response)
        }
    }

    $sort_field = 
        switch ($response) {
            "F" {"Name"}
            "L" {"NameLength"}
            "V" {"NameVowelCount"}
        }

    # @() creates an empty array. when items are added to $files inside
    # the loop, PowerShell needs to _already_ know $file is an array or
    # it won't know what to do.
    $files=@()
    foreach ($file in $(Get-ChildItem -Filter $filter)) {
        $vowel_search = $(Select-String -InputObject $file.Name -Pattern '([aeiou])' -AllMatches)
        $vowel_count = $vowel_search.Matches.Count

        # creating custom object types is easy in PowerShell. it's nice to return
        # objects from your code instead of text so your callers have access to
        # all the object information.
        $files += [PSCustomObject]@{
            "Name" = $file.Name
            "NameLength" = $file.Name.Length
            "NameVowelCount" = $vowel_count
        }
    }

    if ($files.Count -eq 0) {
        Write-Output "No files found matching the filter '$filter'."
        Write-Output ""
    }
    else {
        $files | Sort-Object -Property $sort_field | Format-Table -AutoSize
    }

    while ($response[0] -notin "y", "n") {
        $response = $(Read-Host -Prompt "Would you like to run the program again? (y/N) ")
    }

    if ($response[0] -eq "n") {
        Write-Output ""
        return
    }
    elseif ($response[0] -eq "y") {
        continue
    }
    else {
        # this else "should never happen," so queue liam neeson if it does:
        $error_message = "I don't know who you are. I don't know what you want. If you are looking for ransom I can tell you I don't have money, but what I do have are a very particular set of skills. Skills I have acquired over a very long career. Skills that make me a nightmare for people like you. If you leave my script now, that'll be the end of it. I will not look for you, I will not pursue you. But if you don't, I will look for you, I will find your process, and I will kill it. Sincerely, your Mom."
        $exception = New-Object System.ArgumentOutOfRangeException($error_message)
        throw $exception
        return 0xDEADBEEF
    }
}
