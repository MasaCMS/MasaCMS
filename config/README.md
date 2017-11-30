# Global Configuration

## Primary Configuration Files

### settings.ini.cfm

Mura will dynamically generate an default settings.ini.cfm file in this directory.  This file contains Mura's configuration attributes.  Any settings.ini.cfm attribute will automatically be overridden by environment variables with the following format:

MURA_{attribute_name}

### cfapplication.cfm

Mura will dynamically generate an empty cfapplication.cfm file in this directory.  It gets included into Mura's Application.cfc files.  It can be a great place to put custom settings.

## Legacy Plugin Support

In Mura 7.1 Application.cfc lifecycle files have been moved to (https://github.com/blueriver/MuraCMS/tree/7.1/core/appcfc).  If this causes issues with legacy plugins and updating the plugins is problematic you can a add the following settings.ini.cfm or environment variable and reload.  Mura will then add stub files back that simply include the files in the new location.

### settings.ini.cfm

legacyAppcfcSupport=true

### Environment Variable

MURA_LEGACYAPPCFCSUPPORT="true"
