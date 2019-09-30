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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
component extends="ioc" hint="This provides the primary bean factory that all component instances are instantiated within"{

    public any function declareBean( string beanName, string dottedPath, boolean isSingleton = true, struct overrides = { }, string json='' , siteid='', fromExternalConfig=false) {
      if(isDefined('arguments.beanName') && isJSON(arguments.beanName)){
        arguments.json=arguments.beanName;
      }

      if(len(arguments.json) && isJSON(arguments.json)){
        var entity=deserializeJSON(arguments.json);

        if(!containsBean(entity.entityname) || (isDefined('application.objectMappings.#entity.entityName#.dynamic') && application.objectMappings[entity.entityName].dynamic) ){
          var newline=chr(13)&chr(10);
          var tab=chr(9);
          var extends= (isDefined('entity.historical') && isBoolean(entity.historical) && entity.historical) ? 'mura.bean.beanORMHistorical' : 'mura.bean.beanORM';
          var orderby= (isDefined('entity.orderby') && len(entity.orderby)) ? entity.orderby : '';
          var table= (isDefined('entity.table') && len(entity.table)) ? entity.table : "mura_dyn_" & entity.entityname;
          var properties= (isDefined('entity.properties') && isArray(entity.properties)) ? entity.properties : [];
          var bundleable= (isDefined('entity.bundleable') && isBoolean(entity.bundleable)) ? entity.bundleable : false;
          var hint= (isDefined('entity.hint') && len(entity.hint)) ? entity.hint : "This component was dynamically generated with JSON";
          var scaffold= (isDefined('entity.scaffold')) && isBoolean(entity.scaffold)? entity.scaffold : true;
          var displayname= (isDefined('entity.displayname') && len(entity.displayname)) ? entity.displayname : entity.entityname;
          var public= (isDefined('entity.public') && isBoolean(entity.public)) ? entity.public : false;
          var historical= (extends=='mura.bean.beanORMHistorical') ? true : false ;
          //property name="site" fieldtype="one-to-one" relatesto="site" fkcolumn="siteID";
          var sampleEntity='';
          var result='component#newline##tab#extends="#extends#"#newline##tab#entityname="#entity.entityname#"#newline##tab#displayname="#displayname#"#newline##tab#table="#table#"#newline##tab#orderby="#orderby#"#newline##tab#bundleable=#YesNoToBoolean(bundleable)##newline##tab#hint="#hint#"#newline##tab#dynamic=true#newline##tab#scaffold=#YesNoToBoolean(scaffold)##newline##tab#public=#YesNoToBoolean(public)##newline##tab#{';

          for(var p in properties){

            if(isDefined('p.name') && len(p.name)){
              result = result & newline & tab & tab & "property";
              result = result & ' name="#p.name#"';

              structDelete(p,'dynamic');

              if(isDefined('p.fieldtype')){

                if(listFindNoCase('many-to-one', p.fieldtype)
                  && isDefined('p.relatesto') && len(p.relatesto)
                  && application.Mura.getServiceFactory().containsBean(p.relatesto)
                  && (!isDefined('p.fkcolumn') || !len(p.fkcolumn))
                  ){

                  p.fkcolumn=getBean(p.relatesto).getValue('primaryKey');

                }

                if(listFindNoCase('id,many-to-one,one-to-one,one-to-many,many-to-many', p.fieldtype )){
                  structDelete(p,'datatype');
                  structDelete(p,'rendertype');
                  structDelete(p,'nullable');
                  structDelete(p,'maxlength');
                }

              }

              for(var k in p){
                if(k != 'name'){
                  if(listFindNoCase('yes,no,true,false',p[k])){
                    result = result & ' #lcase(k)#=#YesNoToBoolean(p[k])#';
                  } else {
                    result = result & ' #lcase(k)#="#p[k]#"';
                  }
                }
              }

              result = result & ";";
            }
          }

          result = result & newline & "}";


          var registeredEntity=getBean('entity').loadBy(name=entity.entityname);

          registeredEntity
    			.set('scaffold',entity.scaffold)
    			.set('dynamic',entity.dynamic)
          .set('name',entity.entityname)
    			.set('displayName',entity.displayname)
    			.set('ishistorical',historical)
          .set('json',arguments.json)
          .set('code',result)
          .save();

					if(!isDefined('arguments.fromExternalConfig') || !arguments.fromExternalConfig){
	          var rsSites=getBean('settingsManager').getList();
	          createDynamicEntity(entity.entityname,result,valueList(rsSites.siteid));
	          application.appInitialized=false;
	          getBean('clusterManager').reload();
					}
          return this;
        } else {
          throw(message="Cannot update non-dynamic bean: #entity.entityname#");
        }
      } else {
        return super.declareBean(argumentCollection=arguments);
      }
    }

    function undeclareBean(entityname,deleteSchema=false){

      var registeredEntity=getBean('entity').loadBy(name=arguments.entityname);

      if(registeredEntity.exists() && registeredEntity.getDynamic() && registeredEntity.getCurrentUser().isSuperUser()){

        var entity=getBean(arguments.entityname);

				if( entity.getDynamic() && len(entity.getTable()) && arguments.deleteSchema ){
					try {
						getBean('dbUtility').setTable(entity.getTable()).dropTable();
					} catch(any e){}
				}

        structDelete(application.objectMappings,entity.getEntityName());

        var filePath=expandPath('/muraWRM/modules/dynamic_entities/model/beans/#entity.getEntityName()#.cfc');

        if(fileExists(filePath)){
          fileDelete(filePath);
        }

        registeredEntity.delete();
        application.appInitialized=false;
        getBean('clusterManager').reload();

      } else {
        throw(message="Cannot undeclare non-dynamic bean: #arguments.entityname#");
      }

    }

    // Calls containsBean(). Added for WireBox compatibility
  	public function containsInstance( String name ) {
  	  return containsBean( name );
  	}

    // Calls containsBean(). Added for WireBox compatibility
    public function containsBean( String name ) {
      var exists=super.containsBean( name );

      if(exists){
        return true;
      } else if (super.containsBean( 'entity' )){
        var entity=getBean('entity').loadBy(name=arguments.name);

        if(entity.exists() && entity.getDynamic()){
          if(super.containsBean('settingsManager')){
            var rsSites=getBean('settingsManager').getList();
            createDynamicEntity(entity.getName(),entity.getCode(),valueList(rsSites.siteid));
          } else {
            createDynamicEntity(entity.getName(),entity.getCode());
          }

          return true;

        } else {
          return false;
        }
      } else {
        return false;
      }

    }

    function createDynamicEntity(entityName,code,siteid=''){

      createDynamicEntityModule();

      var filePath=expandPath('/muraWRM/modules/dynamic_entities/model/beans/#arguments.entityName#.cfc');

      if(fileExists(filePath)){
        fileDelete(filePath);
      }

      fileWrite(filePath,arguments.code);

      structDelete(application.objectMappings,arguments.entityName);

      if(len(arguments.siteid)){
        getBean('configBean').registerBean(
          componentPath="muraWRM.modules.dynamic_entities.model.beans.#arguments.entityname#",
          siteid=arguments.siteid,
          moduleid="00000000000000000000000000000000000",
          forceSchemaCheck=true
        );
      }

    }

    function loadDynamicEntities() {
        var qs=new Query();
        var rs=qs.execute(sql="select * from tentity where dynamic=1").getResult();
        var entity='';

        if(directoryExists(expandPath('/muraWRM/modules/dynamic_entities/model/beans'))){
          var files=DirectoryList(expandPath('/muraWRM/modules/dynamic_entities/model/beans'));
          var entityList=valueList(rs.name);
          var entityPath='';

          for(entityPath in files){
            entity=listFirst(listLast(entity,application.configBean.getFileDelim()),".");
            if(!listFindNoCase(entityList,entity)){
                fileDelete(entityPath);
            }
          }
        }

      for(var e=1;e<=rs.recordcount;e++){
          createDynamicEntity(rs.name[e],rs.code[e]);
      }
    }

    function createDynamicEntityModule(){
      if(!directoryExists(expandPath('/muraWRM/modules'))){
        directoryCreate(expandPath('/muraWRM/modules'));
      }

      if(!directoryExists(expandPath('/muraWRM/modules/dynamic_entities'))){
        directoryCreate(expandPath('/muraWRM/modules/dynamic_entities'));
      }

      if(!fileExists(expandPath('/muraWRM/modules/dynamic_entities/config.xml.cfm'))){
        fileWrite(expandPath('/muraWRM/modules/dynamic_entities/config.xml.cfm'),'<mura name="Dynamic Entities"></mura>');
      }

      if(!directoryExists(expandPath('/muraWRM/modules/dynamic_entities/model'))){
        directoryCreate(expandPath('/muraWRM/modules/dynamic_entities/model'));
      }

      if(!directoryExists(expandPath('/muraWRM/modules/dynamic_entities/model/beans'))){
        directoryCreate(expandPath('/muraWRM/modules/dynamic_entities/model/beans'));
      }
    }

	  // calls getBean(). Added for WireBox compatibility
  	public function getInstance( String name, String dsl, Any initArguments ) {
  	  return getBean( arguments.name );
  	}

  	// return the parent factory. Added for WireBox compatibility
  	public function getParent() {
  	  return variables.parent;
  	}

    public function removeBean(beanName){
        structDelete(variables.beanInfo,arguments.beanName);
        structDelete(application.objectMappings,arguments.beanName);
        return this;
    }

  	public function shutdown() {
  	  // shutdown parent bean factory

  	  if ( isObject( variables.parent ) AND structKeyExists( variables.parent, "shutdown" ) ) {
  	    variables.parent.shutdown();
  	  }

  	  // At the moment this does nothing else. This method is here for WireBox compatibility for dealing with WireBox's scope storage.
	}

  function YesNoToBoolean(value){
    if(listFindNoCase("yes,true",arguments.value)){
      return true;
    } else{
      return false;
    }
  }
}
