# Change Log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.0.0] - 2026-08-21

This is the first official release of HelloID-Conn-Prov-Notification-Microsoft-Graph. This connector sends email notifications through Microsoft 365 using the Microsoft Graph API with rich HTML email templates.

### Added

- Microsoft Graph Mail API integration for sending email notifications
- OAuth2 client credentials flow authentication using App Registration
- HTML email template with professional styling including:
  - Responsive design optimized for desktop and mobile email clients
  - Company logo support (configurable via HelloID branding settings)
  - Clean header with blue accent color (#4a8fca)
  - Professional typography using Ubuntu/Helvetica/Arial fonts
- Support for HelloID template variables in email content (Subject, Body, To, CC, BCC)
- Multiple recipient support for To, CC, and BCC fields (semicolon-separated)
- Raw HTML content support in Body field for custom formatting
- Template configuration file (`template_rawhtml.json`) with form field definitions
- Connection settings for App Registration (Tenant ID, Client ID, Client Secret)
- Comprehensive README documentation including:
  - HelloID Icon URL section
  - Requirements section with Microsoft Entra ID setup instructions
  - Connection settings table with examples
  - Template field descriptions
  - Remarks sections covering HTML template structure, sender mailbox requirements
- Debug mode with example HTML email template using HelloID variables
- Error handling with detailed Microsoft Graph API error resolution

### Changed

### Fixed

- Email addresses are now trimmed when splitting multiple recipients (To, CC, BCC fields). This prevents leading/trailing whitespace from causing invalid email addresses when users enter addresses like `email1@test.com; email2@test.com` (with space after semicolon)

### Removed
