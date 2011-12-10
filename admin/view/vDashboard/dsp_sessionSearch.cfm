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

<cfsilent>
<cfhtmlhead text="#session.dateKey#">
<cfset userOptions=arrayNew(2) />
<cfset sessionOptions=arrayNew(2) />
<cfset criterias=arrayNew(2) />

<cfset userOptions[1][1]="tusers.fname^varchar">
<cfset userOptions[1][2]=application.rbFactory.getKeyValue(session.rb,"params.firstname")>
<cfset userOptions[2][1]="tusers.lname^varchar">
<cfset userOptions[2][2]=application.rbFactory.getKeyValue(session.rb,"params.lastname")>
<cfset userOptions[3][1]="tusers.username^varchar">
<cfset userOptions[3][2]=application.rbFactory.getKeyValue(session.rb,"params.username")>
<cfset userOptions[4][1]="tusers.email^varchar">
<cfset userOptions[4][2]=application.rbFactory.getKeyValue(session.rb,"params.email")>
<cfset userOptions[5][1]="tusers.company^varchar">
<cfset userOptions[5][2]=application.rbFactory.getKeyValue(session.rb,"params.company")>
<cfset userOptions[6][1]="tusers.jobTitle^varchar">
<cfset userOptions[6][2]=application.rbFactory.getKeyValue(session.rb,"params.jobtitle")>
<cfset userOptions[7][1]="tusers.website^varchar">
<cfset userOptions[7][2]=application.rbFactory.getKeyValue(session.rb,"params.website")>
<cfset userOptions[8][1]="tusers.IMName^varchar">
<cfset userOptions[8][2]=application.rbFactory.getKeyValue(session.rb,"params.imname")>
<cfset userOptions[9][1]="tusers.IMService^varchar">
<cfset userOptions[9][2]=application.rbFactory.getKeyValue(session.rb,"params.imservice")>
<cfset userOptions[10][1]="tusers.mobilePhone^varchar">
<cfset userOptions[10][2]=application.rbFactory.getKeyValue(session.rb,"params.mobilephone")>
<cfset userOptions[11][1]="tuseraddresses.address1^varchar">
<cfset userOptions[11][2]=application.rbFactory.getKeyValue(session.rb,"params.address1")>
<cfset userOptions[12][1]="tuseraddresses.address2^varchar">
<cfset userOptions[12][2]=application.rbFactory.getKeyValue(session.rb,"params.address2")>
<cfset userOptions[13][1]="tuseraddresses.city^varchar">
<cfset userOptions[13][2]=application.rbFactory.getKeyValue(session.rb,"params.city")>
<cfset userOptions[14][1]="tuseraddresses.state^varchar">
<cfset userOptions[14][2]=application.rbFactory.getKeyValue(session.rb,"params.state")>
<cfset userOptions[15][1]="tuseraddresses.Zip^varchar">
<cfset userOptions[15][2]=application.rbFactory.getKeyValue(session.rb,"params.zip")>
<cfset userOptions[16][1]="tusers.created^date">
<cfset userOptions[16][2]=application.rbFactory.getKeyValue(session.rb,"params.created")>
<cfset options[10][1]="tusers.tags^varchar">
<cfset options[10][2]=application.rbFactory.getKeyValue(session.rb,"params.tag")>

<cfset sessionOptions[1][1]="tsessiontracking.remote_addr^varchar">
<cfset sessionOptions[1][2]=application.rbFactory.getKeyValue(session.rb,"params.remoteaddress")>
<cfset sessionOptions[2][1]="tsessiontracking.query_string^varchar">
<cfset sessionOptions[2][2]=application.rbFactory.getKeyValue(session.rb,"params.querystring")>
<cfset sessionOptions[3][1]="tsessiontracking.user_agent^varchar">
<cfset sessionOptions[3][2]=application.rbFactory.getKeyValue(session.rb,"params.useragent")>
<cfset sessionOptions[4][1]="tsessiontracking.referer^varchar">
<cfset sessionOptions[4][2]=application.rbFactory.getKeyValue(session.rb,"params.referer")>
<cfset sessionOptions[5][1]="tsessiontracking.locale^varchar">
<cfset sessionOptions[5][2]=application.rbFactory.getKeyValue(session.rb,"params.locale")>
<cfset sessionOptions[6][1]="tsessiontracking.keywords^varchar">
<cfset sessionOptions[6][2]=application.rbFactory.getKeyValue(session.rb,"params.keywords")>

