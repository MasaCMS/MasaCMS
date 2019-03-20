component
	entityname="filebrowser"
	extends="mura.bean.bean"
	displayname="Mura File Browser"
	table="m_filebrowser"
	public="true"
  {
		property name="filebrowserid" default="" required=true fieldtype="id" orderno="-100000" rendertype="textfield" displayname="filebrowserid" html=false datatype="char" length="35" nullable=false pos="0";

		private function getBaseResourcePath( siteid,resourcePath ) {
			arguments.resourcePath == "" ? "User_Assets" : arguments.resourcePath;

			var pathRoot = "";
			var m=getBean('$').init(arguments.siteid);
			var currentSite = application.settingsManager.getSite(arguments.siteid);

			if(arguments.resourcePath == "Site_Files") {
				pathRoot = application.configBean.getAssetPath() & '/' & currentSite.getFilePoolID();
			}
			else if(arguments.resourcePath == "Application_Root") {
				pathRoot = "/";
			}
			else {
				pathRoot = application.configBean.getAssetPath() & '/' & currentSite.getFilePoolID() & '/assets';
			}

			return pathRoot;
		}

		private function getBaseAssetPath( siteid,resourcePath ) {
			arguments.resourcePath == "" ? "User_Assets" : arguments.resourcePath;

			var pathRoot = "";
			var m=getBean('$').init(arguments.siteid);
			var currentSite = application.settingsManager.getSite(arguments.siteid);

			if(arguments.resourcePath == "Site_Files") {
				pathRoot = application.configBean.getAssetPath() & '/' & currentSite.getFilePoolID();
			}
			else if(arguments.resourcePath == "Application_Root") {
				pathRoot = "/";
			}
			else {
				pathRoot = application.configBean.getAssetPath() & '/' & currentSite.getFilePoolID() & '/assets';
			}

			return pathRoot;
		}

		private any function checkPerms( siteid,context,mode )  {
			var permission = {};

			var m=getBean('$').init(arguments.siteid);

			permission.success = 0;

			if(m.validateCSRFTokens(context='file-' & arguments.mode)) {
				permission.success = 1;
			}

			permission.success = 1;

//			arguments.$.getContentRenderer().validateCSRFTokens(context='file-' & arguments.mode)

			return permission;
		}

		remote any function upload( siteid,directory,formData,resourcePath )  {

			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.directory = arguments.directory == "" ? "" : arguments.directory;
			arguments.directory = rereplace(arguments.directory,"\\",application.configBean.getFileDelim(),"all");

			// hasrestrictedfiles

			var permission = checkPerms(arguments.siteid,'upload');
			var response = { success: 0,failed: [],saved: []};

			if(!permission.success) {
				response.permission = permission;
				response.message = "Permission failed."
				return response;
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var allowedExtensions = m.getBean('configBean').getFMAllowedExtensions();
			var tempDir = m.globalConfig().getTempDir();

			var baseFilePath = getBaseResourcePath( arguments.siteid,arguments.resourcePath );
			var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");

			response.uploaded = fileUploadAll(destination=tempDir,nameconflict="overwrite");
			response.allowedExtensions = allowedExtensions;

			for(var i = 1; i lte ArrayLen(response.uploaded);i++ ) {
				var item = response.uploaded[i];
				var valid = false;
				if(listFindNoCase(allowedExtensions,item.serverfileext)) {
						fileMove(item.serverdirectory & m.globalConfig().getFileDelim() & item.serverfile,expandPath(filePath) & m.globalConfig().getFileDelim() & item.serverfile );
						ArrayAppend(response.saved,item);
				}
				else {
					ArrayAppend(response.failed,item);
				}
			}

			response.success = 1;
			return response;
		}

		remote any function edit( siteid,directory,filename,filter="",pageIndex=1,resourcePath )  {
			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var permission = checkPerms('edit');
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = "Permission failed."
				return response;
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var pathRoot = application.configBean.getAssetDir() & application.configBean.getFileDelim() & "assets";
			var filePath =  pathRoot & "/" & rereplace(arguments.directory,"\.{1,}","\.","all");

			try {
				var fileContent = fileRead(expandpath(filePath) & application.configBean.getFileDelim() & arguments.filename);
			}
			catch( any e ) {
				return( e );
			}

			response['content'] = fileContent;

			response.success = 1;
			return response;

		}

		remote any function delete( siteid,directory,filename,filter="",pageIndex=1,resourcePath )  {
			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var permission = checkPerms('delete');
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = "Permission failed."
				throw( message = response.message,object=response);
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var baseFilePath = getBaseResourcePath( arguments.siteid,arguments.resourcePath );
			var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
			var path = expandpath(filePath) & application.configBean.getFileDelim() & arguments.filename;

			try {

				var info = getFileInfo ( path );

				if( info.type == "directory") {
					var list = directoryList( path=path,listinfo="query" );

					if(list.recordcount) {
							response.message = "Directory is not empty.";
							throw( message = response.message,object=response,type="customExp");
							return response;
					}
					else {
						fileDelete(path);
					}
				}
				else {
					fileDelete(path);
				}

			}
			catch( customExp e ) {
				throw( message = response.message,object=response,type="customExp");
				return response;
			}
			catch( any e ) {
				rethrow;
				return response;
			}

			response.success = 1;
			return response;
		}

		remote any function rename( siteid,directory,filename,name,filter="",pageIndex=1,resourcePath )  {
			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var permission = checkPerms('rename');
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = "Permission failed."
				return response;
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var baseFilePath = getBaseResourcePath( arguments.siteid,arguments.resourcePath );
			var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
			var ext = rereplacenocase(arguments.filename,".[^\.]*","");

			try {
				var fileContent = filemove(expandpath(filePath) & application.configBean.getFileDelim() & arguments.filename,expandpath(filePath) & application.configBean.getFileDelim() & arguments.name & ext);
			}
			catch( any e ) {
				return( e );
			}
			response.success = 1;
			return response;
		}

		remote any function addFolder( siteid,directory,name,filter="",pageIndex=1,resourcePath )  {
			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var permission = checkPerms('addFolder');
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = "Permission failed."
				return response;
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var baseFilePath = getBaseResourcePath( arguments.siteid,arguments.resourcePath );
			var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");

			try {
				var fileContent = directorycreate(expandpath(filePath) & application.configBean.getFileDelim() & arguments.name);
			}
			catch( any e ) {
				return( e );
			}

			return true;
		}

		remote any function browse( siteid,directory,filterResults="",pageIndex=1,sortOn,sortDir,resourcePath )  {

			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var m=getBean('$').init(arguments.siteid);
			var permission = checkPerms('browse');
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = "Permission failed."
				return response;
			}

// m.globalConfig().getFileDir() ... OS file path (no siteid)
// m.siteConfig().getFileAssetPath() ... includes siteid (urls)

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);

			var baseFilePath = getBaseResourcePath( arguments.siteid,arguments.resourcePath );
			var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
			var assetPath = baseFilePath & replace(arguments.directory,"\","/","all");

			var frow = {};

			response['items'] = [];
			response['links'] = {};
			response['folders'] = [];
			response['itemsperpage'] = 20;

			response['directory'] = arguments.directory == "" ? "" : arguments.directory;

			response['directory'] = rereplace(response['directory'],"\\","\/","all");
			response['directory'] = rereplace(response['directory'],"$\\","");

			var rsDirectory = directoryList(expandPath(filePath),false,"query");
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


			response['resourcePath'] = baseFilePath;
			response['filePath'] = expandPath(filePath);

			response['endindex'] = response['endindex'] > rsFiles.recordCount ? rsFiles.recordCount : response['endindex'];

			response['res'] = serializeJSON(rsFiles);
			response['totalpages'] = ceiling(rsFiles.recordCount / response['itemsperpage']);
			response['totalitems'] = 1;
			response['pageindex'] = arguments.pageindex;
			response['totalitems'] = rsFiles.recordCount;
			response['pre'] = serializeJSON(rsPrefix);

//			response['sql'] = rsExecute.getSQL();

			for(var x = response['startindex'];x <= response['endindex'];x++) {
				frow = {};
				frow['isfile'] = rsFiles['type'][x] == 'File' ? 1 : 0;
				frow['isfolder'] = rsFiles['type'][x] == 'Dir' ? 1 : 0;
				frow['fullname'] = rsFiles['name'][x];
				frow['size'] = int(rsFiles['size'][x]/1000);
				frow['name'] = rereplace(frow['fullname'],"\..*","");
				frow['type'] = rsFiles['type'][x];
				if(frow['isfile'])
					frow['ext'] = rereplace(frow['fullname'],".[^\.]*\.","");
				frow['lastmodified'] = rsFiles['datelastmodified'][x];
				frow['lastmodifiedshort'] = LSDateFormat(rsFiles['datelastmodified'][x],m.getShortDateFormat());
				frow['image'] = assetPath & "/" & frow['fullname'];
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

			response.success = 1;
			return response;


		}


}
