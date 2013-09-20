/*
This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

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
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
component extends="mura.bean.bean" entityname='dataCollection'{

	property name='formID' required=true dataType='string';
	property name='siteID' required=true dataType='string';

	function set(data){
		if(isQuery(arguments.data)){
			arguments.data=getBean('utility').queryRowToStruct(arguments.data);
		}

		if(structKeyExists(arguments.data,'data') && isWDDX(arguments.data.data)){
			var formdata=variables.dataCollectionManager._deserializeWDDX(arguments.data.data);
			structDelete(arguments.data, data);
			structAppend(arguments.data,formdata,true);
		}

		return super.set(arguments.data);

	}

	function getValidations(){
		var content=getFormBean();
		var validations={properties={}};
		var i=1;
		var prop={};
		var rules=[];
		var message='';

		if(isJSON(content.getBody())){
			var formDef=deserializeJSON(content.getBody());
			if(isdefined('formDef.form.fieldOrder') && isdefined('formDef.form.fieldOrder')){
				for(i=1;i lte arrayLen(formDef.form.fieldOrder);i=i+1){
					prop=formDef.form.fields[formDef.form.fieldOrder[i]];
					rules=[];

					if(structkeyExists(prop,'validateMessage') && len(prop.validateMessage)){
						message=prop.validateMessage;
					}

					if(structkeyExists(prop,'validateRegex') && len(prop.validateRegex)){
						arrayAppend(rules,{'regex'=prop.validateRegex,message=message});
					}

					if(structkeyExists(prop,'isrequired') && len(prop.isrequired)){
						arrayAppend(rules,{required=true,message=message});
					}

					if(structkeyExists(prop,'validateType') && len(prop.validateType)){
						arrayAppend(rules,{dataType=prop.validateType,message=message});
					}

					if(arrayLen(rules)){
						validations.properties[prop.name]=rules;
					}

				}
			}

		}

		return validations;

	}

	function getFormBean(){
		return getBean('content').loadBy(contentID=getValue('formID'),siteID=getValue('siteID'));
	}

	function setContentID(contentID){
		variables.instance.formid=arguments.contentID;
	}

	function setObjectID(objectID){
		variables.instance.formid=arguments.objectID;
	}

	function setDataCollectionManager(dataCollectionManager){
		variables.dataCollectionManager=arguments.dataCollectionManager;
	}

	function loadBy(responseID,formID,siteID){
		set(variables.dataCollectionManager.read(responseID));
		return this;
	}

	function delete(){
		variables.dataCollectionManager.delete(getValue('responseID'));
		return this;
	}

	function save(){
		//need to make sure responseID,siteid and formID are in data
		variables.dataCollectionManager.update(getAllValues());
		return this;
	}

}