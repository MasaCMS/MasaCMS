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
<cfparam name="rc.originalfuseAction" default="">
<cfparam name="rc.originalcircuit" default="">
<cfparam name="rc.moduleid" default="">
<cfif not application.configBean.getSessionHistory() or application.configBean.getSessionHistory() gte 30>
	<cfparam name="session.dashboardSpan" default="30">
<cfelse>
	<cfparam name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#">
</cfif>
<cfif not isDefined("session.mura.memberships")>
  <cflocation url="#application.configBean.getContext()#/admin/?muraAction=cLogin.logout" addtoken="false">
</cfif>
<cfset rc.siteBean=application.settingsManager.getSite(session.siteID)>
</cfsilent>

<cfoutput>
<header>
	<div class="navbar navbar-fixed-top">
	  <div class="navbar-inner">
	   <div class="container">
	      <a class="brand" href="http://www.getmura.com" title="Mura CMS" target="_blank">Mura CMS</a>
	      <div class="brand-credit">by Blue River</div>	      
	      <cfif listFind(session.mura.memberships,'S2IsPrivate')>
	       <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	          </a>
	         
	       <!--- Navbar site select button
	       <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-site-select">
	            <span class="icon-globe"></span>
	          </a>--->
	          <cfparam name="session.showdashboard" default="true">
              <cfif session.showdashboard>
                  <cfset baseURL="#application.configBean.getContext()#/admin/?muraAction=cDashboard.main">
              <cfelse>
                   <cfset baseURL="#application.configBean.getContext()#/admin/?muraAction=cArch.list&amp;moduleID=00000000000000000000000000000000000&amp;topID=00000000000000000000000000000000001">
               </cfif> 
	         
	          <div class="nav-collapse">
	            <ul class="nav pull-right">
	              <cfif session.mura.isLoggedIn>
	              <li id="navVersion" class="dropdown">
	               <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-info-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.version")#
	                      <b class="caret"></b>
	                    </a>
	                <ul class="dropdown-menu">
						<li><a href="##"><strong>Core Version</strong> #application.autoUpdater.getCurrentCompleteVersion()#</a></li>
						<li><a href="##"><strong>Site Version</strong> #application.autoUpdater.getCurrentCompleteVersion(session.siteid)#</a></span>
							<cfif application.configBean.getMode() eq 'Staging' and session.siteid neq '' and session.mura.isLoggedIn>
							<li><a href="##"><strong>Last Deployment</strong>
								<cftry>
								#LSDateFormat(application.settingsManager.getSite(session.siteid).getLastDeployment(),session.dateKeyFormat)# #LSTimeFormat(application.settingsManager.getSite(session.siteid).getLastDeployment(),"short")#
									<cfcatch>
									Never
									</cfcatch>
								</cftry>
							</li>
							</cfif>
						</cfif> 
	                </ul>
	                </cfif>
	              <!--- Global Settings --->
	               <cfif session.siteid neq '' and session.mura.isLoggedIn>
	               		<cfif listFind(session.mura.memberships,'S2')>
	              	               
	                  	<li id="navGlobalSettings" class="dropdown">
	                    <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-cogs"></i> #application.rbFactory.getKeyValue(session.rb,"layout.settings")#
	                      <b class="caret"></b>
	                    </a>
		                    <ul class="dropdown-menu">
		                    <li>
		                        <a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.list"><i class="icon-cogs"></i> #application.rbFactory.getKeyValue(session.rb,"layout.globalsettings")#</a>
		                    </li>
		                    <li>
		                        <a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.list##tabPlugins"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.globalsettings-plugins")#</a>
		                    </li>
		                    <li>
		                      <a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&siteid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.addsite")#</a>
		                    </li>
		                    <li><a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.sitecopyselect"><i class="icon-copy"></i> #application.rbFactory.getKeyValue(session.rb,"layout.sitecopytool")#</a>
		                    </li>
		                   
		                     	<li><a href="#application.configBean.getContext()#/admin/?#urlEncodedFormat(application.appreloadkey)#&reload=#urlEncodedFormat(application.appreloadkey)#" onclick="return actionModal(this.href);"><i class="icon-refresh"></i> #application.rbFactory.getKeyValue(session.rb,"layout.reloadapplication")#</a></li>
		                     	
		                     	<cfif not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()>
		                     	<li>
		                     		<a href="##" onclick="confirmDialog('WARNING: Do not update your core files unless you have backed up your current Mura install.<cfif application.configBean.getDbType() eq "mssql">\n\nIf you are using MSSQL you must uncheck Maintain Connections in your CF administrator datasource settings before proceeding. You may turn it back on after the update is complete.</cfif>',function(){actionModal('./?muraAction=cSettings.list&action=updateCore')});return false;">
		                     			<i class="icon-bolt"></i> Update Mura Core
		                     		</a>
		                     	</li>
		                     	</cfif>
		                   
		                    </ul>
	                 </cfif>

	                <li id="navHelp" class="dropdown">
	                  <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-question-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.help")#
	                   <b class="caret"></b>
	                  </a>
	                  <ul class="dropdown-menu">
						  <li><a id="navCSS-API" href="http://docs.getmura.com/v6/" target="_blank"><i class="icon-bookmark"></i> #application.rbFactory.getKeyValue(session.rb,"layout.developers")#</a></li>
	                   <li><a id="navFckEditorDocs" href="http://docs.cksource.com/" target="_blank"><i class="icon-bookmark"></i> #application.rbFactory.getKeyValue(session.rb,"layout.editordocumentation")#</a></li>
					   <li><a id="navProg-API" href="http://www.getmura.com/component-api/6.1/" target="_blank"><i class="icon-bookmark"></i> Component API</a></li>
	                    <li><a id="navHelpDocs" href="http://www.getmura.com/support/professional-support/" target="_blank"><i class="icon-group"></i> #application.rbFactory.getKeyValue(session.rb,"layout.support")#</a></li>
	                   <li class="last"><a id="navHelpForums" href="http://www.getmura.com/support/community-support/" target="_blank"><i class="icon-bullhorn"></i> #application.rbFactory.getKeyValue(session.rb,"layout.supportforum")#</a></li>
	                  </ul>
	                </li> 
	             
	               
	                 <li id="navEditProfile" class="dropdown">
	                 	<a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-user"></i> #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#
	                 		<b class="caret"></b></a>
		                 <ul class="dropdown-menu">
		                 <li>
		                 <a href="#application.configBean.getContext()#/admin/?muraAction=cEditProfile.edit"><i class="icon-pencil"></i> #application.rbFactory.getKeyValue(session.rb,"layout.editprofile")#</a></li>
		                 <li id="navLogout"><a href="#application.configBean.getContext()#/admin/?muraAction=cLogin.logout"><i class="icon-signout"></i> #application.rbFactory.getKeyValue(session.rb,"layout.logout")#</a></li>
		                 </ul>
	                 </li>
	               
	                
	              </ul>
	          </div><!--/.nav-collapse -->
	          </div><!--/.container -->
	    </div>
	    </cfif>
	   </div>
	  </div>
	</div>
	
	 <cfif rc.originalcircuit neq 'cLogin'>
	 
	 <div class="nav-site">
	 
	 	<div class="nav-site-inner">
	 	
	 		<div class="container">
	 		
	 
	 			<cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />		
	 
	 			<ul>
	 				
	 				<li id="select-site" class="dropdown">
	 					
		 				  <a id="select-site-btn" href="http://#application.settingsManager.getSite(session.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.configBean.getStub()#/<cfif application.configBean.getSiteIDInURLS()>#session.siteid#/</cfif>" target="_blank">Current Site</a>
		 				<a class="dropdown-toggle" data-toggle="dropdown" href="##">
		 				  
			 				<!--- <i></i> --->
			 				<div id="site-name">#application.settingsManager.getSite(session.siteid).getSite()#</div>
			 				<b class="caret"></b>
		 				</a>
	 					
		 				<ul id="select-site-ul" class="dropdown-menu ui-front">
		 					<cfif theSiteList.recordCount gt 20> 
		 					<div class="ui-widget"><input name="site-search" class="form-control input-sm" type="text" placeholder="#application.rbFactory.getKeyValue(session.rb,"dashboard.search")#..."></div>
		 					</cfif>
		 				    <cfloop query="theSiteList" startrow="1" endrow="100">
		 				      <li<cfif session.siteID eq theSiteList.siteID> class="active"</cfif>>
		 				        <a href="#baseURL#&amp;siteID=#theSiteList.siteID#" title="#HTMLEditFormat(theSiteList.site)#"><i class="icon-globe"></i> #HTMLEditFormat(theSiteList.site)#</a>
		 				      </li>
		 				    </cfloop>
		 				    
		 				</ul>
	 				
	 				</li>
	 				
	 				<cfif session.showdashboard>
	 				<li<cfif  rc.originalcircuit eq 'cDashboard'> class="active"</cfif>>
	 					<a href="#application.configBean.getContext()#/admin/?muraAction=cDashboard.main&siteid=#session.siteid#&span=#session.dashboardSpan#"> <i class="icon-dashboard"></i><span>#application.rbFactory.getKeyValue(session.rb,"layout.dashboard")#</span></a>
	 				</li>
	 				</cfif>
	 				
	 				<li <cfif rc.originalcircuit eq 'cArch' and not listFind('00000000000000000000000000000000003,00000000000000000000000000000000004',rc.moduleID) and not (rc.originalfuseaction eq 'imagedetails' and isDefined('url.userID'))> class="active"</cfif>>
	 					<a href="#application.configBean.getContext()#/admin/?muraAction=cArch.list&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000">
	 						<i class="icon-list-alt"></i> <span>#application.rbFactory.getKeyValue(session.rb,"layout.sitemanager")#</span>
	 					</a>	    				
	 				</li>
	 				
	 				<cfset hidelist="cLogin">
	 				<cfif not listfindNoCase(hidelist,rc.originalcircuit)>
	 				  <cfinclude template="dsp_module_menu.cfm">
	 				</cfif>
	 				<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')
	 					or (application.settingsManager.getSite(session.siteid).getextranet() and  application.permUtility.getModulePerm("00000000000000000000000000000000008","#session.siteid#"))>
		 					<li class="dropdown<cfif listFindNoCase('cPrivateUsers,cPublicUsers',rc.originalcircuit) or (rc.originalfuseaction eq 'imagedetails' and isDefined('url.userID'))> active</cfif>">
		 					<a class="dropdown-toggle" data-toggle="dropdown" href="##">
		 						<i class="icon-group"></i> <span>#application.rbFactory.getKeyValue(session.rb,"layout.users")#</span>
		 						<b class="caret"></b>
		 					</a>
		 					
		 					<cfparam name="rc.userid" default="">
		 					<ul class="dropdown-menu">
		 						<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
			 						<li <cfif request.action eq "core:cprivateusers.list" or (rc.originalcircuit eq 'cprivateusers' and len(rc.userid))> class="active"</cfif>><a href="#application.configBean.getContext()#/admin/?muraAction=cPrivateUsers.list&siteid=#session.siteid#"><i class="icon-group"></i> #application.rbFactory.getKeyValue(session.rb,"layout.viewadministrativeusers")#</a></li>
				 					<li<cfif request.action eq "core:cprivateusers.edituser" and not len(rc.userID)> class="active"</cfif>><a href="#application.configBean.getContext()#/admin/?muraAction=cPrivateUsers.edituser&siteid=#session.siteid#&userid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.addadministrativeuser")#</a></li>
				 					<li class="last<cfif request.action eq "core:cprivateusers.editgroup" and not len(rc.userID)> active</cfif>"><a href="#application.configBean.getContext()#/admin/?muraAction=cPrivateUsers.editgroup&siteid=#session.siteid#&userid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.addadministrativegroup")#</a></li>
				 					  

					 				<li class="divider"></li>
					 				</cfif>
					 				<cfif application.settingsManager.getSite(session.siteid).getextranet() and  application.permUtility.getModulePerm("00000000000000000000000000000000008","#session.siteid#")>
					 					 <li <cfif request.action eq 'core:cpublicusers.list' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000008') or (rc.originalcircuit eq 'cpublicusers' and len(rc.userid))>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/?muraAction=cPublicUsers.list&siteid=#session.siteid#"><i class="icon-group"></i> #application.rbFactory.getKeyValue(session.rb,"user.viewsitemembers")#</a>
					 					</li>
						 				 <li<cfif request.action eq "core:cpublicusers.edituser" and not len(rc.userID)> class="active"</cfif>><a href="./?muraAction=cPublicUsers.edituser&siteid=#URLEncodedFormat(session.siteid)#&userid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,'user.addmember')#</a></li>
						 				<li<cfif request.action eq "core:cpublicusers.editgroup" and not len(rc.userID)> class="active"</cfif>><a href="./?muraAction=cPublicUsers.editgroup&siteid=#URLEncodedFormat(session.siteid)#&userid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,'user.addmembergroup')#</a></li>
			 					   	</cfif>
		 					  </ul>			
	 					</li>
	 				</cfif>
	 				
	 				<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>

	 					<li id="site-config" class="dropdown<cfif listFindNoCase('csettings,cextend,ctrash,cchain',rc.originalcircuit) or (rc.moduleID eq '00000000000000000000000000000000000' and rc.originalcircuit eq 'cPerm')> active</cfif>">

	 					<a class="dropdown-toggle" data-toggle="dropdown" href="##">
	 						<i class="icon-wrench"></i> <span>#application.rbFactory.getKeyValue(session.rb,"layout.sitesettings")#</span>
	 						<b class="caret"></b>
	 					</a>
	 					
		 				<ul class="dropdown-menu">
		 					
		 				 	<li>
		 						<a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&siteid=#session.siteid#">
		 							<i class="icon-pencil"></i> #application.rbFactory.getKeyValue(session.rb,"layout.editcurrentsite")#
		 						</a>
		 					</li>
		 					
		 					<li <cfif (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000000')>class='active'</cfif>>
		 					   	<a href="#application.configBean.getContext()#/admin/?muraAction=cPerm.module&contentid=00000000000000000000000000000000000&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000">
		 					   		<i class="icon-group"></i> #application.rbFactory.getKeyValue(session.rb,"layout.permissions")#
		 					   	</a>
		 					</li>
		 					<li <cfif rc.originalcircuit eq 'cChain'>class='active'</cfif>>
		 					   	<a href="#application.configBean.getContext()#/admin/?muraAction=cChain.list&siteid=#session.siteid#">
		 					   		<i class="icon-ok"></i> #application.rbFactory.getKeyValue(session.rb,"layout.approvalchains")#
		 					   	</a>
		 					</li>
		 					
		 					<cfset rsExts=application.classExtensionManager.getSubTypes(siteID=session.siteid,activeOnly=false) />

		 					<li class="dropdown-submenu">
		 					<a href="./?muraAction=cExtend.listSubTypes&siteid=#URLEncodedFormat(session.siteid)#"><i class="icon-wrench"></i> Class Extension Manager</a>
			 					<ul class="dropdown-menu">
			 						<!--- This is here solely for autoupdates--->
			 						<cfif structKeyExists(application.classExtensionManager,'getIconClass')>
			 							<cfset exp="application.classExtensionManager.getIconClass(rsExts.type,rsExts.subtype,rsExts.siteid)">
			 						<cfelseif structKeyExists(application.classExtensionManager,'getCustomIconClass')>
			 							<cfset exp="application.classExtensionManager.getCustomIconClass(rsExts.type,rsExts.subtype,rsExts.siteid)">
			 						<cfelse>
			 							<cfset exp="">
			 						</cfif>
			 						<!--- --->
				 					 <li><a href="#application.configBean.getContext()#/admin/?muraAction=cExtend.editSubType&subTypeID=&siteid=#URLEncodedFormat(session.siteid)#"><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.addclassextension")#</a></li>
				 					<cfif rsExts.recordcount>
				 						<li class="divider"></li>
				 					</cfif>
				 					<cfloop query="rsExts">
				 						<li><a href="#application.configBean.getContext()#/admin/?muraAction=cExtend.listSets&subTypeID=#rsExts.subtypeID#&siteid=#URLEncodedFormat(session.siteid)#">
				 							<i class=<cfif len(exp)>"#evaluate(exp)#"<cfelse>"icon-cog"</cfif>></i>				 								
				 							<cfif rsExts.type eq 1>Group<cfelseif rsExts.type eq 2>User<cfelse>#HTMLEditFormat(rsExts.type)#</cfif>/#HTMLEditFormat(rsExts.subtype)#	
				 						</a></li>
				 					</cfloop>
			 					</ul>
		 					</li>

		 					<li>
		 						<a href="?muraAction=cSettings.selectBundleOptions&siteID=#URLEncodedFormat(rc.siteBean.getSiteID())#">
		 							<i class="icon-gift"></i> Create Site Bundle
		 						</a>
		 					</li>

							<li>
		 						<a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&siteid=#session.siteid###tabBundles">
		 							<i class="icon-download-alt"></i> Deploy Site Bundle
		 						</a>
		 					</li>

									 					
		 					<li>
		 						<a href="./?muraAction=cTrash.list&siteID=#URLEncodedFormat(session.siteid)#">
		 							<i class="icon-trash"></i> Trash Bin
		 						</a>
		 					</li>
		 					<cfif listFind(session.mura.memberships,'S2')>
		 					<cfif not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()>
		 					<li>
		 						<a href="##" onclick="confirmDialog('WARNING: Do not update your site files unless you have backed up your current siteID directory.',function(){actionModal('./?muraAction=cSettings.editSite&siteid=#URLEncodedFormat(session.siteid)#&action=updateFiles')});return false;">
		 							<i class="icon-bolt"></i> Update Site
		 						</a>
		 					</li>
		 					</cfif>
		 					</cfif>


		 					<cfif len(rc.siteBean.getExportLocation()) and directoryExists(rc.siteBean.getExportLocation())>
		 						<li>
									<a href="##" onclick="confirmDialog('Export static HTML files to #JSStringFormat("'#rc.siteBean.getExportLocation()#'")#.',function(){actionModal('./?muraAction=csettings.exportHTML&siteID=#rc.siteBean.getSiteID()#')});return false;"><i class="icon-cog"></i> Export Static HTML (BETA)</a>
								</li>
							</cfif>
										 				
		 				
	 					
		 				</ul>	
	 			 									
	 				</li>
	 				</cfif>
	 			</ul>
	 			
	 		</div> <!-- /container -->
	 	
	 	</div> <!-- /subnavbar-inner -->
	 
	 </div> <!-- /subnavbar -->
</cfif>
</header>
</cfoutput>