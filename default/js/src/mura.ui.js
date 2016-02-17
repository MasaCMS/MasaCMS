/* This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

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
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */

;(function(window){

	window.mura.UI=window.mura.Core.extend({

		settings:{},
		templates:{},
		formJSON:{},
		data:{},
		currentPage: 0,
		entity: {},
		fields:{},
		datasets: [],
		smack: [1,2,3],
		templateList: ['checkbox','dropdown','radio','textarea','textfield','form'],
		formInit: false,
		responsemessage: "",

		init:function(properties){
			
			properties || {};
			this.settings = properties;

			console.log('init');
		},

		getTemplates() {

			var self = this;

			var temp = self.templateList.pop();

			$.ajax({
				url :  	'/' + window.mura.siteid + '/includes/display_objects/form/templates/' + temp + '.hb',
				success : function( results ) {
					self.templates[temp] = Handlebars.compile(results);
					if(!self.templateList.length) {
						self.loadForm();
					}
					else
						self.getTemplates();
				},
				error : function( e ) {
					console.log( e );
				}
			});
		},

		renderField:function(name,data) {
			var self = this;
			var templates = this.templates;

			if( data.datasetid != "")
				data.options = self.formJSON.datasets[data.datasetid].options;

			var html = self.templates[name](data);
			$(".field-container",self.settings.formEl).append(html);
		},

		renderData: function( ) {
			var self = this;

			if(self.datasets.length == 0)
				self.renderForm();

			var dataset = this.formJSON.datasets[self.datasets.pop()];

			if(dataset.sourcetype != 'muraorm')
				self.renderData();

			dataset.options = [];

			window.mura.getFeed( dataset.source )
				.getQuery()
				.then( function(collection) {
					collection.each(function(item) {
						var itemid = item.get('id');
						dataset.datarecordorder.push( itemid );
						dataset.datarecords[itemid] = item.getAll();
						dataset.datarecords[itemid]['value'] = itemid;
						dataset.datarecords[itemid]['datarecordid'] = itemid;
						dataset.datarecords[itemid]['datasetid'] = dataset.datasetid;
						dataset.datarecords[itemid]['isselected'] = 0;
						dataset.options.push( dataset.datarecords[itemid] );
					});	

				})
				.then(function() {
					console.log(dataset);
					self.renderData();
				})
				;
		},

		renderForm: function( ) {

			var self = this;
			console.log('render');
			console.log( self.formJSON );

			if(!self.formInit) {
				self.initForm();
			}

			var fields = this.formJSON.form.pages[this.currentPage];
			for(var i = 0;i < fields.length;i++) {

				var field =  this.formJSON.form.fields[fields[i]];
			
				if( field.fieldtype.fieldtype != undefined && field.fieldtype.fieldtype != "") {
					self.renderField(field.fieldtype.fieldtype,field);
/*
					var source = $("#field-" + field.rendertype).html();
					var template = Handlebars.compile(source);
					var html = template(field);
					$("#formContainer").append(html);
*/
				}
			}

		},
		
		getForm: function() {
			var self = this;
			var formJSON = {};
			var entityName = '';

			console.log('get form');

			if(self.templateList.length) {
				self.getTemplates();
			}
			else {
				self.loadForm();
			}
		},
		
		loadForm: function() {

			var self = this;

			window.mura.get(
					window.mura.apiEndpoint + '/' + window.mura.siteid + '/content/' + self.settings.objectid
					 + '?fields=body,title,filename,responsemessage'
					).then(function(data) {
					 	formJSON = JSON.parse( data.data.body );
						entityName = data.data.filename.replace(/\W+/g, "");
						self.entity = entityName;
					 	self.formJSON = formJSON;
					 	self.responsemessage = data.data.responsemessage;

					 	console.log(data);
					 	console.log(self.formJSON);
						for(var i in self.formJSON.datasets)
							self.datasets.push(i);

					 	self.entity = entityName;
					window.mura.get(
						window.mura.apiEndpoint + '/' + window.mura.siteid + '/'+ entityName + '/new/expand'
						).then(function(data) {
							self.data = data.data;
							self.renderData();	
						});
					});

			console.log("done");
			console.log(this.settings.objectid);


			//RETURN CONTENT IN: <div class="mura-object-content"></div>
		},

		initForm: function() {
			var self = this;

			var html = self.templates['form'](self.settings);
			$(self.settings.formEl).append(html);


			$(".form-submit",self.settings.formEl).click( function() {
				self.submitForm();
			});

			self.formInit=true;
		},

		submitForm: function() {
			self = this;

			$(".field-container :input").each( function() {
				self.data[ $(this).attr('name') ] = $(this).val();
			});

			window.mura.getEntity(self.entity)
				.set(
					self.data
				)
				.save()
				.then( function() {
					console.log('done and saved');
					console.log(self.responsemessage);
					$(self.settings.formEl).html( self.responsemessage );
				});
	


		}
	});
	
/*

http://mura.m7/index.cfm/_api/json/v1/default/contactform/?firstname=*bob*
http://mura.m7/index.cfm/_api/json/v1/default/contactform/?firstname=contains^bob




*/

})(window);
