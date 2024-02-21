<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfinclude template="js.cfm">
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
<cfset criterias[1][2]=application.rbFactory.getKeyValue(session.rb,'params.equals')>
<cfset criterias[2][1]="GT">
<cfset criterias[2][2]=application.rbFactory.getKeyValue(session.rb,'params.gt')>
<cfset criterias[3][1]="GTE">
<cfset criterias[3][2]=application.rbFactory.getKeyValue(session.rb,'params.gte')>
<cfset criterias[4][1]="LT">
<cfset criterias[4][2]=application.rbFactory.getKeyValue(session.rb,'params.lt')>
<cfset criterias[5][1]="LTE">
<cfset criterias[5][2]=application.rbFactory.getKeyValue(session.rb,'params.lte')>
<cfset criterias[6][1]="NEQ">
<cfset criterias[6][2]=application.rbFactory.getKeyValue(session.rb,'params.neq')>
<cfset criterias[7][1]="Begins">
<cfset criterias[7][2]=application.rbFactory.getKeyValue(session.rb,'params.beginswith')>
<cfset criterias[8][1]="Contains">
<cfset criterias[8][2]=application.rbFactory.getKeyValue(session.rb,'params.contains')>

</cfsilent>

<cfoutput>
<div class="mura-header">
	<h1>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.advancedsearch")#</h1>

	<cfinclude template="dsp_secondary_menu.cfm">

</div> <!-- /.mura-header -->

<div class="block block-constrain">
		<div class="block block-bordered">
		  <div class="block-content">

				<form novalidate="novalidate"  method="get" name="searchFrm" id="advancedSearch" class="sessionHistory">
				<input type="hidden" name="startSearch" value="true"/>
				<div id="date-range" class="mura-control-group">
					<label class="label-inline">
						#application.rbFactory.getKeyValue(session.rb,"params.from")#
				    <input type="text" class="datepicker" name="startDate" value="#LSDateFormat(session.startDate,session.dateKeyFormat)#" validate="date" message="The 'From' date is required." />
						<input type="hidden" name="muraAction" value="cDashboard.sessionSearch" />
				    <input type="hidden" name="siteID" value="#esapiEncode('html_attr',rc.siteid)#" />
						#application.rbFactory.getKeyValue(session.rb,"params.to")#
	        		<input type="text" class="datepicker" name="stopDate" value="#LSDateFormat(session.stopDate,session.dateKeyFormat)#" validate="date" message="The 'To' date is required." />
					</label>
				</div>

				<div class="mura-control-group" id="searchParams">
					<label>
						#application.rbFactory.getKeyValue(session.rb,"params.where")#
					</label>
					<cfif rc.newSearch or (session.paramCircuit neq 'cDashboard' or not session.paramCount)>
						<div class="mura-control justify">
							<select name="paramRelationship1" style="display:none;">
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
							<a class="criteria remove" href="javascript:;" onclick="$searchParams.removeSeachParam(this.parentNode);$searchParams.setSearchButtons();return false;" style="display:none;" title="#application.rbFactory.getKeyValue(session.rb,"params.removecriteria")#"><i class="mi-minus-circle"></i></a>
							<a class="criteria add" href="javascript:;" onclick="$searchParams.addSearchParam();$searchParams.setSearchButtons();return false;" title="#application.rbFactory.getKeyValue(session.rb,"params.addcriteria")#"><i class="mi-plus-circle"></i></a>
						</div>
					<cfelse>

						<cfloop from="1" to="#session.paramCount#" index="p">
							<div class="mura-control justify form-inline">
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
								<input type="text" name="paramCriteria#p#" value="#session.paramArray[p].criteria#">
								<a class="removeCriteria" href="javascript:;" onclick="$searchParams.removeSeachParam(this.parentNode);$searchParams.setSearchButtons();return false;"><span>#application.rbFactory.getKeyValue(session.rb,"params.removecriteria")#</span></a>
								<a class="addCriteria" href="javascript:;" onclick="$searchParams.addSearchParam();$searchParams.setSearchButtons();return false;" ><span>#application.rbFactory.getKeyValue(session.rb,"params.addcriteria")#</span></a>
							</div>
							</cfloop>
						</cfif>
				</div>

				<cfif application.settingsManager.getSite(rc.siteID).getExtranet() eq 1>
				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,"params.memberoptions")#</label>
				      	<label class="radio inline">
				      	<input type="radio" name="membersOnly" value="true" <cfif session.membersOnly>checked</cfif>> #application.rbFactory.getKeyValue(session.rb,"params.membersonlytrue")#
				      </label>
					<label class="radio inline">
				      <input type="radio" name="membersOnly" value="false" <cfif not session.membersOnly>checked</cfif>> #application.rbFactory.getKeyValue(session.rb,"params.membersonlyfalse")#
				  	</label>
				 </div>

				<div class="mura-control-group">
					<label>
						#application.rbFactory.getKeyValue(session.rb,"params.visitoroptions")#
					</label>

				<cfelse>

				<div class="mura-control-group">
					<label>
						#application.rbFactory.getKeyValue(session.rb,"params.visitoroptions")#
					</label>
				</cfif>

					<label class="radio inline">
				   		<input type="radio" name="visitorStatus" value="Return" <cfif session.visitorStatus eq "Return">checked</cfif>> #application.rbFactory.getKeyValue(session.rb,"params.returningvisitors")#
				    </label>
				    <label class="radio inline">
				    	 <input type="radio" name="visitorStatus" value="New" <cfif session.visitorStatus eq "New">checked</cfif>> #application.rbFactory.getKeyValue(session.rb,"params.newvisitors")#
				    </label>
					<label class="radio inline">
				    	<input type="radio" name="visitorStatus" value="All" <cfif session.visitorStatus eq "All">checked</cfif>> #application.rbFactory.getKeyValue(session.rb,"params.allvisitors")#
				    </label>
				</div>
				<div class="mura-actions">
					<div class="form-actions">
					<button class="btn mura-primary" onclick="submitForm(document.forms.searchFrm);"><i class="mi-search"></i>#application.rbFactory.getKeyValue(session.rb,"params.search")#</button> 
					</div>
				</div>
				</form>

		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->

