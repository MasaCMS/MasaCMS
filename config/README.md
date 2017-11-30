# Global Configuration

## Primary Configuration Files

### settings.ini.cfm

Mura will dynamically generate an default settings.ini.cfm file in this directory.  This file contains Mura's configuration attributes.  Any settings.ini.cfm attribute will automatically be overridden by environment variables with the following format:

MURA_{attribute_name}

### cfapplication.cfm

Mura will dynamically generate an empty cfapplication.cfm file in this directory.  It gets included into Mura's Application.cfc files.  It can be a great place to put custom settings.

## Legacy Plugin Support

The following files are here to prevent legacy plugins from breaking.

* applicationSettings.cfc
* settings.cfm
* mappings.cfm
* ./appcfc
