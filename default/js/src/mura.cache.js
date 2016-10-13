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
     * Creates a new Mura.Cache
     * @class {class} Mura.Cache
     */
	Mura.Cache=Mura.Core.extend(
    /** @lends Mura.Cache.prototype */
    {

		/**
		 * init - Initialiazes cache
		 *
		 * @return {void}
		 */
		init:function(){
			this.cache={};
		},

        /**
         * getKey - Returns Key value associated with key Name
         *
         * @param  {string} keyName Key Name
         * @return {*}         Key Value
         */
        getKey:function(keyName){
            return Mura.hashCode(keyName);
        },

        /**
         * get - Returns the value associated with key name
         *
         * @param  {string} keyName  description
         * @param  {*} keyValue Default Value
         * @return {*}
         */
        get:function(keyName,keyValue){
            var key=this.getKey(keyName);

			if(typeof this.core[key] != 'undefined'){
				return this.core[key].keyValue;
			} else if (typeof keyValue != 'undefined') {
				this.set(keyName,keyValue,key);
				return this.core[key].keyValue;
			} else {
				return;
			}
		},

		/**
		 * set - Sets and returns key value
		 *
		 * @param  {string} keyName  Key Name
		 * @param  {*} keyValue Key Value
		 * @param  {string} key      Key
		 * @return {*}
		 */
		set:function(keyName,keyValue,key){
            key=key || this.getKey(keyName);
		    this.cache[key]={name:keyName,value:keyValue};
			return keyValue;
		},

		/**
		 * has - Returns if the key name has a value in the cache
		 *
		 * @param  {string} keyName Key Name
		 * @return {boolean}
		 */
		has:function(keyName){
			return typeof this.cache[getKey(keyName)] != 'undefined';
		},

		/**
		 * getAll - Returns object containing all key and key values
		 *
		 * @return {object}
		 */
		getAll:function(){
			return this.cache;
		},

        /**
         * purgeAll - Purges all key/value pairs from cache
         *
         * @return {object}  Self
         */
        purgeAll:function(){
            this.cache={};
			return this;
		},

        /**
         * purge - Purges specific key name from cache
         *
         * @param  {string} keyName Key Name
         * @return {object}         Self
         */
        purge:function(keyName){
            var key=this.getKey(keyName)
            if( typeof this.cache[key] != 'undefined')
            delete this.cache[key];
			return this;
		}

	});

}));
