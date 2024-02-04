<#
    .SYNOPSIS
    Retrieves a list of files based on specified filter criteria and sorts them based on a user-specified property.

    .DESCRIPTION
    The Get-FileList function retrieves a list of files based on the specified filter criteria and sorts them based on the specified property. It returns a custom object containing the file name, name length, and the number of vowels in the file name for each file.

    .PARAMETER SortProperty
    Specifies the property by which the files should be sorted. Valid values are "FileName", "NameLength", and "VowelCount". The default value is "FileName".

    .PARAMETER Filter
    Specifies the filter criteria for selecting files. The default value is "*".

    .OUTPUTS
    System.Object
    Returns a custom object containing the file name, name length, and number of vowels in the file name for each file.

    .EXAMPLE
    Get-FileList -SortProperty "NameLength" -Filter "*.txt"
    Retrieves a list of files with the extension ".txt", sorts them based on the name length, and displays the results.

    .EXAMPLE
    Get-FileList -Filter "test" -SortProperty "VowelCount"
    Retrieves a list of files containing the word "test" in their name, sorts them based on the vowel count, and displays the results.
#>


Function Get-FileList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [ValidateSet("Name", "Length", "VowelCount")]
        [alias("Sort", "S")]
        [string]
        $SortProperty = "Name",

        [Parameter(Mandatory=$false)]
        [alias("Pattern", "P")]
        [string]
        $Filter = "*"
    )

    $Filter = $Filter.Trim()
    if ($Filter[0] -ne '*') {
        # add leading '*' if needed:
        $Filter = '*' + $Filter
    }
    
    if ($Filter[-1] -ne '*') {
        # add trailing '*' if needed:
        $Filter += '*'
    }

# @() creates an empty array:
    $files=@()
    foreach ($file in $(Get-ChildItem -Filter $Filter)) {
        $vowel_count = $(Select-String -InputObject $file.Name -Pattern '[aeiou]' -AllMatches).Matches.Count

    # creating custom object types is easy in PowerShell, and allows your code to place its results onto 
    # the pipeline as objects for the calling process. very nice, very polite.
        $files += [PSCustomObject]@{
            "Name" = $file.Name
            "Length" = $file.Name.Length
            "VowelCount" = $vowel_count
        }
    }

    # if ($files.Count -eq 0) {
    #     Write-Output "No files found matching the filter `"$Filter`""
    # }
    # else {
    $files | Sort-Object -Property $SortProperty
    # }
}
