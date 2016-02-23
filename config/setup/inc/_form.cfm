<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. ?See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. ?If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and
conditions of the GNU General Public License version 2 (?GPL?) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, ?the copyright holders of Mura CMS grant you permission
to combine Mura CMS ?with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the ?/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 ?without this exception. ?You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfoutput>
<h1 class="page-heading">Welcome to Mura CMS<br/><small>You've made the right choice, let's get started.</small></h1>

<cfif len( trim( message ) )>
	<p class="alert alert-error">#message#</p>
</cfif>

<div class="js-wizard-simple block">

	<ul class="nav nav-tabs nav-justified">
		<li class="active">
			<a href="##tab-database" data-toggle="tab">Database</a>
		</li>
		<li>
			<a href="##tab-admin" data-toggle="tab">Admin Account</a>
		</li>
		<li>
			<a href="##tab-options" data-toggle="tab">Options</a>
		</li>
	</ul><!-- /.nav-tabs -->


	<form class="form-horizontal" action="index.cfm" method="post">
		<input type="hidden" name="action" value="doSetup" />

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
			<div class="tab-pane fade fade-up in push-20-t push-50 active" id="tab-database">

				<div class="col-sm-10 col-sm-offset-1">
					<p>You're going to need a database to store all of your content. You can either use an existing database or Mura can create one for you. Tell us what you'd like to do below.</p>
				</div>

				<div class="col-sm-10 col-sm-offset-1">

					<div class="mura-control-group">
						<label>Database</label>
						<select name	="production_dbtype"
								id		="production_dbtype" >
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

					<div class="mura-control-group database-create-yes">
						<label>#theCFServer# Password</label>
						<p class="help-block">Required to create database.</p>
						<input type="password" name="production_cfpassword" value="#FORM.production_cfpassword#" />
					</div>
					<div class="mura-control-group database-create-yes">
						<label>Database Server</label>
						<input type="text" name="production_databaseserver" value="#FORM.production_databaseserver#" />
					</div>

					<div class="mura-control-group database-create-oracle">
						<label>Oracle Tablespace</label>
						<input type="text" name="production_dbtablespace" value="#FORM.production_dbtablespace#" />
					</div>

					<div class="mura-control-group database-config">
						<label>Datasource Name</label>
						<input type="text" name="production_datasource" value="#FORM.production_datasource#" />
					</div>
					<div class="mura-control-group database-config">
						<label>Database Username</label>
						<p class="help-block database-create-no">Optional if already configured in #theCFServer# admin.</p>
						<p class="help-block database-create-yes">Required to create database.</p>
						<input type="text" name="production_dbusername" value="#FORM.production_dbusername#" />

					</div>
					<div class="mura-control-group database-config">
						<label>Database Password</label>
						<p class="help-block database-create-no">Optional if already configured in #theCFServer# admin.</p>
						<p class="help-block database-create-yes">Required to create database.</p>
						<input type="password" name="production_dbpassword" value="#FORM.production_dbpassword#" />
					</div>

				</div>
			</div>
			<!--- /TAB-DATABASE --->


			<!-- TAB-ADMIN -->
			<div class="tab-pane fade fade-up push-20-t push-50" id="tab-admin">

				<div class="col-sm-10 col-sm-offset-1">
					<p>Each Mura installation has a "Super Admin" who wields supreme power over all sites within the database. Choose the security credentials for this user carefully.</p>
				</div>

				<div class="col-sm-10 col-sm-offset-1">

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
			<div class="tab-pane fade fade-up push-20-t push-50" id="tab-options">

				<div class="col-sm-10 col-sm-offset-1">
					<p>Mura has a couple of options for cleaner URLs, what would you like URLs to look like?</p>
					<strong>Example:</strong>
					<p id="url_example"><#context#/[siteid]/index.cfm?</p>
				</div>

				<div class="col-sm-10 col-sm-offset-1">

					<div class="mura-control-group" >

						<label class="css-input switch switch-sm switch-primary">
							<input type="checkbox" id="production_siteidinurls" name="production_siteidinurls" value="1" class="build-url-example"
							<cfif val(form.production_siteidinurls)>checked</cfif>
							><span></span> Use SiteIDs in URLs
						</label>

					</div>

					<div class="mura-control-group" >
						<label class="css-input switch switch-sm switch-primary">
							<input type="checkbox" id="production_indexfileinurls" name="production_indexfileinurls" value="1" class="build-url-example"
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
					<button class="wizard-finish btn btn-primary" name="setupSubmitButton" type="submit"><i class="fa fa-check"></i> Submit</button>
				</div>
			</div>
		</div>
		<!-- END Steps Navigation -->

	</form><!-- END Form -->
</div>
<!-- END Simple Classic Progress Wizard -->


<!---
siteidinurls=0
indexfileinurls=1
/index.cfm/test-subpage/sub-of-sub/

siteidinurls=0
indexfileinurls=0
/test-subpage/sub-of-sub/

siteidinurls=1
indexfileinurls=0
/default/test-subpage/sub-of-sub/

siteidinurls=1
indexfileinurls=1
/default/index.cfm/test-subpage/sub-of-sub/
 --->

<script src="//cmsadmin.staging.gowesthosting.com/template/assets/js/plugins/bootstrap-wizard/jquery.bootstrap.wizard.min.js"></script>
<script src="//cmsadmin.staging.gowesthosting.com/template/assets/js/plugins/jquery-validation/jquery.validate.min.js"></script>
<script src="//cmsadmin.staging.gowesthosting.com/template/assets/js/pages/base_forms_wizard.js"></script>
<script type="text/javascript" language="javascript">
dtLocale='';
activetab=1;
activepanel=0;
jQuery(document).ready(function(){

	// don't show DB options till a platform is selected
	$(".database-config").toggle(#(len(trim(FORM.production_dbtype)) gt 0)#);
	$('##production_dbtype').on('change',function(){
		$(".database-config").toggle(this.value.length > 0);
		$(".database-create-oracle").toggle($('##production_dbtype option:selected').val() == 'oracle' && $('##auto_create').is(':checked'));
	});

	// are we creating the db?
	$(".database-create-yes").toggle(#(val(FORM.auto_create) eq 1)#);
	$(".database-create-no").toggle(#(val(FORM.auto_create) eq 0)#);
	$(".database-create-oracle").toggle(#(FORM.production_dbtype eq 'oracle' and val(FORM.auto_create) eq 1)#);
	$('##auto_create').on('change',function(){
		$(".database-create-yes").toggle(this.checked);
		$(".database-create-no").toggle(!this.checked);
		$(".database-create-oracle").toggle($('##production_dbtype option:selected').val() == 'oracle' && $('##auto_create').is(':checked'));
	});

	$('.build-url-example').on('change',function(){
		var ret = 'http(s)://yourdomain.com#context#';

		if ($("##production_siteidinurls").is(':checked')) {
			ret = ret + '/[siteid]';
		}

		if ($("##production_indexfileinurls").is(':checked')) {
			ret = ret + '/index.cfm';
		}

		ret = ret + '/full-path-to/page-location/';

		$("##url_example").html(ret);
	});

	$('.build-url-example').change();

});
</script>
</cfoutput>