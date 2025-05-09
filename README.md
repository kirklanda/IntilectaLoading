# Overview
The PowerShell script `UploadIntilectaFileToPinga.ps1` will find any Intilecta files from a specified directory
and will upload these into Pinga for processing.

# Setup

## PowerShell
The script uses the latest version of PowerShell.  See [Install PowerShell 7.5.1](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5) for instructions on. 

## PowerShell Modules
The script uses the following PowerShell Modules:
* CredentialManager

Install the Modules as follows:
1. From the Start menu search for PowerShell.  Choose `Windows PowerShell` and `Run as Administrator`.
2. Install the CredentialManager Module using `Install-Module -Name CredentialManager -Scope CurrentUser`

## Credentials Manager
The script reads the API key and secret used in the call to Pinga from Windows Credential Manager.  To set up the
credentials, complete the following steps:
1. Open `Credential Manager`.  Press `Win + S` and type <b>Credential Manager</b>.
2. Select `Windows Credentials`. (<b>Note</b>: Not `Web Credentials`).
3. Select `Add a generic credential` to add the API key.
4. Enter an `Internet or network address` and `Username` for the API Key, e.g. <b>"PingaAPIKey"</b>. In the `Password` field, add the API <i>Key</i> value.  Select <b>OK</b>.
5. Select `Add a generic credential` to add the API secret.
6. Enter an `Internet or network address` and `Username` for the API Secret, e.g. <b>"PingaAPISecret"</b>.  In the `Password` field, add the API <i>Secret</i> value.  Select <b>OK</b>.

The names for the API Key and API Secret are configured for the PowerShell script in the `config.json` file.  Update the config file to 
match the names you've used above so that the script finds them.

## Scheduling

- Open `Task Scheduler`.  Press `Win + S` and type <b>Task Scheduler</b>.
- In the lefthand pane navigate to `Microsoft > Windows > PowerShell > ScheduledJobs`.
- Create a new task. Click `Create Task` on the righ-hand side.
- Give the task a name, e.g. "Upload Intilecta Files to Pinga".
- Select `Run whether the user is logged on or not` to have the job run in the background.
- Select the `Triggers` tab.
- Click `New` to create a new trigger.
- Set the schedule for the task and click `OK`.
- Select the `Actions` tab.
- Click `New` to create a new action.  Choose `Start a program` for the action if this is not already selected.
- For the `Program/script` enter `pwsh.exe`.  This should run the PowerShell version that was installed above.
- In the `Add arguments` field enter `-ExecutionPolicy Bypass -File "<script location>\IntilectaLoading\UploadIntilectaFileToPinga.ps1"`.  Change
the script location to match the directory where the script is installed.
- In the `Start in` field, add the directory where the script is installed, i.e. `<script location>\IntilectaLoading`.  This is needed for the PowerShell script to find the `config.json` file.
- Click `OK` and enter the details for the user that will run the task.

# Running the script manually
The script can be run manually to allow the directory and start and end dates to be specified.  This can be useful if the script failed to 
process files on a given day and needs to be re-run.  The command line usage is:
```
.\UploadIntilectaFileToPinga.ps1 -DirectoryPath <path> -StartDate <date> -EndDate <date>

For example:
.\UploadIntilectaFileToPinga.ps1 -DirectoryPath "c:/temp/"  -StartDate 05/09/2025
```
