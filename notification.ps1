#####################################################
# HelloID-Conn-Prov-Notification-GraphApi
# PowerShell Notification System
#####################################################

# Enable TLS1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

# Debug
# if (($actionContext.DryRun -eq $true) -and ($actionContext.TemplateConfiguration.scriptFlow -eq 'rawhtml')) {
#     $actionContext.TemplateConfiguration.MailFrom = 'noreply@helloid.com'
#     $actionContext.TemplateConfiguration.MailTo = 'to@helloid.com;secondTo@helloid.com'
#     $actionContext.TemplateConfiguration.MailCC = 'cc@helloid.com;secondCc@helloid.com'
#     $actionContext.TemplateConfiguration.MailBCC = 'bcc@helloid.com;secondBcc@helloid.com'
#     $actionContext.TemplateConfiguration.Subject = 'Debug subject HelloID'
#     $actionContext.TemplateConfiguration.Body = 'Debug body HelloID'
# }

#region functions
function Resolve-MicrosoftGraphAPIError {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object] $ErrorObject
    )
    process {
        $httpErrorObj = [PSCustomObject]@{
            ScriptLineNumber = $ErrorObject.InvocationInfo.ScriptLineNumber
            Line             = $ErrorObject.InvocationInfo.Line
            ErrorDetails     = $ErrorObject.Exception.Message
            FriendlyMessage  = $ErrorObject.Exception.Message
        }

        if (-not [string]::IsNullOrEmpty($ErrorObject.ErrorDetails.Message)) {
            $httpErrorObj.ErrorDetails = $ErrorObject.ErrorDetails.Message
        }
        elseif ($ErrorObject.Exception -is [System.Net.WebException] -and $ErrorObject.Exception.Response) {
            $streamReaderResponse = [System.IO.StreamReader]::new($ErrorObject.Exception.Response.GetResponseStream()).ReadToEnd()
            if (-not [string]::IsNullOrEmpty($streamReaderResponse)) {
                $httpErrorObj.ErrorDetails = $streamReaderResponse
            }
        }

        try {
            $errorObjectConverted = $httpErrorObj.ErrorDetails | ConvertFrom-Json -ErrorAction Stop

            if ($errorObjectConverted.error_description) {
                $httpErrorObj.FriendlyMessage = $errorObjectConverted.error_description
            }
            elseif ($errorObjectConverted.error) {
                $httpErrorObj.FriendlyMessage = $errorObjectConverted.error.message
                if ($errorObjectConverted.error.code) {
                    $httpErrorObj.FriendlyMessage += " Error code: $($errorObjectConverted.error.code)."
                }
                if ($errorObjectConverted.error.details) {
                    if ($errorObjectConverted.error.details.message) {
                        $httpErrorObj.FriendlyMessage += " Details message: $($errorObjectConverted.error.details.message)"
                    }
                    if ($errorObjectConverted.error.details.code) {
                        $httpErrorObj.FriendlyMessage += " Details code: $($errorObjectConverted.error.details.code)."
                    }
                }
            }
            else {
                $httpErrorObj.FriendlyMessage = $ErrorObject
            }
        }
        catch {
            $httpErrorObj.FriendlyMessage = $httpErrorObj.ErrorDetails
        }
        
        Write-Output $httpErrorObj
    }
}
#endregion functions

