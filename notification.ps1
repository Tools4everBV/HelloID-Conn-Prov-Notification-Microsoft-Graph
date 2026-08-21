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
#     $actionContext.TemplateConfiguration.Subject = 'New Account Created - {{ person.name.nickName }}'
#     $actionContext.TemplateConfiguration.Body = '<p>Hello {{ person.primaryManager.displayName || "manager" }},</p><p>The following account has been created for your new employee {{ person.name.nickName }}</p><p><strong>Username:</strong> {{ data.samAccountName }}<br><strong>Password:</strong> {{ data.password || "No password" }}</p>'
# }

# HTML Email Template
# This is the base HTML structure for the email with placeholders for dynamic content
# Only modify this if you need to change the visual layout, colors, or structure of the email
# Placeholders: {{template-title}} and {{template-text}} will be replaced with actual content below
$bodyTemplate = @"
<!doctype html>
<html lang="und" dir="auto" xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
  <head>
    <title>
    </title>
    <!--[if !mso]><!-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--<![endif]-->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style type="text/css">
      #outlook a {
        padding:0;
      }
      body {
        margin:0;
        padding:0;
        -webkit-text-size-adjust:100%;
        -ms-text-size-adjust:100%;
      }
      table, td {
        border-collapse:collapse;
        mso-table-lspace:0pt;
        mso-table-rspace:0pt;
      }
      img {
        border:0;
        height:auto;
        line-height:100%;
        outline:none;
        text-decoration:none;
        -ms-interpolation-mode:bicubic;
      }
      p {
        display:block;
        margin:13px 0;
      }
    </style>
    <!--[if mso]>
<noscript>
<xml>
<o:OfficeDocumentSettings>
<o:AllowPNG/>
<o:PixelsPerInch>96</o:PixelsPerInch>
</o:OfficeDocumentSettings>
</xml>
</noscript>
<![endif]-->
    <!--[if lte mso 11]>
