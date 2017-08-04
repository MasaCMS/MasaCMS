$( document ).ready(function() {

	var MuraORMScaffold = {
		siteID: '',
		endpoint: '',
		components: {},
		templates: {},
		rb: {},
	
		init: function(siteID,Scaffold){
	
			MuraORMScaffold.siteID = siteID;
			MuraORMScaffold.endpoint = '/index.cfm/_api/json/v1/' + MuraORMScaffold.siteID + '/';
	
			return MuraORMScaffold;
		},
	
		getEndpoint: function() {
			return MuraORMScaffold.endpoint;
		},
	
		all: function( listener ) {
			var self = this;
			var data = {};
	
			Mura
			.get(self.getEndpoint())
			.then(function(data) {
				
				var items = data.data.items;
				var itemlist = []; 
				
				for(var i in items) {
					if(items[i].dynamic && items[i].dynamic == true) {
						itemlist.push(items[i]);
					}
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
							if(data.properties[i].list) {
								data.model._displaylist.push(data.properties[i]);
							}
						}

						listener(data);
	
					});
				});
			}
			else {

				Mura
				.getEntity(entityname)
				.loadBy(entityname + 'id',ident) // 3rd argument = params
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
									if(data.properties[i].list) {
										data.model._displaylist.push(data.properties[i]);
									}
									else if(data.properties[i].fieldtype) {
	
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
	
		feed: function( listener,entityname,itemsPer,sortBy,sortDir,filters ) {
			var self = this;
			var entity = {};
			var data = {};
	
			var feed = Mura
				.getFeed(entityname)
				.itemsPerPage(itemsPer);
	
			$(".filter").each( function() {
				if($(this).val() != '') {
					var filterCol = $(this).attr('name').split('-')[1];
					feed.prop(filterCol).contains(Mura(this).val());
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
			
			feed.getQuery()
				.then(function(collection) {
	
				data.collection = collection;
	
				data.list=collection.getAll().items;
				data.links=collection.getAll().links;
				
				collection.get('properties').then(function(response){
					data.properties=response.properties.properties;
					data.parentproperties=response.properties;
	
					self.processProperties(data);
					listener(data);
				});
			});
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
			.save(
				function( a ) {
					console.log('saved')
				},
				function( b ) {
					console.log('save error');
					console.log(b);
				}
			)
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
			data.listview = [];
	
			data.properties.sort(self.propertySort);
	
			for(var x = 0;x < data.properties.length;x++) {
	
				var item = data.properties[x];
	
				if (item.list) {
					item.listposition = x;
					data.listview.push(item);
				}
	
				if(item['default'] == 'null')
					item['default'] = null;
	
				if(!item.orderno)
					item.orderno = orderpx++;
	
				if(item.optionlist)
					item.optionlist = item.optionlist.split('^');
	
				if(item.optionvaluelist)
					item.optionvaluelist = item.optionvaluelist.split('^');
	
				if(!item.rendertype || item.rendertype == "")
					item.rendertype = self.getRenderType( item );
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
		}
	
	}

	var MuraScaffold = new MuraORMScaffold.init( 'default' );
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
		props: ['entityname','data','entityid'],
		methods: {
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
				Scaffolder.showAll();
			},
			showList: function(name){
				Scaffolder.showList(name);
			}
		}
	,
	});


	Vue.component('scaffold-list-template', {
		template: '#scaffold-list-template',
		props: ['entityname','data','state','currentparent'],
		mounted: function() {
			// processes related 'many' children
			this.$parent.state = [];
		},
		methods: {
			showForm: function(entityname,entityid,parentid){
				Scaffolder.showForm(entityname,entityid,parentid);
			},
			applyFilter: function( event ) {
				Scaffolder.applyFilter( event );
			},
			applyKeyFilter: function( event ) {
				Scaffolder.applyKeyFilter( event );
			},
			applySortBy: function( col ) {
				Scaffolder.applySortBy( col );
			},
			applyPage: function( action ) {
				Scaffolder.applyPage( action );
			},
			applyItemsPer: function( e ) {
				Scaffolder.applyItemsPer( e.target.value );
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
				this.mparent.properties = data.parentproperties;
			},
			doDefault: function( val,fkcolumn,model ) {
				if(val && fkcolumn) {
					model[fkcolumn] = val;
				}
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
			showRelatedList: function(name,parent){
				Scaffolder.showRelatedList(name,parent);
			}
		},
		computed: {
		}
	});


	Vue.component('scaffold-field-text', {
		template: '#scaffold-field-text',
		props: ['property','model','entity','list']
	});

	Vue.component('scaffold-field-text', {
		template: '#scaffold-field-text',
		props: ['property','model','entity'],
		methods: {}
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
			itemsper: 5,
			entity: {},
			entityname: '',
			data: {},
			errordata: [],
			model: {id: ''},
			state: [],
			entityid: "",
			currentView: 'scaffold-form-template',
			currentparent: {},
		},
		mounted: function() {
			//this.hide();
			this.showAll();
		},
		destroyed: function() {
			console.log('main destroyed');
		},
		methods: {
			clickSave: function( entityname ) {
				this.errordata = [];
				MuraScaffold.save( this.doneFormProcessing,entityname,this.model );
			},
			clickBack: function() {
				this.errordata = [];
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
				this.errordata = [];
				var conf = confirm( "Are you sure you wish to delete this? ");

				if(conf) {
					MuraScaffold.delete( this.doneFormProcessing,entityname,this.model );
				}
				else {
					return;
				}
			},
			clickCrumb: function(pos) {
				this.errordata = [];
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
					this.errordata = entity.properties.errors;
					console.log('errors!');
					console.log(this.errordata);
					return;
				}
				else {
					this.errordata = [];
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
				this.errordata = [];
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

				if(this.currentparent.properties) {
					this.model[this.currentparent.properties.properties.primarykey] = this.currentparent.properties.id;
				}
				
				if (this.state.length > 1 && this.state[this.state.length - 1].parent) {
					this.data.parent = this.state[this.state.length - 1].parent;
				}
				else
					this.data.parent = null;

				this.currentView = 'scaffold-form-template';
			},
			showList: function( entityname ) {
				this.entityname = entityname;
				this.currentView = 'scaffold-list-template';
				
				MuraScaffold.feed( this.doList,entityname,this.itemsper,this.sortBy,this.sortDir );
			},
			doList: function( data ) {
				this.data = data;
				this.currentView = 'scaffold-list-template';
			},
			showRelatedList: function( entityname,parent ) {
				this.entityname = entityname;
				this.currentView = 'scaffold-list-template';
				this.currentparent = parent;

				var filters = [];
				
				var filter = {property:this.currentparent.properties.properties.primarykey,value:this.currentparent.properties.id};
				
				filters.push(filter);

				MuraScaffold.feed( this.doRelatedList,entityname,this.itemsper,this.sortBy,this.sortDir,filters );
			},
			doRelatedList: function( data ) {
				this.data = data;
				this.currentView = 'scaffold-list-template';
			},
			applyFilter: function() {
				MuraScaffold.feed( this.doList,this.entityname,this.itemsper,this.sortBy,this.sortDir );
			},
			applyKeyFilter: function( e ) {
				if(e.keyCode == 13)
				MuraScaffold.feed( this.doList,this.entityname,this.itemsper,this.sortBy,this.sortDir );
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
					$("#sortby-" + col).append("<i class='mi-sort-asc' id='sortarrow'></i>");
				else
					$("#sortby-" + col).append("<i class='mi-sort-desc' id='sortarrow'></i>");

				MuraScaffold.feed( this.doList,this.entityname,this.itemsper,this.sortBy,this.sortDir );
			},
			applyPage: function( action ) {
				MuraScaffold.page( this.doList,this.data.collection,action );
			},
			show: function() {
				this.isvisible = true;
				this.showAll();
			},
			hide: function() {
				this.isvisible = false;
			}
		}
	});

	Master = new Vue({
		el: '.container-master',
		data: {
			currentView: ""
		},
		methods: {
			clickShowScaffolder: function( entityname ) {
				Scaffolder.show();
				Assembler.hide();
			},
			clickShowAssembler: function( entityname ) {
				Scaffolder.hide();
				Assembler.show();
			}
		}
	
	});


});
