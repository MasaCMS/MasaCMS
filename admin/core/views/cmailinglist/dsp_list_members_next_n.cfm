<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

 <cfif rc.nextN.numberofpages gt 1>
 <cfoutput>
		<cfset args=arrayNew(1)>
		<cfset args[1]="#rc.nextn.startrow#-#rc.nextn.through#">
		<cfset args[2]=rc.nextn.totalrecords>
		<div class="mura-results-wrapper">
		<p class="clearfix search-showing">
			#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.paginationmeta"),args)#
		</p>
		<div class="pagination"> 
		<ul>
		<cfif rc.nextN.currentpagenumber gt 1> 
			<li>
				<a href="./?muraAction=cMailingList.listmembers&mlid=#rc.mlid#&startrow=#rc.nextN.previous#&siteid=#esapiEncode('url',rc.siteid)#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.prev')#</a>
			</li>
		</cfif>	
		<cfloop from="1"  to="#rc.nextN.lastPage#" index="i">
			<cfif rc.nextN.currentpagenumber eq i> 
				<li class="active"><a href="##">#i#</a></li> 
			<cfelse> 
				<li>
				<a href="./?muraAction=cMailingList.listmembers&mlid=#rc.mlid#&startrow=#evaluate('(#i#*#rc.nextN.recordsperpage#)-#rc.nextN.recordsperpage#+1')#&siteid=#esapiEncode('url',rc.siteid)#">#i#</a> 
				</li>
			</cfif>
		</cfloop>
		<cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages>
			<li><a href="./?muraAction=cMailingList.listmembers&mlid=#rc.mlid#&startrow=#rc.nextN.next#&siteid=#esapiEncode('url',rc.siteid)#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.next')#&nbsp;&raquo;</a></li>
		</cfif> 
		</ul>
		</div>
		</div>		
</cfoutput>
</cfif>