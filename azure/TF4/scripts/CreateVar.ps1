#This will create pipeline variables and assign value according to the stages
<#
.SYNOPSIS
    Assign Variable values at runtime after reading supplied file.

.DESCRIPTION
    Assign Variable values at runtime after reading supplied file.
    Takes any strings for the file name.

.PARAMETER File
    Specifies the file name of tf file.

.INPUTS
    Specifies the file name of tf file.

.OUTPUTS
    Assign Values at Runtime.

.EXAMPLE
    PS> SetVarsWithValue -efile "File"
#>
function SearchPattern {
    [CmdletBinding()]
     Param(
      [Parameter(Position=0, Mandatory=$true)][ValidateNotNullOrEmpty()][string]$pattern,
      [Parameter(Position=1, Mandatory=$true)][ValidateNotNullOrEmpty()][string]$file
    )
    $Matching = Select-String -Path $file -Pattern $pattern
    $result = $Matching.Line.Split("=")
    $final_res = $result[1]  -replace '"', ''
    $final_res = $final_res -replace ' ', ''
    return $final_res
}

function SetVarsWithValue{
    [CmdletBinding()]
    Param(
      [Parameter(Position=0, Mandatory=$true)][ValidateNotNullOrEmpty()][string]$e_file
    )

    try
    {
        $finalcompre = "RND Common"
        $finalenvpre = SearchPattern -pattern "project_location" -file $e_file
        $finalprojpre = SearchPattern -pattern "project_prefix" -file $e_file
        $finalprojpath = "projects/" + "$finalprojpre"
        $finalprojvarpath = "project.tfvars"
        
        write-Host "##vso[task.setvariable variable=TF_Project_Name;]$finalcompre"
        write-Host "##vso[task.setvariable variable=TF_Project_Location;]$finalenvpre"
        write-Host "##vso[task.setvariable variable=TF_Project_Prefix;]$finalprojpre"
        write-Host "##vso[task.setvariable variable=MainPath;]$finalprojpath"
        write-Host "##vso[task.setvariable variable=VariablePath;]$finalprojvarpath"
    }
    catch
    {
        Write-Host "There was an error running this powershell script";
        Write-Host $_.Exception.Message;
        Write-Host $_.Exception.Stacktrace;
        return 0;
    }
    finally
    {
        Write-Host "-----------------------------------------------------";
    }
}

$e_file = $args[0].ToString()
Set-Location -Path ..
SetVarsWithValue -e_file $e_file