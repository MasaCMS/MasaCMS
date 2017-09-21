<cfoutput>

<script>
	var Assembler = "";
	var Scaffolder = "";
	var Master = "";
  var IsSuperUser = #rc.$.currentUser().isSuperUser()#;
</script>


<script src="#$.globalConfig('rootPath')#/core/vendor/vue/vue.js"></script>
<!---
<script src="#$.globalConfig('rootPath')#/admin/assets/js/jquery/jquery-ui.min.js"></script>
<script src="#$.globalConfig('rootPath')#/admin/assets/js/vue.min.js"></script>
--->
<script src="#$.globalConfig('rootPath')#/admin/assets/js/scaffold/scaffolder.js"></script>

<style>

/* TODO move these styles to global less & compile */

	.mura .mura-table-grid > thead > tr:not(:last-child) > th{
			border-bottom: none !important;
			height: 25px !important;
		}

	.mura .mura-table-grid > thead > tr:not(:last-child){
		height: 25px !important;
		overflow-y: hidden;
	}

	.mura .mura-table-grid > thead > tr + tr > th{
		padding-top: 0 !important;
		background-color: ##fafafa;
	}

	.mura .mura-table-grid th input.filter{
    border: 1px solid ##e9e9e9;
    font-size: 13px;
    font-weight: normal !important;
    height: 18px;
    padding-left: 4px;
    position: relative;
    top: 1px;
    /* TODO use global font definition */
    font-family: montserratlight,montserratregular,"Helvetica Neue",Helvetica,Arial,sans-serif;
	}

	.mura .mura-table-grid th .btn-group{
		margin-right: 1px;
		margin-bottom: 1px;
	}
	.mura .mura-table-grid th .btn-group .btn{
		padding: 1px 4px;
		color: ##545454;
    background-color: ##f5f5f5;
    border-color: ##e9e9e9;
	}

	##scaffold-table tbody tr td span{
		cursor: pointer;
	}

	##scaffold-sortby th span{
		cursor: pointer;
	}

	##scaffold-sortby th i {
		padding: 1px 0px 0px 5px;
		color: ##333333;
		font-size: 1.1em;
	}
	##scaffold-sortby th {
	}

	##scaffold-crumb-display:not(:empty){
		min-height: 30px;
	}

	.formtemplate {
		margin: 20px 0;
	}
	.formtemplate div {
		margin: 10px;
		padding: 10px 0;
		border-top: 1px solid ##ccc;
	}
	##property-template {
		margin: 10px 0;
	}
	##assembler-properties li {
		list-style: none;
		margin: 0;
		padding: 0;
	}
	##assembler-properties .assembler-item-box {
		width: 100%;
		display: block;
		margin: 1px 0;
		padding: 5px 5px 5px 10px;
	}

	##assembler-properties .assembler-item-box .assembler-prop {
		padding: 4px 5px 5px 10px;
		border-left: 5px solid ##eee;
	}

	.assembler-no-displayname {
		color: ##880000;
	}

	.small {
		font-size: 0.7em;
	}

	.crumbly li {
		display: inline-block;
		float: left;
	}

	##scaffold-table {

	}

	##scaffold-table td {
		padding-bottom: 5px;
	}

	##assembler-preview,.assembler-preview {
		float: left;
		border: 2px solid ##333;
		width: 490px;
		height: 600px;
		overflow: scroll;

	}

	##load-spin ##spinner {
	  position: absolute;
	  left: 50%;
	  top: 50%;
	  z-index: 10000;
	  width: 150px;
	  height: 150px;
	  margin: -75px 0 0 -75px;
	  border: 16px solid ##f3f3f3;
	  border-radius: 50%;
	  border-top: 16px solid ##3498db;
	  width: 120px;
	  height: 120px;
	  -webkit-animation: spin 2s linear infinite;
	  animation: spin 2s linear infinite;
	}

	##load-spin {
		position: fixed;
		width: 100%;
		height: 100%;
		left: 0;
		top: 0;
		background-color: ##fff;
		z-index: 10000;
		border: 16px solid ##f3f3f3;
		opacity: .8;
	}	

</style>

<div class="block-header">
<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view.custom")#</h3>
</div>

<div id="load-spin" style="display: none;"><div id="load-spin-spinner"></div></div>

<div class="block-content">

	<div id="container-scaffold">
	<scaffold-crumb-template :data="data" :state="state"></scaffold-crumb-template>
		<scaffold-error-template :errordata="errordata"></scaffold-error-template>
		<div>
			<component :is="currentView" :currentparent="currentparent" :entityname="entityname" :data="data" transition="fade" transition-mode="out-in"></component>
		</div>
	</div> <!-- /container-scaffold -->
