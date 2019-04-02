component
	entityname="filebrowser"
	extends="mura.bean.bean"
	displayname="Mura File Browser"
	table="m_filebrowser"
	public="true"
  {
		property name="filebrowserid" default="" required=true fieldtype="id" orderno="-100000" rendertype="textfield" displayname="filebrowserid" html=false datatype="char" length="35" nullable=false pos="0";

		private function getBaseFileDir( siteid,resourcePath ) {
			arguments.resourcePath == "" ? "User_Assets" : arguments.resourcePath;

			var pathRoot = "";
			var m=getBean('$').init(arguments.siteid);
			var currentSite = application.settingsManager.getSite(arguments.siteid);

			if(arguments.resourcePath == "Site_Files") {
				pathRoot = currentSite.getIncludePath();
			}
			else if(arguments.resourcePath == "Application_Root") {
				pathRoot = "/murawrm";
			}
			else {
				pathRoot = currentSite.getAssetDir() & '/assets';

				if(!directoryExists(expandPath(pathRoot & "/File"))){
					directoryCreate(expandPath(pathRoot & "/File"));
				}
				if(!directoryExists(expandPath(pathRoot & "/Image"))){
					directoryCreate(expandPath(pathRoot & "/Image"));
				}
			}

			return pathRoot;
		}

		private function getBaseResourcePath( siteid,resourcePath ) {
			arguments.resourcePath == "" ? "User_Assets" : arguments.resourcePath;

			var pathRoot = "";
			var m=getBean('$').init(arguments.siteid);
			var currentSite = application.settingsManager.getSite(arguments.siteid);

			if(arguments.resourcePath == "Site_Files") {
				pathRoot = currentSite.getAssetPath(complete=1);
			}
			else if(arguments.resourcePath == "Application_Root") {
				pathRoot = application.configBean.getRootPath(complete=1);
			}
			else {
				pathRoot = currentSite.getFileAssetPath(complete=1) & '/assets';
			}

			return pathRoot;
		}

		private any function checkPerms( siteid,context,resourcePath )  {
			var m=getBean('$').init(arguments.siteid);
			var permission = {message: '',success: 0};

			// context: upload,edit,write,delete,rename,addFolder,browse
			// resourcePath: User_Assets,Site_Files,Application_Root

			if ( !m.getBean('permUtility').getModulePerm('00000000000000000000000000000000000',arguments.siteid) ) {
				permission.message = "Permission Denied";
				return permission;
			}

			if(arguments.resourcePath != 'User_Assets' && !m.getCurrentUser().isSuperUser()){
				permission.message = "Permission Denied";
				return permission;
			}

/*			if(!m.validateCSRFTokens()) {
					permission.message = "Invalid CSRF tokens";
					return permission;
			}
*/
			permission.success = 1;
			return permission;
		}

		remote any function ckeditor_quick_upload( siteid,directory,formData,resourcePath ){
			/*
			{
			    "uploaded": 1,
			    "fileName": "foo.jpg",
			    "url": "/files/foo.jpg"
			}

			{
			    "uploaded": 1,
			    "fileName": "foo(2).jpg",
			    "url": "/files/foo(2).jpg",
			    "error": {
			        "message": "A file with the same name already exists. The uploaded file was renamed to \"foo(2).jpg\"."
			    }
			}

			{
			    "uploaded": 0,
			    "error": {
			        "message": "The file is too big."
			    }
			}

			*/

			return serializeJSON({
			    "uploaded": 1,
			    "fileName": "foo.jpg",
			    "url": "/files/foo.jpg"
			});
		}

		remote any function upload( siteid,directory,formData,resourcePath )  {

			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.directory = arguments.directory == "" ? "" : arguments.directory;
			arguments.directory = rereplace(arguments.directory,"\\",application.configBean.getFileDelim(),"all");

			// hasrestrictedfiles

			var permission = checkPerms(arguments.siteid,'upload',resourcePath);
			var response = { success: 0,failed: [],saved: []};

			if(!permission.success) {
				response.permission = permission;
				response.message = permission.message;
				return response;
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var allowedExtensions = m.getBean('configBean').getFMAllowedExtensions();
			var tempDir = m.globalConfig().getTempDir();

			var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
			var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");

			response.uploaded = fileUploadAll(destination=tempDir,nameconflict="unique");
			response.allowedExtensions = allowedExtensions;

			for(var i = 1; i lte ArrayLen(response.uploaded);i++ ) {
				var item = response.uploaded[i];
				var valid = false;
				if(listFindNoCase(allowedExtensions,item.serverfileext)) {
						try {
							fileMove(item.serverdirectory & m.globalConfig().getFileDelim() & item.serverfile,expandPath(filePath) & m.globalConfig().getFileDelim() & item.serverfile );
							ArrayAppend(response.saved,item);
						}
						catch( any e ) {
							ArrayAppend(e.message,item);
						}
				}
				else {
					fileDelete(item.serverdirectory & m.globalConfig().getFileDelim() & item.serverfile);
					ArrayAppend(response.failed,item);
				}
			}

			response.success = 1;
			return response;
		}

		remote any function edit( siteid,directory,filename,filter="",pageIndex=1,resourcepath )  {
			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var permission = checkPerms(arguments.siteid,'edit',resourcePath);
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = permission.message;
				return response;
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
			var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
			var path = expandpath(filePath) & application.configBean.getFileDelim() & arguments.filename;


			try {
				var fileContent = fileRead(path);
			}
			catch( any e ) {
				response['error'] = e;
				return( e );
			}

			response['content'] = fileContent;

			response.success = 1;
			return response;

		}

		remote any function update( siteid,directory,filename,filter="",resourcepath,content )  {
			arguments.siteid == "" ? "default" : arguments.siteid;

			var permission = checkPerms(arguments.siteid,'write',resourcePath);
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = permission.message;
				return response;
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
			var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
			var path = expandpath(filePath) & application.configBean.getFileDelim() & arguments.filename;

			try {
				fileWrite(path,arguments.content);
			}
			catch( any e ) {
				response['error'] = e;
				return( e );
			}

			response.success = 1;
			return response;
		}

		remote any function delete( siteid,directory,filename,filter="",pageIndex=1,resourcePath )  {
			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var permission = checkPerms(arguments.siteid,'delete',resourcePath);
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = permission.message;
				return response;
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
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

			var permission = checkPerms(arguments.siteid,'rename',resourcePath);
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = permission.message;
				return response;
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
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

			var permission = checkPerms(arguments.siteid,'addFolder',resourcePath);
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = permission.message;
				return response;
			}

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);
			var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
			var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");

			try {
				var fileContent = directorycreate(expandpath(filePath) & application.configBean.getFileDelim() & arguments.name);
			}
			catch( any e ) {
				return( e );
			}

			return true;
		}

		remote any function browse( siteid,directory,filterResults="",pageIndex=1,sortOn,sortDir,resourcePath,itemsPerPage=20 )  {

			arguments.siteid == "" ? "default" : arguments.siteid;
			arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

			var m=getBean('$').init(arguments.siteid);
			var permission = checkPerms(arguments.siteid,'browse',resourcePath);
			var response = { success: 0};

			if(!permission.success) {
				response.permission = permission;
				response.message = permission.message;
				return response;
			}

// m.siteConfig().getFileDir() ... OS file path (no siteid)
// m.siteConfig().getFileAssetPath() ... includes siteid (urls)

			var m = application.serviceFactory.getBean('m').init(arguments.siteid);

			var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
			var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");

// move to getBaseResourcePath() --> getFileAssetPath()
			var assetPath = getBaseResourcePath(arguments.siteid,arguments.resourcePath) & replace(arguments.directory,"\","/","all");

			var frow = {};

			response['items'] = [];
			response['links'] = {};
			response['folders'] = [];
			response['itemsperpage'] = arguments.itemsPerPage;

			response['directory'] = arguments.directory == "" ? "" : arguments.directory;
			response['directory'] = rereplace(response['directory'],"\\","\/","all");
			response['directory'] = rereplace(response['directory'],"$\\","");

			var rsDirectory = directoryList(expandPath(filePath),false,"query");

			response['startindex'] = 1 + response['itemsperpage'] * pageIndex - response['itemsperpage'];
			response['endindex'] = response['startindex'] + response['itemsperpage'] - 1;

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
				frow['url'] = assetPath & "/" & frow['fullname'];
				ArrayAppend(response['items'],frow,true);
			}

			var apiEndpoint=m.siteConfig().getApi(type="json", version="v1").getEndpoint();

			var baseurl=apiEndpoint & "/filebrowser/browse?directory=#esapiEncode("url",arguments.directory)#&resourcepath=#esapiEncode("url",arguments.resourcepath)#&pageIndex=";
			if(response.totalpages > 1) {
				if(response.pageindex < response.totalpages) {
					response['links']['next'] = baseurl & response.pageindex+1;
					response['links']['last'] = baseurl & response.totalpages;
				}
				if(response.pageindex > 1) {
					response['links']['first'] =baseurl & 1;
					response['links']['previous'] = baseurl & (response.pageindex-1);
				}
			}

			response.success = 1;
			return response;


		}


}
