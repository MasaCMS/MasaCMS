<div id="load-spin" style="display: none;"><div id="load-spin-spinner"></div></div>

<div id="container-assembler">
	<assembler-attributes-form-template :model="model"></assembler-attributes-form-template>
	<!--- new relationship/property form --->
	<div class="block-content">
		<div class="btn-group pull-right">
			<button class="btn" @click='clickAddProperty'><i class="mi-plus-circle"></i> Add Property</button>
			<button class="btn" @click='clickAddRelated'><i class="mi-plus-circle"></i> Add Relationship</button>
		</div>
		<assembler-property-template :model="model"	></assembler-property-template>
		<div>
			<component :is="currentView" :data="data" :rendertypes="rendertypes" :fieldtypes="fieldtypes" :datatypes="datatypes" :model="model" transition="fade" transition-mode="out-in"></component>
		</div>
	</div>
	<div class="mura-actions">
		<div class="form-actions">
			<button v-if="model.entityname != '' && model.table != ''" @click='clickSave' class="btn mura-primary"><i class="mi-check-circle"></i> Save</button>
			<button v-else class="btn" disabled><i class="mi-ban"></i> Save</button>
		</div>
	</div>				

</div>