</cfoutput>
<!--- <cfdump var="#rc.result#">arrayLen(session.paramArray)  --->
<cfset searchFailed=false/>
<cfif not rc.newSearch>
<cfsilent>
	<cftry>
		<cfif arrayLen(session.paramArray) and session.paramCircuit eq 'cDashboard' >
			<cfset rc.rslist=application.dashboardManager.getSessionSearch(session.paramArray,rc.siteid,session.membersOnly,session.visitorStatus,session.startDate,session.stopDate) />
		<cfelse>
			<cfset rc.rslist=application.dashboardManager.getSessionSearch(arrayNew(1),rc.siteid,session.membersOnly,session.visitorStatus,session.startDate,session.stopDate) />
		</cfif>
	<cfcatch>
		<cfset searchFailed=true/>
	</cfcatch>
	</cftry>
</cfsilent>

<script type="text/javascript">$searchParams.setSearchButtons();</script>

<cfif not searchFailed>
	<div class="block-content">
	<cfoutput>
	<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.totalsessions")# (#rc.rslist.recordcount#)</h2>

<table class="mura-table-grid">
<thead>
<tr>
	<th class="actions"></th>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.user")#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.locale")#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.lastrequest")#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.views")#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.lengthofvisit")#</th>
</tr>
</thead>
<tbody>
<cfif rc.rslist.recordcount>
<cfset rc.nextN=application.utility.getNextN(rc.rsList,15,rc.startrow)/>
<cfset endrow=(rc.startrow+rc.nextN.recordsperpage)-1/>
<cfloop query="rc.rslist" startrow="#rc.startRow#" endrow="#endRow#">
<tr>
	<td class="actions">
		<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
		<div class="actions-menu hide">			
			<ul class="actions-list">
				<li class="viewDetails"><a href="./?muraAction=cDashboard.viewSession&urlToken=#esapiEncode('url',rc.rslist.urlToken)#&siteid=#esapiEncode('url',rc.siteid)#"><i class="mi-pencil"></i>View Details</a></li>
			</ul>
		</div>	
	</td>
	<td><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="./?muraAction=cDashboard.viewSession&urlToken=#esapiEncode('url',rc.rslist.urlToken)#&siteid=#esapiEncode('url',rc.siteid)#"><cfif rc.rslist.fname eq ''>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.anonymous")#<cfelse>#esapiEncode('html',rc.rslist.fname)# #esapiEncode('html',rc.rslist.lname)#<cfif rc.rslist.company neq ''> (#esapiEncode('html',rc.rslist.company)#)</cfif></cfif></a></td>
	<td>#esapiEncode('html',rc.rslist.locale)#</td>
	<td>#LSDateFormat(rc.rslist.lastRequest,session.dateKeyFormat)# #LSTimeFormat(rc.rslist.lastRequest,"short")#</td>
	<td>#rc.rslist.views#</td>
	<td>#application.dashboardManager.getTimespan(rc.rslist.firstRequest,rc.rslist.lastRequest)#</td>
