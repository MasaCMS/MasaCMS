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
<cfset options=arrayNew(2) />
<cfset criterias=arrayNew(2) />

<cfset options[1][1]="tusers.fname^varchar">
<cfset options[1][2]= application.rbFactory.getKeyValue(session.rb,'user.fname') >
<cfset options[2][1]="tusers.lname^varchar">
<cfset options[2][2]= application.rbFactory.getKeyValue(session.rb,'user.lname')>
<cfset options[3][1]="tusers.username^varchar">
<cfset options[3][2]= application.rbFactory.getKeyValue(session.rb,'user.username') >
<cfset options[4][1]="tusers.email^varchar">
<cfset options[4][2]= application.rbFactory.getKeyValue(session.rb,'user.email')>
<cfset options[5][1]="tusers.company^varchar">
<cfset options[5][2]= application.rbFactory.getKeyValue(session.rb,'user.company')>
<cfset options[6][1]="tusers.jobTitle^varchar">
<cfset options[6][2]= application.rbFactory.getKeyValue(session.rb,'user.jobtitle')>
<cfset options[7][1]="tusers.website^varchar">
<cfset options[7][2]= application.rbFactory.getKeyValue(session.rb,'user.website')>
<!---<cfset options[8][1]="tusers.IMName^varchar">
<cfset options[8][2]="IM Name">
<cfset options[8][1]="tusers.IMService^varchar">
<cfset options[8][2]="IM Service">--->
<cfset options[8][1]="tusers.mobilePhone^varchar">
<cfset options[8][2]= application.rbFactory.getKeyValue(session.rb,'user.mobilephone')>
<cfset options[9][1]="tuseraddresses.address1^varchar">
<cfset options[9][2]= application.rbFactory.getKeyValue(session.rb,'user.address1')>
<cfset options[10][1]="tuseraddresses.address2^varchar">
<cfset options[10][2]= application.rbFactory.getKeyValue(session.rb,'user.address2')>
<cfset options[11][1]="tuseraddresses.city^varchar">
<cfset options[11][2]= application.rbFactory.getKeyValue(session.rb,'user.city')>
<cfset options[12][1]="tuseraddresses.state^varchar">
<cfset options[12][2]= application.rbFactory.getKeyValue(session.rb,'user.state')>
<cfset options[13][1]="tuseraddresses.Zip^varchar">
<cfset options[13][2]= application.rbFactory.getKeyValue(session.rb,'user.zip')>
<cfset options[14][1]="tusers.created^date">
<cfset options[14][2]= application.rbFactory.getKeyValue(session.rb,'user.created')>
<cfset options[15][1]="tusers.tags^varchar">
<cfset options[15][2]= application.rbFactory.getKeyValue(session.rb,'user.tag')>

<cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(siteID=attributes.siteid,baseTable="tusers",activeOnly=true)>
<cfloop query="rsExtend">
<cfset options[rsExtend.currentRow + 15][1]="#rsExtend.attributeID#^varchar">
<cfset options[rsExtend.currentRow + 15][2]="#iif(rsExtend.Type eq 1,de('Group'),de('User'))#/#rsExtend.subType# - #rsExtend.attribute#"/>
</cfloop>

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
<h2>#application.rbFactory.getKeyValue(session.rb,"user.advancedmembersearch")#</h2>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cPublicUsers.search&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,"user.basicsearch")#</a></li>
</ul>
<form novalidate="novalidate" id="advancedMemberSearch" action="index.cfm" method="get" name="form2">
<dl>
<dt>#application.rbFactory.getKeyValue(session.rb,"user.searchcriteria")#</dt>
	<dd>
		<ul id="searchParams">
		<cfif attributes.newSearch or (session.paramCircuit neq 'cPublicUsers' or not session.paramCount)>
		<li><select name="paramRelationship1" style="display:none;" >
			<option value="and">#application.rbFactory.getKeyValue(session.rb,"params.and")#</option>
			<option value="or">#application.rbFactory.getKeyValue(session.rb,"params.or")#</option>
		</select>
		<input type="hidden" name="param" value="1" />
		<select name="paramField1">
		<option value="">#application.rbFactory.getKeyValue(session.rb,"params.selectfield")#</option>
		<cfloop from="1" to="#arrayLen(options)#" index="i">
		<option value="#options[i][1]#">#options[i][2]#</option>
		</cfloop>
		</select>
		<select name="paramCondition1">
		<cfloop from="1" to="#arrayLen(criterias)#" index="i">
		<option value="#criterias[i][1]#">#criterias[i][2]#</option>
		</cfloop>
		</select>
		<input type="text" name="paramCriteria1">
		<a class="removeCriteria" href="javascript:;" onclick="removeSeachParam(this.parentNode);setSearchButtons();return false;" style="display:none;">#application.rbFactory.getKeyValue(session.rb,"params.removecriteria")#</a>
		<a class="addCriteria" href="javascript:;" onclick="addSearchParam();setSearchButtons();return false;"><span>#application.rbFactory.getKeyValue(session.rb,"params.addcriteria")#</span></a>
		</li>
		<cfelse>
		<cfloop from="1" to="#session.paramCount#" index="p">
		<li>
		<select name="paramRelationship#p#">
			<option value="and" <cfif session.paramArray[p].relationship eq "and">selected</cfif> >#application.rbFactory.getKeyValue(session.rb,"params.and")#</option>
			<option value="or" <cfif session.paramArray[p].relationship eq "or">selected</cfif> >#application.rbFactory.getKeyValue(session.rb,"params.or")#</option>
		</select>
		<input type="hidden" name="param" value="#p#" />
		<select name="paramField#p#">
		<option value="">#application.rbFactory.getKeyValue(session.rb,"params.selectfield")#</option>
		<cfloop from="1" to="#arrayLen(options)#" index="i">
		<option value="#options[i][1]#" <cfif session.paramArray[p].field eq options[i][1]>selected</cfif>>#options[i][2]#</option>
		</cfloop>
		</select>
		<select name="paramCondition#p#">
		<cfloop from="1" to="#arrayLen(criterias)#" index="i">
		<option value="#criterias[i][1]#" <cfif session.paramArray[p].condition eq criterias[i][1]>selected</cfif>>#criterias[i][2]#</option>
		</cfloop>
		</select>
		<input type="text" name="paramCriteria#p#" value="#session.paramArray[p].criteria#" >
			<a class="removeCriteria" href="javascript:;" onclick="removeSeachParam(this.parentNode);setSearchButtons();return false;">#application.rbFactory.getKeyValue(session.rb,"params.removecriteria")#</a>
		<a class="addCriteria" href="javascript:;" onclick="addSearchParam();setSearchButtons();return false;" >#application.rbFactory.getKeyValue(session.rb,"params.addcriteria")#</a>
		</li>
		</cfloop>
		</cfif>
		</ul>
	</dd>
	<!--- <cfif request.rsGroups.recordcount>
		<dt class="first">Groups</dt>
		<dd>
		<ul><cfloop query="request.rsGroups">
		<li><input name="GroupID" type="checkbox" class="checkbox" value="#request.rsGroups.UserID#" <cfif listfind(session.paramGroups,request.rsGroups.UserID) or listfind(attributes.groupid,request.rsGroups.UserID)>checked</cfif>> #request.rsGroups.site# - #request.rsGroups.groupname#</li>
		</cfloop>
		</ul>
		</dd>
	</cfif>
	<cfif not structIsEmpty(application.settingsManager.getSite(attributes.siteid).getCategoryFilterLookUp())>
		<dt <cfif not request.rsGroups.recordcount>class="first"</cfif>>Interest Groups</dt>
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
	</cfif> --->
	<dt>#application.rbFactory.getKeyValue(session.rb,"user.inactive")#</dt>
		<select name="inActive">
			<option value="">All</option>
			<option value="0" <cfif session.inactive eq 0>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"user.yes")#</option>
			<option value="1" <cfif session.inactive eq 1>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"user.no")#</option>
		</select>
	</dd>
