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
<cfhtmlhead text="#session.dateKey#">
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>

<cfoutput>
  <h2>#application.rbFactory.getKeyValue(session.rb,'email.createeditemail')#</h2>
  <cfif attributes.emailid neq "">
    <ul class="metadata">
      <li><strong>#application.rbFactory.getKeyValue(session.rb,'email.datecreated')#:</strong> #LSDateFormat(request.emailBean.getCreatedDate(),session.dateKeyFormat)#</li>
      <li><strong>#application.rbFactory.getKeyValue(session.rb,'email.createdby')#:</strong> #request.emailBean.getlastupdateby()#</li>
      <li><strong>#application.rbFactory.getKeyValue(session.rb,'email.status')#:</strong>
        <cfif request.emailBean.getstatus()>
          #application.rbFactory.getKeyValue(session.rb,'email.sent')#
          <cfelse>
          #application.rbFactory.getKeyValue(session.rb,'email.queued')#
        </cfif>
      </li>
      <cfif request.emailBean.getstatus()>
        <cfset clicks=application.emailManager.getStat(attributes.emailid,'returnClick')/>
        <cfset opens=application.emailManager.getStat(attributes.emailid,'emailOpen')/>
        <cfset sent=application.emailManager.getStat(attributes.emailid,'sent')/>
        <cfset bounces=application.emailManager.getStat(attributes.emailid,'bounce')/>
        <cfset uniqueClicks=application.emailManager.getStat(attributes.emailid,'returnUnique')/>
        <cfset totalClicks=application.emailManager.getStat(attributes.emailid,'returnAll')/>
        <li><strong>#application.rbFactory.getKeyValue(session.rb,'email.sent')#:</strong> #sent#</li>
        <li><strong>#application.rbFactory.getKeyValue(session.rb,'email.opens')#:</strong> #opens# (
          <cfif sent gt 0>
#evaluate(round((opens/sent)*100))#%
            <cfelse>
            0%
          </cfif>
          )</li>
        <li><a href="index.cfm?fuseaction=cEmail.showReturns&emailid=#attributes.emailid#&siteid=#URLEncodedFormat(attributes.siteid)#"><strong>#application.rbFactory.getKeyValue(session.rb,'email.userswhoclicked')#:</strong></a> #clicks# (
          <cfif sent gt 0>
#evaluate(round((clicks/sent)*100))#%
            <cfelse>
            0%
          </cfif>
          )</li>
        <li><a href="index.cfm?fuseaction=cEmail.showReturns&emailid=#attributes.emailid#&siteid=#URLEncodedFormat(attributes.siteid)#"><strong>#application.rbFactory.getKeyValue(session.rb,'email.uniqueclicks')#:</strong></a> #uniqueClicks# </li>
        <li><a href="index.cfm?fuseaction=cEmail.showReturns&emailid=#attributes.emailid#&siteid=#URLEncodedFormat(attributes.siteid)#"><strong>#application.rbFactory.getKeyValue(session.rb,'email.totalclicks')#:</strong></a> #totalClicks# </li>
        <li><a href="index.cfm?fuseaction=cEmail.showBounces&emailid=#attributes.emailid#&siteid=#URLEncodedFormat(attributes.siteid)#"><strong>Bounces:</strong></a> #bounces# (
          <cfif sent gt 0>
