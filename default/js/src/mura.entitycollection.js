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
;(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        factory(require('Mura'));
    } else {
        // Browser globals (root is window)
        factory(root.Mura);
    }
}(this, function (Mura) {
    /**
     * Creates a new Mura.EntityCollection
     * @class {class} Mura.EntityCollection
     */
	Mura.EntityCollection=Mura.Entity.extend(
    /** @lends Mura.EntityCollection.prototype */
    {
        /**
		 * init - initiliazes instance
		 *
		 * @param  {object} properties Object containing values to set into object
		 * @return {object} Self
		 */
		init:function(properties){
			properties=properties || {};
			this.set(properties);

			var self=this;

			if(Array.isArray(self.get('items'))){
				self.set('items',self.get('items').map(function(obj){
					if(Mura.entities[obj.entityname]){
						return new Mura.entities[obj.entityname](obj);
					} else {
						return new Mura.Entity(obj);
					}
				}));
			}

			return this;
		},

        /**
		 * length - Returns length entity collection
		 *
		 * @return {number}     integer
		 */
		length:function(){
			return this.properties.items.length;
		},

		/**
		 * item - Return entity in collection at index
		 *
		 * @param  {nuymber} idx Index
		 * @return {object}     Mura.Entity
		 */
		item:function(idx){
			return this.properties.items[idx];
		},

		/**
		 * index - Returns index of item in collection
		 *
		 * @param  {object} item Entity instance
		 * @return {number}      Index of entity
		 */
		index:function(item){
			return this.properties.items.indexOf(item);
		},

		/**
		 * getAll - Returns object with of all entities and properties
		 *
		 * @return {object}
		 */
		getAll:function(){
			var self=this;
			return Mura.extend(
				{},
				self.properties,
				{
					items:this.properties.items.map(function(obj){
						return obj.getAll();
					})
				}
			);

		},

		/**
		 * each - Passes each entity in collection through function
		 *
		 * @param  {function} fn Function
		 * @return {object}  Self
		 */
		each:function(fn){
			this.properties.items.forEach( function(item,idx){
				fn.call(item,item,idx);
			});
			return this;
		},

		/**
		 * sort - Sorts collection
		 *
		 * @param  {function} fn Sorting function
		 * @return {object}   Self
		 */
		sort:function(fn){
			this.properties.items.sort(fn);
            return this;
		},

		/**
		 * filter - Returns new Mura.EntityCollection of entities in collection that pass filter
		 *
		 * @param  {function} fn Filter function
		 * @return {Mura.EntityCollection}
		 */
		filter:function(fn){
			var collection=new Mura.EntityCollection(this.properties);
			return collection.set('items',collection.get('items').filter( function(item,idx){
				return fn.call(item,item,idx);
			}));
		},

        /**
		 * map - Returns new Mura.EntityCollection of entities in objects returned from map function
		 *
		 * @param  {function} fn Filter function
		 * @return {Mura.EntityCollection}
		 */
		map:function(fn){
			var collection=new Mura.EntityCollection(this.properties);
			return collection.set('items',collection.get('items').map( function(item,idx){
				return fn.call(item,item,idx);
			}));
		},

        /**
		 * reduce - Returns value from  reduce function
		 *
		 * @param  {function} fn Reduce function
         * @param  {any} initialValue Starting accumulator value
		 * @return {accumulator}
		 */
		reduce:function(fn,initialValue){
            initialValue=initialValue||0;
			return this.properties.items.reduce(
                function(accumulator,item,idx,array){
    				return fn.call(item,accumulator,item,idx,array);
    			},
                initialValue
            );
		}
	});
}));
