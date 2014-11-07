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
<cfinclude template="inc/js.cfm" />
<cfsilent>
	<cfset options=arrayNew(2) />
	<cfset criterias=arrayNew(2) />

	<cfset options[1][1]="tusers.fname^varchar">
	<cfset options[1][2]= rbKey('user.fname') >
	<cfset options[2][1]="tusers.lname^varchar">
	<cfset options[2][2]= rbKey('user.lname')>
	<cfset options[3][1]="tusers.username^varchar">
	<cfset options[3][2]= rbKey('user.username') >
	<cfset options[4][1]="tusers.email^varchar">
	<cfset options[4][2]= rbKey('user.email')>
	<cfset options[5][1]="tusers.company^varchar">
	<cfset options[5][2]= rbKey('user.company')>
	<cfset options[6][1]="tusers.jobTitle^varchar">
	<cfset options[6][2]= rbKey('user.jobtitle')>
	<cfset options[7][1]="tusers.website^varchar">
	<cfset options[7][2]= rbKey('user.website')>
	<!---<cfset options[8][1]="tusers.IMName^varchar">
	<cfset options[8][2]="IM Name">
	<cfset options[8][1]="tusers.IMService^varchar">
	<cfset options[8][2]="IM Service">--->
	<cfset options[8][1]="tusers.mobilePhone^varchar">
	<cfset options[8][2]= rbKey('user.mobilephone')>
	<cfset options[9][1]="tuseraddresses.address1^varchar">
	<cfset options[9][2]= rbKey('user.address1')>
	<cfset options[10][1]="tuseraddresses.address2^varchar">
	<cfset options[10][2]= rbKey('user.address2')>
	<cfset options[11][1]="tuseraddresses.city^varchar">
	<cfset options[11][2]= rbKey('user.city')>
	<cfset options[12][1]="tuseraddresses.state^varchar">
	<cfset options[12][2]= rbKey('user.state')>
	<cfset options[13][1]="tuseraddresses.Zip^varchar">
	<cfset options[13][2]= rbKey('user.zip')>
	<cfset options[14][1]="tusers.created^date">
	<cfset options[14][2]= rbKey('user.created')>
	<cfset options[15][1]="tusers.tags^varchar">
	<cfset options[15][2]= rbKey('user.tag')>

	<!--- Extended Attributes --->
		<cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(siteID=rc.siteid,baseTable="tusers",activeOnly=true)>
		<cfloop query="rsExtend">
			<cfset options[rsExtend.currentRow + 15][1]="#rsExtend.attributeID#^varchar">
			<cfset options[rsExtend.currentRow + 15][2]="#iif(rsExtend.Type eq 1,de('Group'),de('User'))#/#rsExtend.subType# - #rsExtend.attribute#"/>
		</cfloop>

	<!--- Criteria --->
		<cfset criterias[1][1]="Equals">
		<cfset criterias[1][2]=rbKey('params.equals')>
		<cfset criterias[2][1]="GT">
		<cfset criterias[2][2]=rbKey('params.gt')>
		<cfset criterias[3][1]="GTE">
		<cfset criterias[3][2]=rbKey('params.gte')>
		<cfset criterias[4][1]="LT">
		<cfset criterias[4][2]=rbKey('params.lt')>
		<cfset criterias[5][1]="LTE">
		<cfset criterias[5][2]=rbKey('params.lte')>
		<cfset criterias[6][1]="NEQ">
		<cfset criterias[6][2]=rbKey('params.neq')>
		<cfset criterias[7][1]="Begins">
		<cfset criterias[7][2]=rbKey('params.beginswith')>
		<cfset criterias[8][1]="Contains">
		<cfset criterias[8][2]=rbKey('params.contains')>