</div> <!-- /.block-content -->

<!--- TODO: what goes here? : looks empty? --->
	<template id="scaffold-crumb-template">
			<div v-if="state" id="scaffold-crumb-display">
				<ul v-for="(att,index) in state" class="crumbly">
					<li v-if="att.parent" @click="clickCrumb(index)">
						<i class="mi-file">...</i>
						{{att.parent.entityname}}
					</li>
					<li v-else @click="clickCrumb(0)">
						<strong>{{state[0].name}}</strong> List
					</li>
				</ul>
			</div>
	</template>

	<template id="scaffold-error-template">
		<div v-if="errordata.length">
			<div>
				<div>Errors</div>
				<ul v-for="att in errordata">
					<li>
						{{att}}
						<i class="mi-error"></i>
						{{att.name}}
					</li>
				</ul>
			</div>
		</div>
	</template>

	<template id="scaffold-all-template">
		<div>
			<h2>Available Entities:</h2>
			<div v-if="data.items">
				<ul v-for="att in data.items">
					<li @click="showList(att.entityname)">
						{{att.displayname ? att.displayname : att.entityname}}
					</li>
				</ul>
			</div>

			<p v-if="!data.items.length" class="alert alert-info">No items available.</p>

		</div>
	</template>

	<template id="scaffold-list-template">
		<div>

			<div class="btn-group pull-right">
					<a v-if="entityname != 'entity' && data.issuperuser && data && data.parentproperties && data.parentproperties.dynamic" class="btn" @click="goToAssembler(entityname)"><i class="mi-edit"></i> Edit Entity Definition</a>
				<a class="btn" @click="openEndpoint()"><i class="mi-globe"> API Endpoint</i></a>
				<a v-if="currentparent && currentparent.properties" @click="showForm(currentparent.properties.entityname,currentparent.properties.id)" class="btn">Back</a>
				<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
					<a class="btn" href="./?muraAction=cPerm.module&contentid=00000000000000000000000000000000016&siteid=#esapiEncode('url',rc.siteid)#&moduleid=00000000000000000000000000000000016"><i class="mi-group"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.permissions')#</a>
				</cfif>

			</div> <!-- /.btn-group -->

			<span v-if="entityname">
				<ul class="breadcrumb" v-if="entityname=='entity'">	
						<li><strong><a @click="showAll" onclick="return false;" href="##"><i class="mi-cube"></i>Custom Entities</a></strong></li>
				</ul>
				<ul class="breadcrumb" v-if="entityname!='entity'">
						<li><a @click="showAll" onclick="return false;" href="##"><i class="mi-cube"></i>Custom Entities</a></li>					
						<li><strong><a href="##" onclick="return false;"><i class="mi-cube"></i>{{entityname}}</a></strong></li>					
				</ul>
			</span>

			<!--- todo where is this used --->
			<span v-if="currentparent && currentparent.properties"> for {{currentparent.properties.entityname}}:
				<input type="HIDDEN" class="filter" :name="'filter-' + currentparent.properties.properties.primarykey" :value="currentparent.properties.id">
				<span v-for="item in currentparent.properties._displaylist">{{currentparent.properties[item.name]}}</span>
			</span>

<!---
			<h2>
				<span v-if="entityname"><span v-if="entityname!='entity'">{{entityname.toUpperCase()}} LIST</span></span>
			</h2>
