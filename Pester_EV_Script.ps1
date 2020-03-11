<#
.SYNOPSIS
  Event logging
.DESCRIPTION
  Event logging for pester test.
.PARAMETER
  N/A
.INPUTS
  JSON file contains the inputs.
.OUTPUTS
  Event Log
.NOTES
  Version:        7.4.3
  Author:         Paul Skeie
  Creation Date:  12/01/19
  Purpose/Change: Event Logging
.EXAMPLE
  PS Invoke-Pester .\PesterTests.ps1
#>

function Invoke-NCRPesterTest {
    [cmdletbinding()]
    param (
        [String] $eventLogName = 'BVT',

        [String] $eventSource = 'Pester Test',

        [Int32] $eventErrorId = 4000,

        [Int32] $eventInfoId = 1000,
		
		[ValidateSet('Simple','Comprehensive')]
        [String] $TestType = 'Simple'
		
    )

    # Add the Event Source if it doesn't exist
    If ([System.Diagnostics.EventLog]::SourceExists($eventSource) -eq $False) {
        New-EventLog -LogName $eventLogName -Source $eventSource
        }

    # Execute the tests
    $tests = Invoke-OperationValidation -ModuleName NCRPesterTest -TestType $TestType

    foreach ($test in $tests) {
    # Add the tests to the Event Log
   if ($test | Where-Object -Property Result -EQ -Value 'Failed') {
        Write-EventLog `
            -LogName $eventLogName `
            -Source $eventSource `
            -EntryType Error `
            -Message $test.Name `
            -EventId $eventErrorId `
            -Category 0
        $eventId++
        }
    elseif ($test | Where-Object -Property Result -EQ -Value 'Passed') {
            Write-EventLog `
            -LogName $eventLogName `
            -Source $eventSource `
            -EntryType Information `
            -Message $test.Name `
            -EventId $eventInfoId `
            -Category 0
        $eventId++
           }
        }
    }