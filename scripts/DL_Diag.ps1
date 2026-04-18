$rawScriptUrl = 'https://raw.githubusercontent.com/SpotX-Official/SpotX/refs/heads/main/run.ps1'
$mirrorScriptUrl = 'https://spotx-official.github.io/SpotX/run.ps1'
$downloadHost = 'loadspot.amd64fox1.workers.dev'
$defaultLatestFull = '1.2.86.502.g8cd7fb22'
$stableFull = '1.2.13.661.ga588f749'

$reportLines = New-Object 'System.Collections.Generic.List[string]'

function Add-ReportLine {
    param(
        [AllowEmptyString()]
        [string]$Line = ''
    )

    [void]$script:reportLines.Add($Line)
}

function Add-ReportSection {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title
    )

    if ($script:reportLines.Count -gt 0) {
        Add-ReportLine
    }

    Add-ReportLine ("== {0} ==" -f $Title)
}

function Add-CommandOutput {
    param(
        [string[]]$Lines
    )

    foreach ($line in $Lines) {
        Add-ReportLine ([string]$line)
    }
}

function Invoke-WebRequestCompat {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Uri
    )

    $params = @{
        Uri         = $Uri
        ErrorAction = 'Stop'
    }

    if ($PSVersionTable.PSVersion.Major -lt 6) {
        $params.UseBasicParsing = $true
    }

    Invoke-WebRequest @params
}

function Get-DiagnosticArchitecture {
    $arch = $env:PROCESSOR_ARCHITEW6432
    if ([string]::IsNullOrWhiteSpace($arch)) {
        $arch = $env:PROCESSOR_ARCHITECTURE
    }

    switch -Regex ($arch) {
        'ARM64' { return 'arm64' }
        '64' { return 'x64' }
        default { return 'x86' }
    }
}

function Format-ExceptionDetails {
    param(
        [Parameter(Mandatory = $true)]
        [System.Exception]$Exception
    )

    $details = New-Object 'System.Collections.Generic.List[string]'
    $current = $Exception

    while ($null -ne $current) {
        [void]$details.Add($current.Message)
        $current = $current.InnerException
    }

    $details
}

function Invoke-CurlStep {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    Add-ReportSection -Title $Title

    if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
        Add-ReportLine 'curl.exe not found'
        return
    }

    try {
        $output = & curl.exe @Arguments 2>&1
        Add-CommandOutput -Lines ($output | ForEach-Object { [string]$_ })
        Add-ReportLine ("ExitCode: {0}" -f $LASTEXITCODE)
    }
    catch {
        Add-CommandOutput -Lines (Format-ExceptionDetails -Exception $_.Exception)
    }
}

function Invoke-PowerShellStep {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        [Parameter(Mandatory = $true)]
        [scriptblock]$Action
    )

    Add-ReportSection -Title $Title

    try {
        $result = & $Action

        if ($null -eq $result) {
            Add-ReportLine
            return
        }

        if ($result -is [System.Array]) {
            Add-CommandOutput -Lines ($result | ForEach-Object { [string]$_ })
            return
        }

        Add-ReportLine ([string]$result)
    }
    catch {
        Add-CommandOutput -Lines (Format-ExceptionDetails -Exception $_.Exception)
    }
}

$architecture = Get-DiagnosticArchitecture
$latestFull = $defaultLatestFull
$bootstrapResults = New-Object 'System.Collections.Generic.List[object]'

foreach ($source in @(
    [PSCustomObject]@{ Name = 'raw'; Url = $rawScriptUrl },
    [PSCustomObject]@{ Name = 'mirror'; Url = $mirrorScriptUrl }
)) {
    try {
        $response = Invoke-WebRequestCompat -Uri $source.Url
        $content = [string]$response.Content

        if ($latestFull -eq $defaultLatestFull) {
            $match = [regex]::Match($content, '\[string\]\$latest_full\s*=\s*"([^"]+)"')
            if ($match.Success) {
                $latestFull = $match.Groups[1].Value
            }
        }

        $bootstrapResults.Add([PSCustomObject]@{
            Name       = $source.Name
            Url        = $source.Url
            Success    = $true
            StatusCode = [int]$response.StatusCode
            Length     = $content.Length
        }) | Out-Null
    }
    catch {
        $bootstrapResults.Add([PSCustomObject]@{
            Name       = $source.Name
            Url        = $source.Url
            Success    = $false
            StatusCode = $null
            Length     = $null
            Error      = $_.Exception.Message
        }) | Out-Null
    }
}

