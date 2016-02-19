<cfinclude template="_wrapperStart.cfm" />
<cfoutput>

<h1 class="page-heading">Welcome to Mura CMS<br/><small>You've made the right choice, let's get started.</small></h1>

<div class="js-wizard-simple block">

	<ul class="nav nav-tabs nav-justified">
		<li class="active">
			<a href="##tab-database" data-toggle="tab">1. Database</a>
		</li>
		<li>
			<a href="##tab-admin" data-toggle="tab">2. Admin Account</a>
		</li>
		<li>
			<a href="##tab-options" data-toggle="tab">3. Options</a>
		</li>
	</ul><!-- /.nav-tabs -->


	<form class="form-horizontal" action="base_forms_wizard.html" method="post">

		<!-- Progress Bar -->
		<div class="block-content block-content-mini block-content-full border-b">
			<div class="wizard-progress progress progress-mini remove-margin-b">
				<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 0"></div>
			</div>
		</div>
		<!-- /Progress Bar -->

		<!-- Tab Content -->
		<div class="block-content tab-content">


			<!--- TAB-DATABASE --->
			<div class="tab-pane fade fade-up in push-30-t push-50 active" id="tab-database">
				<div class="col-sm-10 col-sm-offset-2">

					<div class="mura-control-group">
						<label>Database</label>
						<select name="production_dbtype"
								id="production_dbtype"
								onChange="javascript:fHandleAutoCreateChange()">
							<option value="" <cfif !len(trim(FORM.production_dbtype))>selected</cfif>>-- Select your Database Type --</option>
							<option value="mysql" <cfif FORM.production_dbtype IS "mysql">selected</cfif>>MySQL</option>
							<option value="mssql" <cfif FORM.production_dbtype IS "mssql">selected</cfif>>MSSQL</option>
							<option value="nuodb" <cfif FORM.production_dbtype IS "nuodb">selected</cfif>>NuoDB</option>
							<option value="oracle" <cfif FORM.production_dbtype IS "oracle">selected</cfif>>Oracle</option>
							<option value="postgresql" <cfif FORM.production_dbtype IS "postgresql">selected</cfif>>PostgreSQL</option>
							</select>
					</div>

					<div class="mura-control-group database-config" >
						<label class="css-input switch switch-sm switch-primary">
							<input type="checkbox" id="auto_create" name="auto_create" value="1"
							<cfif len(trim(form.auto_create)) and val(form.auto_create)>checked</cfif>
							><span></span> Would you like us to create the database for you?
						</label>
					</div>

					<div class="mura-control-group database-create">
						<label>#theCFServer# Password</label>
						<input type="password" name="production_cfpassword" value="#FORM.production_cfpassword#" />
					</div>
					<div class="mura-control-group database-create">
						<label>Database Server</label>
						<input type="text" name="production_databaseserver" value="#FORM.production_databaseserver#" />
					</div>

					<div class="mura-control-group database-config">
						<label>Datasource Name</label>
						<input type="text" name="production_datasource" value="#FORM.production_datasource#" />
					</div>
					<div class="mura-control-group database-config">
						<label>Database Username</label>
						<input type="text" name="production_dbusername" value="#FORM.production_dbusername#" />
					</div>
					<div class="mura-control-group database-config">
						<label>Database Password</label>
						<input type="password" name="production_dbpassword" value="#FORM.production_dbpassword#" />
					</div>

				</div>
			</div>
			<!--- /TAB-DATABASE --->


			<!-- TAB-ADMIN -->
			<div class="tab-pane fade fade-up push-30-t push-50" id="tab-admin">
				<div class="col-sm-10 col-sm-offset-2">

					<div class="mura-control-group">
						<label>Super Admin Username</label>
						<input type="text" name="admin_username" value="#FORM.admin_username#" />
					</div>

					<div class="mura-control-group">
						<label>Super Admin Password</label>
						<input type="text" name="admin_password" value="#FORM.admin_password#" />
					</div>
					<div class="mura-control-group">
						<label>Super Admin Email</label>
						<input type="text" name="production_adminemail" value="#FORM.production_adminemail#" />
					</div>

				</div>
			</div>
			<!-- /TAB-ADMIN -->

			<!-- TAB-OPTIONS -->
			<div class="tab-pane fade fade-up push-30-t push-50" id="tab-options">
				<div class="col-sm-10 col-sm-offset-2">

					<div class="mura-control-group database-config" >
						<label class="css-input switch switch-sm switch-primary">
							<input type="checkbox" id="production_siteidinurls" name="production_siteidinurls" value="1"
							<cfif val(form.production_siteidinurls)>checked</cfif>
							><span></span> Use SiteIDs in URLs
						</label>
					</div>

					<div class="mura-control-group database-config" >
						<label class="css-input switch switch-sm switch-primary">
							<input type="checkbox" id="production_indexfileinurls" name="production_indexfileinurls" value="1"
							<cfif val(form.production_indexfileinurls)>checked</cfif>
							><span></span> Use "index.cfm" in URLS
						</label>
					</div>

				</div>
			</div>
			<!-- /TAB-OPTIONS -->

		</div>
		<!-- END Steps Content -->

		<!-- Steps Navigation -->
		<div class="block-content block-content-mini block-content-full border-t">
			<div class="row">
				<div class="col-xs-6">
					<button class="wizard-prev btn btn-default" type="button"><i class="fa fa-arrow-left"></i> Previous</button>
				</div>
				<div class="col-xs-6 text-right">
					<button class="wizard-next btn btn-default" type="button">Next <i class="fa fa-arrow-right"></i></button>
					<button class="wizard-finish btn btn-primary" type="submit"><i class="fa fa-check"></i> Submit</button>
				</div>
			</div>
		</div>
		<!-- END Steps Navigation -->

	</form><!-- END Form -->
</div>
<!-- END Simple Classic Progress Wizard -->


<cfinclude template="_wrapperEnd.cfm" />

<script src="//cmsadmin.staging.gowesthosting.com/template/assets/js/plugins/bootstrap-wizard/jquery.bootstrap.wizard.min.js"></script>
<script src="//cmsadmin.staging.gowesthosting.com/template/assets/js/plugins/jquery-validation/jquery.validate.min.js"></script>
<script src="//cmsadmin.staging.gowesthosting.com/template/assets/js/pages/base_forms_wizard.js"></script>
<script type="text/javascript" language="javascript">
dtLocale='';
activetab=1;
activepanel=0;
jQuery(document).ready(function(){

	// don't show DB options till a platform is selected
	$(".database-config").toggle(<cfif len(trim(FORM.production_dbtype))>true</cfif>);
	$('##production_dbtype').on('change',function(){
		$(".database-config").toggle(this.value.length > 0);
	});

	// are we creating the db?
	$(".database-create").toggle(<cfif val(FORM.auto_create)>true</cfif>);
	$('##auto_create').on('change',function(){
		$(".database-create").toggle(this.checked);
	});


  $('form:not(.filter) :input:visible:first').focus();
  setToolTips("##frm");
});
</script>
</body>
</html>
</cfoutput>