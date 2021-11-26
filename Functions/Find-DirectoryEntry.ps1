Function Find-DirectoryEntry{
<#
.Synopsis
    Finds an Active Directory object using a directory search
.Description
    Helper function to search AD using an LDAP query
	  
.Parameter Filter
	The filter portion of the LDAP query
	
.Parameter Root
	The root container for the query
	
.Parameter Property
	An array of parameters to be returned
	
.Parameter Scope
	The depth of the query - base,onelevel or subtree
 
 .Example
 	PS C:\>Find-DirectoryEntry -Filter "(objectClass=organizationalUnit)" -Property "*"
	
	This command will return all OU objects in the domain of the current user and include all available properties
	
 .Example
 	PS C:\>Find-DirectoryEntry -Filter "(objectClass=user)" -Property "displayName,givenName,sn" -root "cn=user,dc=my,dc=home"
	
	This command will return all user objects in the Users container of the my.home domain and include the displayName, givenName and surname properties
	
 .Notes
	Version:        1.0
 
 .Outputs
 	DirectoryServices.DirectorySearcher.SearchResult collection
	
 .Link
 	http://msdn.microsoft.com/en-us/library/system.directoryservices.directorysearcher.aspx

#>
[cmdletBinding()]
	param(
		[parameter(position=0)]
		[string]$Filter="*"
		,
		[parameter(position=1)]
		[string]$Root=$env:USERDNSDOMAIN
		,
		[parameter(position=2)]
		[string[]]$Property="*"
		,
		[parameter(position=3)]
		[string]$Scope="subtree"
	)
  PROCESS{
      try{
          $DE = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$Root")
          $Searcher = New-Object System.DirectoryServices.DirectorySearcher
          $Searcher.SearchRoot = $DE
          $Searcher.PageSize = 1000
          $Searcher.Filter = $Filter
          $Searcher.SearchScope = $Scope

          foreach ($entry in $Property){[Void]$Searcher.PropertiesToLoad.Add($entry)}
          $Results = $Searcher.FindOne()

          # Return the DirectorySearcher.SearchResult object
		      
          if($Results){
            Foreach($Result in $Results){
            
              [pscustomobject][ordered]@{
                samAccountName = $Result.Properties['samAccountName'][0]
                DN = $Result.Properties['distinguishedName'][0]
                distinguishedName = $Result.Properties['distinguishedName'][0]
                displayName = $Result.Properties['displayName'][0]
                manager = $Result.Properties['manager'][0]
                directreports = $Result.Properties['directreports']
                mail = $Result.Properties['mail'][0]
                "msds-cloudextensionattribute1" = $Result.Properties['msds-cloudextensionattribute1'][0]
                company = $Result.Properties['company'][0]
                department = $Result.Properties['department'][0]
                lastLogonTimeStamp = [datetime]::FromFileTime($Result.Properties['lastlogontimestamp'][0])
                employeeType = $Result.Properties['employeeType'][0]
                physicaldeliveryofficename = $Result.Properties['physicaldeliveryofficename'][0]
                co = $Result.Properties['co'][0]
                c = $Result.Properties['c'][0]
                UserAccountControl = $Result.Properties['userAccountControl'][0]
                Title = $Result.Properties['Title'][0]
              }
              
            }


          }

        
      }
      catch{
	
          Write-Verbose "Error: $($_.Exception.MessageDetails)"
          Return $null
		
	
      }
  }

}