#evaluate(round((bounces/sent)*100))#%
            <cfelse>
            0%
          </cfif>
          )</li>
      </cfif>
    </ul>
  </cfif>
  <form novalidate="novalidate" action="index.cfm?fuseaction=cEmail.update&siteid=#URLEncodedFormat(attributes.siteid)#" method="post" name="form1" onSubmit="return false;">
    
    <img class="loadProgress tabPreloader" src="images/progress_bar.gif">
    
    <div class="tabs initActiveTab" style="display:none">
	
	<ul>
        <li><a href="##emailContent" onClick="return false;"><span>Email</span></a></li>
        <li><a href="##emailGroupsLists" onClick="return false;"><span>Recipients</span></a></li>
    </ul>

    <!--- Email --->
    <div id="emailContent">
      <dl class="oneColumn">
        <dt class="first">#application.rbFactory.getKeyValue(session.rb,'email.subject')#</dt>
        <dd>
          <input type="text" class="text" name="subject" value="#HTMLEditFormat(request.emailBean.getsubject())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'email.subjectrequired')#">
        </dd>
        <dt>#application.rbFactory.getKeyValue(session.rb,'email.replytoemail')#</dt>
        <dd>
          <input type="text" class="text" name="replyto" value="#iif(attributes.emailid neq '',de("#request.emailBean.getreplyto()#"),de("#application.settingsManager.getSite(attributes.siteid).getcontact()#"))#"  required="true" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'email.replytorequired')#" >
        </dd>
        <dt>#application.rbFactory.getKeyValue(session.rb,'email.fromlabel')#</dt>
        <dd>
          <input type="text" class="text" name="fromLabel" value="#iif(request.emailBean.getFromLabel() neq '',de("#HTMLEditFormat(request.emailBean.getFromLabel())#"),de("#HTMLEditFormat(application.settingsManager.getSite(attributes.siteid).getsite())#"))#"  required="true" message="The 'From Label' form field is required" >
        </dd>
        <dt>#application.rbFactory.getKeyValue(session.rb,'email.format')#</dt>
        <dd>
          <select name="format" class="dropdown" onChange="showMessageEditor();" id="messageFormat">
            <option value="HTML">#application.rbFactory.getKeyValue(session.rb,'email.html')#</option>
            <option value="Text" <cfif request.emailBean.getformat() eq 'Text'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'email.text')#</option>
            <option value="HTML & Text" <cfif request.emailBean.getformat() eq 'HTML & Text'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'email.htmltext')#</option>
          </select>
        </dd>
        <span id="htmlMessage" style="display:none;">
        <dt>#application.rbFactory.getKeyValue(session.rb,'email.htmlmessage')#</dt>
        <dd>
          <cfset rsPluginScripts=application.pluginManager.getScripts("onHTMLEdit",attributes.siteID)>
          <cfif rsPluginScripts.recordcount>
            <cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
#application.pluginManager.renderScripts("onHTMLEdit",attributes.siteid,pluginEvent,rsPluginScripts)#
            <cfelse>
            <cfif application.configBean.getValue("htmlEditorType") eq "fckeditor">
              <cfscript>
		fckEditor = createObject("component", "mura.fckeditor");
		fckEditor.instanceName	= "bodyHTML";
		fckEditor.value			= '#request.emailBean.getBodyHTML()#';
		fckEditor.basePath		= "#application.configBean.getContext()#/wysiwyg/";
		fckEditor.config.EditorAreaCSS	= '#application.settingsManager.getSite(attributes.siteid).getThemeAssetPath()#/css/editor_email.css';
		fckEditor.config.StylesXmlPath = '#application.settingsManager.getSite(attributes.siteid).getThemeAssetPath()#/css/fckstyles.xml';
		fckEditor.config.DefaultLanguage=lcase(session.rb);
		fckEditor.config.AutoDetectLanguage=false;
		fckEditor.width			= "98%";
		fckEditor.height		= 400;
		
		if(fileExists("#expandPath(application.settingsManager.getSite(attributes.siteid).getThemeIncludePath())#/js/fckconfig.js.cfm"))
		{
		fckEditor.config["CustomConfigurationsPath"]=urlencodedformat('#application.settingsManager.getSite(attributes.siteid).getThemeAssetPath()#/js/fckconfig.js.cfm?EditorType=Email');
		}
		
		fckEditor.create(); // create the editor.
	</cfscript>
              <cfelse>
              <textarea name="bodyHTML" id="bodyHTML"><cfif len(request.emailBean.getBodyHTML())>#HTMLEditFormat(request.emailBean.getBodyHTML())#<cfelse><p></p></cfif>
