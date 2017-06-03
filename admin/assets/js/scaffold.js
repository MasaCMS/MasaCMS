var MuraORMScaffold = {
	siteID: '',
	endpoint: '',
	Scaffold: {},
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

		console.log("ALL!");

		Mura
			.get(self.getEndpoint())
			.then(function(data) {

        console.log("got");
        console.log(data);

				data.items = data.data.items;
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
					data.properties = properties.getAll().items;

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

			console.log('getting: ' + entityname);

			Mura
			.getEntity(entityname)
			.loadBy('id',ident) // 3rd argument = params
			.then(function(entity) {
				//Read properties for UI.
        console.log('Loaded Entity');
				console.log(entity);

				data.model = entity.getAll();
				data.model._displaylist = [];
				data.entity = entity;

				entity.get('properties')
					.then(
						function(properties) {
							data.properties = properties.getAll().items;

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
						console.log('well that fucked up!');
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
					data.error = e;
					listener(data);
				}
			);
	},

	feed: function( listener,entityname,itemsPer,sortBy,sortDir ) {
		var self = this;
		var entity = {};
		var data = {};

		var feed = Mura
			.getFeed(entityname);

		var feed = Mura
			.getFeed(entityname)
			.itemsPerPage(itemsPer);

		Mura(".filter").each( function() {
			console.log('fils');
			if(Mura(this).val() != '') {
				var filterCol = Mura(this).attr('name').split('-')[1];
				console.log(filterCol);
				feed.prop(filterCol).contains(Mura(this).val());
			}
		});

		if(sortBy) {
			feed.sort(sortBy,sortDir);
		}

		feed.getQuery()
			.then(function(collection) {

			data.collection = collection;

			data.list=collection.getAll().items;
			data.links=collection.getAll().links;

			collection.get('properties').then(function(properties){
				data.properties=properties.getAll().items;

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

			newcollection.get('properties').then(function(properties){
				data.properties=properties.getAll().items;

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
						console.log('a')
					},
					function( b ) {
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

$( document ).ready(function() {
	var MuraScaffold = new MuraORMScaffold.init( 'default' );
	var qstring = MuraScaffold.qstring();
	var Scaffold = "";

	Vue.component('scaffoldAll', {
		template: '#scaffold-all-template',
		props: ['data'],
		methods: {
			showList: function(name) {
				Scaffold.showList(name);
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
				Scaffold.clickCrumb(pos);
			}
		}
	});

	Vue.component('scaffoldForm', {
		template: '#scaffold-form-template',
		props: ['entityname','data','entityid'],
		methods: {
			clickSave: function() {
				MuraScaffold.Scaffold = this;
				Scaffold.clickSave( this.entityname );
			},
			clickBack: function() {
				MuraScaffold.Scaffold = this;
				Scaffold.clickBack();
			},
			clickDelete: function() {
				MuraScaffold.Scaffold = this;
				Scaffold.clickDelete( this.entityname );
			},
			showAll: function(){
				Scaffold.showAll();
			},
			showList: function(name){
				Scaffold.showList(name);
			}
		}
	,
	});


	Vue.component('scaffoldList', {
		template: '#scaffold-list-template',
		props: ['entityname','data','state'],
		mounted: function() {
			// processes related 'many' children
			this.$parent.state = [];
		},
		methods: {
			showForm: function(entityname,entityid,parentid){
				Scaffold.showForm(entityname,entityid,parentid);
			},
			applyFilter: function( event ) {
				Scaffold.applyFilter( event );
			},
			applyKeyFilter: function( event ) {
				Scaffold.applyKeyFilter( event );
			},
			applySortBy: function( col ) {
				Scaffold.applySortBy( col );
			},
			applyPage: function( action ) {
				Scaffold.applyPage( action );
			},
			applyItemsPer: function( e ) {
				Scaffold.applyItemsPer( e.target.value );
			}
		}
	});

	Vue.component('related-one', {
		template: '#related-one',
		props: ['property','model','entityid'],
		methods: {
			doDefault: function( val,fkcolumn,model ) {
				if(val && fkcolumn) {
					model[fkcolumn] = val;
				}
			}
		}
	});

	Vue.component('related-many-one', {
		template: '#related-many-one',
		props: ['property','model','entityid'],
		methods: {
			doDefault: function( val,fkcolumn,model ) {
				if(val && fkcolumn) {
					model[fkcolumn] = val;
				}
			}
		}
	});

	Vue.component('related-many', {
		template: '#related-many',
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
				Scaffold.showForm(entityname,entityid,parentid);
			}
		},
		computed: {
		}
	});


	Vue.component('field-text', {
		template: '#field-text',
		props: ['property','model','entity','list']
	});

	Vue.component('field-text', {
		template: '#field-text',
		props: ['property','model','entity'],
		methods: {}
	});

	Vue.component('field-textarea', {
		template: '#field-textarea',
		props: ['property','model','entity']
	});

	Vue.component('field-checkbox', {
		template: '#field-checkbox',
		props: ['property','model','entity']
	});

	Vue.component('field-dropdown', {
		template: '#field-dropdown',
		props: ['property','model','entity']
	});

	Vue.component('field-radio', {
		template: '#field-radio',
		props: ['property','model','entity']
	});

	Scaffold = new Vue({
		el: '#container',
		data: {
			all: [],
			sortBy: '',
			sortDir: '',
			itemsper: 5,
			entity: {},
			entityname: '',
			data: {},
			errordata: [],
			model: {id: ''},
			state: [],
			entityid: "",
			currentView: 'scaffoldForm'
		},
		mounted: function() {
			console.log('main mounted');

			this.showAll(); //
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
				if(this.state.length) {
					var stateitem = this.state.pop();

					if(stateitem.parent) {
						MuraScaffold.get( this.doForm,stateitem.parent.entityname,stateitem.parent.id,stateitem.parent );
					}
					else {
						this.showList(stateitem.name);
					}

				}
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

				console.log(arguments);

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

				if(this.state.length) {
					var currentState = this.state.pop();
					this.showForm( currentState.name,currentState.id,currentState.parent );


				}
				else {
					this.showList(this.entityname);
				}
			},
			showAll: function( data ) {
				MuraScaffold.all( this.doAll );
			},
			doAll: function( data ) {
				this.data.items = data.items;
				this.currentView = 'scaffoldAll';
			},
			showForm: function( entityname,entityid,parent ) {

				this.entityid = entityid;
				this.errordata = [];
				this.entityname = entityname;

				var stateitem = {displayname: '',name: entityname,id: entityid} ;
				var parentcopy = {};

				console.log(stateitem);

				if(parent && typeof parent == 'string') {
					Mura.deepExtend(parentcopy,this.model);
					stateitem.parent = parentcopy;
				}
				else if(parent) {
					Mura.deepExtend(parentcopy,parent);
					stateitem.parent = parentcopy;
				}
				else {
					console.log('clear state 1');
					this.state = [];
				}

				this.state.push( stateitem );

				MuraScaffold.get( this.doForm,entityname,entityid ? entityid : 'new' );
			},
			doForm: function( data ) {
				this.model = data.model;
				this.data = data;

				console.log('returned from get()');
				console.log(data);

				if (this.state.length > 1 && this.state[this.state.length - 1].parent) {
					this.data.parent = this.state[this.state.length - 1].parent;
				}
				else
					this.data.parent = null;



				this.currentView = 'scaffoldForm';
			},
			showList: function( entityname ) {
				this.entityname = entityname;
				this.currentView = 'scaffoldList';
				MuraScaffold.feed( this.doList,entityname,this.itemsper,this.sortBy,this.sortDir );
			},
			doList: function( data ) {
				this.data = data;
				this.currentView = 'scaffoldList';
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

				MuraScaffold.feed( this.doList,this.entityname,this.itemsper,this.sortBy,this.sortDir );
			},
			applyPage: function( action ) {
				MuraScaffold.page( this.doList,this.data.collection,action );
			}
		}
	});


});