</cfsilent>
<cfoutput>
	<h1>#rbKey("user.advancedusersearch")#</h1>

	<!--- Basic Search Button --->
		<div id="nav-module-specific" class="btn-group">
			<a class="btn" href="#buildURL(action='cusers.search', querystring='siteid=#esapiEncode('url',rc.siteid)#')#" onclick="actionModal();">
				<i class="icon-search"></i> 
				#rbKey('user.basicsearch')#
			</a>
		</div>

	<!--- Search Form --->
		<form class="fieldset-wrap" novalidate="novalidate" id="advancedMemberSearch" action="index.cfm" method="get" name="form2">
			<div class="fieldset">

				<!--- Search Params --->
					<div class="control-group" id="searchParams">
						<label class="control-label">#rbKey("user.searchcriteria")#</label>
						<div class="controls">
							<cfif rc.newSearch or (session.paramCircuit neq 'cUsers' or not session.paramCount)>
								<select name="paramRelationship1" style="display:none;" class="span2">
									<option value="and">#rbKey("params.and")#</option>
									<option value="or">#rbKey("params.or")#</option>
								</select>

								<input type="hidden" name="param" value="1" />

								<select name="paramField1" class="span2">
									<option value="">#rbKey("params.selectfield")#</option>
									<cfloop from="1" to="#arrayLen(options)#" index="i">
										<option value="#options[i][1]#">#options[i][2]#</option>
									</cfloop>
								</select>
									
								<select name="paramCondition1" class="span2">
									<cfloop from="1" to="#arrayLen(criterias)#" index="i">
										<option value="#criterias[i][1]#">#criterias[i][2]#</option>
									</cfloop>
								</select>
						
								<input type="text" name="paramCriteria1" class="span4">

								<!--- remove --->
								<a class="criteria remove" href="javascript:;" onclick="$searchParams.removeSeachParam(this.parentNode);$searchParams.setSearchButtons();return false;" style="display:none;" title="#rbKey("params.removecriteria")#">
									<i class="icon-remove-sign"></i>
								</a>
								<!--- add --->
								<a class="criteria add" href="javascript:;" onclick="$searchParams.addSearchParam();$searchParams.setSearchButtons();return false;" title="#rbKey("params.addcriteria")#">
									<i class="icon-plus-sign"></i>
								</a>
							<cfelse>
								<cfloop from="1" to="#session.paramCount#" index="p">
									<select name="paramRelationship#p#" class="span2">
										<option value="and" <cfif session.paramArray[p].relationship eq "and">selected</cfif>>
											#rbKey("params.and")#
										</option>
										<option value="or" <cfif session.paramArray[p].relationship eq "or">selected</cfif>>
											#rbKey("params.or")#
										</option>
									</select>

									<input type="hidden" name="param" value="#p#" />
									
									<select name="paramField#p#" class="span2">
										<option value="">#rbKey("params.selectfield")#</option>
										<cfloop from="1" to="#arrayLen(options)#" index="i">
											<option value="#options[i][1]#" <cfif session.paramArray[p].field eq options[i][1]>selected</cfif>>
												#options[i][2]#
											</option>
										</cfloop>
									</select>
									
									<select name="paramCondition#p#" class="span2">
										<cfloop from="1" to="#arrayLen(criterias)#" index="i">
											<option value="#criterias[i][1]#" <cfif session.paramArray[p].condition eq criterias[i][1]>selected</cfif>>
												#criterias[i][2]#
											</option>
										</cfloop>
									</select>
									
									<input type="text" name="paramCriteria#p#" value="#session.paramArray[p].criteria#" class="span4">
									<a class="criteria remove" href="javascript:;" onclick="$searchParams.removeSeachParam(this.parentNode);$searchParams.setSearchButtons();return false;" title="#rbKey('params.removecriteria')#">
										<i class="icon-remove-sign"></i>
									</a>
									<a class="criteria add" href="javascript:;" onclick="$searchParams.addSearchParam();$searchParams.setSearchButtons();return false;" title="#rbKey('params.addcriteria')#">
										<i class="icon-plus-sign"></i>
									</a><br>
								</cfloop>
							</cfif>
						</div>
					</div>
				<!--- /Search Params --->

				<!--- Active --->
					<div class="control-group">
						<label class="control-label">#rbKey('user.inactive')#</label>
						<div class="controls">
							<select name="inActive">
								<option value="">#rbKey('user.all')#</option>
								<option value="0" <cfif session.inactive eq 0>selected</cfif>>#rbKey('user.yes')#</option>
								<option value="1" <cfif session.inactive eq 1>selected</cfif>>#rbKey('user.no')#</option>
							</select>
						</div>
					</div>
				<!--- /Active --->

			</div>
			<!--- /fieldset --->

			<!--- Form Buttons --->
				<div class="form-actions">
					<input type="hidden" name="muraAction" value="cUsers.advancedSearch">
					<input type="hidden" name="siteid" value="#esapiEncode('html', rc.siteid)#">
					<input type="hidden" name="ispublic" value="#esapiEncode('html', rc.ispublic)#">
					
					<!--- Search Button --->
						<button type="button" class="btn" onclick="document.forms.form2.muraAction.value='cUsers.advancedSearch';submitForm(document.forms.form2);">
							<i class="icon-search"></i> 
							#rbKey("user.search")#
						</button>
					
					<!--- Download Button --->
						<cfif rc.it.getRecordcount()>
							<button type="button" class="btn" onclick="document.forms.form2.muraAction.value='cUsers.advancedSearchToCSV';submitForm(document.forms.form2);$('##action-modal').remove();">
								<i class="icon-download"></i> 
								#rbKey("user.download")#
							</button>
						</cfif>
				</div>
			<!--- /Form Buttons --->
		</form>
	<!--- /Search Form --->

<script type="text/javascript">$searchParams.setSearchButtons();</script>

	<!--- Tab Nav (only tabbed for Admin + Super Users) --->
    <cfif rc.isAdmin>
			<ul class="nav nav-tabs">
				<!--- Site Members Tab --->
					<li<cfif rc.ispublic eq 1> class="active"</cfif>>
						<a href="#buildURL(action='cusers.advancedsearch', querystring='#rc.qs#ispublic=1')#" onclick="actionModal();">
							#rbKey('user.sitemembers')#
						</a>
					</li>

        <!--- System Users Tab --->
					<li<cfif rc.ispublic eq 0> class="active"</cfif>>
						<a href="#buildURL(action='cusers.advancedsearch', querystring='#rc.qs#ispublic=0')#" onclick="actionModal();">
							#rbKey('user.systemusers')#
						</a>
					</li>
      </ul>
    <cfelse>
      <h3>#rbKey('user.sitemembers')#</h3>
    </cfif>
  <!--- /Tab Nav --->

	<!--- Search Results --->
		<cfinclude template="inc/dsp_users_list.cfm" />
</cfoutput>