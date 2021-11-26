Function Out-OrgChart{
  [cmdletbinding()]
  param(
    [Parameter(Position=0,Mandatory,ValueFromPipeline)]
    $ADUser
  )

  BEGIN{
    Add-Type -AssemblyName System.Windows.Forms | Out-Null
    Add-type -AssemblyName System.Drawing | Out-Null
   
    function Add-Node { 
      param 
      ( 
          $TreeView,
          $ParentNodeName, 
          $NodeName,
          $DisplayName,
          $Title,
          $Department,
          $EmployeeType,
          $Country
      )

      $newNode = new-object System.Windows.Forms.TreeNode
      $newNode.Name = $NodeName
      $newNode.Text = "$DisplayName - '$Title' - '$Department' - '$EmployeeType' - '$Country'"

      $tns = $treeView.Nodes.Find($ParentNodeName, $true)
      if ($tns.Count -gt 0)
      {
          $ParentNode = $tns[0]
          $Null = $ParentNode.Nodes.Add($newNode)

      }elseif([string]::IsNullOrEmpty($ParentNodeName)){ 
        # Root node
        $Null = $treeView.Nodes.Add($newNode) 
          
      }else{
        Write-Warning "Failed to find parent node '$ParentNodeName'"
        
      }
    }
    
    $Form = New-Object system.Windows.Forms.Form
    $Form.Text = "OrgChart"
    $Form.Width = 1068
    $Form.Height = 799
    
    #REGION -----Treeview-----
    $TreeView = New-Object System.Windows.Forms.TreeView
    $TreeView.Location = New-Object System.Drawing.Point(1,3)
    
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = $Form.Height - 106
    $System_Drawing_Size.Width = $Form.Width - 23
    $TreeView.Size = $System_Drawing_Size

    $TreeView.Anchor = (((([System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom) -bor [System.Windows.Forms.AnchorStyles]::Left) -bor [System.Windows.Forms.AnchorStyles]::Right))
    
    $treeView.Font = New-Object System.Drawing.Font("Century Gothic",11)
    $Null = $Form.Controls.Add($TreeView) 
    #EndREGION
    
    #Region ----TextBox---
    $textBox1 = new-object System.Windows.Forms.TextBox
    $textBox1.Location = New-Object System.Drawing.Point(637,680)
    $textBox1.Size = new-object System.Drawing.Size(308, 26)
    $textBox1.Text = "Enter Text"
    $textBox1.Anchor = ([System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right)
    #EndRegion
    
    #Region ---Button---        
    $button1 = new-object System.Windows.Forms.Button
    $button1.Location = New-Object System.Drawing.Point(955,680)
    $button1.Size = new-object System.Drawing.Size(84, 29)
    $button1.TabIndex = 2
    $button1.Text = "Find"
    #$button1.UseVisualStyleBackColor = $true
    #Endregion
    
    #Region ---StatusBar---
    $statusStrip1 = new-object System.Windows.Forms.StatusStrip
    $toolStripStatusLabel1 = new-object System.Windows.Forms.ToolStripStatusLabel
    
    $statusStrip1.ImageScalingSize = new-object System.Drawing.Size(20, 20)
    $statusStrip1.Items.AddRange([System.Windows.Forms.ToolStripItem]$toolStripStatusLabel1)
    $statusStrip1.Location = new-object System.Drawing.Point(0, 727)
    $statusStrip1.Name = "statusStrip1"
    $statusStrip1.Size = new-object System.Drawing.Size(1050, 25)
    $statusStrip1.TabIndex = 3
    $statusStrip1.Text = "statusStrip1"


    $toolStripStatusLabel1.Name = "toolStripStatusLabel1"
    $toolStripStatusLabel1.Size = new-object System.Drawing.Size(279, 20)
    $toolStripStatusLabel1.Text = "Use the find box to search by name or ID"
    #Endregion
    
    
    $Null = $Form.Controls.Add($statusStrip1)
    $Null = $Form.Controls.Add($textBox1)
    $textBox1.BringToFront()
    $button1.BringToFront()
    
  }

  PROCESS{ 
   
    Add-Node -TreeView $TreeView -ParentNodeName $ADUser.ManagerIdentity -NodeName $ADUser.SamAccountName -DisplayName $ADUser.DisplayName -Title $ADUser.Title -Department $ADUser.Department -Country $ADUser.Co -EmployeeType $ADUser.employeeType

  }
  
  END{
    $null = $form.ShowDialog()

  }

}


