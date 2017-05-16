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

		describe("Testing Entity Schema Creation and Persistence", function() {
			application.serviceFactory.getBean('configBean').registerModelDir(dir="/muraWRM/core/tests/resources/model",siteid="default");

			var $=application.serviceFactory.getBean('$').init('default');
			var ioc=$.getServiceFactory();

			it(
				title="Widget should exist in bean factory",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=ioc.containsBean('testWidget') }
			);

			it(
				title="Widget should not be singleton",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=ioc.isSingleton('testWidget')  }
			);

			it(
				title="Option should exist in bean factory",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=ioc.containsBean('testWidget') }
			);

			it(
				title="Option should not be singleton",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=ioc.isSingleton('optionWidget')  }
			);

			it(
				title="Service should be singleton",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=ioc.isSingleton('testService')  }
			);

			it(
				title="Service should be able to call method",
				body=function( data ){
					expect( arguments.data.value).toBe('hello');
				},
				data={value=$.getBean('testService').sayHello()   }
			);

			var widget=$.getBean('testWidget');
			var option=$.getBean('testOption');

			widget.checkSchema();
			widget.validate();

			it(
				title="Widget should have errors",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=widget.hasErrors()   }
			);

			it(
				title="Widget 'Name' should have error",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.getErrors(), "name") }
			);

			it(
				title="Widget 'Name' should not have error",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=StructKeyExists(widget.setName('Example Widget').validate().getErrors(),'name') }
			);

			it(
				title="Widget 'Email' should have error",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.getErrors(), "email") }
			);

			it(
				title="Widget 'Email' should not have error",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=StructKeyExists(widget.setEmail('example@example.com').validate().getErrors(),'email') }
			);

			it(
				title="Widget 'Description' should have error",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.getErrors(), "description") }
			);

			it(
				title="Widget 'Description' should not have error",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=StructKeyExists(widget.setDescription('This is my widget').validate().getErrors(),'description') }
			);

			it(
				title="Widget 'intVar' should have error",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.getErrors(), "intVar") }
			);

			it(
				title="Widget 'intVar' should still have error with invalid datatype",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.setIntVar('This is my int Var').validate().getErrors(), "intVar") }
			);

			it(
				title="Widget 'intVar' should not have error",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=StructKeyExists(widget.setIntVar(1).validate().getErrors(), "intVar") }
			);

			it(
				title="Widget 'smallIntVar' should have error",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.getErrors(), "smallIntVar") }
			);

			it(
				title="Widget 'smallIntVar' should still have error with invalid datatype",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.setSmallIntVar('This is my small int Var').validate().getErrors(), "smallIntVar") }
			);

			it(
				title="Widget 'smallIntVar' should not have error",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=StructKeyExists(widget.setSmallIntVar(1).validate().getErrors(), "smallIntVar") }
			);

			it(
				title="Widget 'floatVar' should have error",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.getErrors(), "floatVar") }
			);

			it(
				title="Widget 'floatVar' should still have error with invalid datatype",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.setfloatVar('This is my float Var').validate().getErrors(), "floatVar") }
			);

			it(
				title="Widget 'floatVar' should not have error",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=StructKeyExists(widget.setfloatVar(1).validate().getErrors(), "floatVar") }
			);

			it(
				title="Widget 'doubleVar' should have error",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.getErrors(), "doubleVar") }
			);

			it(
				title="Widget 'doubleVar' should still have error with invalid datatype",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.setDoubleVar('This is my double Var').validate().getErrors(), "doubleVar") }
			);

			it(
				title="Widget 'doubleVar' should not have error",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=StructKeyExists(widget.setDoubleVar(1).validate().getErrors(), "doubleVar") }
			);

			it(
				title="Widget 'dateVar' should have error",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.getErrors(), "dateVar") }
			);

			it(
				title="Widget 'dateVar' should still have error with invalid datatype",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=StructKeyExists(widget.setDateVar('This is my date Var').validate().getErrors(), "dateVar") }
			);

			it(
				title="Widget 'dateVar' should not have error",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=StructKeyExists(widget.setDateVar(now()).validate().getErrors(), "dateVar") }
			);

			it(
				title="Widget should not have errors",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=widget.validate().hasErrors() }
			);

			option.checkSchema();

			widget.addOption(option);

			it(
				title="Widget should see errors in invalid option",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value=widget.validate().hasErrors() }
			);

			option.set({
					name="My Option",
					description="This is my description"
			});

			it(
				title="Widget should not have errors",
				body=function( data ){
					expect( arguments.data.value).toBeFalse();
				},
				data={value=widget.validate().hasErrors()  }
			);

			widget.save();

			it(
				title="Widget should now exist",
				body=function( data ){
					expect( arguments.data.value).toBeTrue();
				},
				data={value= widget.exists()  }
			);


			it(
				title="Widget should be able to access it's saved option",
				body=function( data ){
					expect( arguments.data.value).toBe(1);
				},
				data={value= widget.getOptionQuery().recordcount  }
			);

			it(
				title="Widget should be able to accessed from option option",
				body=function( data ){
					expect( arguments.data.value).toBe('Example Widget');
				},
				data={value= widget.getOptionIterator().next().getWidget().getName()}
			);

			widget.delete();

			it(
				title="Deleted Widget should not have any saved options",
				body=function( data ){
					expect( arguments.data.value).toBe(0);
				},
				data={value= widget.getOptionQuery().recordcount  }
			);

			//queryExecute("drop table #widget.getTable()#");
			//queryExecute("drop table #option.getTable()#");


			});

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
										} else if ( listFindNoCase('int,smallint,integer,number',arguments.data.columns[arguments.data.prop].datatype) ){
											expect( listFindNoCase('int,smallint,integer,number',arguments.data.columns[arguments.data.prop].datatype) ).toBeTrue();
										} else if (columnType=='tinyint'){
											expect( listFindNoCase('tinyint,number',arguments.data.columns[arguments.data.prop].datatype) ).toBeTrue();
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
