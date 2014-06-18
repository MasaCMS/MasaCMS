<cfoutput>

	<!--- User Search --->		
		<form class="form-inline" novalidate="novalidate" action="index.cfm" method="get" name="form1" id="siteSearch">
			<div class="input-append">
				<input id="search" name="search" type="text" placeholder="Search for Users" />
				<button type="button" class="btn" onclick="submitForm(document.forms.form1);">
					<i class="icon-search"></i>
				</button>
				<button type="button" class="btn" onclick="window.location='./?muraAction=cUsers.advancedSearch&amp;siteid=#URLEncodedFormat(rc.siteid)#&amp;newSearch=true'" value="#rc.$.rbKey('user.advanced')#">
					#rc.$.rbKey('user.advanced')#
				</button>
				<input type="hidden" name='siteid' value="#HTMLEditFormat(rc.siteid)#"/>
				<input type="hidden" name='muraAction' value="cUsers.search"/>
			</div>
		</form>

	<!--- Page Title --->
		<h1>#rc.$.rbKey('user.groupsandusers')#</h1>

	<!--- Buttons --->
		<div id="nav-module-specific" class="btn-group">

			<!--- Add Member --->
			<a class="btn" href="#buildURL(action='cusers.edituser', querystring='siteid=#URLEncodedFormat(rc.siteid)#&userid=')#">
		  	<i class="icon-plus-sign"></i> 
		  	<!--- #rc.$.rbKey('user.addmember')# --->
		  	Add User
		  </a>

		  <!--- Add Group --->
		  <a class="btn" href="#buildURL(action='cusers.editgroup', querystring='siteid=#URLEncodedFormat(rc.siteid)#&userid=')#">
		  	<i class="icon-plus-sign"></i> 
		  	#rc.$.rbKey('user.addgroup')#
		  </a>

			<cfif rc.muraaction eq 'core:cusers.listusers'>
				<!--- View Groups --->
				<a class="btn" href="#buildURL(action='cusers.default', querystring='siteid=#URLEncodedFormat(rc.siteid)#')#">
		  		<i class="icon-eye-open"></i>
		  		#rc.$.rbKey('user.viewgroups')#
		  	</a>
		  <cfelse>
		  	<!--- View Users --->
				<a class="btn" href="#buildURL(action='cusers.listUsers', querystring='siteid=#URLEncodedFormat(rc.siteid)#')#">
					<i class="icon-eye-open"></i>
					#rc.$.rbKey('user.viewusers')#
				</a>
			</cfif>

			<!--- Permissions --->
			<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
				<cfif rc.ispublic>
					<a class="btn" href="./?muraAction=cPerm.module&amp;contentid=00000000000000000000000000000000008&amp;siteid=#URLEncodedFormat(rc.siteid)#&amp;moduleid=00000000000000000000000000000000008">
						<i class="icon-legal"></i> 
						#rc.$.rbKey('user.permissions')#
					</a>
				</cfif>
			</cfif>
		</div>

</cfoutput>