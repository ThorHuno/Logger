Add-Type -TypeDefinition @"
    public enum LogLevel {
        Information,
        Warning,
        Error
    }
"@

[string]$Script:LogLocation = ""

function Set-FileLocation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    Begin{
        $headers = [string]::Format("{0}`t{1}`t{2}`r`n","Level","Time","Message")
    }
    Process{
        New-Item -Path $Path -Name $Name -ItemType File -Value $headers | Out-Null
        $Script:LogLocation = [string]::Format("{0}\{1}",$Path,$Name)
    }
}

function Write-Logger {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Message,
        [Parameter()]
        [LogLevel]
        $LogLevel = [LogLevel]::Information
    )

    Begin{
        [datetime]$writtenAt = (Get-Date).ToUniversalTime()
        $logFile = [System.IO.StreamWriter]::new($Script:LogLocation,$true)
    }
    Process{
        $CustomMessage = [string]::Format("{0}`t{1}`t{2}",$LogLevel,$writtenAt,$Message)
        $logFile.WriteLine($CustomMessage)
        #Add-Content -Path $Script:LogLocation -Value $CustomMessage
    }
    End{
        $logFile.Close()
        $logFile.Dispose()
    }
}