$tempUrl = if ($architecture -eq 'x64') {
    'https://{0}/temporary-download/spotify_installer-{1}-x64.exe' -f $downloadHost, $latestFull
}
else {
    $null
}

$directUrl = 'https://{0}/download/spotify_installer-{1}-{2}.exe' -f $downloadHost, $stableFull, $architecture

Add-ReportSection -Title 'Environment'
Add-ReportLine ("Date: {0}" -f (Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz'))
Add-ReportLine ("ComputerName: {0}" -f $env:COMPUTERNAME)
Add-ReportLine ("UserName: {0}" -f $env:USERNAME)
Add-ReportLine ("PowerShell: {0}" -f $PSVersionTable.PSVersion)
Add-ReportLine ("Architecture: {0}" -f $architecture)
Add-ReportLine ("LatestFull: {0}" -f $latestFull)
Add-ReportLine ("StableFull: {0}" -f $stableFull)
Add-ReportLine ("TempUrl: {0}" -f $(if ($tempUrl) { $tempUrl } else { 'skipped for non-x64 system' }))
Add-ReportLine ("DirectUrl: {0}" -f $directUrl)

Add-ReportSection -Title 'Bootstrap check'
foreach ($item in $bootstrapResults) {
    Add-ReportLine ("Source: {0}" -f $item.Name)
    Add-ReportLine ("Url: {0}" -f $item.Url)
    Add-ReportLine ("Success: {0}" -f $item.Success)

    if ($item.Success) {
        Add-ReportLine ("StatusCode: {0}" -f $item.StatusCode)
        Add-ReportLine ("ContentLength: {0}" -f $item.Length)
    }
    else {
        Add-ReportLine ("Error: {0}" -f $item.Error)
    }

    Add-ReportLine
}

Invoke-CurlStep -Title 'curl version' -Arguments @('-V')

Invoke-PowerShellStep -Title 'DNS' -Action {
    Resolve-DnsName $downloadHost | Format-Table -AutoSize | Out-String -Width 4096
}

if ($tempUrl) {
    Invoke-CurlStep -Title 'HEAD temp' -Arguments @('-I', '-L', '-k', '--ssl-no-revoke', $tempUrl)
    Invoke-CurlStep -Title '1MB temp' -Arguments @('-L', '-k', '--ssl-no-revoke', '--fail-with-body', '--connect-timeout', '15', '-r', '0-1048575', '-o', 'NUL', '-D', '-', '-w', "`nHTTP_STATUS:%{http_code}`n", $tempUrl)
}
else {
    Add-ReportSection -Title 'HEAD temp'
    Add-ReportLine 'Skipped because temporary route is only used for x64 latest build'

    Add-ReportSection -Title '1MB temp'
    Add-ReportLine 'Skipped because temporary route is only used for x64 latest build'
}

Invoke-CurlStep -Title '1MB direct stable' -Arguments @('-L', '-k', '--ssl-no-revoke', '--fail-with-body', '--connect-timeout', '15', '-r', '0-1048575', '-o', 'NUL', '-D', '-', '-w', "`nHTTP_STATUS:%{http_code}`n", $directUrl)

Invoke-PowerShellStep -Title 'WebClient test' -Action {
    $webClientUrl = if ($tempUrl) { $tempUrl } else { $directUrl }
    $wc = New-Object System.Net.WebClient
    $stream = $null

    try {
        $stream = $wc.OpenRead($webClientUrl)
        $buffer = New-Object byte[] 1
        [void]$stream.Read($buffer, 0, 1)

        $lines = New-Object 'System.Collections.Generic.List[string]'
        $lines.Add('WEBCLIENT_OK') | Out-Null
        $lines.Add(("Url: {0}" -f $webClientUrl)) | Out-Null

        if ($wc.ResponseHeaders) {
            foreach ($headerName in $wc.ResponseHeaders.AllKeys) {
                $lines.Add(("{0}: {1}" -f $headerName, $wc.ResponseHeaders[$headerName])) | Out-Null
            }
        }

        $lines
    }
    finally {
        if ($stream) {
            $stream.Dispose()
        }

        $wc.Dispose()
    }
}

Write-Host
Write-Host 'Copy everything between the markers below and send it to SpotX support' -ForegroundColor Yellow
Write-Host '----- BEGIN DIAGNOSTICS -----' -ForegroundColor Cyan

foreach ($line in $reportLines) {
    Write-Output $line
}

Write-Host '----- END DIAGNOSTICS -----' -ForegroundColor Cyan
