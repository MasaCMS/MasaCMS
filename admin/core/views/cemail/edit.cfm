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
<cfset event=request.event>
<cfinclude template="js.cfm">
<cfhtmlhead text="#session.dateKey#">
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>

<cfoutput>
<div class="mura-header">
  <h1>#application.rbFactory.getKeyValue(session.rb,'email.createeditemail')#</h1>
 <cfinclude template="dsp_secondary_menu.cfm">

  <div class="mura-item-metadata">
    <div class="label-group">
  
      <cfif rc.emailid neq "">
        <div class="metadata-horizontal">
          <span class="label">#application.rbFactory.getKeyValue(session.rb,'email.datecreated')#:<strong> #LSDateFormat(rc.emailBean.getCreatedDate(),session.dateKeyFormat)#</strong></span>
          <span class="label">#application.rbFactory.getKeyValue(session.rb,'email.createdby')#:<strong> #rc.emailBean.getlastupdateby()#</strong></span>
          <span class="label">#application.rbFactory.getKeyValue(session.rb,'email.status')#:<strong>
            <cfif rc.emailBean.getstatus()>
              #application.rbFactory.getKeyValue(session.rb,'email.sent')#
              <cfelse>
              #application.rbFactory.getKeyValue(session.rb,'email.queued')#
            </cfif>
          </strong></span>
          <cfif rc.emailBean.getstatus()>
            <cfset clicks=application.emailManager.getStat(rc.emailid,'returnClick')/>
            <cfset opens=application.emailManager.getStat(rc.emailid,'emailOpen')/>
            <cfset sent=application.emailManager.getStat(rc.emailid,'sent')/>
            <cfset bounces=application.emailManager.getStat(rc.emailid,'bounce')/>
            <cfset uniqueClicks=application.emailManager.getStat(rc.emailid,'returnUnique')/>
            <cfset totalClicks=application.emailManager.getStat(rc.emailid,'returnAll')/>
            <span class="label">#application.rbFactory.getKeyValue(session.rb,'email.sent')#:<strong> #sent#</strong></span>
            <span class="label">#application.rbFactory.getKeyValue(session.rb,'email.opens')#:<strong> #opens# (
              <cfif sent gt 0>
    #evaluate(round((opens/sent)*100))#%
                <cfelse>
                0%
              </cfif>
              )</strong></span>
            <span class="label"><a href="./?muraAction=cEmail.showReturns&emailid=#rc.emailid#&siteid=#esapiEncode('url',rc.siteid)#">#application.rbFactory.getKeyValue(session.rb,'email.userswhoclicked')#:</a> <strong>#clicks#</strong> (
              <cfif sent gt 0>
    #evaluate(round((clicks/sent)*100))#%
                <cfelse>
                0%
              </cfif>
              )</span>
            <span class="label"><a href="./?muraAction=cEmail.showReturns&emailid=#rc.emailid#&siteid=#esapiEncode('url',rc.siteid)#">#application.rbFactory.getKeyValue(session.rb,'email.uniqueclicks')#:</a> <strong>#uniqueClicks# </strong></span>
            <span class="label"><a href="./?muraAction=cEmail.showReturns&emailid=#rc.emailid#&siteid=#esapiEncode('url',rc.siteid)#">#application.rbFactory.getKeyValue(session.rb,'email.totalclicks')#:</a> <strong>#totalClicks# </strong></span>
            <span class="label"><a href="./?muraAction=cEmail.showBounces&emailid=#rc.emailid#&siteid=#esapiEncode('url',rc.siteid)#">Bounces:</a> <strong>#bounces# (
              <cfif sent gt 0>
    #evaluate(round((bounces/sent)*100))#%
                <cfelse>
                0%
              </cfif>
              )</strong></span>
          </cfif>
        </div>
      </cfif>

    </div><!-- /.label-group -->
  </div><!-- /.mura-item-metadata -->
</div> <!-- /.mura-header -->

<form novalidate="novalidate" action="./?muraAction=cEmail.update&siteid=#esapiEncode('url',rc.siteid)#" method="post" name="form1" onSubmit="return false;">
    
<div class="load-inline tab-preloader"></div>
<script>$('.tab-preloader').spin(spinnerArgs2);</script>
    

