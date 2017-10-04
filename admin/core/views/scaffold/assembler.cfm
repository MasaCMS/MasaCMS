<!---
	This file is part of Mura CMS.

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

<cfoutput>

<script src="#$.globalConfig('rootPath')#/core/vendor/vue/vue.js"></script>
<script src="#$.globalConfig('rootPath')#/admin/assets/js/scaffold/assembler.js"></script>

<script>
	var Assembler = "";
	var Scaffolder = "";
	var Master = "";
</script>

<div id="load-spin" style="display: none;"><div id="load-spin-spinner"></div></div>
<div id="alert-assembler-saved"></div>

<div class="mura-header">
  <h1>Custom Mura ORM Entity</h1>

	<div class="nav-module-specific btn-group">
		<!---<a class="btn" href="./?muraAction=scaffold.assembler"><i class="mi-plus-circle"></i> New Entity</a>--->
    <a class="btn" href="./?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteid)#&activeTab=2"><i class="mi-arrow-circle-left"></i> Back</a>
  </div>

</div> <!-- /.mura-header -->

<div class="block block-constrain" id="container">

	<!--- Tab navigation --->
  <ul class="mura-tabs nav-tabs" data-toggle="tabs">
    <li class="active"><a href="##tabDef" onclick="return false;"><span>Definition</span></a></li>
    <li class=""><a href="##tabProp" onclick="return false;"><span>Properties</span></a></li>
    <li class=""><a href="##tabRel" onclick="return false;"><span>Relationships</span></a></li>
  </ul>	<!--- /Tab Nav --->

	<!--- assembler --->
	<div id="container-assembler">

	  <!--- start tab content --->
		<div class="block-content tab-content">		
			<!-- definitions-->
			<div class="tab-pane active" id="tabDef">
				<div class="block block-bordered">
					<assembler-attributes-form-template :model="model"></assembler-attributes-form-template>
				</div> <!-- /.block-bordered -->
			</div> <!-- /tabDef -->

			<!-- properties -->
			<div class="tab-pane" id="tabProp">
				<div class="block block-bordered">
					<!--- new property form --->
					<div class="block-content">
						<div class="btn-group pull-right">
							<button class="btn" @click='clickAddProperty'><i class="mi-plus-circle"></i> Add Property</button>
						</div>
						<assembler-property-template :model="model"	></assembler-property-template>
						<div>
							<component :is="currentView" :data="data" :rendertypes="rendertypes" :fieldtypes="fieldtypes" :datatypes="datatypes" :model="model" transition="fade" transition-mode="out-in"></component>
						</div>
					</div>
				</div> <!-- /.block-bordered -->
			</div> <!-- /tabProp -->

			<!-- relationships -->
			<div class="tab-pane" id="tabRel">
				<div class="block block-bordered">
					<!--- new relationship form --->
					<div class="block-content">
						<div class="btn-group pull-right">
							<button class="btn" @click='clickAddRelated'><i class="mi-plus-circle"></i> Add Relationship</button>
						</div>
						<assembler-property-template :model="model"	></assembler-property-template>
						<div>
							<component :is="currentView" :data="data" :rendertypes="rendertypes" :fieldtypes="fieldtypes" :datatypes="datatypes" :model="model" transition="fade" transition-mode="out-in"></component>
						</div>
					</div>

				</div> <!-- /.block-bordered -->
			</div> <!-- /tabRel -->

		</div> <!-- /.block-content.tab-content -->

		<div class="mura-actions">
			<div class="form-actions">
				<button v-if="model.entityname != '' && model.table != ''" @click='clickSave' class="btn mura-primary"><i class="mi-check-circle"></i> Save</button>
				<button v-else class="btn" disabled><i class="mi-ban"></i> Save</button>
			</div>
		</div>				

	</div> <!--- /container-assembler --->

</div> <!-- /.block-constrain -->

</cfoutput>
<!--- vue templates --->
<cfinclude template="assembler_templates.cfm">

<style>
	#scaffold-sortby th i {
		padding: 1px 0px 0px 5px;
		color: #333333;
		font-size: 1.1em;
	}
	#scaffold-table tr.alt td {
		background-color: #eee;
	}
	.formtemplate{
		margin: 0 0 20px 0;
	}
	.formtemplate + .formtemplate {
		margin-top: 20px;
	}
	#property-template,
	#related-form-template-property,
	#related-form-template {
		margin: 10px 0;
	}
	#assembler-properties li {
		list-style: none;
		margin: 0;
		padding: 0;
	}
	#assembler-properties .assembler-item-box {
		width: 100%;
		display: block;
		margin: 1px 0;
		padding: 5px 5px 5px 10px;
	}

	#assembler-properties .assembler-item-box .assembler-prop {
		padding: 4px 5px 5px 10px;
		border-left: 5px solid #eee;
	}

	.assembler-no-displayname {
		color: #880000;
	}

	.small {
		font-size: 0.7em;
	}

	.breadcrumb {
		list-style: none;
		overflow: hidden;
		height: 25px;
	}
	.crumbly li {
		display: inline-block;
		float: left;
	}

	#scaffold-table td {
		padding-bottom: 5px;
	}

  #assembler-preview-pane{
  	display: none;
  }
	#assembler-preview,.assembler-preview {
		float: left;
		margin-bottom:60px;
		margin-top:10px;
		width: 100%;
		height: 480px;
		font-size: .92em;
		overflow: scroll;

	}

	#load-spin #spinner {
	  position: absolute;
	  left: 50%;
	  top: 50%;
	  z-index: 10000;
	  width: 150px;
	  height: 150px;
	  margin: -75px 0 0 -75px;
	  border: 16px solid #f3f3f3;
	  border-radius: 50%;
	  border-top: 16px solid #3498db;
	  width: 120px;
	  height: 120px;
	  -webkit-animation: spin 2s linear infinite;
	  animation: spin 2s linear infinite;
	}

	#load-spin {
		position: fixed;
		width: 100%;
		height: 100%;
		left: 0;
		top: 0;
		background-color: #fff;
		z-index: 10000;
		border: 16px solid #f3f3f3;
		opacity: .8;
	}
</style>