<#
.SYNOPSIS
  Overview
.DESCRIPTION
  Details
.INPUTS
  N/A
.OUTPUTS
  A log is written to the event log
.NOTES
  Version:        7.0
  Author:         Who created it
  Creation Date:  03/10/2020
  Purpose/Change: What and why
.EXAMPLE
  PS .\Name.ps1
#>
# Start script with logging to event viewer
begin {
    $eventHashInformation = @{
      eventLogName = 'Event Log Name'
      eventSource = 'Name.ps1'
      eventID = '1000'
      entryType = 'Information'
    }
    $eventHashWarning = @{
      eventLogName = 'Event Log Name'
      eventSource = 'Name.ps1'
      eventID = '4000'
      entryType = 'Error'
    }
  }
  process {
  # Set Error/Information Action Preference to Stop/Continue for Try Catch code and write information to event log
  $ErrorActionPreference = "stop"
  
  # Check if the source exists and create if needed
  If ([System.Diagnostics.EventLog]::SourceExists($eventHashInformation.eventSource) -eq $False) {
    New-EventLog -LogName $eventHashInformation.eventLogName -Source $eventHashInformation.eventSource
    }
   #Write EventLog Function
  function Write-InfoEventLog {
    Param($infoMessage)
    Write-EventLog -LogName $eventHashInformation.eventLogName -EventID $eventHashInformation.eventID -EntryType $eventHashInformation.entryType -Source $eventHashInformation.eventSource -Message $infoMessage
   }
  
   function Write-ErrorEventLog {
     Param($errorMessage)
     Write-EventLog -LogName $eventHashWarning.eventLogName -EventID $eventHashWarning.eventID -EntryType $eventHashWarning.entryType -Source $eventHashWarning.eventSource -Message $errorMessage
   }
  
  try {
  $infoMessage = "Name.ps1 script to install PowerShell v7.0 has begun"
  Write-InfoEventLog $infoMessage

}
catch {
  $errorMessage = $_.Exception.message
  Write-ErrorEventLog $errorMessage
    }
  } 
end {
  $infoMessage = "Name.ps1 has successfully finished"
  Write-InfoEventLog $infoMessage
}