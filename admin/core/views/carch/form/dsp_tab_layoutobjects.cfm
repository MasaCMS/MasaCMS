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

<cfloop from="1" to="#application.settingsManager.getSite('siteID').getColumnCount()#" index="i">
  <cfparam name="request.rsContentObjects#i#.recordcount" default=0>
</cfloop>
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.layoutobjects"))/>
<cfset tabList=listAppend(tabList,"tabLayoutObjects")>

<cfoutput>
  <div id="tabLayoutObjects" class="tab-pane fade">

  <span id="extendset-container-tablayoutobjectstop" class="extendset-container"></span>

  <div class="fieldset">
      <div class="control-group">
              <label class="control-label">
                <cfoutput><a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.layoutTemplate"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.layouttemplate')# <i class="icon-question-sign"></i></a></cfoutput>
            </label>
            <div class="controls">
              <select name="template" class="dropdown">
            <cfif rc.contentid neq '00000000000000000000000000000000001'>
              <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritfromparent')#</option>
            </cfif>
            <cfloop query="rc.rsTemplates">
              <cfif right(rc.rsTemplates.name,4) eq ".cfm">
                <cfoutput>
                  <option value="#rc.rsTemplates.name#" <cfif rc.contentBean.gettemplate() eq rc.rsTemplates.name>selected</cfif>>#rc.rsTemplates.name#</option>
                </cfoutput>
              </cfif>
            </cfloop>
          </select>
        </div>
      </div>

      <div class="control-group">
              <label class="control-label">
                <cfoutput><a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.childTemplate"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.childtemplate')# <i class="icon-question-sign"></i></a></cfoutput>
              </label>
              <div class="controls">
              <select name="childTemplate" class="dropdown">
            <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.none')#</option>
            <cfloop query="rc.rsTemplates">
              <cfif right(rc.rsTemplates.name,4) eq ".cfm">
                <cfoutput>
                  <option value="#rc.rsTemplates.name#" <cfif rc.contentBean.getchildTemplate() eq rc.rsTemplates.name>selected</cfif>>#rc.rsTemplates.name#</option>
                </cfoutput>
              </cfif>
            </cfloop>
          </select>
        </div>
    </div>
 
    <div class="control-group">
      <label class="control-label"> <a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.inheritanceRules"))#"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritancerules')# <i class="icon-question-sign"></i> </a> </label>
      <div class="controls">
        <label for="ioi" class="radio inline">
          <input type="radio" name="inheritObjects" id="ioi" value="Inherit" <cfif rc.contentBean.getinheritObjects() eq 'inherit' or rc.contentBean.getinheritObjects() eq ''>checked</cfif>>
#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritcascade')#           </label>
        <label for="ioc" class="radio inline">
          <input type="radio" name="inheritObjects" id="ioc" value="Cascade" <cfif rc.contentBean.getinheritObjects() eq 'cascade'>checked</cfif>>
#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startnewcascade')#           </label>
        <label for="ior" class="radio inline">
          <input type="radio" name="inheritObjects" id="ior" value="Reject" <cfif rc.contentBean.getinheritObjects() eq 'reject'>checked</cfif>>