<style type="text/css">
.mj-outlook-group-fix { width:100% !important; }
</style>
<![endif]-->
    <!--[if !mso]><!-->
    <link href="https://fonts.googleapis.com/css?family=Ubuntu:300,400,500,700" rel="stylesheet" type="text/css">
    <style type="text/css">
      @import url(https://fonts.googleapis.com/css?family=Ubuntu:300,400,500,700);
    </style>
    <!--<![endif]-->
    <style type="text/css">
      @media only screen and (min-width:480px) {
        .mj-column-per-100 {
          width:100% !important;
          max-width: 100%;
        }
        .mj-column-per-25 {
          width:25% !important;
          max-width: 25%;
        }
        .mj-column-per-75 {
          width:75% !important;
          max-width: 75%;
        }
      }
    </style>
    <style media="screen and (min-width:480px)">
      .moz-text-html .mj-column-per-100 {
        width:100% !important;
        max-width: 100%;
      }
      .moz-text-html .mj-column-per-25 {
        width:25% !important;
        max-width: 25%;
      }
      .moz-text-html .mj-column-per-75 {
        width:75% !important;
        max-width: 75%;
      }
    </style>
    <style type="text/css">
      @media only screen and (max-width:479px) {
        table.mj-full-width-mobile {
          width: 100% !important;
        }
        td.mj-full-width-mobile {
          width: auto !important;
        }
      }
    </style>
  </head>
  <body style="word-spacing:normal;background-color:#E7E7E7;">
    <div
         aria-roledescription="email" style="background-color:#E7E7E7;" role="article" lang="und" dir="auto"
         >
      <!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" class="" role="presentation" style="width:600px;" width="600" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
      <div  style="margin:0px auto;max-width:600px;">
        <table
               align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;"
               >
          <tbody>
            <tr>
              <td
                  style="direction:ltr;font-size:0px;padding:20px 0;text-align:center;"
                  >
                <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:600px;" ><![endif]-->
                <div
                     class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"
                     >
                  <table
                         border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"
                         >
                    <tbody>
                    </tbody>
                  </table>
                </div>
                <!--[if mso | IE]></td></tr></table><![endif]-->
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <!--[if mso | IE]></td></tr></table><table align="center" border="0" cellpadding="0" cellspacing="0" class="" role="presentation" style="width:600px;" width="600" bgcolor="#4a8fca" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
      <div  style="background:#4a8fca;background-color:#4a8fca;margin:0px auto;max-width:600px;">
        <table
               align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="background:#4a8fca;background-color:#4a8fca;width:100%;"
               >
          <tbody>
            <tr>
              <td
                  style="direction:ltr;font-size:0px;padding:20px 0;padding-bottom:0;padding-top:0;text-align:center;"
                  >
                <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:150px;" ><![endif]-->
                <div
                     class="mj-column-per-25 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"
                     >
                  <table
                         border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"
                         >
                    <tbody>
                      <tr>
                        <td
                            align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"
                            >
                          <table
                                 border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:collapse;border-spacing:0px;"
                                 >
                            <tbody>
                              <tr>
                                <td  style="width:50px;">
                                  <img
                                       alt="" src="https://tools4ever.helloid.com/appearance/companyicon" style="border:0;display:block;outline:none;text-decoration:none;height:50px;width:100%;font-size:13px;" width="50" height="50"
                                       />
                                </td>
                              </tr>
                            </tbody>
                          </table>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <!--[if mso | IE]></td><td class="" style="vertical-align:top;width:450px;" ><![endif]-->
                <div
                     class="mj-column-per-75 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"
                     >
                  <table
                         border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"
                         >
                    <tbody>
                      <tr>
                        <td
                            align="left" style="font-size:0px;padding:10px 25px;padding-top:25px;padding-bottom:25px;word-break:break-word;"
                            >
                          <div
                               style="font-family:Arial, Helvetica, sans-serif;font-size:14px;line-height:1;text-align:left;color:#FFFFFF;"
                               >
                            <b>{{template-title}}
                              <br/> 
                            </b>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <!--[if mso | IE]></td></tr></table><![endif]-->
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <!--[if mso | IE]></td></tr></table><table align="center" border="0" cellpadding="0" cellspacing="0" class="" role="presentation" style="width:600px;" width="600" bgcolor="#FFFFFF" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
      <div  style="background:#FFFFFF;background-color:#FFFFFF;margin:0px auto;max-width:600px;">
        <table
               align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="background:#FFFFFF;background-color:#FFFFFF;width:100%;"
               >
          <tbody>
            <tr>
              <td
                  style="direction:ltr;font-size:0px;padding:20px 0;text-align:center;"
                  >
                <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:600px;" ><![endif]-->
                <div
                     class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"
                     >
                  <table
                         border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"
                         >
                    <tbody>
                      <tr>
                        <td
                            align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"
                            >
                          <div
                               style="font-family:Ubuntu, Helvetica, Arial, sans-serif;font-size:13px;line-height:1;text-align:left;color:#000000;"
                               >{{template-text}}
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <!--[if mso | IE]></td></tr></table><![endif]-->
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <!--[if mso | IE]></td></tr></table><table align="center" border="0" cellpadding="0" cellspacing="0" class="" role="presentation" style="width:600px;" width="600" bgcolor="#ffffff" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
      <div  style="background:#ffffff;background-color:#ffffff;margin:0px auto;max-width:600px;">
        <table
               align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="background:#ffffff;background-color:#ffffff;width:100%;"
               >
          <tbody>
            <tr>
              <td
                  style="direction:ltr;font-size:0px;padding:20px 0;text-align:center;"
                  >
                <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:600px;" ><![endif]-->
                <div
                     class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"
                     >
                  <table
                         border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"
                         >
                    <tbody>
                      <tr>
                        <td
                            align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"
                            >
                          <div
                               style="font-family:Arial, Helvetica, sans-serif;font-size:12px;line-height:1;text-align:center;color:#999999;"
                               >This is an automatically generated message.
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <!--[if mso | IE]></td></tr></table><![endif]-->
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <!--[if mso | IE]></td></tr></table><![endif]-->
    </div>
  </body>
</html>
"@

# Replace both placeholders in the template with the actual content
$mailBody = $bodyTemplate -replace "{{template-title}}", $actionContext.TemplateConfiguration.Subject -replace "{{template-text}}", $actionContext.TemplateConfiguration.Body

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