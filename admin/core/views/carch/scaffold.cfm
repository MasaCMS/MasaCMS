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
	##scaffold-sortby th i {
		padding: 1px 0px 0px 5px;
		color: ##333333;
		font-size: 1.1em;
	}
	##scaffold-sortby th {
	}

	##scaffold-table tr.alt td {
		background-color: ##eee;
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

	.breadcrumb {
		list-style: none;
		overflow: hidden;
		height: 25px;
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

<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
<div class="nav-module-specific btn-group">
	<a class="btn" href="./?muraAction=cPerm.module&contentid=00000000000000000000000000000000016&siteid=#esapiEncode('url',rc.siteid)#&moduleid=00000000000000000000000000000000016"><i class="mi-group"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.permissions')#</a>
</div>
</cfif>

<div class="block block-constrain" id="container">
	<div class="block-content">
			<div class="block block-bordered">
				<div id="load-spin" style="display: none;"><div id="load-spin-spinner"></div></div>
				<div class="block-content">
					<div>
						<div>
							<div id="container-scaffold">
							<scaffold-crumb-template :data="data" :state="state"></scaffold-crumb-template>
								<scaffold-error-template :errordata="errordata"></scaffold-error-template>
								<div>
									<component :is="currentView" :currentparent="currentparent" :entityname="entityname" :data="data" transition="fade" transition-mode="out-in"></component>
								</div>
							</div>
						</div>
					</div>
			</div> <!-- /.block-content -->
		</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->


	<template id="scaffold-crumb-template">
		<div style="height: 30px">
			<div v-if="state">
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
			<h2>
			<span v-if="entityname"><span v-if="entityname=='entity'">CUSTOM </span>{{entityname.toUpperCase()}} LIST</span>
			<span v-if="currentparent && currentparent.properties"> for {{currentparent.properties.entityname}}:
				<input type="HIDDEN" class="filter" :name="'filter-' + currentparent.properties.properties.primarykey" :value="currentparent.properties.id">
				<span v-for="item in currentparent.properties._displaylist">
					{{currentparent.properties[item.name]}}
				</span>
			</span>
			</h2>
			<div class="btn-group">
			<span v-if="entityname != 'entity'">
				<button @click="showAll" type="submit" class="btn">View All Custom Entities</button>
				<span v-if="data.issuperuser && data && data.parentproperties.dynamic && data.parentproperties.dynamic">
					<button @click="goToAssembler(entityname)">Edit Entity Definition</button>
				</span>
			</span>
			<button @click="openEndpoint()">View API Endpoint</button>
			<span v-if="currentparent && currentparent.properties">
				<button @click="showForm(currentparent.properties.entityname,currentparent.properties.id)" class="btn">Back</button>
			</span>
		</div>
			<div v-if="data.list">
				<table width="100%" id="scaffold-table">
					<thead id="scaffold-filterby">
						<tr>
							<th v-for="item in data.listview">
								<div v-if="item.filter==true || item.filter == 'true'">
									<input class="filter" :name="'filter-' + item.name" @keyup="applyKeyFilter">
								</div>
							</th>
							<th><button class="pull-right" @click='applyFilter'>Filter</button><span v-if="data.hasFilterApplied"><button class="pull-right" @click='removeFilter'>Remove Filter</button><span></th>
						</tr>
					</thead>
					<thead id="scaffold-sortby">
						<tr>
							<th v-for="(item, key, index) in data.listview" :id="'sortby-' + item.name">
								<span @click="applySortBy(item.name)">{{item.displayname}}</span>
							</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<span v-if="data.list.length">
							<tr v-for="(object,index) in data.list" :class="{'alt': index % 2 === 0}">
									<td v-for="item in data.listview" @click="(entityname == 'entity') ? showList(object.entityname) : showForm(object.entityname,object.id)">
											<span v-if="item.rendertype == 'htmleditor'" v-html="object[item.name]"></span>
											<span v-else-if="item.datatype=='datetime' || item.datetime=='date'" v-text="formatDate(object[item.name])"></span>
											<span v-else v-text="object[item.name]"></span>
									</td>
									<td v-if="entityname != 'entity'">
										<button class="pull-right" @click="showForm(object.entityname,object.id)"><i class="mi-edit"></i></button>
									</td>
									<td v-if="entityname == 'entity'">
										<button class="pull-right" @click="showList(object.entityname)"><i class="mi-edit"></i></button>
									</td>
								</li>
							</tr>
						</span>

						<tr v-if="!data.list.length">
								<td :colspan="data.listview.length+1">
									<p class="alert alert-info">No items available.</p>
								</td>
						</tr>

					</tbody>
					<tfoot>
						<tr>
							<th :colspan="data.listview.length+1" style="text-align: right">
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
							</th>
						</tr>
					</tfoot>
				</table>
				<span v-if="entityname != 'entity'">
					<span v-if="currentparent && currentparent.properties">
						<button @click="showForm(entityname)">Add Child</button>
						<button @click="showForm(currentparent.properties.entityname,currentparent.properties.id)">Back</button>
					</span>
					<span v-else>
						<button @click="showForm(entityname)">Add New</button>
					</span>
				</span>
				<span v-if="entityname == 'entity' && data.issuperuser">
					<a href="./?muraAction=scaffold.assembler" class="btn">Add New</a>
				</span>
			</div>
		</div>
	</template>

	<template id="scaffold-form-template">
		<div>
		<h2>EDIT {{entityname.toUpperCase()}}</h3>
		<button @click="clickBack" type="submit" class="btn">Back</button>
		<button @click="openEndpoint()">View API Endpoint</button>
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