#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.donotinheritcascade')#           </label>
      </div>
    </div>
    
    <div class="control-group">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentobjects')#</label>
      <div class="controls" id="editObjects">
        <div id="availableObjectsContainer">
          <dl>
            <dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.availablecontentobjects')#</dt>
            <dd>
              <select name="classSelector" onchange="siteManager.loadObjectClass('#rc.siteid#',this.value,'','#rc.contentBean.getContentID()#','#rc.parentID#','#rc.contentBean.getContentHistID()#',0);"  id="dragme">
                <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectobjecttype')#</option>
                <option value="system">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.system')#</option>
               <option value="navigation">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.navigation')#</option>
                <cfif application.settingsManager.getSite(rc.siteid).getemailbroadcaster()>
                  <option value="mailingList">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mailinglists')#</option>
                </cfif>
                <cfif application.settingsManager.getSite(rc.siteid).getAdManager()>
                  <option value="adzone">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.adregions')#</option>
                </cfif>
                <!--- <option value="category">Categories</option> --->
                <option value="folder">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.Folders')#</option>
                <option value="calendar">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendars')#</option>
                <option value="gallery">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.galleries')#</option>
                <option value="component">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.components')#</option>
                <cfif application.settingsManager.getSite(rc.siteid).getDataCollection()>
                  <option value="form">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forms')#</option>
                </cfif>
                <cfif application.settingsManager.getSite(rc.siteid).getHasfeedManager()>
                  <option value="localFeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexes')#</option>
                  <option value="slideshow">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexslideshows')#</option>
                  <option value="remoteFeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeeds')#</option>
                </cfif>
                <cfif fileExists("#application.configBean.getWebRoot()##application.configBean.getFileDelim()##rc.siteid##application.configBean.getFileDelim()#includes#application.configBean.getFileDelim()#display_objects#application.configBean.getFileDelim()#custom#application.configBean.getFileDelim()#admin#application.configBean.getFileDelim()#dsp_objectClassLabel.cfm")>
                  <cfinclude template="/#application.configBean.getWebRootMap()#/#rc.siteID#/includes/display_objects/custom/admin/dsp_objectClassLabel.cfm" >
                </cfif>
                <option value="plugins">#application.rbFactory.getKeyValue(session.rb,'layout.plugins')#</option>
              </select>
            </dd>
          </dl>
          <div id="classList"></div>
        </div>
        <div id="availableRegions">
          <cfloop from="1" to="#application.settingsManager.getSite(rc.siteid).getcolumnCount()#" index="r">
            <div class="region">
              <div class="btn-group btn-group-vertical"> <a class="objectNav btn" onclick="siteManager.addDisplayObject('availableObjects',#r#,true);"> <i class="icon-caret-right"></i></a> <a class="objectNav btn" onclick="siteManager.deleteDisplayObject(#r#);"> <i class="icon-caret-left"></i></a> </div>
              <cfif listlen(application.settingsManager.getSite(rc.siteid).getcolumnNames(),"^") gte r>
                <dl>
                <dt>#listgetat(application.settingsManager.getSite(rc.siteid).getcolumnNames(),r,"^")#
                  <cfelse>
                <dt>
                Region #r#
              </cfif>
#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentobjects')#
              </dt>
              <cfset variables["objectlist#r#"]="">
              <dd>
                <select name="selectedObjects#r#" id="selectedObjects#r#" class="multiSelect displayRegions" multiple="multiple" size="4" data-regionid="#r#">
                  <cfloop query="request.rsContentObjects#r#">
                    <option  value="#request["rsContentObjects#r#"].object#~#HTMLEditFormat(request["rsContentObjects#r#"].name)#~#request["rsContentObjects#r#"].objectid#~#HTMLEditFormat(request["rsContentObjects#r#"].params)#">
                    #request["rsContentObjects#r#"].name#
						      
                    </option>
                    <cfset variables["objectlist#r#"]=listappend(variables["objectlist#r#"],"#request["rsContentObjects#r#"].object#~#HTMLEditFormat(request["rsContentObjects#r#"].name)#~#request["rsContentObjects#r#"].objectid#~#HTMLEditFormat(request["rsContentObjects#r#"].params)#","^")>
                  </cfloop>
                </select>
                <input type="hidden" name="objectList#r#" id="objectList#r#" value="#variables["objectlist#r#"]#">
              </dd>
              </dl>
              <div class="btn-group btn-group-vertical"> <a class="objectNav btn" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.up')#" onclick="siteManager.moveDisplayObjectUp(#r#);"> <i class="icon-caret-up"></i></a> <a class="objectNav btn" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.down')#" onclick="siteManager.moveDisplayObjectDown(#r#);"> <i class="icon-caret-down"></i></a> </div>
            </div> <!--- /.region --->
          </cfloop>
        </div> <!--- /#availableRegions --->
      </div> <!--- /#editObjects--->
    </div> <!--- /.control-group --->

  
  </div>  

  <span id="extendset-container-layoutobjects" class="extendset-container"></span>
  <span id="extendset-container-tablayoutobjectsbottom" class="extendset-container"></span>

  </div> <!--- /.tab-pane --->
  <cfinclude template="../dsp_configuratorJS.cfm">
</cfoutput>