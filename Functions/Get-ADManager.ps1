<#
  .SYNOPSIS

  .DESCRIPTION

  .NOTES

#>
Function Get-ADManager{
  [cmdletBinding()]
  param(
    [string]$Identity

  )
  BEGIN{
    
    . 'C:\Program Files\WindowsPowerShell\Modules\OrgChart\0.0.1\Functions\Find-DirectoryEntry.ps1'
    . 'C:\Program Files\WindowsPowerShell\Modules\OrgChart\0.0.1\Functions\Get-UserByDN.ps1'
  
  }

  PROCESS{
  
    $ADUser = Find-DirectoryEntry -Filter "(&(objectClass=user)(objectCategory=person)(samAccountName=$Identity))"
    
    if($ADUser.Manager -ne $null){
      $Manager = Get-UserByDN -DN $ADUser.Manager | Select-Object -Property *,@{n='ManagerIdentity';e={}}
    }



  }

  END{}
}