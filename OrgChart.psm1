<#
    .SYNOPSIS
    Import functions in the module folders
    .DESCRIPTION
      Imports .ps1 files in the \Functions and \Internal folders
    .NOTES
        1.0
#>
Function Import-ModuleFunction{
  [cmdletBinding()]
  param(
    [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias("Fullname")]
    [string]$Path
  )

  PROCESS{
    Write-Verbose $Path
    $ExecutionContext.InvokeCommand.InvokeScript($false, ([scriptblock]::Create([io.file]::ReadAllText($Path))), $null, $null)

  }

}

# Public functions
Get-ChildItem -Path "$PSScriptRoot\Functions" -Recurse -Filter '*.ps1' -Force | Foreach-Object {
    . Import-ModuleFunction -Path $_.FullName

}

    #Private functions
Get-ChildItem -Path "$PSScriptRoot\Internal" -Recurse -Filter '*.ps1' -Force | Foreach-Object{
    . Import-ModuleFunction -Path $_.FullName
}

Enum Severity{
  Debug
  Info
  Warning
  Error
}