<div class="block block-constrain">

  <ul class="mura-tabs nav-tabs" data-toggle="tabs">
      <li class="active"><a href="##emailContent" onClick="return false;"><span>Email</span></a></li>
      <li><a href="##emailGroupsLists" onClick="return false;"><span>Recipients</span></a></li>
  </ul>

    <div class="block-content tab-content">

    <!--- Email --->
    <div id="emailContent" class="tab-pane active">
      <div class="block block-bordered">
        <!-- block header -->
        <div class="block-header">
          <h3 class="block-title">Email</h3>
        </div> <!-- /.block header -->            
        <div class="block-content">

      	<div class="mura-control-group">
        <label>
          #application.rbFactory.getKeyValue(session.rb,'email.subject')#
        </label>
          <input type="text" name="subject" value="#esapiEncode('html_attr',rc.emailBean.getsubject())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'email.subjectrequired')#">
      </div>
        
      <div class="mura-control-group">
        <label>
          #application.rbFactory.getKeyValue(session.rb,'email.replytoemail')#
        </label>
          <input type="text" name="replyto" value="#iif(rc.emailid neq '',de("#rc.emailBean.getreplyto()#"),de("#application.settingsManager.getSite(rc.siteid).getcontact()#"))#"  required="true" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'email.replytorequired')#" >
      </div>
        
      <div class="mura-control-group">
        <label>
          #application.rbFactory.getKeyValue(session.rb,'email.fromlabel')#
          </label>
          <input type="text" name="fromLabel" value="#esapiEncode('html_attr',iif(rc.emailBean.getFromLabel() neq '',de("#rc.emailBean.getFromLabel()#"),de("#application.settingsManager.getSite(rc.siteid).getsite()#")))#"  required="true" message="The 'From Label' form field is required" >
        </div>
        
        <div class="mura-control-group">
        <label>
          #application.rbFactory.getKeyValue(session.rb,'email.format')#
        </label>
          <select name="format"  onChange="emailManager.showMessageEditor();" id="messageFormat">
            <option value="HTML">#application.rbFactory.getKeyValue(session.rb,'email.html')#</option>
            <option value="Text" <cfif rc.emailBean.getformat() eq 'Text'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'email.text')#</option>
            <option value="HTML & Text" <cfif rc.emailBean.getformat() eq 'HTML & Text'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'email.htmltext')#</option>
          </select>
         </div>
        
        <span id="htmlMessage" style="display:none;">

          <!--- HTML LAYOUT TEMPLATE --->
          <cfif rc.rsTemplates.recordcount>
            <div class="mura-control-group">
              <label>
                #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.layouttemplate')#
              </label>
                <select name="template" class="dropdown">
                  <cfloop query="rc.rsTemplates">
                    <option value=""<cfif not Len(rc.rsTemplates.name)> selected</cfif>>Default</option>
                    <cfif right(rc.rsTemplates.name,4) eq ".cfm">
                      <cfoutput>
                        <option value="#rc.rsTemplates.name#" <cfif rc.emailBean.gettemplate() eq rc.rsTemplates.name>selected</cfif>>#rc.rsTemplates.name#</option>
                      </cfoutput>
                    </cfif>
                  </cfloop>
                </select>
            </div>
            <cfelse>
            <input type="hidden" name="template" value="">
          </cfif>
        
        <div class="mura-control-group">
        <label>
          #application.rbFactory.getKeyValue(session.rb,'email.htmlmessage')#
        </label>
          <cfset rsPluginScripts=application.pluginManager.getScripts("onHTMLEdit",rc.siteID)>
          <cfif rsPluginScripts.recordcount>
            <cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
