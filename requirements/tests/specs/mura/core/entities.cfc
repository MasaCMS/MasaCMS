/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
	}

	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		variables.data={};

		for(entityName in application.objectMappings){

			if(listFindNoCase('bundleableBeans,versionedbeans',entityName)){
				continue;
			}
			variables.data={
				siteid='default',
				entities=application.objectMappings,
				$=application.serviceFactory.getBean('$').init('default'),
				entityName=entityName
			};

			describe(
				title="Testing #variables.data.entityName# entity",
				body=function(data) {
					var exists=variables.data.$.getServiceFactory().containsBean(variables.data.entityName);

					if( exists && !isObject(variables.data.$.getBean(variables.data.entityName))){
						return;
					}

					it(
						title="should exist in bean factory",
						body=function( data ){
							expect( arguments.data.exists).toBeTrue();
						},
						data={exists=exists}
					);

					if(exists){

						var bean=variables.data.$.getBean(variables.data.entityName);

						structAppend(variables.data,{
							bean=bean,
							properties=bean.getProperties(),
							synthedFunctions=bean.getSynthedFunctions(),
							columns=bean.getColumns()
						});

						if(findNoCase('orm',getMetaData(bean).fullname)){
							it(
								title="should have built in feed access",
								body=function(data){
									expect(
										(
											structKeyExists(arguments.data.bean,'getFeed')
											&& isQuery(arguments.data.bean.getFeed().getQuery())
										)
									).toBeTrue();
								},
								data={
									bean=bean
								}
							);
						}
						for(prop in variables.data.properties){
							variables.data.prop=prop;

							if(structKeyExists(variables.data.properties[data.prop],'cfc') && variables.data.$.getServiceFactory().containsBean(variables.data.properties[variables.data.prop].cfc)){

								it(
									title='#data.prop# should have cfc',
									body=function(data){
										expect(arguments.data.properties[arguments.data.prop].cfc).toBeGT('');
									},
									data={
										properties=variables.data.properties,
										prop=variables.data.prop
									}
								);

								variables.data.validFieldType=(
									structKeyExists(variables.data.properties[variables.data.prop],'fieldType')
									&& listFindNoCase('one-to-many,many-to-one,one-to-one,many-to-many',variables.data.properties[variables.data.prop].fieldtype)
								);

								it(
									title='#variables.data.prop# should have valid fieldtype',
									body=function(data){
										expect(arguments.data.validFieldType).toBeTrue();
									},
									data={validFieldType=variables.data.validFieldType}
								);

								if(variables.data.validFieldType){

									if(variables.data.properties[variables.data.prop].fieldtype == 'one-to-many'){
										var objInstance=evaluate('data.bean.get#variables.data.prop#Iterator()');
										it(
											title='#variables.data.entityName#.get#variables.data.prop#Iterator() should return valid object',
											body=function(data){
												expect(
													(right(getMetaData(arguments.data.objInstance).fullname,len('iterator'))=='iterator')
													).toBeTrue();
											},
											data={objInstance=objInstance}
										);


									} else {
										var objInstance=evaluate('variables.data.bean.get#variables.data.prop#()');

										it(
											title='#variables.data.entityName#.get#variables.data.prop#() should return valid object',
											body=function(data){
												expect(isObject(arguments.data.objInstance)).toBeTrue();
											},
											data={objInstance=objInstance}
										);
									}

								}

							} else if (
								structKeyExists(variables.data.properties[variables.data.prop],'fieldtype')
								&& listFindNoCase('one-to-many,many-to-one,one-to-one,many-to-many',variables.data.properties[variables.data.prop].fieldtype)
								) {
								it(
									title='#variables.data.prop# should have valid cfc',
									body=function(){
										expect(false).toBeTrue();
									}
								);
							}

							else if (isStruct(variables.data.columns) && structKeyExists(variables.data.columns,variables.data.prop)) {
								//writeDump(var=data.columns,abort=1);
								it(
									title='#variables.data.prop# should match schema datatype #ucase(variables.data.columns[variables.data.prop].datatype)#',
									body=function(data){
										var columnType=arguments.data.properties[arguments.data.prop].dataType;

										if(columnType=='varchar'){
											expect( listFindNoCase('string,varchar',arguments.data.columns[arguments.data.prop].datatype) ).toBeTrue();
										} else if (columnType=='text'){
											expect( (arguments.data.columns[arguments.data.prop].datatype=='text') ).toBeTrue();
										} else if (columnType=='longtext'){
											expect( (arguments.data.columns[arguments.data.prop].datatype=='longtext') ).toBeTrue();
										} else if (columnType=='char'){
											expect( (arguments.data.columns[arguments.data.prop].datatype=='char') ).toBeTrue();
										} else if ( listFindNoCase('int,integer,number',arguments.data.columns[arguments.data.prop].datatype) ){
											expect( listFindNoCase('int,integer,number',arguments.data.columns[arguments.data.prop].datatype) ).toBeTrue();
										} else if (columnType=='tinyint'){
											expect( listFindNoCase('tiny,number',arguments.data.columns[arguments.data.prop].datatype) ).toBeTrue();
										} else if (columnType=='double'){
											expect( (arguments.data.columns[arguments.data.prop].datatype=='double') ).toBeTrue();
										} else if (columnType=='float'){
											expect( (arguments.data.columns[arguments.data.prop].datatype=='float') ).toBeTrue();
										} else if (listFindNoCase('date,timestamp,datetime',arguments.data.columns[arguments.data.prop].datatype)){
											//expect( (arguments.data.columns[arguments.data.prop].datatype=='datetime') ).toBeTrue();
										}

									},
									data={
										properties=variables.data.properties,
										columns=variables.data.columns,
										prop=variables.data.prop
									}
								);
							}


						}


					}

				}
			);



		}



	}

}
