<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<cfsilent>
	<cfparam name="request.parentcommentid" default="" />
	<cfquery name="request.rsSubComments#variables.level#" dbtype="query">
		SELECT *
		FROM rsComments
		WHERE
			<cfif len(request.parentcommentid)>
				parentID = <cfqueryparam value="#request.parentcommentid#" cfsqltype="cf_sql_varchar" maxlength="35">
			<cfelse>
				parentID IS NULL
			</cfif>
	</cfquery>
</cfsilent>

<cfif request['rsSubComments#variables.level#'].recordcount>
	<cfoutput query="request.rsSubComments#variables.level#" startrow="#request.startrow#">
		<cfset request.parentcommentid = request['rsSubComments#variables.level#'].commentid />
		<cfset class=iif(request['rsSubComments#variables.level#'].currentrow eq 1,de('first'),de(iif(request['rsSubComments#variables.level#'].currentrow eq request['rsSubComments#variables.level#'].recordcount,de('last'),de('')))) />
		<cfif variables.level>
			<cfset class = class & iif(level lt 10,de(" indent-#variables.level#"),de(" indent-10")) />
		</cfif>
		#$.dspObject_Include(thefile='comments_nested/dsp_comment.cfm', currentrow=request['rsSubComments#variables.level#'].currentrow)#
		<cfif request['rsSubComments#variables.level#'].kids neq ''>
			<cfset variables.level = variables.level+1 />
			#$.dspObject_Include(thefile='comments_nested/dsp_comments.cfm')#
			<cfset variables.level = variables.level-1 />
		</cfif>
	</cfoutput>
</cfif>