--->

			<div v-if="data.list">
				<table width="100%" class="table table-striped table-condensed table-bordered mura-table-grid" id="scaffold-table">

					<thead>

						<tr id="scaffold-sortby">
							<th class="actions"></th>
							<th class="var-width" v-for="(item, key, index) in data.listview" :id="'sortby-' + item.name">
								<span @click="applySortBy(item.name)">{{item.displayname}}</span>
							</th>
							<th></th>
						</tr>

						<tr id="scaffold-filterby">
							<th class="actions"></th>
							<th class="var-width" v-for="item in data.listview">
									<input v-if="item.filter==true || item.filter == 'true'" class="filter" :name="'filter-' + item.name" @keyup="applyKeyFilter">
							</th>
							<th>
								<div class="btn-group pull-right">
									<span v-if="!data.hasFilterApplied"><a class="btn btn-sm" @click='applyFilter'>Apply Filter</a></span>
									<span v-if="data.hasFilterApplied"><a class="btn btn-sm" @click='removeFilter'>Remove Filter</a><span>
								</div>
							</th>
						</tr>
					</thead>

					<tbody>
							<tr v-if="data.list.length" v-for="(object,index) in data.list">

									<td class="actions">

									<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
									<div class="actions-menu hide">
										<ul class="actions-list">
											<li v-if="entityname != 'entity'">
												<a href="##" onclick="return false;" @click="showForm(object.entityname,object.id)"><i class="mi-edit"></i> Edit Record</a>
											</li>
											<li v-if="entityname == 'entity'">
												<a href="##" onclick="return false;" @click="showList(object.entityname)"><i class="mi-list"></i> View Records</a>
											</li>
											<li v-if="entityname == 'entity' && data.issuperuser && object.dynamic">  
												<a href="##" onclick="return false;" @click="goToAssembler(object.entityname)"><i class="mi-edit"></i> Edit Entity Definition</a>
											</li>
										</ul>
									</div>	


									</td>


									<td class="var-width" v-for="item in data.listview" @click="(entityname == 'entity') ? showList(object.entityname) : showForm(object.entityname,object.id)">
											<span v-if="item.rendertype == 'htmleditor'" v-html="object[item.name]"></span>
											<span v-else-if="item.datatype=='datetime' || item.datetime=='date'" v-text="formatDate(object[item.name])"></span>
											<span v-else v-text="object[item.name]"></span>
									</td>
									<td></td>

