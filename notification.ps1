#####################################################
# HelloID-Conn-Prov-Notification-GraphApi
#
# Version: 1.0.0
#####################################################

# Initialize default values
$success = $false

# Enable TLS1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

# Set debug logging
switch ($($actionContext.Configuration.IsDebug)) {
    $true { $VerbosePreference = 'Continue' }
    $false { $VerbosePreference = 'SilentlyContinue' }
}

# Used to connect to Azure AD Graph API
# App Registration requires Mail.Send permissions. For more info see: https://docs.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http

#connect parameters
$AADtenantID = $actionContext.Configuration.AADtenantID 
$AADAppId = $actionContext.Configuration.AADAppId 
$AADAppSecret = $actionContext.Configuration.AADAppSecret

# Send mail parameters
$mailFrom = $actionContext.TemplateConfiguration.MailFrom  # Needs to be an existing mailbox in Office 365 (can be shared mailbox)
$mailTo = $actionContext.TemplateConfiguration.MailTo
$mailCC = @()
$mailBCC = @()

$mailSubject = $actionContext.TemplateConfiguration.Subject
$mailBody = $actionContext.TemplateConfiguration.Body

if (-Not($actionContext.DryRun -eq $true)) {
    # Write notification logic here

    if ($actionContext.TemplateConfiguration.scriptFlow -eq "one") {
        try {
            Write-Verbose "Generating Microsoft Graph API Access Token"

            $baseAuthUri = "https://login.microsoftonline.com/"
            $authUri = $baseAuthUri + "$AADTenantID/oauth2/token"

            $body = @{
                grant_type    = "client_credentials"
                client_id     = "$AADAppId"
                client_secret = "$AADAppSecret"
                resource      = "https://graph.microsoft.com"
            }

            $Response = Invoke-RestMethod -Method POST -Uri $authUri -Body $body -ContentType 'application/x-www-form-urlencoded'
            $accessToken = $Response.access_token

            #Add the authorization header to the request
            $authorization = @{
                Authorization  = "Bearer $accesstoken"
                'Content-Type' = "application/json"
                Accept         = "application/json"
            }
         
            Write-Verbose "Sending mail to '$($mailTo)', CC '$($mailCC)', BCC '$($mailBCC)', with subject '$($mailSubject)'"

            $baseGraphUri = "https://graph.microsoft.com/"
            $sendMailUri = $baseGraphUri + "/v1.0/users/$($mailFrom)/sendMail"

            $sendMailBody = (
                @{
                    "message" = @{
                        "subject"       = $mailSubject
                        "body"          = @{
                            "contentType" = 'HTML'
                            "content"     = $mailBody
                        }
                        "toRecipients"  = @(
                            $mailTo | ForEach-Object {
                                @{
                                    "emailAddress" = @{
                                        "address" = $_
                                    }
                                }
                            }
                        )
                        "ccRecipients"  = @(
                            $mailCC | ForEach-Object {
                                @{
                                    "emailAddress" = @{
                                        "address" = $_
                                    }
                                }
                            }
                        )
                        "bccRecipients" = @(
                            $mailBCC | ForEach-Object {
                                @{
                                    "emailAddress" = @{
                                        "address" = $_
                                    }
                                }
                            }
                        )
                    }
                }
            ) | ConvertTo-Json -Depth 10

            $sendMail = Invoke-RestMethod -Uri $sendMailUri -Method Post -Body $sendMailBody -Headers $authorization -Verbose:$false

            # Write-Information "Succesfully sent mail to '$($mailTo)', CC '$($mailCC)', BCC '$($mailBCC)', with subject '$($mailSubject)'"
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                    Message = "Sending notification [$($actionContext.TemplateConfiguration.scriptFlow)] for [$($personContext.Person.DisplayName)] was successful."
                    IsError = $false
                })
        }
        catch {
            $ex = $PSItem
            $verboseErrorMessage = $ex
            Write-Verbose "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($verboseErrorMessage)"
            $auditErrorMessage = $ex.exception.message
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                    Message = "Sending notification [$($actionContext.TemplateConfiguration.scriptFlow)] for [$($personContext.Person.DisplayName)] was unsuccessful reason [$($auditErrorMessage)]."
                    IsError = $true
                })
            #throw "Error sending mail to '$($mailTo)', CC '$($mailCC)', BCC '$($mailBCC)', with subject '$($mailSubject)'. Error message: $($auditErrorMessage)"
        }
        finally {
            # Check if auditLogs contains errors, if no errors are found, set success to true
            if (-NOT($outputContext.AuditLogs.isError -contains $true)) {
                $success = $true
            }
            $outputContext.Success = $success
        }
    }
    
    else {
        # Execute script flow two
    }
}
else {
    #  dryrun logic
   
    # Add an auditMessage showing what will happen during enforcement
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Message = "Sending notification [$($actionContext.TemplateConfiguration.scriptFlow)] for: [$($personContext.Person.DisplayName)], will be executed during enforcement"
        })
}