try {
    $actionMessage = "creating access token"
    $createAccessTokenBody = @{
        grant_type    = "client_credentials"
        client_id     = $actionContext.Configuration.AppId
        client_secret = $actionContext.Configuration.AppSecret
        resource      = "https://graph.microsoft.com"
    }
    $createAccessTokenSplatParams = @{
        Uri         = "https://login.microsoftonline.com/$($actionContext.Configuration.TenantID)/oauth2/token"
        Headers     = $headers
        Body        = $createAccessTokenBody
        Method      = "POST"
        ContentType = "application/x-www-form-urlencoded"
        Verbose     = $false
        ErrorAction = "Stop"
    }
    $createAccessTokenResonse = Invoke-RestMethod @createAccessTokenSplatParams

    $actionMessage = "creating headers"
    $headers = @{
        "Accept"          = "application/json"
        "Authorization"   = "Bearer $($createAccessTokenResonse.access_token)"
        "Content-Type"    = "application/json;charset=utf-8"
        "Mwp-Api-Version" = "1.0"     
    }

    switch ($actionContext.TemplateConfiguration.scriptFlow) {
        'rawhtml' {
            $actionMessage = "sending mail using scriptFlow [$($actionContext.TemplateConfiguration.scriptFlow)]"

            $mailFrom = $actionContext.TemplateConfiguration.MailFrom # Needs to be an existing mailbox in Office 365 (can be shared mailbox)
            $mailTo = @($actionContext.TemplateConfiguration.MailTo -split ';' | Where-Object { $_ })
            $mailCC = @($actionContext.TemplateConfiguration.MailCC -split ';' | Where-Object { $_ })
            $mailBCC = @($actionContext.TemplateConfiguration.MailBCC -split ';' | Where-Object { $_ })
            $mailSubject = $actionContext.TemplateConfiguration.Subject
            $mailBody = $actionContext.TemplateConfiguration.Body
            
            $sendMailBody = @{
                message = @{
                    subject      = $mailSubject
                    body         = @{
                        contentType = 'HTML'
                        content     = $mailBody
                    }
                    toRecipients = @($mailTo | ForEach-Object { @{ emailAddress = @{ address = $_ } } })
                }
            }
            if ($mailCC.Count -gt 0) { $sendMailBody.message.ccRecipients = @($mailCC | ForEach-Object { @{ emailAddress = @{ address = $_ } } }) }
            if ($mailBCC.Count -gt 0) { $sendMailBody.message.bccRecipients = @($mailBCC | ForEach-Object { @{ emailAddress = @{ address = $_ } } }) }

            $splatPostParams = @{
                Uri     = "https://graph.microsoft.com/v1.0/users/$mailFrom/sendMail"
                Method  = 'POST'
                Headers = $headers
                Body    = ($sendMailBody | ConvertTo-Json -Depth 10)
                Verbose = $false
            }

            if (-not($actionContext.DryRun -eq $true)) {
                $null = Invoke-RestMethod @splatPostParams
                $outputContext.AuditLogs.Add([PSCustomObject]@{
                        Message = "Successfully sent notification from [$mailFrom] to [$($mailTo -join ', ')] with subject [$mailSubject]"
                        IsError = $false
                    })
            }
            else {
                Write-Information "[DryRun] Sent notification from [$mailFrom] to [$($mailTo -join ', ')] with subject [$mailSubject], will be executed during enforcement"
            }
            break

        }
        default {
            $actionMessage = "retrieving scriptFlow [$($actionContext.TemplateConfiguration.scriptFlow)]"
            throw "Unknown scriptFlow [$($actionContext.TemplateConfiguration.scriptFlow)]"
            break
        }  
    }
    $outputContext.Success = $true
}
catch {
    $outputContext.Success = $false
    $ex = $PSItem
    if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException') -or
        $($ex.Exception.GetType().FullName -eq 'System.Net.WebException')) {
        $errorObj = Resolve-MicrosoftGraphAPIError -ErrorObject $ex
        $auditMessage = "Error $($actionMessage). Error: $($errorObj.FriendlyMessage)"
        $warningMessage = "Error at Line [$($errorObj.ScriptLineNumber)]: $($errorObj.Line). Error: $($errorObj.ErrorDetails)"
    }
    else {
        $auditMessage = "Error $($actionMessage). Error: $($ex.Exception.Message)"
        $warningMessage = "Error at Line [$($ex.InvocationInfo.ScriptLineNumber)]: $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    }
    Write-Warning $warningMessage
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Message = $auditMessage
        })
}