</textarea>
              <script type="text/javascript" language="Javascript">
		var loadEditorCount = 0;
		jQuery('##bodyHTML').ckeditor({
			toolbar:'Default',
			height: '550',
			customConfig : 'config.js.cfm'
			},
			htmlEditorOnComplete
		);
		</script>
            </cfif>
          </cfif>
        </dd>
        </span> <span id="textMessage" style="display:none;">
        <dt>#application.rbFactory.getKeyValue(session.rb,'email.textmessage')#</dt>
        <dd>
          <textarea name="bodyText" id="textEditor">#HTMLEditFormat(request.emailBean.getbodytext())#</textarea>
        </dd>
        </span>
      </dl>
      </div>
      
      <!--- Recipients --->      
       <div id="emailGroupsLists" class="clearfix">
      <!--- <h3>#application.rbFactory.getKeyValue(session.rb,'email.sendto')#:</h3> --->
     	
     	<div class="tabs initActiveTab" style="display:none">
	
		<ul>
	        <cfif request.rsPrivateGroups.recordcount><li><a href="##privateGroups" onClick="return false;"><span>Admin Groups</span></a></li></cfif>
	        <cfif request.rsPublicGroups.recordcount><li><a href="##publicGroups" onClick="return false;"><span>Site Member Groups</span></a></li></cfif>
	        <cfif application.categoryManager.getInterestGroupCount(attributes.siteID)><li><a href="##interestGroups" onClick="return false;"><span>Interest Groups</span></a></li></cfif>
	        <cfif request.rsMailingLists.recordcount><li><a href="##mailingLists" onClick="return false;"><span>Mailing Lists</span></a></li></cfif>
	    </ul>
     	
      <cfif request.rsPrivateGroups.recordcount>
      <div id="privateGroups">
      <dl>
        <dt>#application.rbFactory.getKeyValue(session.rb,'email.privategroups')#</dt>
        <dd>
          <ul>
            <cfloop query="request.rsPrivateGroups">
              <li>
                <input type="checkbox" id="#request.rsPrivateGroups.groupname##request.rsPrivateGroups.UserID#" name="GroupID" class="checkbox" value="#request.rsPrivateGroups.UserID#" <cfif  listfind(request.emailBean.getgroupID(),request.rsPrivateGroups.userid)>checked</cfif>>
                <label for="#request.rsPrivateGroups.groupname##request.rsPrivateGroups.UserID#"><span class="text">#request.rsPrivateGroups.groupname#</span></label>
              </li>
            </cfloop>
          </ul>
        </dd>
        </dl>
        </div>
      </cfif>
      <cfif request.rsPublicGroups.recordcount>
      <div id="publicGroups">
        <dl>
          <dt>#application.rbFactory.getKeyValue(session.rb,'email.publicgroups')#</dt>
          <dd>
            <ul>
              <cfloop query="request.rsPublicGroups">
                <li>
                  <input type="checkbox" id="#request.rsPublicGroups.groupname##request.rsPublicGroups.UserID#" name="GroupID"  class="checkbox" value="#request.rsPublicGroups.UserID#" <cfif  listfind(request.emailBean.getgroupID(),request.rsPublicGroups.userid)>checked</cfif>>
                  <label for="#request.rsPublicGroups.groupname##request.rsPublicGroups.UserID#"><span class="text">#request.rsPublicGroups.groupname#</span></label>
                </li>
              </cfloop>
            </ul>
          </dd>
        </dl>
       </div>
      </cfif>
      <cfif application.categoryManager.getInterestGroupCount(attributes.siteID)>
      <div id="interestGroups">
        <dl>
          <dt>#application.rbFactory.getKeyValue(session.rb,'email.userinterestgroups')#</dt>
          <dd>
            <cf_dsp_categories_nest siteID="#attributes.siteID#" parentID="" nestLevel="0" groupid="#request.emailBean.getgroupID()#">
          </dd>
        </dl>
      </div>
      </cfif>
      <cfif request.rsMailingLists.recordcount>
      <div id="mailingLists">
        <dl>
          <dt>#application.rbFactory.getKeyValue(session.rb,'email.mailinglists')#</dt>
          <dd>
            <ul>
              <cfloop query="request.rsMailingLists">
                <li>
                  <input type="checkbox" id="#request.rsMailingLists.name##request.rsMailingLists.mlid#" name="GroupID"  class="checkbox" value="#request.rsMailingLists.mlid#" <cfif  listfind(request.emailBean.getgroupID(),request.rsMailingLists.mlid)>checked</cfif>>
                  <label for="#request.rsMailingLists.name##request.rsMailingLists.mlid#"><span class="text">#request.rsMailingLists.name#</span></label>
                </li>
              </cfloop>
            </ul>
          </dd>
        </dl>
      </div>
      </cfif>
    </div>
 </div> <!--- End Tab Container --->
      <div class="clearfix separate" id="actionButtons"> 
      <div style="display:inline" id="controls"> 
        <!---Delivery Options---><br />
        <cfsilent>
        <cfif attributes.emailid eq "">
          <cfset formAction = "add">
          <cfset currentEmailid = "">
          <cfset showDelete = false>
          <cfset showScheduler = false>
          <cfelse>
          <cfif request.emailBean.getStatus() eq 1>
            <cfset formAction = "add">
            <cfset currentEmailid = "">
            <cfset showDelete = true>
            <cfset showScheduler = false>
            <cfelse>
            <cfset formAction = "update">
            <cfset currentEmailid = attributes.emailid>
            <cfset showDelete = true>
            <cfset showScheduler = true>
          </cfif>
        </cfif>
        </cfsilent>
        <input type="button" class="submit" onClick="validateEmailForm('#formAction#', '#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'email.saveconfirm'))#')" value="#application.rbFactory.getKeyValue(session.rb,'email.save')#" /> <input type="button" class="submit" onClick="document.forms.form1.sendNow.value='true'; validateEmailForm('#formAction#', '#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'email.sendnowconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'email.sendnow')#" /> <input type="button" class="submit" onClick="openScheduler();" value="#application.rbFactory.getKeyValue(session.rb,'email.schedule')#" />
          <input type="hidden" name="emailid" value="#currentEmailid#">
          <cfif showDelete>
            <input type="button" class="submit" onClick="validateEmailForm('delete', '#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'email.deleteconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'email.delete')#" />
          </cfif>
       </div>
        <div style="display:none" id="scheduler"> #application.rbFactory.getKeyValue(session.rb,'email.deliverydate')#<br />
          <input type="text" class="textAlt datepicker" id="deliveryDate" name="deliveryDate" value="#LSDateFormat(request.emailBean.getDeliveryDate(),session.dateKeyFormat)#">
          <!---<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=form1&field=deliveryDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
          <cfsilent>
          <cfset timehour = "">
          <cfset timeminute = "">
          <cfset timepart = "">
          <cfset deliveryDate = request.emailBean.getDeliveryDate()>
          <cfset datecheck=LSisDate(deliveryDate)>
          <cfif datecheck>
            <cfset timehour=hour(deliveryDate) >
            <cfset timeminute=minute(deliveryDate) >
            <cfif timehour gte 12>
              <cfset timehour=timehour -12>
              <cfset timepart="PM">
              <cfelse>
              <cfset timepart="AM">
            </cfif>
            <cfif timeminute lt 30>
              <cfset timeminute = 0>
              <cfelse>
              <cfset timeminute = 30>
            </cfif>
          </cfif>
          </cfsilent>
          <select name="timehour" class="dropdown">
            <cfloop from="1" to="11" index="I">
              <cfif len(I) eq 1>
                <cfset hr="0#I#">
                <cfelse>
                <cfset hr="#I#">
              </cfif>
              <option value="#hr#" <cfif timehour eq I>selected</cfif>>#hr#</option>
            </cfloop>
            <option value="0" <cfif timehour eq 0>selected</cfif>>12</option>
          </select>
          <select name="timeminute" class="dropdown">
            <option value="00" <cfif timeminute eq 0>selected</cfif>>00</option>
            <option value="30" <cfif timeminute eq 30>selected</cfif>>30</option>
          </select>
          <select name="timepart" class="dropdown">
            <option value="AM" <cfif timepart eq 'AM'>selected</cfif>>AM</option>
            <option value="PM" <cfif timepart eq 'PM'>selected</cfif>>PM</option>
          </select>
          <input type="button" class="submit" onClick="validateScheduler('#formAction#', '#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'email.pleaseenterdate'))#', 'deliveryDate');" value="#application.rbFactory.getKeyValue(session.rb,'email.save')#"/> <input type="button" class="submit" onClick="closeScheduler()" value="#application.rbFactory.getKeyValue(session.rb,'email.cancel')#" /> </div>
        <input type="hidden" name="action" value="">
        <input type="hidden" name="sendNow" value="">
      </div>
	  </div>
      <div id="actionIndicator" style="display: none;"> <img src="#application.configBean.getContext()#/admin/images/progress_bar.gif"> </div>
    
    
  </form>
</cfoutput>
<cfif showScheduler and dateCheck>
  <script language="javascript">
				openScheduler();
			</script>
  <cfelse>
  <script language="javascript">
				closeScheduler();
			</script>
</cfif>
<script language="javascript">
			showMessageEditor();
		</script>