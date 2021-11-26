<#
  .SYNOPSIS

  .DESCRIPTION

  .NOTES

#>
Function Get-UserByDN{
  [cmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias('distinguishedName')]
    [string]$DN
  )
  BEGIN{}

  PROCESS{

    $DE = New-Object -TypeName System.DirectoryServices.DirectoryEntry("LDAP://$DN")
    [pscustomobject][ordered]@{
      samAccountName = $DE.Properties['samAccountName'][0]
      DN = $DE.Properties['distinguishedName'][0]
      distinguishedName = $DE.Properties['distinguishedName'][0]
      displayName = $DE.Properties['displayName'][0]
      manager = $DE.Properties['manager'][0]
      directreports = $DE.Properties['directreports']
      mail = $DE.Properties['mail'][0]
      "msds-cloudextensionattribute1" = $DE.Properties['msds-cloudextensionattribute1'][0]
      company = $DE.Properties['company'][0]
      department = $DE.Properties['department'][0]
      #lastLogonTimeStamp = [datetime]::FromFileTime($DE.Properties['lastlogontimestamp'][0])
      employeeType = $DE.Properties['employeeType'][0]
      physicaldeliveryofficename = $DE.Properties['physicaldeliveryofficename'][0]
      co = $DE.Properties['co'][0]
      c = $DE.Properties['c'][0]
      userAccountControl = $DE.Properties['userAccountControl'][0]
      Title = $DE.Properties['Title'][0]
    }

  }

  END{}
}