#application.pluginManager.renderScripts("onHTMLEdit",rc.siteid,pluginEvent,rsPluginScripts)#
            <cfelse>
            <cfif application.configBean.getValue("htmlEditorType") eq "fckeditor">
              <cfscript>
		fckEditor = createObject("component", "mura.fckeditor");
		fckEditor.instanceName	= "bodyHTML";
		fckEditor.value			= '#rc.emailBean.getBodyHTML()#';
		fckEditor.basePath		= "#application.configBean.getContext()#/wysiwyg/";
		fckEditor.config.EditorAreaCSS	= '#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#/css/editor_email.css';
		fckEditor.config.StylesXmlPath = '#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#/css/fckstyles.xml';
		fckEditor.config.DefaultLanguage=lcase(session.rb);
		fckEditor.config.AutoDetectLanguage=false;
		fckEditor.width			= "98%";
		fckEditor.height		= 400;
		
		if(fileExists("#expandPath(application.settingsManager.getSite(rc.siteid).getThemeIncludePath())#/js/fckconfig.js.cfm"))
		{
		fckEditor.config["CustomConfigurationsPath"]=esapiEncode('url','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#/js/fckconfig.js.cfm?EditorType=Email');
		}
		
		fckEditor.create(); // create the editor.
	</cfscript>
              <cfelse>
              <textarea name="bodyHTML" id="bodyHTML"><cfif len(rc.emailBean.getBodyHTML())>#esapiEncode('html',rc.emailBean.getBodyHTML())#<cfelse><p></p></cfif>