<!--- 
									<td v-if="entityname != 'entity'">
										<button class="pull-right" @click="showForm(object.entityname,object.id)"><i class="mi-edit"></i></button>
									</td>
									<td v-if="entityname == 'entity'">
										<button class="pull-right" @click="showList(object.entityname)"><i class="mi-edit"></i></button>
									</td>
 --->
								</li>
							</tr>

						<tr v-if="!data.list.length">
							<td class="actions"></td>
								<td class="var-width" :colspan="data.listview.length+1">
									<div class="help-block-empty">No items available.</div>
								</td>
						</tr>

					</tbody>
				</table>

				<span v-if="entityname != 'entity'">
					<span v-if="currentparent && currentparent.properties">
						<div class="btn-group">
							<a class="btn" href="##" onclick="return false;" @click="showForm(entityname)">Add Child</a>
							<a class="btn" href="##" onclick="return false;" @click="showForm(currentparent.properties.entityname,currentparent.properties.id)">Back</a>
						</div>
					</span>
					<span v-else>
						<div class="btn-group">
							<a class="btn" href="##" onclick="return false;" @click="showForm(entityname)">Add New</a>
						</div>
					</span>
				</span>
				<span v-if="entityname == 'entity' && data.issuperuser">
					<div class="btn-group">
						<a href="./?muraAction=scaffold.assembler" class="btn">Add New</a>
					</div>
				</span>


				<!--- TODO :  paging :  --->
				<button v-if="data.links.first" @click="applyPage('first')">
					|<
				</button>
				<button v-if="data.links.previous" @click="applyPage('previous')">
					<
				</button>
				<button v-if="data.links.next" @click="applyPage('next')">
					>
				</button>
				<button v-if="data.links.last" @click="applyPage('last')">
					>|
				</button>
				<span>
					<select name="itemsper" @change="applyItemsPer">
						<option value='5' :selected="this.$parent.itemsper == 5 ? 'selected' : null">5</option>
						<option value='10' :selected="this.$parent.itemsper == 10 ? 'selected' : null">10</option>
						<option value='20' :selected="this.$parent.itemsper == 20 ? 'selected' : null">20</option>
					</select>
				</span>

			</div>
		</div>
	</template>

	<template id="scaffold-form-template">
		<div>


		<div class="btn-group pull-right">
			<button class="btn" @click="clickBack" type="submit" class="btn">Back</button>
			<button  class="btn" @click="openEndpoint()"><i class="mi-globe"> API Endpoint</i></button>
			<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
					<a class="btn" href="./?muraAction=cPerm.module&contentid=00000000000000000000000000000000016&siteid=#esapiEncode('url',rc.siteid)#&moduleid=00000000000000000000000000000000016"><i class="mi-group"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.permissions')#</a>
			</cfif>
		</div>	<!-- /.btn-group -->

		<ul class="breadcrumb">	
			<li><a @click="showAll" href="##" onclick="return false;"><i class="mi-cube"></i>Custom Entities</a></li>
			<li><a @click="clickBack" href="##" onclick="return false;"><i class="mi-cube"></i>{{entityname}}</a></li>
			<li><strong><a href="##" onclick="return false;"><i class="mi-edit"></i>Edit Record</a></strong></li>
		</ul>

		<ul>
			<template v-for="property in data.properties">
				<span v-if="property.fieldtype == 'id'">
				</span>
				<span v-else-if="property.name == 'siteid' || property.relatesto == 'site'">
				</span>
				<span v-else-if="property.fieldtype == 'one-to-one'">
					<scaffold-related-one :property=property :model=data.model :entity=data.entity :data=data :entityid="entityid"></scaffold-related-one>
				</span>
				<span v-else-if="property.fieldtype == 'many-to-one'">
					<scaffold-related-many-one :property=property :model=data.model :entity=data.entity :data=data :entityid="entityid"></scaffold-related-many-one>
				</span>
				<span v-else-if="property.fieldtype == 'one-to-many'">
					<scaffold-related-many v-if="Math.random()" :property=property :model=data.model :entity=data.entity :data=data :entity="data.entity"></scaffold-related-many>
				</span>
				<span v-else-if="property.name.slice(-2).toLowerCase()=='id'">
				</span>
				<li v-else>
				<scaffold-field-textarea v-if="property.rendertype == 'textarea'" :property=property :model=data.model :entity=data.entity></scaffold-field-textarea>
				<scaffold-field-htmleditor v-else-if="property.rendertype === 'htmleditor'" :property=property :model=data.model :entity=data.entity></scaffold-field-htmleditor>
				<scaffold-field-checkbox v-else-if="property.rendertype === 'checkbox'" :property=property :model=data.model :entity=data.entity></scaffold-field-checkbox>
				<scaffold-field-dropdown v-else-if="property.rendertype === 'dropdown'" :property=property :model=data.model :entity=data.entity></scaffold-field-dropdown>
				<scaffold-field-radio v-else-if="property.rendertype === 'radio'" :property=property :model=data.model :entity=data.entity></scaffold-field-radio>
				<scaffold-field-text v-else="property.rendertype == 'textbox'" :property=property :model=data.model :entity=data.entity>~</scaffold-field-text>
				</li>
			</template>


			<li>
				<button @click="clickSave" type="submit" class="btn">Save</button>
				<button @click="clickBack" type="submit" class="btn">Back</button>
				<button v-if="data.model && !data.model.isnew" @click="clickDelete" type="submit" class="btn btn-warning">Delete</button>
			</li>
		</ul>
		</div>
	</template>

	<template id="scaffold-related-one">
		<div>
			<ul v-if="property.fieldtype && this.$parent.data.parent">
				<input type="hidden" :name="property.fkcolumn" v-model="model[property.fkcolumn]" id="primary-id"
				:data-default="doDefault(this.$parent.data.parent[property.fkcolumn] ? this.$parent.data.parent[property.fkcolumn] : null,property.fkcolumn ? property.fkcolumn : null,model)"
				:value="this.$parent.data.parent[property.fkcolumn] ? this.$parent.data.parent[property.fkcolumn] : null" :length="property.length">
			</ul>
		</div>
	</template>

	<template id="scaffold-related-many-one">
		<div v-if="mparent && mparent.properties">
			<div v-if="property.relatesto">
				<label>{{property.displayname ? property.displayname : property.label ? property.label : mparent.properties.name}}</label>
				<select
				v-model="property.fkcolumn=='primaryKey' ? model[mparent.properties.primarykey] : model[property.fkcolumn]"
				:name="mparent.properties.primarykey">
				<option value="">-- None --</option>
				<option v-for="(option,index) in this.mparent.list" :value="option.id"
					 :selected="option[property.loadkey] == model[property.fkcolumn] ? 'selected' : null">
					<span v-if="property.renderfield">{{option[property.renderfield]}}</span>
					<span v-elseif="option.name">{{option.name}}</span>
					<span v-elseif="option.menutitle">{{option.menutitle}}</span>
					<span v-elseif="option.title">{{option.title}}</span>
					<span v-elseif="option.grouname">{{option.groupname}}</span>
					<span v-elseif="option.company">{{option.company}}</span>
					<span v-elseif="option.organization">{{option.organization}}</span>
					<span v-else>
							<span v-if="option.fname">{{option.fname}}</span>
							<span v-if="option.firstname">{{option.firstname}}</span>
							<span v-if="option.lname">{{option.lname}}</span>
							<span v-if="option.lastname">{{option.lastname}}</span>
					</span>
					<!--
					<span v-else v-for="(option,index) in mparent.properties.properties">

					</span>
					-->
				</option>
			</select>
			</div>
		</div>
	</template>

	<template id="x-scaffold-related-many">
		<div v-if="this.entity.properties.isnew == 0">
			<label>{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
			<ul v-if="mrelated && mrelated.collection">
				<li v-for="object in mrelated.collection.items">
					<span v-if="property.renderfield">{{object.properties[property.renderfield]}}</span><span v-else>{{object.properties.id}}</span>
					<button @click="showForm(object.properties.entityname,object.properties.id,entity.properties.id)">EDIT: {{object.properties[property.renderfield] ? object.properties[property.renderfield] : object.properties.entityname}}</button>
				</li>
			</ul>
			<button class='btn' @click="showForm(property.name,'new',entity.properties.id)">ADD NEW {{property.displayname ? property.displayname : property.name.toUpperCase()}}</button>
		</div>
	</template>

	<template id="scaffold-related-many">
		<div v-if="this.entity.properties.isnew == 0">
			<label>{{property.displayname ? property.displayname : property.label ? property.label : property.name}}(s)</label>
			<button class='btn' @click="showRelatedList(property.relatesto,entity)">Manage {{property.displayname ? property.displayname : property.label ? property.label : property.name}}(s)</button>
		</div>
	</template>

	<template id="scaffold-field-text">
		<div>
			<div v-if="model.errors && model.errors[property.name]">{{model.errors[property.name]}}</div>
			<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
			<input
				type="text"
				v-model="model[property.name]"
				:name="property.name"
				:id="property.name"
				:value="model[property.name] ? model[property.name] : property.default"
				:length="property.length"
				:data-validate="property.validate ? property.validate : null"
				:data-validate-message="property.validatemessage ? property.validatemessage : null"
				>
		</div>
	</template>

	<template id="scaffold-field-htmleditor">
		<div>
			<div v-if="model.errors && model.errors[property.name]">{{model.errors[property.name]}}</div>
			<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
			<textarea
				v-model="model[property.name]"
				class="htmlEditor"
				:id="property.name"
				:name="property.name"
				:data-validate="property.validate ? property.validate : null"
				:data-validate-message="property.validatemessage ? property.validatemessage : null"
				>{{model[property.name] ? model[property.name] : property.default}}</textarea>
		</div>
	</template>

	<template id="scaffold-field-textarea">
		<div>
			<div v-if="model.errors && model.errors[property.name]">{{model.errors[property.name]}}</div>
			<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
			<textarea
				v-model="model[property.name]"
				:name="property.name"
				:data-validate="property.validate ? property.validate : null"
				:data-validate-message="property.validatemessage ? property.validatemessage : null"
				>{{model[property.name] ? model[property.name] : property.default}}</textarea>
		</div>
	</template>

	<template id="scaffold-field-checkbox">
		<div>
			<div v-if="model.errors && model.errors[property.name]">{{model.errors[property.name]}}</div>
			<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
			<input type="checkbox" v-model="model[property.name]"
			 v-bind:true-value="1"
  		 v-bind:false-value="0"
			:name="property.name" :value="1" :checked="typeof model[property.name] != 'undefined'  ? model[property.name] == 1 ? 1 : 0 : property.default"
			:data-validate="property.validate ? property.validate : null"
			:data-validate-message="property.validatemessage ? property.validatemessage : null"
			>
		</div>
	</template>

	<template id="scaffold-field-dropdown">
		<div>
			<div v-if="model.errors && model.errors[property.name]">{{model.errors[property.name]}}</div>
			<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
			<select
				v-model="model[property.name]"
				:name="property.name"
				:data-validate="property.validate ? property.validate : null"
				:data-validate-message="property.validatemessage ? property.validatemessage : null"
				>
				<option v-for="(option,index) in property.optionlist" :value="option" :selected="option == property.default ? 'selected' : null">{{property.optionvaluelist[index]}}</option>
			</select>
		</div>
	</template>


	<template id="scaffold-field-radio">
		<div>
			<div v-if="model.errors && model.errors[property.name]">{{model.errors[property.name]}}</div>
			<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
			<div v-for="(option,index) in property.optionlist" :value="option">
				{{property.optionvaluelist[index]}}
				<input
					type="radio"
					v-model="model[property.name]"
					:name="property.name"
					:value="option"
					:checked="option == property.default ? 'checked' : null"
					>
			</div>
		</div>
	</template>
</cfoutput>
