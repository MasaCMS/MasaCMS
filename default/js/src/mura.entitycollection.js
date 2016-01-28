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
	window.mura.EntityCollection=window.mura.Entity.extend({
		init:function(properties){
			properties=properties || {};
			this.set(properties);

			var self=this;

			if(Array.isArray(self.get('items'))){
				self.set('items',self.get('items').map(function(obj){
					if(window.mura.entities[obj.entityname]){
						return new window.mura.entities[obj.entityname](obj);
					} else {
						return new window.mura.Entity(obj);
					}
				}));
			}

			return this;
		},

		item:function(idx){
			return this.properties.items[idx];
		},

		index:function(item){
			return this.properties.items.indexOf(item);
		},

		getAll:function(){
			var self=this;

			return mura.extend(
				{},
				self.properties,
				{
					items:self.map(function(obj){
						return obj.getAll();
					})
				}
			);

		},

		each:function(fn){
			this.properties.items.forEach( function(item,idx){
				fn.call(item,item,idx);
			});
			return this;
		},

		sort:function(fn){
			this.properties.items.sort(fn);
		},

		filter:function(fn){
			var collection=new window.mura.EntityCollection(this.properties);
			return collection.set('items',collection.get('items').filter( function(item,idx){
				return fn.call(item,item,idx);
			}));
		},

		map:function(fn){
			var collection=new window.mura.EntityCollection(this.properties);
			return collection.set('items',collection.get('items').map( function(item,idx){
				return fn.call(item,item,idx);
			}));
		}
	});
})(window);
