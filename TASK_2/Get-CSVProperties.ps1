<#
.Synopsis
   Retrieve CSV Properties
.DESCRIPTION
   To read a CSV file and display a specific property in the
console.
.EXAMPLE
   Get-CSVProperties -CSVFileName "CSVFilePath"
#>
function Get-CSVProperties
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        $CSVFileName
    )

    Begin
    {
        Write-Host "Executing function - Get-CSVProperties..."
        Write-Host "Provided CSV file name : $CSVFileName"        
    }
    Process
    {      
        $position = 0  
        $data = Import-Csv "$PSScriptRoot\$CSVFileName"        
        $data | Format-List -Property bookTitle, authorName, @{Name="Position"; Expression={$script:position++; $script:position}}        
    }
    End
    {
        Write-Host "Executed function - Get-CSVProperties"
    }
}

Get-CSVProperties -CSVFileName "goodreads_cleaned.csv"