<cfset contentOptions[1][1]="tcontent.Title^varchar">
<cfset contentOptions[1][2]=application.rbFactory.getKeyValue(session.rb,"params.title")>
<cfset contentOptions[2][1]="tcontent.menuTitle^varchar">
<cfset contentOptions[2][2]=application.rbFactory.getKeyValue(session.rb,"params.menutitle")>
<cfset contentOptions[3][1]="tcontent.summary^longvarchar">
<cfset contentOptions[3][2]=application.rbFactory.getKeyValue(session.rb,"params.summary")>

<cfset criterias[1][1]="Equals">
<cfset criterias[1][2]=application.rbFactory.getKeyValue(session.rb,"params.equals")>
<cfset criterias[2][1]="GT">
<cfset criterias[2][2]=application.rbFactory.getKeyValue(session.rb,"params.gt")>
<cfset criterias[3][1]="GTE">
<cfset criterias[3][2]=application.rbFactory.getKeyValue(session.rb,"params.gte")>
<cfset criterias[4][1]="LT">
<cfset criterias[4][2]=application.rbFactory.getKeyValue(session.rb,"params.lt")>
<cfset criterias[5][1]="LTE">
<cfset criterias[5][2]=application.rbFactory.getKeyValue(session.rb,"params.lte")>
<cfset criterias[6][1]="Begins">
<cfset criterias[6][2]=application.rbFactory.getKeyValue(session.rb,"params.beginswith")>
<cfset criterias[7][1]="Contains">
<cfset criterias[7][2]=application.rbFactory.getKeyValue(session.rb,"params.contains")>

</cfsilent>

<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.advancedsearch")#</h2>

<form novalidate="novalidate"  method="get" name="searchFrm" id="advancedSearch" class="sessionHistory">
<input type="hidden" name="startSearch" value="true"/>
<dl class="clearfix">
<dt class="from">#application.rbFactory.getKeyValue(session.rb,"params.from")#</dt>
<dd class="from"><input type="hidden" name="fuseaction" value="cDashboard.sessionSearch" />
<input type="hidden" name="siteID" value="#HTMLEditFormat(attributes.siteid)#" />

