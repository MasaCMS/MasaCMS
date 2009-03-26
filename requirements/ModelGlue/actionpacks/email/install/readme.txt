<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


Model-Glue ActionPack:  E-mail Service

Description
-------------------------------------------------------------------------------
This ActionPack provides a configurable e-mail service.  It's superior to using
the <cfmail> tag in that it's easy to configure it for "development" or 
"production" modes.  When in "development" mode, all e-mails are routed to 
whatever e-mail addreses are defined as "developer" addresses - so you'll
never accidently e-mail your customers from your development server again!


Requirements
-------------------------------------------------------------------------------
No other ActionPacks are required for this to run.   


Installation
-------------------------------------------------------------------------------
To use this ActionPack in a Model-Glue:Unity application, you need to do two
things:

1.  Copy the contents of config/Beans.xml into your application's ColdSpring.xml
file, then edit the various values to match your e-mail configuration.  They're
both self explanatory and commented.

2.  Add the following at the top of your application's ModelGlue.xml file, just
after the <modelglue> tag:

<include template="/ModelGlue/actionpacks/email/config/ModelGlue.xml" />

That's it!



Use
-------------------------------------------------------------------------------
This ActionPack adds a value to the viewstate on each request named "EmailService."

To use it inside of a controller to send an e-mail:

<cfset var svc = arguments.event.getValue("emailService") />
<cfset var email = svc.createEmail() />

<!--- 
	See model/Email.cfc for all values that can be set and how to add 
	attachments
--->
<cfset email.setTo("somebody@localhost") />
<cfset email.setSubject("Test") />
<cfset email.send() />

To use the service inside of another ColdSpring-based service, wire the service
to the new "EmailService" bean in ColdSpring.xml.


