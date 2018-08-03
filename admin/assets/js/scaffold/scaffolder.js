Mura(function() {

	var MuraORMScaffold = {
		siteID: '',
		endpoint: '',
		components: {},
		templates: {},
		rb: {},
		init: function(siteID,Scaffold){

			MuraORMScaffold.siteID = siteID;
			MuraORMScaffold.endpoint = Mura.apiEndpoint;

			return MuraORMScaffold;
		},

		getEndpoint: function() {
			return MuraORMScaffold.endpoint;
		},

		all: function( listener ) {
			var self = this;
			var data = {};

			Mura
			.get(self.getEndpoint() + "?scaffold=1")
			.then(function(data) {

				var items = data.data.items;
				var itemlist = [];

				for(var i in items) {
					itemlist.push(items[i]);
				}

				data.items = itemlist;
				listener(data);
			});
		},

		get: function( listener,entityname,id,properties,params ) {
			var self = this;
			var entity = {};
			var data = {};
			var ident = id ? id : 'new';

			if(ident == 'new') {
				Mura
				.getEntity(entityname)
				.new()
				.then(function(entity) {
					//Read properties for UI.

					data.model = entity.getAll();
					data.model._displaylist = [];
					data.entity = entity;

					entity.get('properties').then(function(properties){
						data.properties = properties.properties.properties;

						self.processProperties(data);

						for(var i = 0;i < data.properties.length;i++) {

							if(data.properties[i].listview) {
								data.model._displaylist.push(data.properties[i]);
							}

							if(data.properties[i].datatype=='datetime' || data.properties[i].datatype=='date') {
								data.model[data.properties[i].name]=MuraScaffold.formatDate(data.model[data.properties[i].name]);
							}
						}

						listener(data);

					});
				});
			}
			else {
				Mura
				.getEntity(entityname)
				.loadBy('id',ident) // 3rd argument = params
				.then(function(entity) {
					//Read properties for UI.

					data.model = entity.getAll();
					data.model._displaylist = [];
					data.entity = entity;

					entity.get('properties')
						.then(
							function(properties) {
								data.properties = properties.properties.properties;
								self.processProperties(data);

								for(var i = 0;i < data.properties.length;i++) {
									if(data.properties[i].listview) {
										data.model._displaylist.push(data.properties[i]);
									}
									else if(data.properties[i].fieldtype) {

									}

									if(data.properties[i].datatype=='datetime' || data.properties[i].datatype=='date') {
										data.model[data.properties[i].name]=MuraScaffold.formatDate(data.model[data.properties[i].name]);
									}
								}

							listener(data);
						},
						function(error) {
							console.log('error!');
							console.log(error);
						}
					);
				});
			}
		},

		processEntity: function(listener, entity,data) {

			listener(data);
		},

		related: function(listener, entity, propertyname) {
			var data = {};

			entity
				.get(propertyname).then(
					function(collection){
						data.collection = collection.properties;
						listener(data);
					},
					function(e){
						console.log('error');
						console.log(e);
						data.error = e;
						listener(data);
					}
				);
		},

		feed: function( listener,entityname,itemsPer,sortBy,sortDir,filters) {
			var self = this;
			var entity = {};
			var data = {};
			var filterVal='';
			var itemsPer = itemsPer || ((this.data && this.data.itemsPer) ? this.data.itemsPer : 0);
			var feed = Mura
				.getFeed(entityname)
				.itemsPerPage(itemsPer);

			if(entityname=='entity'){
				feed.prop('scaffold').isEQ(1);
			}

			var hasFilterApplied=false;

			Mura(".filter").each( function() {
				if(Mura(this).val() != '') {
					var filterCol = Mura(this).attr('name').split('-')[1];
					feed.prop(filterCol).contains(Mura(this).val());
					hasFilterApplied=true;
				}
			});

			if(filters && filters.length) {
				for(var i =0;i < filters.length;i++) {
					feed.prop(filters[i].property).contains(filters[i].value);
				}
			}

			if(sortBy) {
				feed.sort(sortBy,sortDir);
			}

			Mura.getEntity(entityname).new().then(
				function(entity){
					entity.get('properties').then(function(response){
						data.properties=response.properties.properties;
						data.parentproperties=response.properties;

						if(typeof data.parentproperties.dynamic=='undefined'){
							data.parentproperties.dynamic=false;
						} else if(typeof data.parentproperties.dynamic =='string'){
							if(data.parentproperties.dynamic=='0' || data.parentproperties.dynamic.toLowerCase()=='false'){
								data.parentproperties.dynamic=false;
							} else {
								data.parentproperties.dynamic=true;
							}
						}
						self.processProperties(data);
						data.hasFilterApplied=hasFilterApplied;

						feed.expand(data.expand.join());

						feed.getQuery().then(function(response){

							feed.getQuery()
								.then(function(collection) {

								data.collection = collection;
								data.list=collection.getAll().items;
								data.links=collection.getAll().links;
								data.loaded=true;
								listener(data);
							});
						});
					});
				}
			);
		},

		page: function( listener,collection,action ) {
			var self = this;
			var entity = {};
			var data = {};

			collection.get(action).then( function( newcollection ) {

				data.collection = newcollection;

				data.list=newcollection.getAll().items;
				data.links=newcollection.getAll().links;

				newcollection.get('properties').then(function(properties) {
					data.properties=properties.properties.properties;

					self.processProperties(data);

					listener(data);
				});
			});
		},

		save: function( listener,entityname,model ) {
			var self = this;

			Mura
			.getEntity(entityname)
			.set(
				model
			)
			.save()
			.then(
				function( savedmodel ) {
					listener(savedmodel);
				},
				function( failed ) {
					listener(failed,true);
				}
			);
		},

		delete: function( listener,entityname,model ) {
			var self = this;

			Mura
				.getEntity(entityname)
				.set(
					model
				)
				.delete()
			.then( function( deletedModel ) {
				listener(deletedModel);
			});
		},

		getRenderType: function( properties ) {
			if(properties.datatype == 'text')
				return "textarea";
			else if(properties.datatype == 'int' && properties['default'] <= 1)
				return "checkbox";
			else
				return "textfield";

		},

		buildUrl: function( entity,id,properties,params ) {
			var self = this;

			var url = self.endpoint;
			url += entity ?  entity : '';
			url += id ?  "/" + id : '';

			if(properties) {
				url += "/properties";
			}
			else if(params && params.length) {

				url += "/?"

				for(var param in params) {
					url += param + "=" + params[param];
				}
			}

			return encodeURI(url);
		},

		processProperties: function( data ) {
			var self = this;
			var orderpx = 10000;
			var hasFilter=false;

			data.expand= [];
			data.listview = [];

			data.properties.sort(self.propertySort);

			for(var x = 0;x < data.properties.length;x++) {

				var item = data.properties[x];

				if (item.listview) {
					item.listposition = x;
					data.listview.push(item);
				}

				if(item['default'] == 'null'){
					item['default'] = null;
				}

				if(!item.orderno){
					item.orderno = orderpx++;
				}

				if(item.optionlist){
					item.optionlist = item.optionlist.split('^');
				}

				if(item.optionvaluelist){
					item.optionvaluelist = item.optionvaluelist.split('^');
				}

				if(!item.rendertype || item.rendertype == ""){
					item.rendertype = self.getRenderType( item );
				}

				if(item.filter==true || item.filter == 'true' || typeof item.filter == 'string' && item.filter.toLowerCase() == 'yes'){
					hasFilter=true;
				}

				if(!item.displayname || item.displayname == ""){
					item.displayname = item.name;
				}

				item.displayname=item.displayname.charAt(0).toUpperCase() + item.displayname.slice(1)

			}

			if(!data.listview.length){
				for(var x = 0;x < data.properties.length;x++) {
					var item=data.properties[x];
					if(
						(
							item.name=='name'
							|| item.name=='title'
							|| item.name=='summary'
							|| item.name=='description'
							|| item.name=='lastupdate'
							|| item.name=='created'
							|| item.name=='fname'
							|| item.name=='lname'
							|| item.name=='firstname'
							|| item.name=='lastname'
							|| item.name=='company'
							|| item.name=='organization'
						)
						 && (!item.relatesto || item.relatesto=="")
					 ){
						item.listposition = x;
						data.listview.push(item);
					}
				}

				if(!data.listview.length){
					for(var x = 0;x < data.properties.length;x++) {
						var item=data.properties[x];
						if(!item.relatesto || item.relatesto==""){
							item.listposition = x;
							data.listview.push(data.properties[x]);
						}
					}
				}
			}

			for(var x = 0;x < data.listview.length;x++) {
				var item=data.listview[x];
				if(item.fieldtype=='one-to-one' || item.fieldtype=='many-to-one'){
					data.expand.push(item.name);
				}
			}

			if(!hasFilter){
				for(var x = 0;x < data.listview.length;x++) {
					data.listview[x].filter=true;
				}
			}

			return data;

		},

		propertySort: function(a,b) {
			if(!a.orderno)
				a.orderno = 0;
			if(!b.orderno)
				b.orderno = 0;

			return parseInt(a.orderno) - parseInt(b.orderno);
		},

		registerComponent: function( component,ident ) {
			var self = this;
			self.components[ident] = component;
		},

		qstring: function() {
			var querystring = {};

			var url = window.location.href;
			var qstring = "";
			var items = "";
			var item = "";
			var keyval = "";

			if(url.split('?').length < 2)
				return querystring;

			qstring = url.split('?')[1];

			if( qstring.includes("&") ) {
				items = qstring.split("&");

				for(var i = 0;i < items.length;i++) {
					keyval = items[i].split("=");
					querystring[decodeURIComponent(keyval[0])] = decodeURIComponent(keyval[1]);
				}
			}
			else {
				keyval = qstring.split("=");
				querystring[decodeURIComponent(keyval[0])] = decodeURIComponent(keyval[1]);

			}
			return querystring;
		},
		formatDate:function(dateString){
			if(!dateString){
				return '';
			}

			dateString=dateString.split('T')[0];
			var dateArray=dateString.split("-");

			if(dtFormat[0]==0){
				return dateArray[1] + dtCh + dateArray[2] + dtCh + dateArray[0];
			} else {
				return dateArray[2] + dtCh + dateArray[1] + dtCh + dateArray[0];
			}

		}

	}

	var MuraScaffold = new MuraORMScaffold.init( Mura.siteid );
	var qstring = MuraScaffold.qstring();

	Vue.component('scaffold-all-template', {
		template: '#scaffold-all-template',
		props: ['data'],
		methods: {
			showList: function(name) {
				Scaffolder.showList(name);
			}
		}
	});

	Vue.component('scaffold-error-template', {
		template: '#scaffold-error-template',
		props: ['errordata'],
		methods: {
		}
	});

	Vue.component('scaffold-crumb-template', {
		template: '#scaffold-crumb-template',
		props: ['data','state'],
		methods: {
			clickCrumb: function(pos) {
				Scaffolder.clickCrumb(pos);
			}
		}
	});

	Vue.component('scaffold-form-template', {
		template: '#scaffold-form-template',
		props: ['entityname','data','entityid','errordata'],
		methods: {
			openEndpoint:function(){
				window.open(MuraScaffold.getEndpoint() + this.$props.entityname + "/" + this.$props.data.model.id, '_blank');
			},
			clickSave: function() {
				MuraScaffold.Scaffold = this;

				Scaffolder.clickSave( this.entityname );
			},
			clickBack: function() {
				MuraScaffold.Scaffold = this;
				Scaffolder.clickBack();
			},
			clickDelete: function() {
				MuraScaffold.Scaffold = this;
				Scaffolder.clickDelete( this.entityname );
			},
			showAll: function(){
				Scaffolder.showList('entity');
			},
			showList: function(name){
				Scaffolder.showList(name);
			}
		}
	,
	});

	Vue.component('scaffold-list-template', {
		template: '#scaffold-list-template',
		props: ['entityname','data','state','currentparent','issuperuser'],
		mounted: function() {
			// processes related 'many' children
			this.$parent.state = [];
			this.entityTransitionLoader();
		},
		data:function(){
			return {
				listtransition:false
			}
		},
		watch: {
			 data: function () {
				 this.listtransition=false;
			 }
		},
		methods: {
			openEndpoint:function(){
				if(this.$props.entityname=='entity'){
					window.open(MuraScaffold.getEndpoint(), '_blank');
				} else {
					window.open(MuraScaffold.getEndpoint() + this.$props.entityname, '_blank');
				}
			},
			entityTransitionLoader:function(){
				delete this.data.list;
				setTimeout(function(){$('.scaffolder-list-entity-loader > .load-inline').spin(spinnerArgs2);},10)
			},
			listTransitionLoader:function(){
				this.listtransition=true;
				setTimeout(function(){$('.scaffolder-list-transition-loader  > .load-inline').spin(spinnerArgs2);},10)
			},
			goToAssembler: function(entityname){
				location.href="./?muraAction=scaffold.assembler&entityname=" + entityname;
			},
			showForm: function(entityname,entityid,parentid){
				Scaffolder.showForm(entityname,entityid,parentid);
			},
			applyFilter: function( event ) {
				this.listTransitionLoader();
				Scaffolder.applyFilter( event );
			},
			removeFilter:function(){
			  Mura(".filter").val('');
				this.listTransitionLoader();
			  Scaffolder.applyFilter();
			},
			applyKeyFilter: function( event ) {
				if(event.keyCode == 13){
					this.listTransitionLoader();
					Scaffolder.applyKeyFilter( event );
				}
			},
			applySortBy: function( col ) {
				this.listTransitionLoader();
				Scaffolder.applySortBy( col );
			},
			applyPage: function( action ) {
				this.listTransitionLoader();
				Scaffolder.applyPage( action );
			},
			applyItemsPer: function( e ) {
				this.listTransitionLoader();
				Scaffolder.applyItemsPer( e.target.value );
			},
			showAll: function() {
				this.showList('entity');
			},
			showList: function(name) {
				this.entityTransitionLoader();
				Scaffolder.showList(name);
			},
			formatDate:function(dateString){
				return MuraScaffold.formatDate(dateString);
			}
		}
	});

	Vue.component('scaffold-related-one', {
		template: '#scaffold-related-one',
		props: ['property','model','entityid'],
		methods: {
			doDefault: function( val,fkcolumn,model ) {
				if(val && fkcolumn) {
					model[fkcolumn] = val;
				}
			}
		}
	});

	Vue.component('scaffold-related-many-one', {
		template: '#scaffold-related-many-one',
		props: ['property','model','entity','mparent','properties'],
		mounted: function() {
			// processes related 'many' children

			MuraScaffold.feed( this.proplist,this.property.relatesto );
		},
		methods: {
			proplist: function( data ) {
				this.mparent = {};

				this.properties = data.properties;
				this.mparent.list = data.list;

				if(!this.property.renderfield && data.list.length){
					var item=data.list[0];

					if(item.name){
						this.property.renderfield='name';
					} else if(item.menutitle){
						this.property.renderfield='item';
					} else if(item.title){
						this.property.renderfield='title';
					} else if(item.groupname){
						this.property.renderfield='groupname';
					} else if(item.company){
						this.property.renderfield='company';
					} else if(item.organization){
						this.property.renderfield='organization';
					} else if(item.label){
						this.property.renderfield='label';
					}
				}

				this.mparent.properties = data.parentproperties;
				this.loaded=true;
			},
			doDefault: function( val,fkcolumn,model ) {
				if(val && fkcolumn) {
					model[fkcolumn] = val;
				}
			},
			showForm: function(entityname,entityid,parentid){
				Scaffolder.showForm(entityname,entityid,parentid);
			}
		}
	});

	Vue.component('scaffold-related-many', {
		template: '#scaffold-related-many',
		props: ['property','entity','related','entityid'],
		data: function() {
			return {
				// must use 'mrelated' proxy to avoid vue mutable error
				mrelated: this.related ? JSON.parse(this.related) : {}
			}
		},
		mounted: function() {
			// processes related 'many' children
			MuraScaffold.related( this.proplist,this.entity,this.property.name );
		},
		methods: {
			proplist: function( data ) {
				this.mrelated = data;
			},
			showForm: function(entityname,entityid,parentid) {
				Scaffolder.showForm(entityname,entityid,parentid);
			},
			showRelatedList: function(relatesto,parent){
				Scaffolder.showRelatedList(relatesto,parent);
			}
		},
		computed: {
		}
	});

	Vue.component('scaffold-field-text-readonly', {
		template: '#scaffold-field-text-readonly',
		props: ['property','model','entity','list']
	});

	Vue.component('scaffold-field-text', {
		template: '#scaffold-field-text',
		props: ['property','model','entity','list']
	});

	Vue.component('scaffold-field-htmleditor', {
		template: '#scaffold-field-htmleditor',
		props: ['property','model','entity','list'],
		mounted: function() {
			setHTMLEditors()
		}
	});

	if($){
		if(dtLocale){
			$.datepicker.setDefaults( $.datepicker.regional[ dtLocale ] );
		} else {
			$.datepicker.setDefaults( $.datepicker.regional[ '' ] );
		}
	}

	Vue.component('scaffold-field-text', {
		template: '#scaffold-field-text',
		props: ['property','model','entity'],
		methods: {
			formatDate:function(dateString){
				return MuraScaffold.formatDate(dateString);
			}
		},
		mounted: function() {
			var self=this;
			if($ && (this.$props.property.datatype=='date' || this.$props.property.datatype=='datetime' || this.$props.property.validate=='date')){
				//self.$props.model[self.$props.property.name]=MuraScaffold.formatDate(self.$props.model[self.$props.property.name]);
				$('input[name="' + this.$props.property.name + '"]').datepicker({
						'minDate': 1,
						onSelect: function(selectedDate) {
								if (selectedDate) {
									self.$props.model[self.$props.property.name]=selectedDate;
								}
						}
				});
			}
		}
	});

	Vue.component('scaffold-field-textarea', {
		template: '#scaffold-field-textarea',
		props: ['property','model','entity']
	});

	Vue.component('scaffold-field-checkbox', {
		template: '#scaffold-field-checkbox',
		props: ['property','model','entity']
	});

	Vue.component('scaffold-field-dropdown', {
		template: '#scaffold-field-dropdown',
		props: ['property','model','entity']
	});

	Vue.component('scaffold-field-radio', {
		template: '#scaffold-field-radio',
		props: ['property','model','entity']
	});

	Scaffolder = new Vue({
		el: '#container-scaffold',
		data: {
			all: [],
			sortBy: '',
			sortDir: '',
			isvisible: false,
			itemsper: 10,
			entity: {},
			entityname: '',
			data: {},
			errordata: {},
			model: {id: ''},
			state: [],
			entityid: "",
			currentView: 'scaffold-form-template',
			currentparent: {},
			issuperuser:window.IsSuperUser,
			listtransition:false
		},
		mounted: function() {
			//this.hide();
			this.showList('entity');
		},
		destroyed: function() {
			console.log('main destroyed');
		},
		methods: {
			clickSave: function( entityname ) {
				this.errordata = {};

				for(i in CKEDITOR.instances){
					CKEDITOR.instances[i].updateElement();
					this.model[i]=CKEDITOR.instances[i].getData();
				}

				MuraScaffold.save( this.doneFormProcessing,entityname,this.model );
			},
			clickBack: function() {
				this.errordata = {};
				/*
				if(this.state.length) {
					var stateitem = this.state.pop();

					if(stateitem.parent) {
						MuraScaffold.get( this.doForm,stateitem.parent.entityname,stateitem.parent.id,stateitem.parent );
					}
					else {
						this.showList(stateitem.name);
					}
				}
				*/
				this.showList(this.entityname);

			},
			clickDelete: function( entityname ) {
				this.errordata = {};
				var conf = confirm( "Are you sure you wish to delete this? ");

				if(conf) {
					MuraScaffold.delete( this.doneFormProcessing,entityname,this.model );
				}
				else {
					return;
				}
			},
			clickCrumb: function(pos) {
				this.errordata = {};
				var stateitem = this.state[pos];

				// use splice as setting length will not trigger vue.js redreaw
				this.state = this.state.splice(0,this.state.length - (this.state.length-pos));

				if(stateitem.parent) {
					MuraScaffold.get( this.doForm,stateitem.parent.entityname,stateitem.parent.id,stateitem.parent );
				}
				else {
					this.showList(stateitem.name);
				}
			},
			doneFormProcessing: function( entity,hasError ) {
				// process state

				if( hasError ) {
					var self=this;

					self.data.model = entity.getAll();
					self.data.model._displaylist = [];
					self.data.entity = entity;
					self.model = self.data.model;
					self.errordata=self.data.model.errors;
					entity.get('properties')
						.then(
							function(properties) {

								self.data.properties = properties.properties.properties;

								MuraScaffold.processProperties(self.data);

								for(var i = 0;i < self.data.properties.length;i++) {
									if(self.data.properties[i].listview) {
										self.data.model._displaylist.push(self.data.properties[i]);
									}
									else if(self.data.properties[i].fieldtype) {

									}

									if(self.data.properties[i].datatype=='datetime' || self.data.properties[i].datatype=='date') {
										self.data.model[self.data.properties[i].name]=MuraScaffold.formatDate(self.data.model[self.data.properties[i].name]);
									}
								}

								this.currentView = "";
								this.currentView = 'scaffold-form-template';

						},
						function(error) {
							console.log('error!');
							console.log(error);
						}
					);

					console.log('errors!');
					//console.log(this.errordata)

					return;
				}
				else {
					this.errordata = {};
				}

				var dead = this.state.pop();

				/*
				if(this.state.length) {
					var currentState = this.state.pop();
					this.showForm( currentState.name,currentState.id,currentState.parent );
				}
				else {
					this.showList(this.entityname);
				}

				*/

				if(this.currentparent.properties) {
					this.showRelatedList(this.entityname,this.currentparent);
				}
				else {
					this.showList(this.entityname);
				}
			},
			showAll: function( data ) {
				this.currentparent = {};
				this.sortBy= '';
				this.sortDir= '';
				MuraScaffold.all( this.doAll );
			},
			hide: function() {
				this.currentView = "";
			},
			doAll: function( data ) {
				this.data.items = data.items;
				this.currentView = 'scaffold-all-template';
			},
			showForm: function( entityname,entityid,parent ) {

				this.entityid = entityid;
				this.errordata = {};
				this.entityname = entityname;

				if(this.currentparent.properties && this.currentparent.properties.entityname == entityname) {
					this.currentparent = {};
				}

				/*
				var stateitem = {displayname: '',name: entityname,id: entityid} ;
				var parentcopy = {};

				if(parent && typeof parent == 'string') {
					Mura.deepExtend(parentcopy,this.model);
					stateitem.parent = parentcopy;
				}
				else if(parent) {
					Mura.deepExtend(parentcopy,parent);
					stateitem.parent = parentcopy;
				}
				else {
					this.state = [];
				}

				this.state.push( stateitem );
*/
				MuraScaffold.get( this.doForm,entityname,entityid ? entityid : 'new' );
			},
			doForm: function( data ) {
				this.model = data.model;
				this.data = data;
				this.errordata={};

				if(this.currentparent.properties) {
					this.model[this.currentparent.properties.properties.primarykey] = this.currentparent.properties.id;
				}

				if (this.state.length > 1 && this.state[this.state.length - 1].parent) {
					this.data.parent = this.state[this.state.length - 1].parent;
				}
				else {
					this.data.parent = null;
				}

				this.currentView = 'scaffold-form-template';
			},
			showList: function( entityname ) {
				if(entityname=='entity'){
					this.currentparent={};
				}
				this.sortBy='';
				this.sortDir='';
				this.entityname = entityname;
				this.currentView = 'scaffold-list-template';
				MuraScaffold.feed( this.doList,entityname,this.itemsper,this.sortBy,this.sortDir );
			},
			doList: function( data ) {
				data.listtransition=false;
				this.data=data;
				this.data.issuperuser=window.IsSuperUser;
				this.currentView = 'scaffold-list-template';
			},
			showRelatedList: function( entityname,parent ) {
				this.entityname = entityname;
				this.currentView = 'scaffold-list-template';
				this.currentparent = parent;

				var self=this;

				this.currentparent.get('properties').then(function(collection){

					var filters = [];
					var property;
					var value;
					var properties=collection.getAll();

					for(var p=0;p < properties.properties.length;p++){

						if(properties.properties[p].fieldtype && (properties.properties[p].fieldtype=='one-to-many' || properties.properties[p].fieldtype=='many-to-many') && properties.properties[p].relatesto==self.entityname){

							if(properties.properties[p].loadkey=='primaryKey'){
								property=properties.primarykey;
							} else {
								property=properties.properties[p].loadkey;
							}

							if(properties.properties[p].fkcolumn=='primaryKey'){
								value=self.currentparent.properties[properties.primarykey];
							} else {
								value=self.currentparent.properties[properties.properties[p].fkcolumn];
							}

							var filter = {property:property,value:value};
						}
					}

					if(filter){
						filters.push(filter);
					}

					MuraScaffold.feed( self.doRelatedList,entityname,self.itemsper,self.sortBy,self.sortDir,filters,false);

				});

			},
			doRelatedList: function( data ) {
				this.data = data;
				this.currentView = 'scaffold-list-template';
			},
			applyFilter: function() {
				MuraScaffold.feed( this.doList,this.entityname,this.itemsper,this.sortBy,this.sortDir );
			},
			removeFilter:function(){
				Mura(".filter").val('');
				MuraScaffold.feed( this.doList,this.entityname,this.itemsper,this.sortBy,this.sortDir );
			},
			applyKeyFilter: function( e ) {
				if(e.keyCode == 13){
					MuraScaffold.feed( this.doList,this.entityname,this.itemsper,this.sortBy,this.sortDir );
				}
			},
			applyItemsPer: function( itemsper ) {
				this.itemsper = itemsper;
				MuraScaffold.feed( this.doList,this.entityname,this.itemsper,this.sortBy,this.sortDir );
			},
			applySortBy: function( col ) {
				this.sortBy = col;
				this.sortDir = this.sortDir == '' ? 'desc' : this.sortDir == 'desc' ? 'asc' : 'desc';

				Mura("#sortarrow").remove();
				if(this.sortDir == 'asc')
					Mura("#sortby-" + col).append("<i class='mi-sort-asc' id='sortarrow'></i>");
				else
					Mura("#sortby-" + col).append("<i class='mi-sort-desc' id='sortarrow'></i>");

				MuraScaffold.feed( this.doList,this.entityname,this.itemsper,this.sortBy,this.sortDir );
			},
			applyPage: function( action ) {
				MuraScaffold.page( this.doList,this.data.collection,action );
			},
			show: function() {
				this.isvisible = true;
				this.showList('entity');
			},
			hide: function() {
				this.isvisible = false;
			}
		}
	});

});