<input type="input" class="datepicker" name="startDate" value="#LSDateFormat(session.startDate,session.dateKeyFormat)#" validate="date" message="The 'From' date is required." />
<!---<input class="calendar" type="image" src="images/icons/cal_24.png" onclick="window.open('date_picker/index.cfm?form=searchFrm&field=startDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
</dd>
<dt class="to">#application.rbFactory.getKeyValue(session.rb,"params.to")#</dt>
<dd class="to">
<input type="input" class="datepicker" name="stopDate" value="#LSDateFormat(session.stopDate,session.dateKeyFormat)#" validate="date" message="The 'To' date is required." />
<!---<input class="calendar" type="image" src="images/icons/cal_24.png" onclick="window.open('date_picker/index.cfm?form=searchFrm&field=stopDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
</dd>
<dt class="where">#application.rbFactory.getKeyValue(session.rb,"params.where")#</dt>
	<dd class="where">
		<ul id="searchParams">
		<cfif attributes.newSearch or (session.paramCircuit neq 'cDashboard' or not session.paramCount)>
		<li class="first"><select name="paramRelationship1" style="display:none;" >
			<option value="and">#application.rbFactory.getKeyValue(session.rb,"params.and")#</option>
			<option value="or">#application.rbFactory.getKeyValue(session.rb,"params.or")#</option>
		</select>
		<input type="hidden" name="param" value="1" />
		<select name="paramField1">
		<option value="">#application.rbFactory.getKeyValue(session.rb,"params.selectfield")#</option>
		<optgroup label="#application.rbFactory.getKeyValue(session.rb,"params.memberoptions")#">
		<cfloop from="1" to="#arrayLen(userOptions)#" index="i">
		<option value="#userOptions[i][1]#">#userOptions[i][2]#</option>
		</cfloop>
		</optgroup>
		<optgroup label="#application.rbFactory.getKeyValue(session.rb,"params.contentoptions")#">
		<cfloop from="1" to="#arrayLen(contentOptions)#" index="i">
		<option value="#contentOptions[i][1]#">#contentOptions[i][2]#</option>
		</cfloop>
		</optgroup>
		<optgroup label="#application.rbFactory.getKeyValue(session.rb,"params.siteoptions")#">
		<cfloop from="1" to="#arrayLen(sessionOptions)#" index="i">
		<option value="#sessionOptions[i][1]#">#sessionOptions[i][2]#</option>
		</cfloop>
		</optgroup>
		</select>
		<select name="paramCondition1">
		<cfloop from="1" to="#arrayLen(criterias)#" index="i">
		<option value="#criterias[i][1]#">#criterias[i][2]#</option>
		</cfloop>
		</select>
		<input type="text" name="paramCriteria1">
		<a class="removeCriteria" href="javascript:;" onclick="removeSeachParam(this.parentNode);setSearchButtons();return false;" style="display:none;">#application.rbFactory.getKeyValue(session.rb,"params.removecriteria")#</a>
		<a class="addCriteria" href="javascript:;" onclick="addSearchParam();setSearchButtons();return false;">#application.rbFactory.getKeyValue(session.rb,"params.addcriteria")#</a>
		</li>
		<cfelse>
		<cfloop from="1" to="#session.paramCount#" index="p">
		<li <cfif p eq 1> class="first"</cfif>>
		<select name="paramRelationship#p#">
			<option value="and" <cfif session.paramArray[p].relationship eq "and">selected</cfif> >#application.rbFactory.getKeyValue(session.rb,"params.and")#</option>
			<option value="or" <cfif session.paramArray[p].relationship eq "or">selected</cfif> >#application.rbFactory.getKeyValue(session.rb,"params.or")#</option>
		</select>
		<input type="hidden" name="param" value="#p#" />
		<select name="paramField#p#">
		<option value="">#application.rbFactory.getKeyValue(session.rb,"params.selectfield")#</option>
		<optgroup label="#application.rbFactory.getKeyValue(session.rb,"params.memberoptions")#">
		<cfloop from="1" to="#arrayLen(userOptions)#" index="i">
		<option value="#userOptions[i][1]#" <cfif session.paramArray[p].field eq userOptions[i][1]>selected</cfif>>#userOptions[i][2]#</option>
		</cfloop>
		</optgroup>
		<optgroup label="#application.rbFactory.getKeyValue(session.rb,"params.contentoptions")#">
		<cfloop from="1" to="#arrayLen(contentOptions)#" index="i">
		<option value="#contentOptions[i][1]#" <cfif session.paramArray[p].field eq contentOptions[i][1]>selected</cfif>>#contentOptions[i][2]#</option>
		</cfloop>
		</optgroup>
		<optgroup label="#application.rbFactory.getKeyValue(session.rb,"params.siteoptions")#">
		<cfloop from="1" to="#arrayLen(sessionOptions)#" index="i">
		<option value="#sessionOptions[i][1]#" <cfif session.paramArray[p].field eq sessionOptions[i][1]>selected</cfif>>#sessionOptions[i][2]#</option>
		</cfloop>
		</optgroup>
		</select>
		<select name="paramCondition#p#">
		<cfloop from="1" to="#arrayLen(criterias)#" index="i">
		<option value="#criterias[i][1]#" <cfif session.paramArray[p].condition eq criterias[i][1]>selected</cfif>>#criterias[i][2]#</option>
		</cfloop>
		</select>
		<input type="text" name="paramCriteria#p#" value="#session.paramArray[p].criteria#" >
			<a class="removeCriteria" href="javascript:;" onclick="removeSeachParam(this.parentNode);setSearchButtons();return false;"><span>#application.rbFactory.getKeyValue(session.rb,"params.removecriteria")#</span></a>
		<a class="addCriteria" href="javascript:;" onclick="addSearchParam();setSearchButtons();return false;" ><span>#application.rbFactory.getKeyValue(session.rb,"params.addcriteria")#</span></a>
		</li>
		</cfloop>
		</cfif>
		</ul>
	</dd>
