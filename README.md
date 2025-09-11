# HelloID-Conn-Prov-Notification-Microsoft-Graph

> [!IMPORTANT]
> Please be aware that the notifications only can be triggered by [events](https://docs.helloid.com/en/provisioning/notifications--provisioning-/notification-events--provisioning-.html) and cannot be used as entitlements.

> [!IMPORTANT]
> This repository contains the connector and configuration code only. The implementer is responsible to acquire the connection details such as username, password, certificate, etc. You might even need to sign a contract or agreement with the supplier before implementing this connector. Please contact the client's application manager to coordinate the connector requirements.

<p align="center"> 
  <img src="https://raw.githubusercontent.com/Tools4everBV/HelloID-Conn-Prov-Notification-Microsoft-Graph/refs/heads/main/Logo.png">
</p>

## Table of Contents

- [HelloID-Conn-Prov-Notification-Microsoft-Graph](#helloid-conn-prov-notification-microsoft-graph)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Connection settings](#connection-settings)
  - [Templates](#templates)
    - [rawhtml](#rawhtml)
  - [Getting help](#getting-help)
  - [HelloID Docs](#helloid-docs)

## Requirements

1. **HelloID Environment**:
   - Set up your _HelloID_ environment.
   - Install the _HelloID_ Provisioning agent (cloud or on-prem).
1. **Graph API Credentials**:
   - Create an **App Registration** in Microsoft Entra ID.
   - Add API permissions for your app:
     - **Microsoft Graph: Application permissions**:
       - `Mail.Send`
   - Create access credentials for your app:
     - Create a **client secret** for your app.

## Connection settings

The following settings are required to connect to the API.

| Setting                                  | Description                                                     | Mandatory |
| ---------------------------------------- | --------------------------------------------------------------- | --------- |
| App Registration Directory (tenant) ID   | The ID to the Tenant in Microsoft Entra ID                      | Yes       |
| App Registration Application (client) ID | The ID to the App Registration in Microsoft Entra ID            | Yes       |
| App Registration Client Secret           | The Client Secret to the App Registration in Microsoft Entra ID | Yes       |

## Templates
### rawhtml
The table below describes the different form fields from the template.

| template key | Description                                                                                       | Mandatory |
| ------------ | ------------------------------------------------------------------------------------------------- | --------- |
| scriptFlow   | Fixed value "rawhtml" (read-only)                                                                 | Yes       |
| MailFrom     | Enter sender email address. Needs to be an existing mailbox in Office 365 (can be shared mailbox) | Yes       |
| MailTo       | Enter email address, for multiple email addresses use ;                                           | Yes       |
| MailCC       | Enter a cc email address, for multiple email addresses use ;f                                     |           |
| MailBCC      | Enter a bcc email address, for multiple email addresses use ;                                     |           |
| Subject      | Please enter email subject                                                                        | Yes       |
| Body         | Please enter email message (raw html)                                                             | Yes       |

> [!NOTE]
> If the `Body` textarea exceeds the [performance limits](https://docs.helloid.com/en/provisioning/performance-limits--provisioning-.html#notifications--performance-limits-), we recommend building your own template that includes HTML in the body using PowerShell.

## Getting help
> _For more information on how to configure a HelloID PowerShell connector, please refer to our [documentation](https://docs.helloid.com/hc/en-us/articles/360012518799-How-to-add-a-target-system) pages_

> _If you need help, feel free to ask questions on our [forum](https://forum.helloid.com)_

## HelloID Docs
The official HelloID documentation can be found at: https://docs.helloid.com/
