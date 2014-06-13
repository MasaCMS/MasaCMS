<cfoutput>

	<!--- jQuery DataTables Plugin --->
	
	<style type="text/css">
		@import "#application.configBean.getValue('context')#/tasks/widgets/data-tables/media/css/demo_page.css";
		@import "#application.configBean.getValue('context')#/tasks/widgets/data-tables/media/css/jquery.dataTables.css";
	</style>
	<script type="text/javascript" language="javascript" src="#application.configBean.getValue('context')#/tasks/widgets/data-tables/media/js/jquery.dataTables.js"></script>
	<script type="text/javascript" charset="utf-8">
		jQuery(function ($) {
			//$('table').dataTable();
		});
	</script>

	<!--- Custom CSS --->
	<style type="text/css">
		th i.icon-calendar {font-size: 14px !important;}

		/* dataTables styles */
		.dataTables_wrapper {}
		.dataTables_length, .dataTables_filter {padding-bottom: 1em;}
	</style>
	
	

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
		  	#rc.$.rbKey('user.addmember')#
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
				<a class="btn" href="./?muraAction=cPerm.module&amp;contentid=00000000000000000000000000000000008&amp;siteid=#URLEncodedFormat(rc.siteid)#&amp;moduleid=00000000000000000000000000000000008">
					<i class="icon-legal"></i> 
					#rc.$.rbKey('user.permissions')#
				</a>
			</cfif>
		</div>

</cfoutput>