<!---
	<cfif request.rsGroups.recordcount>
		<dt class="first">Groups</dt>
		<dd>
		<ul><cfloop query="request.rsGroups">
		<li><input name="GroupID" type="checkbox" class="checkbox" value="#request.rsGroups.UserID#" <cfif listfind(session.paramGroups,request.rsGroups.UserID) or listfind(attributes.groupid,request.rsGroups.UserID)>checked</cfif>> #request.rsGroups.site# - #request.rsGroups.groupname#</li>
		</cfloop>
		</ul>
		</dd>
	</cfif>
	
	<cfif not structIsEmpty(application.settingsManager.getSite(attributes.siteid).getCategoryFilterLookUp())>
		<dt <cfif not request.rsGroups.recordcount>class="first"</cfif>>Categories / Interest Groups</dt>
		<dd>
			<ul class="interestGroups">
				<cfloop collection="#application.settingsManager.getSites()#" item="site">
					<cfif application.settingsManager.getSite(site).getPrivateUserPoolID() eq attributes.siteid>
						<li>
							<cfoutput>#application.settingsManager.getSite(site).getSite()#</cfoutput>
							<cf_dsp_categories_nest_search siteID="#attributes.siteID#" parentID="" categoryID="#session.paramCategories#" nestLevel="0" >
						</li>
					</cfif>
				</cfloop>
			</ul>
		</dd>
	</cfif>
	<dt class="first">Display Columns</dt>
	<dd>
	<cfloop from="1" to="#arrayLen(sessionOptions)#" index="i">
		<input type="checkbox" name="displayFields" value="#sessionOptions[i][1]#"> #sessionOptions[i][2]# 
		</cfloop>
		<cfloop from="1" to="#arrayLen(userOptions)#" index="i">
		<input type="checkbox" name="displayFields" value="#userOptions[i][1]#"> #userOptions[i][2]#
		</cfloop>
	</dd> --->
	
	
</dl>
<dl class="clearfix" id="memberVisitorOptions">
<cfif application.settingsManager.getSite(attributes.siteID).getExtranet() eq 1>
	<dt class="first">#application.rbFactory.getKeyValue(session.rb,"params.memberoptions")#</dt>
	<dd><input type="radio" name="membersOnly" value="true" <cfif session.membersOnly>checked</cfif>> #application.rbFactory.getKeyValue(session.rb,"params.membersonlytrue")#&nbsp; &nbsp; <input type="radio" name="membersOnly" value="false" <cfif not session.membersOnly>checked</cfif>> #application.rbFactory.getKeyValue(session.rb,"params.membersonlyfalse")#</dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,"params.visitoroptions")#</dt>
<cfelse>
	<dt class="first">#application.rbFactory.getKeyValue(session.rb,"params.visitoroptions")#</dt>
</cfif>
	<dd><input type="radio" name="visitorStatus" value="Return" <cfif session.visitorStatus eq "Return">checked</cfif>> #application.rbFactory.getKeyValue(session.rb,"params.returningvisitors")# &nbsp; &nbsp; <input type="radio" name="visitorStatus" value="New" <cfif session.visitorStatus eq "New">checked</cfif>> #application.rbFactory.getKeyValue(session.rb,"params.newvisitors")# &nbsp; &nbsp; <input type="radio" name="visitorStatus" value="All" <cfif session.visitorStatus eq "All">checked</cfif>> #application.rbFactory.getKeyValue(session.rb,"params.allvisitors")#</dd>
</dl>
<input type="button" class="submit" onclick="submitForm(document.forms.searchFrm);" value="#application.rbFactory.getKeyValue(session.rb,"params.search")#" />
</form>
</cfoutput>
<!--- <cfdump var="#request.result#">arrayLen(session.paramArray)  --->

