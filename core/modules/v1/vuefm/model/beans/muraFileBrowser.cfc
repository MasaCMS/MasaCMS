component
	entityname="muraFileBrowser"
	extends="mura.bean.bean"
	displayname="Mura File Browser"
	table="m_murafilebrowser"
	public="true"
  {
		property name="filebrowserid" default="" required=true fieldtype="id" orderno="-100000" rendertype="textfield" displayname="filebrowserid" html=false datatype="char" length="35" nullable=false pos="0";

		this._resourcepath_User_Assets = application.configBean.getAssetDir() & application.configBean.getFileDelim();
		this._resourcepath_Site_Assets = application.configBean.getAssetDir() & application.configBean.getFileDelim();
		this._resourcepath_Application_Root = "./";
		this._siteid = "default";
/*
		private function getAssetPath(resourcepath) {
			var rArray = ListToArray(arguments.resourcepath,"_");
			var siteid = rArray[1];
			var path = "User_Assets";

			if(ArrayLen(rArray) > 1) {
				var path = ArrayToList(ArraySlice(rArray,2,ArrayLen(rArray));
			}

			if(!arguments.resourcepath) {
				return this._resourcepath_User_Assets & arguments.siteid &  application.configBean.getFileDelim() & "assets";;
			}
			else {
				if(path == "Site_Assets") {
					return this._resourcepath_User_Assets;
				}
				else if(path == "Application_Root") {
					return this._resourcepath_Application_Root;
				}
			}
		}
*/

		private any function checkPerms( siteid,context,mode )  {
			var permission = {};

			var $=getBean('$').init(arguments.siteid);

			permission.success = 0;

			if($.validateCSRFTokens(context='file-' & arguments.mode)) {
				permission.success = 1;
			}

			permission.success = 1;

//			arguments.$.getContentRenderer().validateCSRFTokens(context='file-' & arguments.mode)

			return permission;
		}

		remote any function upload( formData )  {

			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.directory = arguments.directory == "" ? "" : arguments.directory;
			arguments.directory = rereplace(arguments.directory,"\\",application.configBean.getFileDelim(),"all");

			var permission = checkPerms(arguments.siteid,'upload');

			if(!permission.success) {
				return permission;
			}

			var m = application.serviceFactory.getBean('m').init('default');
			var pathRoot = application.configBean.getAssetDir() & application.configBean.getFileDelim() & arguments.siteid &  application.configBean.getFileDelim() & "assets";
			var pathDir =  pathRoot & rereplace(arguments.directory,"\.{1,}","\.","all");
			var fieldName = arguments.fieldnames;

			var response = {};

			response.savedFiles = fileUploadAll(destination=pathDir,nameconflict="overwrite");
			response.path = pathDir;

			return response;
		}

		remote any function edit( siteid,directory,filename,filter="",pageIndex=1,resourcepath )  {
			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var permission = checkPerms('edit');

			if(!permission.success) {
				return permission;
			}

			var m = application.serviceFactory.getBean('m').init('default');
			var pathRoot = len(arguments.resourcepath) ? arguments.resourcepath : application.configBean.getAssetDir() & application.configBean.getFileDelim() & arguments.siteid &  application.configBean.getFileDelim() & "assets";
			var pathDir =  pathRoot & "/" & rereplace(arguments.directory,"\.{1,}","\.","all");
			var response = {};

			try {
				var fileContent = fileRead(expandpath(pathDir) & application.configBean.getFileDelim() & arguments.filename);
			}
			catch( any e ) {
				return( e );
			}

			response['content'] = fileContent;

			return response;

		}

		remote any function delete( siteid,directory,filename,filter="",pageIndex=1,resourcepath )  {
			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var permission = checkPerms('delete');

			if(!permission.success) {
				return permission;
			}

			var m = application.serviceFactory.getBean('m').init('default');
			var pathRoot = len(arguments.resourcepath) ? arguments.resourcepath : application.configBean.getAssetDir() & application.configBean.getFileDelim() & arguments.siteid &  application.configBean.getFileDelim() & "assets";
			var pathDir =  pathRoot & "/" & rereplace(arguments.directory,"\.{1,}","\.","all");
			var response = {};

			try {
				var fileContent = fileDelete(expandpath(pathDir) & application.configBean.getFileDelim() & arguments.filename);
			}
			catch( any e ) {
				return( e );
			}

			return browse(argumentCollection=arguments);
		}

		remote any function rename( siteid,directory,filename,name,filter="",pageIndex=1,resourcepath )  {
			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var permission = checkPerms('rename');

			if(!permission.success) {
				return false;
			}

			var m = application.serviceFactory.getBean('m').init('default');
			var pathRoot = len(arguments.resourcepath) ? arguments.resourcepath : application.configBean.getAssetDir() & application.configBean.getFileDelim() & arguments.siteid &  application.configBean.getFileDelim() & "assets";
			var pathDir =  pathRoot & "/" & rereplace(arguments.directory,"\.{1,}","\.","all");
			var response = {};
			var ext = rereplacenocase(arguments.filename,".[^\.]*","");


			try {
				var fileContent = filemove(expandpath(pathDir) & application.configBean.getFileDelim() & arguments.filename,expandpath(pathDir) & application.configBean.getFileDelim() & arguments.name & ext);
			}
			catch( any e ) {
				return( e );
			}

			return true;
		}


		remote any function addFolder( siteid,directory,filename,name,filter="",pageIndex=1,resourcepath )  {
			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var permission = checkPerms('addFolder');

			if(!permission.success) {
				return permission;
			}

			var m = application.serviceFactory.getBean('m').init('default');
			var pathRoot = len(arguments.resourcepath) ? arguments.resourcepath : application.configBean.getAssetDir() & application.configBean.getFileDelim() & arguments.siteid &  application.configBean.getFileDelim() & "assets";
			var pathDir =  pathRoot & "/" & rereplace(arguments.directory,"\.{1,}","\.","all");
			var response = {};
			var ext = rereplacenocase(arguments.filename,".[^\.]*","");


			try {
				var fileContent = filemove(expandpath(pathDir) & application.configBean.getFileDelim() & arguments.filename,expandpath(pathDir) & application.configBean.getFileDelim() & arguments.name & ext);
			}
			catch( any e ) {
				return( e );
			}

			return true;
		}


		remote any function browse( siteid,directory,filterResults="",pageIndex=1,resourcepath,sortOn,sortDir )  {

			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var $=getBean('$').init(arguments.siteid);

			var permission = checkPerms('browse');

			if(!permission.success) {
				return permission;
			}

			var m = application.serviceFactory.getBean('m').init('default');
			var pathRoot = this._resourcepath_User_Assets & arguments.siteid &  application.configBean.getFileDelim() & "assets";
			var pathDir =  pathRoot & "/" & rereplace(arguments.directory,"\.{1,}","\.","all");
			var browseDir = directoryList( pathDir,false,"query" );

			var response = {};
			var frow = {};

			response['items'] = [];
			response['links'] = {};
			response['folders'] = [];
			response['itemsperpage'] = 20;

			response['path'] = pathDir;
			response['directory'] = arguments.directory == "" ? "" : arguments.directory;

			response['directory'] = rereplace(response['directory'],"\\","\/","all");
			response['directory'] = rereplace(response['directory'],"$\\","");

			var linkDir = arguments.siteid & application.configBean.getFileDelim() & "assets/" & response['directory'];
			var rsDirectory = directoryList(pathDir,false,"query");
			var response['startindex'] = 1 + response['itemsperpage'] * pageIndex - response['itemsperpage'];
			var response['endindex'] = response['startindex'] + response['itemsperpage'] - 1;

			var sqlString = "SELECT * from sourceQuery";

			var qObj = new query();
			qObj.setName("files")
			qObj.setDBType("query");
			qObj.setAttributes(sourceQuery=rsDirectory);

			if(len(arguments.filterResults)) {
				sqlString &= " where name LIKE :filtername";

				qObj.addParam( name="filtername",value="%#arguments.filterResults#%",cfsqltype="cf_sql_varchar" );
			}

			sqlString &= " ORDER by type,name";


			qObj.setSQL( sqlString );

			var rsExecute = qObj.execute();
			var rsFiles = rsExecute.getResult();
			var rsPrefix = rsExecute.getPrefix();

			response['endindex'] = response['endindex'] > rsFiles.recordCount ? rsFiles.recordCount : response['endindex'];

			response['totalpages'] = ceiling(rsFiles.recordCount / response['itemsperpage']);
			response['totalitems'] = 1;
			response['pageindex'] = arguments.pageindex;
			response['totalitems'] = rsFiles.recordCount;
			response['pre'] = serializeJSON(rsPrefix);
			response['sql'] = rsPrefix.sql;


//			response['sql'] = rsExecute.getSQL();

			for(var x = response['startindex'];x <= response['endindex'];x++) {
				frow = {};
				frow['isfile'] = rsFiles['type'][x] == 'File' ? 1 : 0;
				frow['isfolder'] = rsFiles['type'][x] == 'Dir' ? 1 : 0;
				frow['fullname'] = rsFiles['name'][x];
				frow['size'] = int(rsFiles['size'][x]/1000);
				frow['name'] = rereplace(frow['fullname'],"\..*","");
				frow['type'] = rereplace(frow['fullname'],".[^\.]*\.","");
				frow['lastmodified'] = rsFiles['datelastmodified'][x];
				frow['lastmodifiedshort'] = LSDateFormat(rsFiles['datelastmodified'][x],$.getShortDateFormat());
				frow['image'] = "/" & linkDir & "/" & frow['fullname'];
				ArrayAppend(response['items'],frow,true);
			}

			if(response.totalpages > 1) {
				if(response.pageindex < response.totalpages) {
					response['links']['next'] = linkDir & "&pageIndex=" & response.pageindex+1;
					response['links']['last'] = linkDir & "&pageIndex=" & response.totalpages;
				}
				if(response.pageindex > 1) {
					response['links']['first'] = linkDir & "&pageIndex=1";
					response['links']['previous'] = linkDir & "&pageIndex=" & response.pageindex-1;
				}
			}


			return response;


		}


}
