﻿function Get-ADReport{
  [CmdletBinding()]
  PARAM (
    [Parameter(Mandatory)]
    [String]$Identity
    ,
    [int]$Level=1000
    ,
    [int]$CurrentLevel=1
    ,
    [int]$ReportCount=0
    
  )
  PROCESS{
    $CurrentLevel++
    
    
    TRY{
      Write-Verbose "Account: $Identity, Level = $Level; CurrentLevel $CurrentLevel; ReportCount = $ReportCount"
      
      if($Identity -match 'DC='){
        $DE = Get-UserByDN -DN $Identity
      }else{
        $DE = Find-DirectoryEntry -Filter "(&(objectClass=user)(objectCategory=person)(samAccountName=$Identity))"
      }
      
      if($ReportCount -eq 0){
        
        # Output the top level manager
        $DE | Select-Object -Property *, @{ Name = "ManagerIdentity"; Expression = {''}}

      }
        
      #Recurse through the reports
      Write-Progress -Activity "Getting direct reports" -Status "$($DE.DisplayName)"
       
      $Reports = $DE.directreports | Where-object{$_ -notmatch '^cn=SV-|^cn=ADM-'} | ForEach-Object{
        
        # msDS-cloudExtensionAttribute1 filters out mailboxes, service accounts and adm accounts
        # UserAccountControl -ne 514 filters out disabled accounts
        Get-UserbyDN -DN $_ | Where-Object{($_."msDS-cloudExtensionAttribute1" -ne $null) -and ($_.UserAccountControl -ne 514)} | Select-Object -Property *, @{ Name = "ManagerIdentity"; Expression = { Get-UserByDN -DN $_.Manager | Select-Object -ExpandProperty samAccountName } }

      }
      
     
      $Reports | Sort-Object -Property DisplayName | ForEach-Object{
        
        #Output
        $_
        
        $ReportCount++
          
        if(($CurrentLevel -le $Level) -and ($_.directReports -ne $null)){
          Get-ADReport -Identity $_.DN -CurrentLevel $CurrentLevel -Level $Level -ReportCount $ReportCount
        }             
      }
      
      $null = Remove-Variable -Name "Reports" -ErrorAction SilentlyContinue      
      
        
        
    }CATCH{
      Write-Warning "Error '$_'"
    }
    $CurrentLevel--
  }
}
      

# Get-ADReport -Identity Aross3 -Verbose | Out-Null
# Get-ADReport -Identity A0763390 -Level 1 -Verbose | Select DisplayName