</textarea>
              <script type="text/javascript">
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
          </div>
        
        </span> 

        <span id="textMessage" style="display:none;">
        
        <div class="mura-control-group">
        <label>
          #application.rbFactory.getKeyValue(session.rb,'email.textmessage')#
        </label>
          <textarea name="bodyText" id="textEditor">#esapiEncode('html',rc.emailBean.getbodytext())#</textarea>
        </div>

        </span>

      </div> <!-- /.block-content -->
    </div> <!-- /.block-bordered -->
  </div> <!-- /.tab-pane -->


	<!--- Recipients --->      
	<div id="emailGroupsLists" class="tab-pane">
	<!--- <h2>#application.rbFactory.getKeyValue(session.rb,'email.sendto')#:</h2> --->     	
    <div class="block block-bordered">
    <!-- block header -->
    <div class="block-header">
			<h3 class="block-title">Recipients</h3>
    </div> <!-- /.block header -->            
    <div class="block-content">
  
	  <cfif rc.rsPrivateGroups.recordcount>
	  <div id="privateGroups" class="mura-control-group">
        <label>
            #application.rbFactory.getKeyValue(session.rb,'email.privategroups')#
        </label>
        <cfloop query="rc.rsPrivateGroups">
          <label class="checkbox">
            <input type="checkbox" id="#esapiEncode('html_attr',rc.rsPrivateGroups.groupname)##rc.rsPrivateGroups.UserID#" name="GroupID" class="checkbox" value="#rc.rsPrivateGroups.UserID#" <cfif  listfind(rc.emailBean.getgroupID(),rc.rsPrivateGroups.userid)>checked</cfif>> #esapiEncode('html',rc.rsPrivateGroups.groupname)#</label>
        </cfloop>
      </div>
      </cfif>

      <cfif rc.rsPublicGroups.recordcount>
      <div id="publicGroups" class="mura-control-group">
        <label>
            #application.rbFactory.getKeyValue(session.rb,'email.publicgroups')#
        </label>
          <cfloop query="rc.rsPublicGroups">
            <label class="checkbox">
              <input type="checkbox" id="#esapiEncode('html_attr',rc.rsPublicGroups.groupname)##rc.rsPublicGroups.UserID#" name="GroupID"  class="checkbox" value="#rc.rsPublicGroups.UserID#" <cfif  listfind(rc.emailBean.getgroupID(),rc.rsPublicGroups.userid)>checked</cfif>> #esapiEncode('html',rc.rsPublicGroups.groupname)#</label>
            </label>
          </cfloop>
       </div>
      </cfif>
      
      
      <cfif application.categoryManager.getInterestGroupCount(rc.siteID)>
      <div id="interestGroups" class="mura-control-group">
        <label>
          #application.rbFactory.getKeyValue(session.rb,'email.userinterestgroups')#
        </label>
        <div class="mura-control" id="mura-list-tree">
            <cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" nestLevel="0" groupid="#rc.emailBean.getgroupID()#">
        </div>
      </div>
      </cfif>
      
      
      <cfif rc.rsMailingLists.recordcount>
      <div id="mailingLists" class="mura-control-group">
        <label>
          #application.rbFactory.getKeyValue(session.rb,'email.mailinglists')#
        </label>
          <cfloop query="rc.rsMailingLists">
            <label class="checkbox">
              <input type="checkbox" id="#esapiEncode('html_attr',rc.rsMailingLists.name)##rc.rsMailingLists.mlid#" name="GroupID"  class="checkbox" value="#rc.rsMailingLists.mlid#" <cfif  listfind(rc.emailBean.getgroupID(),rc.rsMailingLists.mlid)>checked</cfif>>#esapiEncode('html',rc.rsMailingLists.name)#</span>
            </label>
          </cfloop>
          </div>
      </cfif>
      </div> <!-- /.block-content -->
    </div> <!-- /.block-bordered -->
  </div> <!-- /.tab-pane -->
  <!-- /end tab -->

  <!--- End Tab Container --->
  <div class="mura-actions">
    <div class="form-actions"> 
    <!---Delivery Options--->
    	<cfsilent>
    	<cfif rc.emailid eq "">
    	<cfset formAction = "add">
    	<cfset currentEmailid = "">
    	<cfset showDelete = false>
    	<cfset showScheduler = false>
    	<cfelse>
    	<cfif rc.emailBean.getStatus() eq 1>
    	<cfset formAction = "add">
    	<cfset currentEmailid = "">
    	<cfset showDelete = true>
    	<cfset showScheduler = false>
    	<cfset rc.emailBean.setDeliveryDate('')>
    	<cfelse>
    	<cfset formAction = "update">
    	<cfset currentEmailid = rc.emailid>
    	<cfset showDelete = true>
    	<cfset showScheduler = true>
    	</cfif>
    	</cfif>
    	</cfsilent>
    	<cfif showDelete>
    	<button type="button" class="btn toggle" onClick="emailManager.validateEmailForm('delete', '#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'email.deleteconfirm'))#');"><i class="mi-remove"></i> #application.rbFactory.getKeyValue(session.rb,'email.delete')#</button>
    	</cfif>
    	<button type="button" class="btn toggle" onClick="emailManager.validateEmailForm('#formAction#', '#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'email.saveconfirm'))#')"><i class="mi-check"></i> #application.rbFactory.getKeyValue(session.rb,'email.save')#</button>
    	<button type="button" class="btn" onClick="emailManager.openScheduler();"><i class="mi-calendar"></i> #application.rbFactory.getKeyValue(session.rb,'email.schedule')#</button>
    	<button type="button" class="btn mura-primary toggle" onClick="document.forms.form1.sendNow.value='true'; emailManager.validateEmailForm('#formAction#', '#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'email.sendnowconfirm'))#');"><i class="mi-share-alt"></i> #application.rbFactory.getKeyValue(session.rb,'email.sendnow')#</button>
    	<input type="hidden" name="emailid" value="#currentEmailid#">
    </div>
  </div>
         
    <div style="display:none" id="scheduler">
      <div class="mura-control-group">
        <label>#application.rbFactory.getKeyValue(session.rb,'email.deliverydate')#</label>
        <cf_datetimeselector name="deliveryDate" 
        datetime="#rc.emailBean.getDeliveryDate()#" >
        <cfset deliveryDate = rc.emailBean.getDeliveryDate()>
        <cfset datecheck=LSisDate(deliveryDate)>
      </div>
     
      <div class="mura-actions">
        <div class="form-actions">
          <button type="button" class="btn" onClick="emailManager.validateScheduler('#formAction#', '#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'email.pleaseenterdate'))#', 'deliveryDate');"><i class="mi-check"></i> #application.rbFactory.getKeyValue(session.rb,'email.save')#</button>
          <button type="button" class="btn" onClick="emailManager.closeScheduler()"><i class="mi-ban"></i> #application.rbFactory.getKeyValue(session.rb,'email.cancel')#</button>
          <input type="hidden" name="action" value="">
          <input type="hidden" name="sendNow" value="">
       </div>
     </div>
    </div>
  </div>
  
 </div> 
    
    </div> <!-- /.block-content.tab-content -->	
  </div> <!-- /.block-constrain -->
</form>
</cfoutput>
<cfif showScheduler and dateCheck>
  <script>
		emailManager.openScheduler();
	</script>
  <cfelse>
  <script>
		emailManager.closeScheduler();
	</script>
</cfif>
  <script>
		emailManager.showMessageEditor();
  </script>