</dl>
<input type="hidden" name="fuseaction" value="cPublicUsers.advancedSearch" /><input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#"/>
<input type="button" class="submit" onclick="document.forms.form2.fuseaction.value='cPublicUsers.advancedSearch';submitForm(document.forms.form2);" value="#application.rbFactory.getKeyValue(session.rb,"user.search")#" />
<input type="button" class="submit" onclick="document.forms.form2.fuseaction.value='cPublicUsers.advancedSearchToCSV';submitForm(document.forms.form2);" value="#application.rbFactory.getKeyValue(session.rb,"user.download")#" />
</form>
</cfoutput>

<script type="text/javascript">setSearchButtons();</script>

<cfif not attributes.newSearch>

<cfsilent>
<cfset request.rslist=application.userManager.getAdvancedSearch(session,attributes.siteid,1) />
<cfif request.rslist.recordcount eq 1>
	<cflocation url="index.cfm?fuseaction=cPublicUsers.editUser&userid=#request.rslist.userid#&siteid=#URLEncodedFormat(attributes.siteid)#" />
</cfif>
<cfset request.nextN=application.utility.getNextN(request.rsList,15,attributes.startrow)/>

</cfsilent><cfoutput>
        <table class="mura-table-grid stripe">
          <tr> 
            <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,"user.name")#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,"user.email")#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,"user.update")#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,"user.time")#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,"user.authoreditor")#</th>
            <th>&nbsp;</th>
          </tr></cfoutput>
          <cfif request.rsList.recordcount>
            <cfoutput query="request.rsList" maxrows="#request.nextN.recordsperPage#" startrow="#attributes.startrow#"> 
              <tr> 
                <td class="varWidth"><a title="Edit" href="index.cfm?fuseaction=cPublicUsers.edituser&userid=#request.rsList.UserID#&type=2&siteid=#URLEncodedFormat(attributes.siteid)#">#HTMLEditFormat(lname)#, #HTMLEditFormat(fname)# <cfif company neq ''> (#HTMLEditFormat(company)#)</cfif></a></td>
                <td><cfif request.rsList.email gt ""><a href="mailto:#HTMLEditFormat(request.rsList.email)#">#HTMLEditFormat(request.rsList.email)#</a><cfelse>&nbsp;</cfif></td>
                <td>#LSDateFormat(request.rslist.lastupdate,session.dateKeyFormat)#</td>
              <td>#LSTimeFormat(request.rslist.lastupdate,"short")#</td>
			  <td>#HTMLEditFormat(request.rsList.LastUpdateBy)#</td>
                <td class="administration"><ul class="one"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPublicUsers.edituser&userid=#request.rsList.UserID#&type=2&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li></ul></td>
              </tr>
            </cfoutput>
			
            <cfelse>
            <tr> 
              <td colspan="6" class="noResults"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'user.nosearchresults')#</cfoutput></td>
            </tr>
          </cfif>   
        </table>

<cfif request.nextN.numberofpages gt 1>
<cfoutput>#application.rbFactory.getKeyValue(session.rb,'user.moreresults')#: 
<cfif request.nextN.currentpagenumber gt 1> <a href="index.cfm?fuseaction=cPublicUsers.advancedSearch&startrow=#request.nextN.previous#&siteid=#URLEncodedFormat(attributes.siteid)#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'user.prev')#</a></cfif>
<cfloop from="#request.nextN.firstPage#"  to="#request.nextN.lastPage#" index="i">
	<cfif request.nextN.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?fuseaction=cPublicUsers.advancedSearch&startrow=#evaluate('(#i#*#request.nextN.recordsperpage#)-#request.nextN.recordsperpage#+1')#&siteid=#URLEncodedFormat(attributes.siteid)#">#i#</a> </cfif></cfloop>
	<cfif request.nextN.currentpagenumber lt request.nextN.NumberOfPages><a href="index.cfm?fuseaction=cPublicUsers.advancedSearch&startrow=#request.nextN.next#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'user.next')#&nbsp;&raquo;</a></cfif> 
</cfoutput>
</cfif>
</cfif>