<cfset searchFailed=false/>
<cfif not attributes.newSearch>
<cfsilent>
<cftry>
<cfif arrayLen(session.paramArray) and session.paramCircuit eq 'cDashboard' >
<cfset request.rslist=application.dashboardManager.getSessionSearch(session.paramArray,attributes.siteid,session.membersOnly,session.visitorStatus,session.startDate,session.stopDate) />
<cfelse>
<cfset request.rslist=application.dashboardManager.getSessionSearch(arrayNew(1),attributes.siteid,session.membersOnly,session.visitorStatus,session.startDate,session.stopDate) />
</cfif>
<cfcatch><cfset searchFailed=true/></cfcatch>
</cftry>
</cfsilent>
	<script type="text/javascript">setSearchButtons();</script>
<cfif not searchFailed>
	<cfoutput>
	<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.totalsessions")# (#request.rslist.recordcount#)</h3>
	
<table class="mura-table-grid stripe"> 
<tr>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.user")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.locale")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.lastrequest")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.views")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.lengthofvisit")#</th>
<th>&nbsp;</th>
</tr>
<cfif request.rslist.recordcount>
<cfset request.nextN=application.utility.getNextN(request.rsList,15,attributes.startrow)/>
<cfset endrow=(attributes.startrow+request.nextN.recordsperpage)-1/>
<cfloop query="request.rslist" startrow="#attributes.startRow#" endrow="#endRow#">
<tr>
<td><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="index.cfm?fuseaction=cDashboard.viewSession&urlToken=#urlEncodedFormat(request.rslist.urlToken)#&siteid=#URLEncodedFormat(attributes.siteid)#"><cfif request.rslist.userid eq ''>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.anonymous")#<cfelse>#HTMLEditFormat(request.rslist.fname)# #HTMLEditFormat(request.rslist.lname)#<cfif request.rslist.company neq ''> (#HTMLEditFormat(request.rslist.company)#)</cfif></cfif></a></td>
<td>#request.rslist.locale#</td>
<td>#LSDateFormat(request.rslist.lastRequest,session.dateKeyFormat)# #LSTimeFormat(request.rslist.lastRequest,"short")#</td>
<td>#request.rslist.views#</td>
<td>#application.dashboardManager.getTimespan(request.rslist.firstRequest,request.rslist.lastRequest)#</td>
<td class="administration"><ul class="one"><li class="viewDetails"><a title="View Details" href="index.cfm?fuseaction=cDashboard.viewSession&urlToken=#urlEncodedFormat(request.rslist.urlToken)#&siteid=#URLEncodedFormat(attributes.siteid)#">View Details</a></li></ul></td>
</tr></cfloop>
<cfelse>
<tr>
<td class="noResults" colspan="6">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.nosearchresults")#</td>
</tr>
</cfif>
</table>

<cfif request.rslist.recordcount and request.nextN.numberofpages gt 1>
#application.rbFactory.getKeyValue(session.rb,"dashboard.session.moreresults")#: <cfif request.nextN.currentpagenumber gt 1> <a href="index.cfm?fuseaction=cDashboard.sessionSearch&startrow=#request.nextN.previous#&siteid=#URLEncodedFormat(attributes.siteid)#&direction=#attributes.direction#&orderBy=#attributes.orderBy#">&laquo;&nbsp;Prev</a></cfif>
<cfloop from="#request.nextN.firstPage#"  to="#request.nextN.lastPage#" index="i">
	<cfif request.nextN.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?fuseaction=cDashboard.sessionSearch&startrow=#evaluate('(#i#*#request.nextN.recordsperpage#)-#request.nextN.recordsperpage#+1')#&siteid=#URLEncodedFormat(attributes.siteid)#&direction=#attributes.direction#&orderBy=#attributes.orderBy#">#i#</a> </cfif></cfloop>
	<cfif request.nextN.currentpagenumber lt request.nextN.NumberOfPages><a href="index.cfm?fuseaction=cDashboard.sessionSearch&startrow=#request.nextN.next#&siteid=#URLEncodedFormat(attributes.siteid)#&direction=#attributes.direction#&orderBy=#attributes.orderBy#">Next&nbsp;&raquo;</a></cfif> 

</cfif>
</cfoutput>
<cfelse>
<cfoutput>
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.searchtimedout")#</h3> 
<p>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.searchtimedoutdesc")#</p>
</cfoutput> 
</cfif>
</cfif>
</div>
	