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
<cfloop from="1" to="#application.settingsManager.getSite($.event('siteID')).getColumnCount()#" index="i">
  <cfparam name="request.rsContentObjects#i#.recordcount" default=0>
</cfloop>
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.layoutobjects"))/>
<cfset tabList=listAppend(tabList,"tabLayoutObjects")>

<cfoutput>
  <div id="tabLayoutObjects" class="tab-pane">

    <!-- block -->
    <div class="block block-bordered">
      <!-- block header -->
      <div class="block-header">
			   <h3 class="block-title">Layout &amp; Objects</h3>
      </div>
      <!-- /block header -->

      <!-- block content -->
      <div class="block-content">
  			<span id="extendset-container-tablayoutobjectstop" class="extendset-container"></span>
        <div class="mura-control-group">
              <div class="half">
                <div class="mura-control-group">
                  <label>
                      <span data-toggle="popover" title="" data-placement="right"
                      data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.layoutTemplate"))#"
                      data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.layouttemplate"))#">
                        #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.layouttemplate')#
                       <i class="mi-question-circle"></i></span>
            			</label>
		              <select name="template" class="dropdown">
			            <cfif rc.contentid neq '00000000000000000000000000000000001'>
			              <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritfromparent')#</option>
			            </cfif>
									<cfset renderer=rc.$.getContentRenderer()>
									<cfif isDefined('renderer.templateArray') and isArray(renderer.templateArray)>
										<cfset templateArray=renderer.templateArray>
									<cfelse>
										<cfset templateArray=listToArray(rc.$.siteConfig('templateList'),'^')>
									</cfif>
									<cfif rc.moduleID eq  '00000000000000000000000000000000000' and arrayLen(templateArray)>
										<cfloop from="1" to="#arrayLen(renderer.templateArray)#" index="t">
			                <cfoutput>
			                  <option value="#templateArray[t]#" <cfif rc.contentBean.gettemplate() eq templateArray[t]>selected</cfif>>#templateArray[t]#</option>
			                </cfoutput>
				            </cfloop>
									<cfelse>
				            <cfloop query="rc.rsTemplates">
				              <cfif listFindNocase('cfm,html,htm,hbs',listLast(rc.rsTemplates.name,'.'))>
				                <option value="#rc.rsTemplates.name#" <cfif rc.contentBean.gettemplate() eq rc.rsTemplates.name>selected</cfif>>#rc.rsTemplates.name#</option>
				              </cfif>
				            </cfloop>
									</cfif>
		          		</select>
        			</div>
        		</div>
            <div class="half">
              <div class="mura-control-group">
              <label>
                <span data-toggle="popover" title="" data-placement="right"
                data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.childTemplate"))#"
                data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.childtemplate"))#">
                  #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.childtemplate')#
                 <i class="mi-question-circle"></i></span>
              </label>
              <select name="childTemplate" class="dropdown">
	            <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.none')#</option>
							<cfset templateArray=listToArray(rc.$.siteConfig('templateList'),'^')>
							<cfif rc.moduleID eq  '00000000000000000000000000000000000' and arrayLen(templateArray)>
								<cfloop from="1" to="#arrayLen(templateArray)#" index="t">
	                <cfoutput>
	                  <option value="#templateArray[t]#" <cfif rc.contentBean.getchildTemplate() eq templateArray[t]>selected</cfif>>#templateArray[t]#</option>
	                </cfoutput>
		            </cfloop>
							<cfelse>
								<cfloop query="rc.rsTemplates">
		              <cfif listFindNocase('cfm,html,htm,hbs',listLast(rc.rsTemplates.name,'.'))>
		                <cfoutput>
		                  <option value="#rc.rsTemplates.name#" <cfif rc.contentBean.getchildTemplate() eq rc.rsTemplates.name>selected</cfif>>#rc.rsTemplates.name#</option>
		                </cfoutput>
		              </cfif>
		            </cfloop>
							</cfif>
	          </select>
        </div>
      </div>
    </div>

      <div class="mura-control-group">
        <label>
          <span data-toggle="popover" title="" data-placement="right"
          data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.inheritancerules"))#"
          data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.inheritancerules"))#">
            #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritancerules')#
           <i class="mi-question-circle"></i></span>
        </label>
         <cfif structKeyExists(request, "inheritedObjects") and len(request.inheritedObjects)>
            <cfset inheritBean=$.getBean('content').loadBy(contenthistid=request.inheritedObjects)>
            <cfif inheritBean.getContentID() neq rc.contentBean.getContentID()>
            <div class="help-block">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.currentinheritance')#:
            <cfif listFindNoCase("author,editor",application.permUtility.getnodePerm(inheritBean.getCrumbArray()))>
              <a href='#inheritBean.getEditURL(compactDisplay=yesNoFormat(rc.compactdisplay),tab='tabLayoutObjects')#'>#esapiEncode('html',inheritBean.getMenuTitle())#</a>
            <cfelse>
               #esapiEncode('html',inheritBean.getMenuTitle())#
            </cfif>
            </div>
            </cfif>
        </cfif>
        <label for="ioi" class="radio inline">
        <input type="radio" name="inheritObjects" id="ioi" value="Inherit" <cfif rc.contentBean.getinheritObjects() eq 'inherit' or rc.contentBean.getinheritObjects() eq ''>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritcascade')#
        </label>
        <label for="ioc" class="radio inline">
        <input type="radio" name="inheritObjects" id="ioc" value="Cascade" <cfif rc.contentBean.getinheritObjects() eq 'cascade'>checked</cfif>>
        #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startnewcascade')#
        </label>
        <label for="ior" class="radio inline">
        <input type="radio" name="inheritObjects" id="ior" value="Reject" <cfif rc.contentBean.getinheritObjects() eq 'reject'>checked</cfif>>
        #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.donotinheritcascade')#
        </label>
      </div>

        <cfif rc.$.getContentRenderer().useLayoutManager()>
          <div class="mura-control-group">
            <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentobjects')#</label>
            <div class="help-block">
              <p>To manage content objects, <a href="##" onclick="return preview('#application.settingsManager.getSite(rc.siteid).getWebPath(complete=1)##$.getURLStem(rc.siteid,rc.contentbean.getfilename())#?previewid=#rc.contentbean.getContentHistID()#','#esapiEncode('javascript',rc.contentbean.getTargetParams())#');">preview this content node</a> and select the "Inline Edit" option.</p>
            </div>
          </div>

        <cfelse>
          <div class="mura-control-group">
            <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentobjects')#</label>
            <div id="editObjects">
            <script>
             var availableObjectSuffix='';
            </script>
            <div id="availableObjectsContainer">
            <dl>
              <dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.availablecontentobjects')#</dt>
              <dd>
                <select name="classSelector" onchange="siteManager.loadObjectClass('#esapiEncode("Javascript",rc.siteid)#',this.value,'','#rc.contentBean.getContentID()#','#esapiEncode("Javascript",rc.parentID)#','#rc.contentBean.getContentHistID()#',0);"  id="dragme">
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
                  <cfif fileExists("#application.configBean.getWebRoot()#/#rc.siteid#/includes/display_objects/custom/admin/dsp_objectClassLabel.cfm")>
                  <cfinclude template="/#application.configBean.getWebRootMap()#/#rc.siteID#/includes/display_objects/custom/admin/dsp_objectClassLabel.cfm" >
                  </cfif>
                  <option value="plugins">#application.rbFactory.getKeyValue(session.rb,'layout.plugins')#</option>
                </select>
              </dd>
            </dl>
            <div id="classList"></div>
            </div><!--- /#availableObjects --->
        <div id="availableRegions">
          <cfloop from="1" to="#application.settingsManager.getSite(rc.siteid).getcolumnCount()#" index="r">
            <div class="region">
                    <div class="btn-group btn-group-vertical"> <a class="objectNav btn" onclick="siteManager.addDisplayObject('availableObjects' + availableObjectSuffix,#r#,true);"> <i class="mi-caret-right"></i></a> <a class="objectNav btn" onclick="siteManager.deleteDisplayObject(#r#);"> <i class="mi-caret-left"></i></a> </div>
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
                    <option  value="#request["rsContentObjects#r#"].object#~#esapiEncode('html',request["rsContentObjects#r#"].name)#~#request["rsContentObjects#r#"].objectid#~#esapiEncode('html',request["rsContentObjects#r#"].params)#">
                    #request["rsContentObjects#r#"].name#

                    </option>
                    <cfset variables["objectlist#r#"]=listappend(variables["objectlist#r#"],"#request["rsContentObjects#r#"].object#~#esapiEncode('html',request["rsContentObjects#r#"].name)#~#request["rsContentObjects#r#"].objectid#~#esapiEncode('html',request["rsContentObjects#r#"].params)#","^")>
                  </cfloop>
                </select>
                <input type="hidden" name="objectList#r#" id="objectList#r#" value="#variables["objectlist#r#"]#">
              </dd>
              </dl>
                    <div class="btn-group btn-group-vertical"> <a class="objectNav btn" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.up')#" onclick="siteManager.moveDisplayObjectUp(#r#);"> <i class="mi-caret-up"></i></a> <a class="objectNav btn" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.down')#" onclick="siteManager.moveDisplayObjectDown(#r#);"> <i class="mi-caret-down"></i></a> </div>
            </div> <!--- /.region --->
          </cfloop>
        </div> <!--- /#availableRegions --->
      </div> <!--- /#editObjects--->
          </div> <!--- /.mura-control-group --->
    </cfif>

  <span id="extendset-container-layoutobjects" class="extendset-container"></span>
  <span id="extendset-container-tablayoutobjectsbottom" class="extendset-container"></span>

    </div> <!--- /.block-content --->
  </div> <!--- /.block --->
</div> <!--- /.tab-pane --->
  <cfinclude template="../dsp_configuratorJS.cfm">
</cfoutput>