</tr></cfloop>
<cfelse>
<tr>
<td class="noResults" colspan="6">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.nosearchresults")#</td>
</tr>
</cfif>
</tbody>
</table>


<cfif rc.rslist.recordcount and rc.nextN.numberofpages gt 1>
	<br/>
	<cfset args=arrayNew(1)>
	<cfset args[1]="#rc.nextn.startrow#-#rc.nextn.through#">
	<cfset args[2]=rc.nextn.totalrecords>
	<div class="clearfix mura-results-wrapper">
		<p class="search-showing">
			#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.paginationmeta"),args)#
		</p>
		 <ul class="moreResults pagination">
		  <cfif rc.nextN.currentpagenumber gt 1>
		  	<li>
		  	<a href="./?muraAction=cDashboard.sessionSearch&startrow=#rc.nextN.previous#&siteid=#esapiEncode('url',rc.siteid)#&direction=#esapiEncode('url',rc.direction)#&orderBy=#esapiEncode('url',rc.orderBy)#"><i class="mi-angle-left"></i></a>
		  	</li>
		  </cfif>
		  <cfloop from="#rc.nextN.firstPage#"  to="#rc.nextN.lastPage#" index="i">
		  <cfif rc.nextN.currentpagenumber eq i>
		  		<li class="active"><a href="##">#i#</a></li>
		  <cfelse>
		  		<li>
		  			<a href="./?muraAction=cDashboard.sessionSearch&startrow=#val((i*rc.nextn.recordsperpage)-rc.nextn.recordsperpage+1)#&siteid=#esapiEncode('url',rc.siteid)#&direction=#esapiEncode('url',rc.direction)#&orderBy=#esapiEncode('url',rc.orderBy)#">#i#</a>
		  		</li>
		  	</cfif>
	     </cfloop>
		 <cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages>
		 	<li>
		 		<a href="./?muraAction=cDashboard.sessionSearch&startrow=#rc.nextN.next#&siteid=#esapiEncode('url',rc.siteid)#&direction=#esapiEncode('url',rc.direction)#&orderBy=#esapiEncode('url',rc.orderBy)#"><i class="mi-angle-right"></i></a>
		 	</li>
		 </cfif>
		</ul>
	</div>
</cfif>
</cfoutput>
<cfelse>
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.searchtimedout")#</h2>
<p>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.searchtimedoutdesc")#</p>
</cfoutput>
</div> <!-- /.block-content -->
</cfif>
</cfif>
</div> <!-- /.block-constrain -->
