<!--- This file is part of Mura CMS.

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
--->
<cfcomponent extends="mura.cfobject" displayname="FormBuilderManager" output="false" hint="This provides form service level logic functionality">
	<cfset variables.fields		= StructNew()>

	<cffunction name="init" output="false" returntype="FormBuilderManager">
		<cfargument name="configBean" type="any" required="yes"/>

		<cfset variables.configBean = configBean />

		<cfset variables.filePath = "#expandPath("/muraWRM")##variables.configBean.getAdminDir()#/core/utilities/formbuilder/templates" />
		<cfset variables.templatePath = "/muraWRM#variables.configBean.getAdminDir()#/core/utilities/formbuilder/templates" />
		<cfset variables.fields["en_US"] = StructNew()>

		<cfreturn this/>
	</cffunction>

	<cffunction name="createJSONForm" output="false">
		<cfargument name="formID" required="false" type="uuid" default="#createUUID()#" />

		<cfset var formStruct	= StructNew() />
		<cfset var formBean		= createObject('component','formBean').init(formID=formID) />

		<cfset formStruct['datasets']	= StructNew() />
		<cfset formStruct['form']		= formBean.getAsStruct() />

		<cfreturn serializeJSON( formStruct ) />
	</cffunction>

	<cffunction name="getFormBean" output="false">
		<cfargument name="formID" required="false" type="uuid" default="#createUUID()#" />
		<cfargument name="asJSON" required="false" type="boolean" default="false" />

		<cfset var formBean		= createObject('component','formBean').init(formID=arguments.formID) />

		<cfif arguments.asJSON>
			<cfreturn formBean.getasJSON() />
		<cfelse>
			<cfreturn formBean  />
		</cfif>

	</cffunction>

	<cffunction name="getFieldBean" output="false">
		<cfargument name="formID" required="true" type="uuid" />
		<cfargument name="fieldID" required="false" type="uuid" default="#createUUID()#" />
		<cfargument name="fieldType" required="false" type="string" default="field-textfield" />
		<cfargument name="asJSON" required="false" type="boolean" default="false" />

		<cfset var fieldBean		= createObject('component','fieldBean').init(formID=arguments.formID,fieldID=arguments.fieldID,isdirty=1) />
		<cfset var fieldTypeBean	= "" />
		<cfset var mmRBF			= application.rbFactory />
		<cfset var fieldTypeName	= rereplace(arguments.fieldType,".[^\-]*-","") />
		<cfset var sessionData=getSession()>

		<cfset fieldTypeBean	= getFieldTypeBean( fieldType=fieldType,asJSON=arguments.asJSON ) />
		<cfset fieldBean.setFieldType( fieldTypeBean ) />
		<cfset fieldBean.setLabel( mmRBF.getKeyValue(sessionData.rb,'formbuilder.new') & " " & mmRBF.getKeyValue(sessionData.rb,'formbuilder.field.#fieldTypeName#') ) />

		<cfif arguments.asJSON>
			<cfreturn fieldBean.getasJSON() />
		<cfelse>
			<cfreturn fieldBean  />
		</cfif>
	</cffunction>

	<cffunction name="getDatasetBean" output="false">
		<cfargument name="datasetID" required="true" type="uuid" />
		<cfargument name="fieldID" required="false" type="uuid" default="#createUUID()#" />
		<cfargument name="asJSON" required="false" type="boolean" default="false" />
		<cfargument name="modelBean" required="false" type="any" />

		<cfset var datasetBean		= createObject('component','datasetBean').init(datasetID=arguments.datasetID,fieldID=arguments.fieldID) />
		<cfset var mBean			= "" />

		<cfif not StructKeyExists( arguments,"modelBean" ) or isSimpleValue(arguments.modelBean)>
			<cfset mBean	= createObject('component','datarecordBean').init(datasetID=arguments.datasetID) />
		<cfelse>
			<cfset mBean	= arguments.modelBean />
		</cfif>

		<cfset datasetBean.setModel( mBean ) />

		<cfif arguments.asJSON>
			<cfreturn datasetBean.getasJSON() />
		<cfelse>
			<cfreturn datasetBean  />
		</cfif>
	</cffunction>

	<cffunction name="getFieldTypeBean" output="false">
		<cfargument name="fieldTypeID" required="false" type="uuid" default="#createUUID()#" />
		<cfargument name="fieldType" required="false" type="string" default="field-textfield" />
		<cfargument name="asJSON" required="false" type="boolean" default="false" />

		<cfset var aFieldTemplate		= ListToArray(rereplace(arguments.fieldType,"[^[:alnum:]|-]","","all"),"-") />
		<cfset var displayName			= lcase( aFieldTemplate[1] ) />
		<cfset var typeName				= lcase( aFieldTemplate[2] ) />
		<cfset var fieldTypeBean		= createObject('component','fieldtypeBean').init(fieldTypeID=arguments.fieldTypeID,fieldtype=typeName,displayType=displayName) />

		<cfswitch expression="#fieldTypeBean.getFieldType()#">
			<cfcase value="dropdown,checkbox,radio,multientity" >
				<cfset fieldTypeBean.setIsData( 1 ) />
			</cfcase>
			<cfcase value="textarea,htmleditor" >
				<cfset fieldTypeBean.setIsLong( 1 ) />
			</cfcase>
		</cfswitch>

		<cfif arguments.asJSON>
			<cfreturn fieldTypeBean.getasJSON() />
		<cfelse>
			<cfreturn fieldTypeBean  />
		</cfif>
	</cffunction>

	<cffunction name="getFieldTemplate" output="false">
		<cfargument name="fieldType" required="true" type="string" />
		<cfargument name="locale" required="false" type="string" default="en" />
		<cfargument name="reload" required="false" type="boolean" default="false" />

		<cfset var fieldTemplate		= lcase( rereplace(arguments.fieldType,"[^[:alnum:]|-]","","all") & ".cfm" ) />
		<cfset var filePath				= "#variables.filePath#/#fieldTemplate#" />
		<cfset var templatePath			= "#variables.templatePath#/#fieldTemplate#" />
		<cfset var strField				= "" />
		<cfset var mmRBF				= application.rbFactory />
		<cfset var sessionData=getSession()>

		<cfif not StructKeyExists( variables.fields,arguments.locale)>
			<cfset variables.fields[arguments.locale] = StructNew()>
		</cfif>

		<cfif arguments.reload or not StructKeyExists( variables.fields[arguments.locale],fieldTemplate)>
			<cfif not fileExists( filePath )>
				<cfreturn mmRBF.getKeyValue(sessionData.rb,'formbuilder.missingfieldtemplatefile') & ": " & fieldTemplate />
			</cfif>
			<cfsavecontent variable="strField"><cfinclude template="#templatePath#"></cfsavecontent>
			<cfset variables.fields[arguments.locale][arguments.fieldType] = trim(strField) />
		</cfif>

		<cfreturn variables.fields[arguments.locale][arguments.fieldType] />
	</cffunction>

	<cffunction name="getDialog" output="false">
		<cfargument name="dialog" required="true" type="string" />
		<cfargument name="locale" required="false" type="string" default="en_US" />
		<cfargument name="reload" required="false" type="boolean" default="false" />

		<cfset var dialogTemplate		= lcase( rereplace(arguments.dialog,"[^[:alnum:]|-]","","all") & ".cfm" ) />
		<cfset var filePath				= "#variables.filePath#/#dialogTemplate#" />
		<cfset var templatePath			= "#variables.templatePath#/#dialogTemplate#" />
		<cfset var strField				= "" />
		<cfset var mmRBF				= application.rbFactory />
		<cfset var sessionData=getSession()>

		<cfif not StructKeyExists( variables.fields,arguments.locale)>
			<cfset variables.fields[arguments.locale] = StructNew()>
		</cfif>

		<cfif arguments.reload or not StructKeyExists( variables.fields[arguments.locale],dialogTemplate)>
			<cfif not fileExists( filePath )>
				<cfreturn mmRBF.getKeyValue(sessionData.rb,'formbuilder.missingfieldtemplatefile') & ": " & dialogTemplate />
			</cfif>
			<cfsavecontent variable="strField"><cfinclude template="#templatePath#"></cfsavecontent>
			<cfset variables.fields[arguments.locale][arguments.dialog] = trim(strField) />
		</cfif>

		<cfreturn variables.fields[arguments.locale][arguments.dialog] />
	</cffunction>

	<cffunction name="renderFormJSON" output="false" returntype="struct">
		<cfargument name="formJSON" required="true" type="string" />

		<cfset var formStruct		= StructNew() />
		<cfset var dataStruct		= StructNew() />
		<cfset var return			= StructNew() />
		<cfset var formBean			= "" />
		<cfset var fieldBean		= "" />
		<cfset var mmRBF			= application.rbFactory />
		<cfset var sessionData=getSession()>

		<cfif not isJSON( arguments.formJSON )>
			<cfthrow message="#mmRBF.getKeyValue(sessionData.rb,"formbuilder.mustbejson")#" >
		</cfif>

		<cfset formStruct = deserializeJSON(arguments.formJSON) />

		<cfreturn formStruct />
	</cffunction>

	<cffunction name="processDataset" output="false" returntype="struct">
		<cfargument name="$" required="true" type="any" />
		<cfargument name="dataset" required="true" type="struct" />

		<cfset var return			= StructNew() />
		<cfset var srcData			= "" />
		<cfset var mmRBF			= application.rbFactory />
		<cfset var dataArray		= ArrayNew(1) />
		<cfset var x				= "" />

		<cfset var dataOrder		= ArrayNew(1) />
		<cfset var dataRecords		= StructNew() />
		<cfset var dataBean			= "" />
		<cfset var rsData			= "" />
		<cfset var primaryKey		= "" />
		<cfset var rowid			= "" />
		<cfset var sessionData=getSession()>

		<cfif not StructKeyExists( arguments.dataset,"datasetID" )>
			<cfthrow message="#mmRBF.getKeyValue(sessionData.rb,"formbuilder.invaliddataset")#" >
		</cfif>

		<cfswitch expression="#arguments.dataset.sourcetype#">
			<cfcase value="manual,entered">
				<cfreturn arguments.dataset />
			</cfcase>
			<cfcase value="remote">
                <cfhttp url="#dataset.source#" result="srcData" >

				<cfif isJSON(srcData.filecontent)>
                    <cfset arguments.dataset = deserializeJSON(srcData.filecontent) />
                </cfif>

                <cfreturn arguments.dataset />
            </cfcase>
			<cfcase value="muraorm">

				<cfset dataBean = $.getBean( arguments.dataset.source ) />
				<cfset primaryKey = dataBean.getPrimaryKey() />
				<cfset rsData = dataBean
					.loadby( siteid = $.event('siteid'))
					.getFeed()
					.getQuery() />

				<cfloop query="#rsData#">
					<cfset rowid = rsdata[primaryKey] />
					<cfset ArrayAppend( arguments.dataset.datarecordorder,rowid )>
					<cfset arguments.dataset.datarecords[rowid] = $.getBean('utility').queryRowToStruct( rsData,currentrow )>
					<cfset arguments.dataset.datarecords[rowid]['value'] = rowid>
					<cfset arguments.dataset.datarecords[rowid]['datarecordid'] = rowid>
					<cfset arguments.dataset.datarecords[rowid]['datasetid'] = dataset.datasetid>
					<cfset arguments.dataset.datarecords[rowid]['isselected'] = 0>
				</cfloop>

				<cfreturn arguments.dataset />
			</cfcase>
			<cfcase value="object">
				<cfset arguments.dataset = createObject('component',$.siteConfig().getAssetMap() & "." & replacenocase(dataset.source,".cfc","") ).getData($,arguments.dataset) />
				<cfreturn arguments.dataset />
			</cfcase>
			<cfcase value="dsp">
				<cfset var filepath=$.siteConfig().lookupDisplayObjectFilePath(filePath=dataset.source)>
				<cfif len(filepath)>
					<cfinclude template="#filepath#">
				</cfif>
				<cfreturn arguments.dataset />
			</cfcase>
			<cfdefaultcase>
				<!---<cfdump var="#dataset#" label="no list source chosen"><cfabort>--->
				<cfreturn arguments.dataset />
			</cfdefaultcase>

		</cfswitch>

	</cffunction>

	<cffunction name="getForms" output="false">
		<cfargument name="$" required="true" type="any" />
		<cfargument name="siteid" required="true" type="any" />
		<cfargument name="excludeformid" required="false" type="string" default="" />

		<cfset var rs="">

		<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			select contentid,title from tcontent
			where type='Form'
			and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
			and active=1
			<cfif len(arguments.excludeformid)>
				and contentid != <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.excludeformid#" />
			</cfif>
			order by title
		</cfquery>

		<cfreturn rs />
	</cffunction>

	<cffunction name="renderNestedForm">
		<cfargument name="$" required="true" type="any" />
		<cfargument name="siteid" required="true" type="any" />
		<cfargument name="formid" required="true" type="any" />
		<cfargument name="prefix" required="false" type="string" default="" />

		<cfset var renderedForm = arguments.$.dspObject_Include(
						thefile='formbuilder/dsp_form.cfm',
						formid=arguments.formid,
						siteid=arguments.siteid,
						isNested=true,
						prefix=arguments.prefix
					)/>

		<cfreturn renderedForm />
	</cffunction>

	<cfscript>

	function generateFormObject($,event,contentBean,extends) {

		var content = "";
		var siteid = arguments.$.event('siteid');

		if(structKeyExists(arguments,"contentbean"))
			content = arguments.contentBean;
		else
			content = $.getBean('content');

		var objectname = rereplacenocase( content.getValue('filename'),"[^[:alnum:]]","","all" );
		var formStruct = deserializeJSON( content.getValue('body') );

		if( !structKeyExists(formStruct.form,'formattributes') || !structKeyExists(formStruct.form.formattributes,'muraormentities') || formStruct.form.formattributes.muraormentities neq 1 )
			return;

		var extendpath = "mura.formbuilder.entityBean";

		if( structKeyExists(arguments,"extends") and len(arguments.extends) ) {
			extendpath = arguments.extends;
		}
		var field = "";

		if(!directoryExists(#expandPath("/muraWRM/" & siteid)# & "/includes/model")) {
			directoryCreate(#expandPath("/muraWRM/" & siteid)# & "/includes/model");
		}
		if(!directoryExists(#expandPath("/muraWRM/" & siteid)# & "/includes/model/core")) {
			directoryCreate(#expandPath("/muraWRM/" & siteid)# & "/includes/model/core");
		}
		if(!directoryExists(#expandPath("/muraWRM/" & siteid)# & "/includes/model/core/formbuilder")) {
			directoryCreate(#expandPath("/muraWRM/" & siteid)# & "/includes/model/core/formbuilder");
		}
		if(!directoryExists(#expandPath("/muraWRM/" & siteid)# & "/includes/model/beans")) {
			directoryCreate(#expandPath("/muraWRM/" & siteid)# & "/includes/model/beans");
		}
		if(!directoryExists(#expandPath("/muraWRM/" & siteid)# & "/includes/archive")) {
			directoryCreate(#expandPath("/muraWRM/" & siteid)# & "/includes/archive");
		}

		var exists = fileExists( "#expandPath("/muraWRM/" & siteid)#/includes/model/beans/#lcase(objectname)#.cfc" );

		var param = "";
		var fieldcount = 0;

		var fieldorder = [];
		var listview = "";

		for(var i = 1;i <= ArrayLen(formStruct.form.pages);i++) {
			fieldorder.addAll(formStruct.form.pages[i]);
		}

		var fieldlist = formStruct.form.fields;

		// start CFC
		var con = 'component contentid="#content.getContentID()#"  extends="#extendpath#" table="fb_#lcase(objectname)#" entityName="#lcase(objectname)#Entity" displayName="#objectname#Entity" rendertype="form"';

		for(var i = 1;i <= ArrayLen(fieldorder);i++) {
			field = fieldlist[ fieldorder[i] ];
			if(field.fieldtype.fieldtype == 'textfield' and listLen(listview) < 5)
				listview = listAppend(listview,field.name);
		}

		if(listLen(listview) > 0) {
			con = con & ' listview="#listview#" ';
		}

		con = con & '{#chr(13)##chr(13)#// ** Not update safe! Edit extending bean in /model/beans **#chr(13)##chr(13)#';
		con = con & '	property name="#lcase(objectname)#id" fieldtype="id";#chr(13)#';

		var datasets = formStruct.datasets;

		for(var i = 1;i <= ArrayLen(fieldorder);i++) {
			field = fieldlist[ fieldorder[i] ];

			if( field.fieldtype.fieldtype != "section" && field.fieldtype.fieldtype != "textblock" && field.fieldtype.fieldtype != "matrix") {
				fieldcount++;
				param = '	property name="#field.name#"';
				param = param & ' displayname="#field.label#"';
				param = param & ' orderno="#fieldcount#"';

				if(structKeyExists(field,'isrequired') && field.isrequired == true)
					param = param & ' required="true"';

				if(structKeyExists(field,'validatetype') && len(field.validatetype) > 0) {
					param = param & ' validate="#field.validatetype#"';

					if(field.validatetype == 'regex' && structKeyExists(field,'validateregex') && len(field.validateregex) > 0)
						param = param & ' validateparams="#field.validateregex#"';
				}

				if(structKeyExists(field,'size') && isNumeric(field.size) && field.size > 0) {
					param = param & ' length="#field.size#"';
				}
				else if(field.fieldtype.fieldtype == "textfield" || field.fieldtype.fieldtype == "hidden") {
					param = param & ' length="250"';
				}

				param = param & '#getDataType($,field,datasets,objectname)#';

				con = con & "#param#;#chr(13)#";
			}
			else if( field.fieldtype.fieldtype == "matrix" ) {
				var matrix = createMatrixParams($,field,datasets,objectname,fieldcount);
				fieldcount = matrix.fieldcount;
				con = con & matrix.params;
			}
		}

		con = con & "#chr(13)##chr(13)#";

		// close CFC
		con = con & "#chr(13)#}";

		fileWrite( "#expandPath("/muraWRM/" & siteid)#/includes/model/core/formbuilder/#lcase(objectname)#Entity.cfc",con );

		if( !exists ) {
		// start update safe CFC
			var con = 'component contentid="#content.getContentID()#" extends="#siteid#.includes.model.core.formbuilder.#lcase(objectname)#Entity" table="fb_#lcase(objectname)#" entityName="#lcase(objectname)#" displayName="#objectname#" rendertype="form"';
			con = con & '{#chr(13)##chr(13)#// ** update safe ** #chr(13)##chr(13)#}';

			fileWrite( "#expandPath("/muraWRM/" & siteid)#/includes/model/beans/#lcase(objectname)#.cfc",con );
		}

		if(structKeyExists(application.objectMappings,objectname))
		try {
			StructDelete(application.objectMappings,objectname);
		}
		catch(any e) {

		}

		try {
		$.globalConfig().registerBean( "#siteid#.includes.model.beans.#lcase(objectname)#",siteid );
		$.getBean(objectname).checkSchema();
		}
		catch(any e) {
			removeFormObject( objectname,$.event('siteid') );
			rethrow;
		}

	}


	function destroyFormObject(contentBean) {

		var content = arguments.contentBean;
		var siteid = arguments.contentBean.getSiteID();

		var objectname = rereplacenocase( content.getValue('filename'),"[^[:alnum:]]","","all" );
		if(getServiceFactory().containsBean(objectname)){
			getBean('dbUtility').dropTable(table=getBean(objectname).getTable());
			getServiceFactory().removeBean(objectname);
		}
		var fullFilePath="#expandPath("/muraWRM/" & siteid)#/includes/model/beans/#lcase(objectname)#.cfc";
		if(fileExists( fullFilePath )){
			fileDelete(fullFilePath);
		}
		fullFilePath="#expandPath("/muraWRM/" & siteid)#/includes/model/core/formbuilder/#lcase(objectname)#Entity.cfc";
		if(fileExists( fullFilePath )){
			fileDelete(fullFilePath);
		}
	}
	function removeFormObject( objectname,siteid ) {

		if(getServiceFactory().containsBean(objectname)){
			try {
			getBean('dbUtility').dropTable(table=getBean(objectname).getTable());
			}
			catch(any e) {
				writeLog("Error dropping table on formBuilderManager removeFormObject: #arguments.objectname#");
			}
			getServiceFactory().removeBean(objectname);
		}

		var fullFilePath="#expandPath("/muraWRM/" & siteid)#/includes/model/beans/#lcase(objectname)#.cfc";

		if(fileExists( fullFilePath )){
			fileDelete(fullFilePath);
		}

		fullFilePath="#expandPath("/muraWRM/" & siteid)#/includes/model/core/formbuilder/#lcase(objectname)#Entity.cfc";

		if(fileExists( fullFilePath )){
			fileDelete(fullFilePath);
		}

	}

	function getDataType( $,fieldData,datasets,objectname ) {
		var str = "";
		var fieldtype = fieldData.fieldtype.fieldtype;
		var dataset = {sourcetype='manual'};
		var cfcBridgeName = "";

		if(StructKeyExists( arguments.datasets,arguments.fieldData.datasetid )) {
			dataset = arguments.datasets[arguments.fieldData.datasetid];
			cfcBridgeName = lcase("#arguments.objectname##dataset.source#");
		}
		if(StructKeyExists(arguments.fieldData,"columnsid") && StructKeyExists( arguments.datasets,arguments.fieldData.columnsid )) {
			columns = arguments.datasets[arguments.fieldData.columnsid];
		}

		switch(fieldtype) {
			case "nested":
				if( dataset.sourcetype == 'muraorm' ) {
					str = ' fieldtype="one-to-one" cfc="#dataset.source#" rendertype="#fieldtype#" fkcolumn="#lcase(fieldData.name)#id"';
					createFieldOptionCFC($,fieldData,objectname,cfcBridgeName,dataset,false,false);
				}
				else {
					str = ' datatype="varchar" length="250" rendertype="#fieldtype#"';
				}
			break;
			case "dropdown":
				if( dataset.sourcetype == 'muraorm' ) {
					str = ' fieldtype="one-to-one" cfc="#dataset.source#" rendertype="#fieldtype#" fkcolumn="#lcase(fieldData.name)#id"';
					createFieldOptionCFC($,fieldData,objectname,cfcBridgeName,dataset,false,true);
				}
				else {
					str = ' datatype="varchar" length="250" rendertype="#fieldtype#"';
				}
			break;
			case "radio":
				if( dataset.sourcetype == 'muraorm' ) {
					str = ' fieldtype="one-to-one" cfc="#dataset.source#" rendertype="#fieldtype#" fkcolumn="#lcase(fieldData.name)#id"';
					createFieldOptionCFC($,fieldData,objectname,cfcBridgeName,dataset,false,true);
				}
				else {
					str = ' datatype="varchar" length="250" rendertype="#fieldtype#"';
				}
			break;
			case "checkbox":
				if( dataset.sourcetype == 'muraorm' ) {
					str = ' fieldtype="one-to-many" cfc="#cfcBridgeName#" rendertype="#fieldtype#" source="#lcase(dataset.source)#" loadkey="#lcase(objectname)#id"';
					createFieldOptionCFC($,fieldData,objectname,cfcBridgeName,dataset,true,true);
				}
				else {
					str = ' datatype="varchar" length="250" rendertype="#fieldtype#"';
				}
			break;
			case "multiselect":
				str = ' fieldtype="one-to-many" cfc="#cfcBridgeName#" rendertype="dropdown" source="#lcase(dataset.source)#" loadkey="#lcase(objectname)#id"';
				createFieldOptionCFC($,fieldData,objectname,cfcBridgeName,dataset,true,true);
			break;
			case "textfield":
				str = ' datatype="varchar" rendertype="#fieldtype#" list=true';
			break;
			case "hidden":
				str = ' datatype="varchar" rendertype="#fieldtype#"';
			break;
			case "file":
				str = ' datatype="varchar" length="35" fieldtype="index" rendertype="#fieldtype#"';
			break;
			case "textarea":
				str = ' datatype="text" rendertype="#fieldtype#"';
			break;
		}

		return str;
	}

	function createMatrixParams( $,fieldData,datasets,objectname,fieldcount ) {

		var matrix = {};
		matrix.fieldcount = arguments.fieldcount;
		matrix.params = "";

		var questions = datasets[fieldData.datasetid];
		var param = "";
		var record = "";

		for(var i = 1;i <= ArrayLen(questions.datarecordorder);i++) {
			record = questions.datarecords[ questions.datarecordorder[i] ];

			matrix.fieldcount++;

			if(!structKeyExists(record,"name")) {
				record.name = rereplace( lcase(record.label),'[^a-z0-9]', '', 'all');
			}

			param = '	property name="#fieldData.name#_#record.name#"';
			param = param & ' displayname="#record.label#"';
			param = param & ' orderno="#matrix.fieldcount#"';
			param = param & ' datatype="varchar" length="35" rendertype="matrix" matrix="#fieldData.name#";#chr(13)#';

			matrix.params = matrix.params & param;
		}

		return matrix;
	}


	function createFieldOptionCFC( $,fieldData,parentObject,cfcBridgeName,dataset,createJoinentity=false,createDataentity=false ) {
		var objectname = fieldData.name;
		var exists = fileExists( "#expandPath("/muraWRM/" & $.event('siteid'))#/includes/model/beans/#lcase(arguments.cfcBridgeName)#.cfc" );
		var param = "";

		objectname = rereplacenocase( objectname,"[^[:alnum:]]","","all" );

		if( !exists && arguments.createJoinEntity ) {
			// start relationship CFC
			var con = 'component extends="mura.bean.beanORM" table="fb_#lcase(arguments.cfcBridgeName)#" entityName="#lcase(arguments.cfcBridgeName)#" displayName="#arguments.cfcBridgeName#" type="join" {#chr(13)##chr(13)#';

			var con = con & '	property name="#lcase(arguments.cfcBridgeName)#id" fieldtype="id";#chr(13)##chr(13)#';

			var con = con & '	property name="#lcase(arguments.parentobject)#" fieldtype="many-to-one" cfc="#arguments.parentobject#" fkcolumn="#lcase(arguments.parentobject)#id";#chr(13)#';
			var con = con & '	property name="#lcase(dataset.source)#" fieldtype="one-to-one" cfc="#dataset.source#" fkcolumn="#lcase(dataset.source)#id";#chr(13)#';

			con = con & "#chr(13)##chr(13)#";

			// close relationship CFC
			con = con & "#chr(13)#}";

			fileWrite( "#expandPath("/muraWRM/" & $.event('siteid'))#/includes/model/beans/#lcase(cfcBridgeName)#.cfc",con );

			if( structKeyExists(application.objectMappings,dataset.source))
			try {
				StructDelete(application.objectMappings,dataset.source);
			}
			catch(any e) {
			}
		}

		if(arguments.createDataentity == false) {
			$.globalConfig().registerBean( "#$.event('siteid')#.includes.model.beans.#lcase(cfcBridgeName)#",$.event('siteid') );
			$.getBean(cfcBridgeName).checkSchema();
			return;
		}

		exists = fileExists( expandPath("/muraWRM/" & $.event('siteid')) & "/includes/model/beans/#lcase(dataset.source)#.cfc" );

		// data beans are never recreated
		if(exists) {
			$.globalConfig().registerBean( "#$.event('siteid')#.includes.model.beans.#lcase(dataset.source)#",$.event('siteid') );
			$.getBean(dataset.source).checkSchema();
			return;
		}
		else if(arguments.dataset.sourcetype != "muraorm") {
			return;
		}

		// start data CFC
		var con = 'component extends="mura.formbuilder.fieldOptionBean" table="fb_#lcase(dataset.source)#" entityName="#lcase(dataset.source)#" displayName="#dataset.source#" {#chr(13)##chr(13)#';

		var con = con & '	property name="#lcase(dataset.source)#id" fieldtype="id";#chr(13)##chr(13)#';

		con = con & "#chr(13)##chr(13)#";

		// close data CFC
		con = con & "#chr(13)#}";

		fileWrite( "#expandPath("/muraWRM/" & $.event('siteid'))#/includes/model/beans/#lcase(dataset.source)#.cfc",con );

		if(structKeyExists(application.objectMappings,dataset.source))
		try {
			StructDelete(application.objectMappings,dataset.source);
		}
		catch(any e) {}

		if(arguments.createDataentity == false) {
			$.globalConfig().registerBean( "#$.event('siteid')#.includes.model.beans.#lcase(dataset.source)#",$.event('siteid') );
			$.getBean(dataset.source).checkSchema();
		}

		try {
		if( arguments.createJoinEntity ) {
			$.globalConfig().registerBean( "#$.event('siteid')#.includes.model.beans.#lcase(cfcBridgeName)#",$.event('siteid') );
			$.getBean(cfcBridgeName).checkSchema();

			}
		}
		catch(any e) {
			removeFormObject( cfcBridgeName,$.event('siteid') );
			rethrow(e);
		}

	}

	function createDatasetCFC( $,fieldData,dataset ) {
		var objectname = fieldData.name & "ExtendedData";
		var exists = fileExists( "#expandPath("/muraWRM/" & $.event('siteid'))#/includes/core/formbuilder/#lcase(objectname)#.cfc" );
		var param = "";
		var record = "";

		// start data CFC
		var con = 'component extends="mura.formbuilder.entityBean" table="fb_#lcase(objectname)#" entityName="#lcase(objectname)#" displayName="#objectname#" {#chr(13)##chr(13)#';
		var con = con & '	property name="#lcase(objectname)#id" fieldtype="id";#chr(13)##chr(13)#';
		var con = con & '	property name="#lcase(fieldData.name)#" fieldtype="many-to-one" cfc="#lcase(fieldData.name)#" fkcolumn="#lcase(fieldData.name)#id";#chr(13)#';

		return;

		for(var i = 1;i <= ArrayLen(arguments.dataset.datarecordcount);i++) {
			record = arguments.dataset.datarecords[ arguments.dataset.datarecordcount[i] ];
			var con = con & '	property name="#lcase(record)#" fieldtype="many-to-one" cfc="#lcase(fieldData.name)#" fkcolumn="#lcase(fieldData.name)#id";#chr(13)#';
		}


	}



	function getFormFromObject( siteid,formName,nested=false) {

		return getFormProperties( argumentCollection=arguments );
	}

	function getModuleBeans( siteid ) {
		var $=getBean('$').init(arguments.siteid);
		var dirList = directoryList( #expandPath("/muraWRM/" & siteid)# & "/includes/model/beans",false,'query' );
		var beanArray = [];

		for(var i = 1; i <= dirList.recordCount;i++) {
			var name = replaceNoCase( dirList.name[i],".cfc","");
			arrayAppend(beanArray,{name=name});

		}

		return beanArray;
	}


	function getFormProperties( siteid,formName,nested=false,debug=false ) {

		var $=getBean('$').init(arguments.siteid);
		var formObj = $.getBean( arguments.formname );
		var util = $.getBean('fb2Utility');
		var props = formObj.getProperties();
		var formProps = {};
		var formArray = [];
		var formFields = [];
		var val = 100000;
		var x = "";

		for(var i in props) {
			if( !listFindNoCase("errors,fromMuraCache,instanceID,isnew,saveErrors,site",i) ) {
				formProps[i] = getFieldProperties( props[i] );

				if( formProps[i].rendertype == "form" ) {
					formProps[i]['nested'] = getFieldProperties( arguments.siteid,formProps[i].cfc,true );
				}

				if(!structKeyExists(formProps[i],"orderno"))
					formProps[i]['orderno'] = val++;

				if(structKeyExists(formProps[i],"cfc")) {
					var dataBean = $.getBean(i);

					if(dataBean.getProperty('source') != "") {
						var dataBean = $.getBean(dataBean.getProperty('source'));
					}

					var options = dataBean
						.getFeed()
						.addParam(field='siteid',relationship='equals',criteria='#arguments.siteid#')
						.getIterator();

					formProps[i]['options'] = util.queryToArray( options.getQuery(),dataBean.getPrimaryKey() );
				}
			}
		}

		formArray = structSort(formProps,"numeric","asc","orderno" );

		for( var i = 1;i <= ArrayLen(formArray);i++ ) {
			ArrayAppend(formFields,formProps[formArray[i]]);
		}

		if(arguments.debug) {
			writeDump(formFields);
			abort;
		}


		return formFields;
	}

	function getFieldProperties( prop ) {

		var fieldProp = {};

		for(var x in arguments.prop ) {
			fieldProp["#lcase(x)#"] = arguments.prop[x];
		}

		if( !structKeyExists(fieldProp,"rendertype")) {
			fieldProp['rendertype'] = getRenderType( fieldProp );
		}

		return fieldProp;
	}


	function getRenderType( formProp ) {
		var retType = "";

		if( structKeyExists(formProp,"cfc") ) {
			retType = "dropdown";
		}

		return retType;

	}

























	</cfscript>

</cfcomponent>
