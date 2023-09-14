# Check if the required modules are installed, and install them if not
if (!(Get-Module -Name MicrosoftPowerBIMgmt -ListAvailable)) {
    Install-Module -Name MicrosoftPowerBIMgmt
}

# Define the root path as the parent folder of the script
#$rootPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Get a list of tenants, one txt file per tenant in the tenants folder
# The file should be named after tenant and contain username in the first line and password in the second
$tenants = Get-ChildItem -Path ".\tenants\" -file

# Initialize arrays for refreshes, failures and disabled datasets
$refs = @()
$fails = @()
$dis = @()
# Loop through each tenant
foreach ($tenant in $tenants) {
    # Get the path to the credential file for the tenant
    $credentialPath = $tenant.fullname

    # Read the username and password from the credential file
    $credentials = Get-Content -Path $credentialPath
    $username = $credentials[0]
    $password = $credentials[1]

    # Convert the password to a secure string
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force

    # Create a PSCredential object from the username and secure password
    $credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

    # Connect to the Power BI service using the tenant's credentials. 
    
    Connect-PowerBIserviceaccount -Credential $credential

    # Get a list of all the workspaces in the tenant
    # The users field will only contain data if the -scope organization parameter is set, and this parameter requires
    # that the user has tenant administrator rights in the customers powerbi account/tenant.
    $workspaces = Get-PowerBIWorkspace 

    
    # Loop through each workspace
    foreach ($w in $workspaces) {
        # Get a list of all the datasets in the workspace
        $d = Get-PowerBIDataset -workspaceid $w.Id
        foreach ($di in $d) {
            if ($di.isrefreshable ) {
                # Get a list of all the refreshes for the dataset
                $results = (Invoke-PowerBIRestMethod -Method get -Url ("datasets/" + $di.id + "/Refreshes") | ConvertFrom-Json) 
                # Selecting the most recent refresh
                $results.value[0] 
                # Create a PSCustomObject with the information about the refresh
                $refresh = [PSCustomObject]@{
                    Clock        = Get-Date
                    Tenant       = $tenant.basename
                    Workspace    = $w.name
                    Dataset      = $di.Name
                    refreshtype  = $results.value[0].refreshType
                    startTime    = $results.value[0].startTime
                    endTime      = $results.value[0].endTime
                    status       = $results.value[0].status
                    ErrorMessage = $results.value[0].serviceExceptionJson   
                }
                $refs += $refresh
                if ($results.value[0].status -eq "Failed") {
                    $fails += $refresh
                }
                if ($results.value[0].status -eq "Disabled") {
                    $dis += $refresh
                }
       
            }

        }
    }
    
}
$refs | export-csv -Path ".\refreshes.csv" -Append
# Export the information about the users to a CSV file. Add -Append to the command to append to an existing file.

$fails | export-csv -Path ".\failures.csv" -Append
# Export the information about the users to a CSV file. Add -Append to the command to append to an existing file.

$dis | export-csv -Path ".\disabled.csv" -Append
# Export the information about the users to a CSV file. Add -Append to the command to append to an existing file.
