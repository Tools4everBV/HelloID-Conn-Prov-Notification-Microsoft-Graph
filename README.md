# HelloID-Conn-Prov-Notification-Microsoft-Graph

| :information_source: Important |
|:---| 
| Please be aware that the notifications only can be triggered by [events](https://docs.helloid.com/en/provisioning/notifications--provisioning-/notification-events--provisioning-.html) and cannot be used as entitlements. |

| :information_source: Important |
|:---|
| This repository contains the connector and configuration code only. The implementer is responsible to acquire the connection details such as username, password, certificate, etc. You might even need to sign a contract or agreement with the supplier before implementing this connector. Please contact the client's application manager to coordinate the connector requirements. |

<p align="center">
  <img src="https://raw.githubusercontent.com/Tools4everBV/HelloID-Conn-Prov-Notification-Microsoft-Graph/refs/heads/main/Logo.png">
</p>

## Table of contents

- [HelloID-Conn-Prov-Notification-Microsoft-Graph](#helloid-conn-prov-notification-microsoft-graph)
  - [Table of contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Getting started](#getting-started)
    - [HelloID Icon URL](#helloid-icon-url)
    - [Requirements](#requirements)
    - [Connection settings](#connection-settings)
    - [Templates](#templates)
      - [rawhtml](#rawhtml)
  - [Remarks](#remarks)
    - [HTML email template](#html-email-template)
    - [Sender mailbox requirements](#sender-mailbox-requirements)
  - [Getting help](#getting-help)
  - [HelloID docs](#helloid-docs)

## Introduction

HelloID-Conn-Prov-Notification-Microsoft-Graph is a notification connector. Microsoft Graph provides a set of REST APIs that allow you to programmatically interact with its data. The [Microsoft Graph Mail API documentation](https://learn.microsoft.com/en-us/graph/api/user-sendmail) provides details of API commands that are used.

This connector sends email notifications through Microsoft 365 using the Microsoft Graph API. The connector supports rich HTML email templates with customizable styling and HelloID template variables for dynamic content.

## Getting started

### HelloID Icon URL

URL of the icon used for the HelloID Provisioning notification system.

```
https://raw.githubusercontent.com/Tools4everBV/HelloID-Conn-Prov-Notification-Microsoft-Graph/refs/heads/main/Icon.png
```

### Requirements

Before implementing this connector, ensure the following requirements are met:

**Microsoft Entra ID (Azure AD) Requirements:**

- **App Registration** in Microsoft Entra ID with the following configuration:
  - **Application (client) ID** - Provided by Microsoft Entra ID after app registration
  - **Directory (tenant) ID** - The tenant ID of your Microsoft 365 organization
  - **Client Secret** - Created in the app registration for authentication
  
- **API Permissions** configured on the App Registration:
  - **Microsoft Graph: Application permissions**:
    - `Mail.Send` - Required to send emails on behalf of any user

| :memo: Note |
|:---|
| Application permissions allow the connector to send emails from any mailbox without user interaction. Ensure the app registration is secured and only accessible by authorized administrators. |

**Mailbox Requirements:**

- The sender email address (`MailFrom`) must be an existing mailbox in Microsoft 365
- The mailbox can be a user mailbox or a shared mailbox
- The mailbox must be licensed (Exchange Online license required)

**HelloID Environment:**

- HelloID environment configured
- HelloID Provisioning agent installed (cloud or on-premises)

| :bulb: Tip |
|:---|
| For more information on creating an App Registration in Microsoft Entra ID, please refer to the [Microsoft documentation](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app). |

### Connection settings

The following settings are required to connect to the API.

| Setting                                  | Description                                                                                         | Mandatory | Example                                  |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------- | --------- | ---------------------------------------- |
| App Registration Directory (tenant) ID   | The Directory (tenant) ID of your Microsoft 365 organization. Found in the app registration overview. | Yes       | 12345678-1234-1234-abcd-123456789abc     |
| App Registration Application (client) ID | The Application (client) ID of the app registration. Found in the app registration overview.        | Yes       | 9c15a9b1-2175-678d-1234-8a790199d46d     |
| App Registration Client Secret           | The client secret value created in the app registration certificates & secrets section.              | Yes       | (secret value)                           |

### Templates

#### rawhtml

To create a notification using HTML email, use the following template: [template_rawhtml.json](https://github.com/Tools4everBV/HelloID-Conn-Prov-Notification-Microsoft-Graph/blob/main/template_rawhtml.json).

The table below describes the different form fields from the template.

| Template Key | Description                                                                                                                     | Mandatory | Example                                  |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------- | --------- | ---------------------------------------- |
| scriptFlow   | Fixed value `rawhtml` (read-only)                                                                                               | Yes       | rawhtml                                  |
| MailFrom     | The sender email address. Must be an existing mailbox (user or shared) in Microsoft 365 with send permissions.                  | Yes       | noreply@company.com                      |
| MailTo       | Recipient email address(es). Multiple addresses can be separated with semicolons (`;`). Supports HelloID template variables.    | Yes       | user@company.com;manager@company.com     |
| MailCC       | CC recipient email address(es). Multiple addresses can be separated with semicolons (`;`). Supports HelloID template variables. | No        | team@company.com                         |
| MailBCC      | BCC recipient email address(es). Multiple addresses can be separated with semicolons (`;`). Supports HelloID template variables.| No        | audit@company.com                        |
| Subject      | The email subject line. Supports HelloID template variables.                                                                    | Yes       | New Account - {{ person.name.nickName }} |
| Body         | The email body content in raw HTML format. Supports HelloID template variables. Maximum 2063 characters.                        | Yes       | `<p>Hello {{ person.primaryManager.displayName }},</p>` |

| :warning: Important |
|:---|
| Please keep in mind that the key form field names in the templates are used in the notification.ps1. Changing them will break the connector. |

| :bulb: Tip |
|:---|
| It is possible to hide or disable (make them read-only) certain form fields if they are not used or should not be changed. For example, if the sender address should always be `noreply@company.com`, you can set `"disabled": true` and `"hide": true` in the template configuration. |

| :memo: Note |
|:---|
| The `Body` textarea has a performance limit of 2063 characters. |

## Remarks

### HTML email template

The connector includes a built-in HTML email template with professional styling. The template features:

- Responsive design optimized for desktop and mobile email clients
- Company logo (configurable via HelloID branding settings)
- Clean header with blue accent color (#4a8fca)
- Professional typography using Ubuntu/Helvetica/Arial fonts
- Proper email structure with MIME types for maximum compatibility

The template uses two placeholders that are automatically replaced:

- `{{template-title}}` - Replaced with the configured `Subject`
- `{{template-text}}` - Replaced with the configured `Body` (raw HTML content)

| :bulb: Tip |
|:---|
| The Body field accepts raw HTML, allowing you to use formatting like `<p>`, `<strong>`, `<br>`, `<ul>`, `<li>`, etc. The built-in template provides the outer email structure, while you control the main content area. |

### Sender mailbox requirements

The Microsoft Graph API requires that the sender email address (`MailFrom`) corresponds to an actual mailbox in Microsoft 365:

- **User mailboxes**: Regular user accounts with Exchange Online licenses
- **Shared mailboxes**: Shared mailboxes are supported and recommended for notification scenarios

| :memo: Note |
|:---|
| Unlike SMTP-based solutions, Microsoft Graph does not support sending from arbitrary email addresses. The sender must be a real mailbox in your organization. |

| :bulb: Tip |
|:---|
| For notification scenarios, we recommend using a shared mailbox (e.g., `noreply@company.com` or `helloid@company.com`) rather than a personal user mailbox. |

## Getting help

| :bulb: Tip |
|:---|
| For more information on how to configure a HelloID PowerShell notification connector, please refer to our [documentation](https://docs.helloid.com/en/provisioning/notifications--provisioning-/notification-systems--provisioning-/powershell-notification-systems--provisioning-/add,-edit,-or-remove-a-powershell-notification-system.html) pages. |

## HelloID docs

The official HelloID documentation can be found at: https://docs.helloid.com/
