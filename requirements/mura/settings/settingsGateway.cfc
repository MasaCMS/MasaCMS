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
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
<cfreturn this />
</cffunction>

<cffunction name="getList" access="public" output="false" returntype="query">
	<cfset var rs = "" />

	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" cachedwithin="#createtimespan(1,0,0,0)#"  >
	select * from tsettings order by orderno, site
	</cfquery>
	
	<cfreturn rs />
	
</cffunction>

</cfcomponent>