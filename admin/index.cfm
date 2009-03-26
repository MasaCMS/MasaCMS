<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfset FUSEBOX_APPLICATION_KEY = "primaryAdmin" />
<cfset FUSEBOX_PARAMETERS.allowImplicitFusebox = true />
<cfset FUSEBOX_PARAMETERS.allowImplicitCircuits = true />
<cfset FUSEBOX_PARAMETERS.defaultFuseaction = "home.redirect" />
<cfset FUSEBOX_PARAMETERS.password = application.appreloadkey />
<cfset FUSEBOX_PARAMETERS.mode = "production" />
<cfinclude template="/fusebox5/fusebox5.cfm" />