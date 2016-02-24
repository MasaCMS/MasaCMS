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

	window.mura.DM=window.mura.Core.extend({
		settings:{},
		templates:{},
		formJSON:{},
		data:{},
		columns:[],
		entity: "",
		location: "",
		templateList: ['list','table'],
		formInit: false,
		responsemessage: "",

		init:function(properties){
			
			properties || {};
			this.settings = properties;

			this.getTemplates();

		},

		setupData: function() {
			self = this;
			var formData = {};

			formData.method = "setupDatamanager";
			formData.siteid = window.mura.siteid;
			
			$.ajax({
				type: 'POST',
				url: window.mura.apiEndpoint,
				data: formData,
				dataType: 'json',
				encode: true
			}).done( function(results) {
			}).complete( function(results) {
				self.showBeanList(results.responseJSON.data);
			});
		},

		showBeanList: function( beanList ) {
			self.renderBeanList(beanList);
		},

		renderBeanList: function(beanList) {
			self = this;

			var html = self.templates['list'](beanList);
			$("#app-container").html( html );

			$("#select-bean").click( function() {
				self.entity = $("#select-bean-value").val();
				self.showTable();
			});
		},


		showTable: function() {
			self = this;
			self.getTableData();
		},

		getTableData: function( navlink ) {
			var self=this;

			window.mura.get(
				window.mura.apiEndpoint + window.mura.siteid + '/' + self.entity + '/listviewdescriptor'
			).then(function(resp) {
				self.columns = resp.data;

				if( navlink == undefined) {
					navlink = window.mura.apiEndpoint + window.mura.siteid + '/' + self.entity + '?itemsperpage=3';					
					var fields = [];
					for(var i = 0;i < self.columns.length;i++) {
						fields.push(self.columns[i].column);
					}
					navlink = navlink + "&fields=" + fields.join(",");
				}

				window.mura.get(
					navlink
				).then(function(resp) {
					self.data = resp.data;
					self.location = self.data.links.self;
					var tableData = {rows:self.data,columns:self.columns};
					self.renderTable( tableData );
				});

			});
		},

		renderTable: function( tableData ) {
			self = this;

			console.log(tableData);

			Handlebars.registerHelper('eachColRow',function(row, columns, options) {
				var ret = "";
				for(var i = 0;i < columns.length;i++) {
					ret = ret + options.fn(row[columns[i].column]);
				}
				return ret;
			});


			var html = self.templates['table'](tableData);
			$("#app-container").html( html );

			$(".data-edit").click( function() {
				self.renderCRUD( $(this).attr('data-value'),$(this).attr('data-pos'));
			});
			$(".data-nav").click( function() {
				self.getTableData( $(this).attr('data-value') );
			});
			$("#back-nav").click( function() {
				self.setupData();
			});

		},

		renderCRUD: function( itemid,pos ) {
			self = this;

			$("#app-container").empty();
			console.log('cid: ' + itemid);
			console.log("self: " + this.location);

			var muraUI=new window.mura.UI( {objectid:'C128AC64-B906-C3AF-07A4101C360DCF9B',formEl:'#app-container'} );
			muraUI.getForm( itemid,self.back,self );
		},

		back: function(ref) {
			self=ref;
			$("#app-container").empty();
			self.getTableData(self.location);
		},

		getTemplates: function() {

			var self = this;

			var temp = self.templateList.pop();

			$.ajax({
				url :  	'/' + window.mura.siteid + '/includes/display_objects/datamanager/templates/' + temp + '.hb',
				success : function( results ) {
					self.templates[temp] = Handlebars.compile(results);
					if(!self.templateList.length) {
						self.setupData();
					}
					else
						self.getTemplates();
				},
				error : function( e ) {
					console.log( e );
				}
			});
		},






	});
	
/*

http://mura.m7/index.cfm/_api/json/v1/default/contactform/?firstname=*bob*
http://mura.m7/index.cfm/_api/json/v1/default/contactform/?firstname=contains^bob




*/

})(window);
