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
		}

		return pathRoot;
	}

	private function getBaseResourcePath( siteid,resourcePath,complete=1 ) {
		arguments.resourcePath == "" ? "User_Assets" : arguments.resourcePath;

		var pathRoot = "";
		var m=getBean('$').init(arguments.siteid);
		var currentSite = application.settingsManager.getSite(arguments.siteid);

		if(arguments.resourcePath == "Site_Files") {
			pathRoot = currentSite.getAssetPath(complete=arguments.complete);
		}
		else if(arguments.resourcePath == "Application_Root") {
			pathRoot = currentSite.getRootPath(complete=arguments.complete);
		}
		else {
			if(isValid('URL', application.configBean.getAssetPath())) {
				pathRoot = application.configBean.getAssetPath() & '/assets';
			}
			else {
				pathRoot = currentSite.getFileAssetPath(complete=arguments.complete) & '/assets';
			}
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

		permission.success = 1;
		return permission;
	}


	remote any function resize( resourcePath,file,dimensions ) {
		var m=getBean('$').init(arguments.siteid);

		if(!m.validateCSRFTokens(context='resize')){
			throw(type="invalidTokens");
		}

		var permission = checkPerms(arguments.siteid,'editimage',resourcePath);
		var response = { success: 0 };

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		if(isJSON(arguments.file)) {
			arguments.file = deserializeJSON(arguments.file);
		}
		if(isJSON(arguments.dimensions)) {
			arguments.dimensions = deserializeJSON(arguments.dimensions);
		}

		response.args = arguments;

		var currentSite = application.settingsManager.getSite(arguments.siteid);
		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var tempDir = m.globalConfig().getTempDir();
		var timage = replace(createUUID(),"-","","all");
		var delim = rereplace(baseFilePath,".*\/","");
		var filePath = baseFilePath & rereplace(arguments.file.url,".*?#delim#","");
		var sourceImage = ImageNew(filePath);
		var response = {};

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		if(arguments.dimensions.aspect eq "within") {
			if(!isNumeric(arguments.dimensions.width) || !isNumeric(arguments.dimensions.height) || arguments.dimensions.width < 1 || arguments.dimensions.height < 1) {
				var rb = getResourceBundle(arguments.siteid);
				response.message = rb['filebrowser.dimensionsrequired'];
				return response;
			}
			ImageScaleToFit(sourceImage,int(arguments.dimensions.width),int(arguments.dimensions.height));
		}
		else if(arguments.dimensions.aspect eq "height") {
			if(!isNumeric(arguments.dimensions.height) || arguments.dimensions.height < 1) {
				var rb = getResourceBundle(arguments.siteid);
				response.message = rb['filebrowser.dimensionsrequired'];
				return response;
			}
			response.stuff = "HEIGHT!";
			ImageResize(sourceImage,'',int(arguments.dimensions.height),'');
		}
		else if(arguments.dimensions.aspect eq "width") {
			if(!isNumeric(arguments.dimensions.width) || arguments.dimensions.width < 1) {
				var rb = getResourceBundle(arguments.siteid);
				response.message = rb['filebrowser.dimensionsrequired'];
				return response;
			}
			response.stuff = "WIDTH!";
			ImageResize(sourceImage,int(arguments.dimensions.width),'');
		}
		else {
			if(!isNumeric(arguments.dimensions.width) || !isNumeric(arguments.dimensions.height) || arguments.dimensions.width < 1 || arguments.dimensions.height < 1) {
				var rb = getResourceBundle(arguments.siteid);
				response.message = rb['filebrowser.dimensionsrequired'];
				return response;
			}
			response.stuff = "BARF";
			ImageResize(sourceImage,int(arguments.dimensions.width),int(arguments.dimensions.height),'');
		}

		var sourceImageInfo = imageInfo(sourceImage);
		var destination = replace(filePath,".#arguments.file.ext#","-resize-#randrange(10000,99999)#.#arguments.file.ext#");

		ImageWrite(sourceImage,tempDir & timage & "." & arguments.file.ext);
		fileMove(tempDir & timage & "." & arguments.file.ext,filePath);

		response.info = imageInfo(sourceImage);
		response.success = 1;

		var info = {};
		info['filePath'] = filePath;
		m.event('fileBrowser',info).announceEvent('onAfterFileResize');

		return response;
	}

	remote any function duplicate( resourcePath,file ) {
		var m=getBean('$').init(arguments.siteid);

		if(!m.validateCSRFTokens(context='duplicate')){
			throw(type="invalidTokens");
		}

		var permission = checkPerms(arguments.siteid,'duplicate',resourcePath);
		var response = { success: 0 };

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		if(isJSON(arguments.file)) {
			arguments.file = deserializeJSON(arguments.file);
		}

		var currentSite = application.settingsManager.getSite(arguments.siteid);
		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var tempDir = m.globalConfig().getTempDir();
		var timage = replace(createUUID(),"-","","all");
		var delim = rereplace(baseFilePath,".*\/","");
		var filePath = baseFilePath & rereplace(arguments.file.url,".*?#delim#","");
		var sourceImage = ImageNew(filePath);
		var destination = replace(filePath,".#arguments.file.ext#","-copy1.#arguments.file.ext#");
		var version = 1;

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		while(fileExists(destination)) {
			version++;
			destination = replace(filePath,".#arguments.file.ext#","-copy#version#.#arguments.file.ext#");
		}

		ImageWrite(sourceImage,tempDir & timage & "." & arguments.file.ext);
		fileMove(tempDir & timage & "." & arguments.file.ext,destination);

		var info = {};
		info['filePath'] = destination;
		m.event('fileBrowser',info).announceEvent('onAfterFileDuplicate');

		response.success = 1;
		return response;
	}

	remote any function rotate( resourcePath,file,direction ) {
		var m=getBean('$').init(arguments.siteid);

		if(!m.validateCSRFTokens(context='rotate')){
			throw(type="invalidTokens");
		}

		var permission = checkPerms(arguments.siteid,'editimage',resourcePath);
		var response = { success: 0 };

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		if(isJSON(arguments.file)) {
			arguments.file = deserializeJSON(arguments.file);
		}

		var currentSite = application.settingsManager.getSite(arguments.siteid);
		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var tempDir = m.globalConfig().getTempDir();
		var timage = replace(createUUID(),"-","","all");
		var delim = rereplace(baseFilePath,".*\/","");
		var filePath = baseFilePath & rereplace(arguments.file.url,".*?#delim#","");
		var sourceImage = ImageNew(filePath);
		var response = {};
		var rotation = 90;

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		if(arguments.direction eq "counterclock") {
			rotation = -90;
		}

		var sourceImageInfo = imageInfo(sourceImage);
		ImageRotate(sourceImage,int(sourceImageInfo.width/2),int(sourceImageInfo.height/2),rotation);

		ImageWrite(sourceImage,tempDir & timage & "." & arguments.file.ext);
		fileMove(tempDir & timage & "." & arguments.file.ext,filePath);

		var info = {};
		info['filePath'] = filePath;
		m.event('fileBrowser',info).announceEvent('onAfterFileRotate');

		response.info = imageInfo(sourceImage);
		response.success = 1;
		return response;

	}

	remote any function processCrop( resourcePath,file,crop,size ) {
		var m=getBean('$').init(arguments.siteid);

		if(!m.validateCSRFTokens(context='processCrop')){
			throw(type="invalidTokens");
		}

		var permission = checkPerms(arguments.siteid,'editimage',arguments.resourcePath);

		var response = { success: 0};

		if(isJSON(arguments.file)) {
			arguments.file = deserializeJSON(arguments.file);
		}

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		var currentSite = application.settingsManager.getSite(arguments.siteid);
		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var tempDir = m.globalConfig().getTempDir();
		var timage = replace(createUUID(),"-","","all");
		var response = {};
		var delim = rereplace(baseFilePath,".*\/","");
		var filePath = baseFilePath & rereplace(arguments.file.url,".*?#delim#","");

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		if(isJSON(arguments.file)) {
			arguments.file = deserializeJSON(arguments.file);
		}
		if(isJSON(arguments.crop)) {
			arguments.crop = deserializeJSON(arguments.crop);
		}
		if(isJSON(arguments.size)) {
			arguments.size = deserializeJSON(arguments.size);
		}

		var sourceImage = ImageNew(filePath);

		ImageScaleToFit(sourceImage,size.width,size.height,"highestPerformance");
		ImageWrite(sourceImage,tempDir & timage & "." & arguments.file.ext);
		var workImage = ImageNew(tempDir & timage & "." & arguments.file.ext);
		sourceImage = ImageNew(filePath);

		var workImageInfo = imageInfo(workImage);
		var sourceImageInfo = imageInfo(sourceImage);
		var aspect = 1;

		if(workImageInfo.width != sourceImageInfo.width) {
			aspect = floor(sourceImageInfo.width/workImageInfo.width*1000)/1000;
		}
		else if(workImageInfo.height != sourceImageInfo.height) {
			aspect = floor(sourceImageInfo.height/workImageInfo.height*1000)/1000;
		}

		ImageCrop(sourceImage,arguments.crop.x*aspect,arguments.crop.y*aspect,arguments.crop.width*aspect,arguments.crop.height*aspect);
		ImageWrite(sourceImage,tempDir & timage & "." & arguments.file.ext);
		fileMove(tempDir & timage & "." & arguments.file.ext,filePath);
		workImage = ImageNew(filePath);

		response.info = imageInfo(workImage);
		response.aspect = aspect;

		var info = {};
		info['filePath'] = filePath;
		m.event('fileBrowser',info).announceEvent('onAfterFileCrop');

		response.success = 1;
		return response;
	}

	remote any function ckeditor_quick_upload( siteid,directory,formData,resourcePath ) {
		arguments.siteid == "" ? "default" : arguments.siteid;

		var m=getBean('m').init(arguments.siteid);
		var sentCSRF = arguments.ckcsrftoken;
		var cookieCSRF = cookie.ckcsrftoken;

		if(cookieCSRF != cookieCSRF) {
			return serializeJSON({
				"uploaded": 0,
				"error": {
					"message": "Not supported."
				}
			});
		}

		arguments.siteid == "" ? "default" : arguments.siteid;
		var m=getBean('m').init(arguments.siteid);

		arguments.directory = arguments.directory == "" ? "" : arguments.directory;
		arguments.directory = rereplace(arguments.directory,"\\",application.configBean.getFileDelim(),"all");

		// hasrestrictedfiles

		var permission = checkPerms(arguments.siteid,'upload',resourcePath);
		var response = { success: 0,failed: [],saved: []};

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return serializeJSON({
				"uploaded": 0,
				"error": {
					"message": "Not allowed."
				}
			});
		}

		var currentSite = application.settingsManager.getSite(arguments.siteid);
		var pathRoot = currentSite.getAssetPath() & '/assets#arguments.directory#';

		var allowedExtensions = m.getBean('configBean').getFMAllowedExtensions();
		var tempDir = m.globalConfig().getTempDir();

		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");

		//if(!isPathLegal(arguments.siteid,arguments.resourcepath,conditionalExpandPath(filePath))){
		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="Illegal file path",errorcode ="invalidParameters");
		}

		if(getBean('configBean').getCompiler()=='Adobe'){
			var item = fileUpload(tempDir,'',"MakeUnique");
		} else {
			var item = fileUpload(tempDir,'','',"Overwrite");
		}

		// fix for . in filename
		var namePostFix = replace(item.clientfile,"~","","all");
		namePostFix = rereplace(namePostFix,"\.(.[^\.]*)$","~\1");
		var dotDelimArray = listToArray(namePostFix,'~');
		var newFileName = dotDelimArray[1]  & dateTimeFormat( item.timecreated,'yyyymmddhhnnss'  ) & '.'  & dotDelimArray[arrayLen(dotDelimArray)];

		if(listFindNoCase(allowedExtensions,item.serverfileext)) {
			if(fileExists(conditionalExpandPath(filePath) & m.globalConfig().getFileDelim() & item.serverfile)) {
				fileDelete(conditionalExpandPath(filePath) & m.globalConfig().getFileDelim() & item.serverfile );
			}
			if(!directoryExists(conditionalExpandPath(filePath))){
				directoryCreate(conditionalExpandPath(filePath));
			}
			//moving and renaming file
			var safePostFix = listToArray(newFileName,".");

			if(ArrayLen(safePostFix) neq 2) {
				response.success = 0;
				return serializeJSON({
					"uploaded": 0,
					"error": {
						"message": "File must have an extension type."
					}
				});
			}

			var safeName = rereplaceNoCase(safePostFix[1],"[[:space:]]","_","ALL");
			safeName = rereplaceNoCase(safeName,"[^[:alnum:]\_\-]","","ALL") & "." & safePostFix[2];
			var newFilePath=conditionalExpandPath(filePath) & m.globalConfig().getFileDelim() & safeName;

			fileMove(item.serverdirectory & m.globalConfig().getFileDelim() & item.serverfile, newFilePath );

			var info = {};
			info['filePath'] = newFilePath;
			m.event('fileBrowser',info).announceEvent('onAfterFileUpload');
		}
		else {
			fileDelete(item.serverdirectory & m.globalConfig().getFileDelim() & item.serverfile);
			response.success = 0;
			return serializeJSON({
				"uploaded": 0,
				"error": {
					"message": "File type not allowed."
				}
			});
		}

		var fileurl=getBaseResourcePath(arguments.siteid,arguments.resourcePath) & replace(arguments.directory,"\","/","all") & m.globalConfig().getFileDelim() & newFileName;
		response.success = 1;

		if(response.success) {
			// this is the only one that counts
			return serializeJSON({
				"uploaded": 1,
				"fileName": item.serverfile,
				"url": fileurl
			});
		}
		else {
			return serializeJSON({
				"uploaded": 0,
				"error": {
					"message": "Upload failed."
				}
			});
		}
	}

	remote any function upload( siteid,directory,formData,resourcePath )  {
		arguments.siteid == "" ? "default" : arguments.siteid;
		var m=getBean('m').init(arguments.siteid);
		var info = {};

		if(!m.validateCSRFTokens(context='upload')){
			throw(type="invalidTokens");
		}

		arguments.siteid == "" ? "default" : arguments.siteid;
		arguments.directory = arguments.directory == "" ? "" : arguments.directory;
		arguments.directory = rereplace(arguments.directory,"\\",application.configBean.getFileDelim(),"all");

		// hasrestrictedfiles
		var permission = checkPerms(arguments.siteid,'upload',arguments.resourcePath);
		var response = { success: 0,failed: [],saved: []};


		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		var allowedExtensions = m.getBean('configBean').getFMAllowedExtensions();
		var tempDir = m.globalConfig().getTempDir();

		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		//response.uploaded = fileUploadAll(destination=tempDir,nameconflict="makeunique");
		response.uploaded = fileUploadAll(tempdir,'',"makeunique");

		//do not return temp directory
		if(isStruct(response.uploaded) and structKeyExists(response.uploaded,"serverdirectory")) {
			structDelete(response.uploaded,"serverdirectory");
		}

		response.allowedExtensions = allowedExtensions;

		for(var i = 1; i lte ArrayLen(response.uploaded);i++ ) {
			var item = response.uploaded[i];
			var valid = false;
			if(listFindNoCase(allowedExtensions,item.serverfileext)) {
					try {
						// fix for . in filename
						var namePostFix = replace(item.clientfile,"~","","all");
						namePostFix = rereplace(namePostFix,"\.(.[^\.]*)$","~\1");
						var safePostFix = listToArray(namePostFix,"~");

						if(ArrayLen(safePostFix) neq 2) {
							response.success = 0;
							response.message = "File must have an extension";
							return response;
						}

						var safeName = rereplaceNoCase(safePostFix[1],"[[:space:]]","_","ALL");
						safeName = rereplaceNoCase(safeName,"[^[:alnum:]\_\-]","","ALL") & "." & safePostFix[2];
						var newFilePath=conditionalExpandPath(filePath) & m.globalConfig().getFileDelim() & safeName;

						var finalFilePath = conditionalExpandPath(filePath) & m.globalConfig().getFileDelim() & safeName;
						fileMove(item.serverdirectory & m.globalConfig().getFileDelim() & item.serverfile, finalFilePath);
						ArrayAppend(response.saved,item);
						info['filePath'] = finalFilePath;
						m.event('fileBrowser',info).announceEvent('onAfterFileUpload');
					}
					catch( any e ) {
						ArrayAppend(e.message,item);
					}
			}
			else {
				fileDelete(item.serverdirectory & m.globalConfig().getFileDelim() & item.serverfile);
				item.message = "File type not allowed";
				ArrayAppend(response.failed,item);
			}
		}

		response.success = 1;
		return response;
	}

	remote any function children( directory,resourcepath ) {
		var m=getBean('$').init(arguments.siteid);

		if(!m.validateCSRFTokens(context='children')){
			throw(type="invalidTokens");
		}

		var permission = checkPerms(arguments.siteid,'children',resourcePath);
		var response = { success: 0,folders: [] };

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");

		if(!DirectoryExists(filePath)) {
			return response;
		}

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		var folders = directoryList(filePath,false,'name','','asc',"dir");

		if(ArrayLen(folders)) {
			response.folders = folders;
		}

		response.success = 1;
		return response;
	}

	remote any function move( siteid,directory,destination,filename,resourcePath )  {
		var m=getBean('$').init(arguments.siteid);
		arguments.directory = rereplace(arguments.directory,"\\",application.configBean.getFileDelim(),"all");

		if(!m.validateCSRFTokens(context='move')){
			throw(type="invalidTokens");
		}

		var permission = checkPerms(arguments.siteid,'move',resourcePath);
		var response = { success: 0,folders: [] };

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
		var destinationPath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.destination,"\.{1,}","\.","all");
		var tempDir = m.globalConfig().getTempDir();

		if(!isPathLegal(arguments.resourcepath, conditionalExpandPath(filePath),arguments.siteid)){
			throw(message="Illegal file path A",errorcode ="invalidParameters");
		}
		if(!isPathLegal(arguments.resourcepath, conditionalExpandPath(destinationPath),arguments.siteid)){
			throw(message="Illegal file path B",errorcode ="invalidParameters");
		}

		if(!DirectoryExists(filePath) || !DirectoryExists(destinationPath)) {
			response.message = "File or destination does not exist";
			return response;
		}

		// always move to the temp directory first!!!
		var origin=conditionalExpandPath(filePath) & m.globalConfig().getFileDelim() & arguments.filename;
		var finalDestination=conditionalExpandPath(destinationPath) & m.globalConfig().getFileDelim() & arguments.filename;

		fileMove(origin,tempDir & arguments.filename);
		fileMove(tempDir & filename,finalDestination);

		var info = {};
		info['filePath'] = finalDestination;
		m.event('fileBrowser',info).announceEvent('onAfterFileMove');
		return response;
	}

	remote any function edit( siteid,directory,filename,filter="",pageIndex=1,resourcepath )  {
		arguments.siteid == "" ? "default" : arguments.siteid;
		arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

		var m = application.serviceFactory.getBean('m').init(arguments.siteid);
		var permission = checkPerms(arguments.siteid,'edit',arguments.resourcePath);
		var response = { success: 0};

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
		var path = expandpath(filePath) & application.configBean.getFileDelim() & arguments.filename;

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		try {
			var fileContent = fileRead(path);
		}
		catch( any e ) {
			response['error'] = e;
			return( e );
		}

		response['content'] = fileContent;

		var info = {};
		info['filePath'] = path;
		m.event('fileBrowser',info).announceEvent('onAfterFileEdit');

		response.success = 1;
		return response;

	}

	remote any function update( siteid,directory,filename,filter="",resourcepath,content )  {
		arguments.siteid == "" ? "default" : arguments.siteid;

		var m = application.serviceFactory.getBean('m').init(arguments.siteid);

		if(!m.validateCSRFTokens(context='update')){
			throw(type="invalidTokens");
		}

		var permission = checkPerms(arguments.siteid,'write',arguments.resourcePath);
		var response = { success: 0};

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
		var path = expandpath(filePath) & application.configBean.getFileDelim() & arguments.filename;

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		try {
			fileWrite(path,arguments.content);
		}
		catch( any e ) {
			response['error'] = e;
			return( e );
		}

		var info = {};
		info['filePath'] = path;
		m.event('fileBrowser',info).announceEvent('onAfterFileUpdate');


		response.success = 1;
		return response;
	}

	remote any function delete( siteid,directory,filename,filter="",pageIndex=1,resourcePath )  {
		arguments.siteid == "" ? "default" : arguments.siteid;
		var m=getBean('m').init(arguments.siteid);
		var info = {};

		if(!m.validateCSRFTokens(context='delete')){
			throw(type="invalidTokens");
		}

		arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

		var permission = checkPerms(arguments.siteid,'delete',arguments.resourcePath);
		var response = { success: 0};

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
		var path = conditionalExpandPath(filePath) & application.configBean.getFileDelim() & arguments.filename;

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		var info = {};

		try {
			if(directoryExists(path)) {
				var list = directoryList(path,false,"query");

				if(list.recordcount) {
					response.message = "Directory is not empty.";
					throw(message=response.message);
					return response;
				}
				else {
					fileDelete(path);
					info['filePath'] = path;
					m.event('fileBrowser',info).announceEvent('onAfterFileDelete');

				}
			}
			else if(fileExists(path)) {
				info = getFileInfo ( path );
				info['filePath'] = path;
				fileDelete(path);
				m.event('fileBrowser',info).announceEvent('onAfterFileDelete');
			}

		}
		catch( customExp e ) {
			response.success = 0;
			response.message = e.message;
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

		var m = application.serviceFactory.getBean('m').init(arguments.siteid);

		if(!m.validateCSRFTokens(context='rename')){
			throw(type="invalidTokens");
		}

		var permission = checkPerms(arguments.siteid,'rename',arguments.resourcePath);
		var response = { success: 0};

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
		var ext = rereplacenocase(arguments.filename,".[^\.]*","");

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		var safeName = rereplaceNoCase(arguments.name,"[[:space:]]","_","ALL");
		safeName = rereplaceNoCase(safeName,"[^[:alnum:]\_\-]","","ALL");

		var currentFilePath = conditionalexpandpath(filePath) & application.configBean.getFileDelim() & arguments.filename;
		var success = 0;

		if(fileExists(currentFilePath)) {
			var newFilePath = conditionalexpandpath(filePath) & application.configBean.getFileDelim() & safeName & ext;

			try {
				filemove(currentFilePath,newFilePath);
				success = 1;
			}
			catch( any e ) {
				return( e );
			}
		}
		else if(directoryExists(currentFilePath)) {
			var newFilePath = expandpath(filePath) & application.configBean.getFileDelim() & safeName;

			try {
				directoryRename(currentFilePath,newFilePath);
				success = 1;
			}
			catch( any e ) {
				return( e );
			}
		}

		if(success) {
			var info = {};
			info['filePath'] = newFilePath;
			m.event('fileBrowser',info).announceEvent('onAfterFileRename');
		}

		response.success = success;
		return response;
	}

	remote any function addFolder( siteid,directory,name,filter="",pageIndex=1,resourcePath )  {
		arguments.siteid == "" ? "default" : arguments.siteid;
		arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

		var m = application.serviceFactory.getBean('m').init(arguments.siteid);

		if(!m.validateCSRFTokens(context='addfolder')){
			throw(type="invalidTokens");
		}

		var permission = checkPerms(arguments.siteid,'addFolder',arguments.resourcePath);
		var response = { success: 0};

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		var cleanName = rereplaceNoCase(arguments.name,"[[:space:]]","_","ALL");
		cleanName = rereplaceNoCase(cleanName,"[^[:alnum:]\_\-]","","ALL");

		if(!len(cleanName)) {
			throw(message="File name must contain at least one letter/number");
		}

		try {
			directorycreate(conditionalExpandPath(filePath) & application.configBean.getFileDelim() & cleanName);
		}
		catch( any e ) {
			return( e );
		}

		var info = {};
		info['filePath'] = conditionalExpandPath(filePath) & application.configBean.getFileDelim() & arguments.name;
		m.event('fileBrowser',info).announceEvent('onAfterCreateFolder');


		return true;
	}

	private any function getResourceBundle(siteid) {
		arguments.siteid == "" ? "default" : arguments.siteid;
		var m=getBean('$').init(arguments.siteid);
		var rb = application.rbFactory.getKeyStructure(session.rb,'filebrowser');

		return rb;
	}

	remote any function browse( siteid,directory,filterResults="",pageIndex=1,sortOn,sortDir,resourcePath,itemsPerPage=20,settings=0 )  {

		arguments.siteid == "" ? "default" : arguments.siteid;
		arguments.pageindex == isNumeric(arguments.pageindex) ? arguments.pageindex : 1;

		var m=getBean('$').init(arguments.siteid);
		var permission = checkPerms(arguments.siteid,'browse',arguments.resourcePath);
		var response = { success: 0,dne: 0};
		var editfilelist = "txt,html,htm,css,less,scss";
		var imagelist = "gif,jpg,jpeg,png";

		if(!permission.success) {
			response.permission = permission;
			response.message = permission.message;
			return response;
		}

		if(arguments.settings) {
			// list of allowable editable files and files displayed as "images"
			editfilelist = m.globalConfig().getValue(property='filebrowsereditlist',defaultValue=editfilelist); // settings.ini.cfm: filebrowsereditlist
			imagelist = m.globalConfig().get(property='filebrowserimagelist',defaultValue=imagelist); // settings.ini.cfm: filebrowserimagelist
			var rb = getResourceBundle(arguments.siteid);
			response.settings = {
				editfilelist: editfilelist,
				imagelist: imagelist,
				rb: rb
			};
		}

		var baseFilePath = getBaseFileDir( arguments.siteid,arguments.resourcePath );
		var expandedBaseFilePath = conditionalExpandPath(baseFilePath);
		var filePath = baseFilePath  & m.globalConfig().getFileDelim() & rereplace(arguments.directory,"\.{1,}","\.","all");
		var expandedFilePath = conditionalExpandPath(filePath);

		// directory does not exist
		if(!directoryExists(conditionalExpandPath(filePath))) {
			response['dne'] = 1;
			structDelete(cookie,'fbFolderTree');
			filePath = baseFilePath;
			return response;
		}

		if(!isPathLegal(arguments.resourcepath,conditionalExpandPath(filePath),arguments.siteid)) {
			throw(message="File path illegal");
		}

		var frow = {};

		response['items'] = [];
		response['links'] = {};
		response['folders'] = [];
		response['itemsperpage'] = arguments.itemsPerPage;

		response['directory'] = arguments.directory == "" ? "" : arguments.directory;
		response['directory'] = rereplace(response['directory'],"\\","\/","all");
		response['directory'] = rereplace(response['directory'],"$\\","");

		// move to getBaseResourcePath() --> getFileAssetPath()
		var complete = (m.siteConfig('isremote') || (isdefined('arguments.completepath') && isBoolean(arguments.completepath) && arguments.completepath));
		var preAssetPath = getBean('configBean').get('assetPath');

		if(len(preAssetPath)) {
			if(arguments.resourcePath == "Site_Files") {
				preAssetPath = preAssetPath & "/" & arguments.siteid & response['directory'];
			}
			else if(arguments.resourcePath == "Application_Root") {
				preAssetPath = response['directory'];
			}
			else {
				preAssetPath = preAssetPath & "/" & arguments.siteid & "/assets" & response['directory'];
			}
		}
		else {
			preAssetPath = getBaseResourcePath(siteid=arguments.siteid,resourcePath=arguments.resourcePath,complete=complete);
		}

		var rsDirectory = directoryList(conditionalExpandPath(filePath),false,"query");

		response['startindex'] = 1 + response['itemsperpage'] * pageIndex - response['itemsperpage'];
		response['endindex'] = response['startindex'] + response['itemsperpage'] - 1;

		if (application.configBean.getValue('fmcaseinsensitive') == 'true') {
			var sqlString = "SELECT *, UPPER(name) AS upper_name from sourceQuery";
		} else {
			var sqlString = "SELECT * from sourceQuery";
		}

		var qObj = new query();
		qObj.setName("files");
		qObj.setDBType("query");
		qObj.setAttributes(sourceQuery=rsDirectory);

		if(len(arguments.filterResults)) {
			sqlString &= " where UPPER(name) LIKE :filtername";

			qObj.addParam( name="filtername",value="%#UCase(arguments.filterResults)#%",cfsqltype="cf_sql_varchar" );
		}

		if (application.configBean.getValue('fmcaseinsensitive') == 'true') {
			sqlString &= " ORDER by type,upper_name";
		} else {
			sqlString &= " ORDER by type,name";
		}

		qObj.setSQL( sqlString );

		var rsExecute = qObj.execute();
		var rsFiles = rsExecute.getResult();
		var rsPrefix = rsExecute.getPrefix();

		queryAddColumn(rsFiles,'subfolder',[]);
		for(var i = 1;i <= rsFiles.recordcount;i++) {
			rsFiles['subfolder'][i] = response['directory'];
		}

		var rootpath= m.getBean('utility').getRequestProtocol() & "://" & m.getBean('utility').getRequestHost() & m.globalConfig('context');

		response['endindex'] = response['endindex'] > rsFiles.recordCount ? rsFiles.recordCount : response['endindex'];

		response['totalpages'] = ceiling(rsFiles.recordCount / response['itemsperpage']);
		response['totalitems'] = 1;
		response['rootpath'] = rootpath;
		response['pageindex'] = arguments.pageindex;
		response['totalitems'] = rsFiles.recordCount;
		response['pre'] = serializeJSON(rsPrefix);

		for(var x = response['startindex'];x <= response['endindex'];x++) {


			frow = {};
			frow['isfile'] = rsFiles['type'][x] == 'File' ? 1 : 0;
			frow['isfolder'] = rsFiles['type'][x] == 'Dir' ? 1 : 0;
			frow['fullname'] = rsFiles['name'][x];
			frow['size'] = int(rsFiles['size'][x]/1000);
			frow['name'] = rereplace(frow['fullname'],"\..*","");
			frow['type'] = rsFiles['type'][x];
			frow['ext'] = rereplace(frow['fullname'],".[^\.]*\.","");
			frow['isimage'] = listfind(imagelist,frow['ext']);

			frow['info'] = {};
			if(frow['isfile']) {
				frow['ext'] = rereplace(frow['fullname'],".[^\.]*\.","");
				if( frow['isimage'] ) {
				// Reading an image could fail
				try {
						var readImage = imageRead(conditionalExpandPath(filePath) & application.configBean.getFileDelim() & frow['fullname']);
						var iinfo = imageInfo(readImage);
						if( isStruct(iinfo)) {
								frow['info']['height'] = iinfo.height;
								frow['info']['width'] = iinfo.width;
							}
					} catch (any e) {
						// Do nothing; reading image has failed, no width and height info is available
					}
				}
			}

			frow['lastmodified'] = rsFiles['datelastmodified'][x];
			frow['lastmodifiedshort'] = LSDateFormat(rsFiles['datelastmodified'][x],m.getShortDateFormat());
			frow['subfolder'] = rsFiles['subfolder'][x];
			frow['url'] = preAssetPath & "/" & frow['fullname'];

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

	// mod from fileWriter.cfc
	function conditionalExpandPath(path){
		// windows
		if(structKeyExists(server,"separator") and structKeyExists(server.separator,"file") and server.separator.file == "\" ) {
			return expandPath(arguments.path);
		// else aka linux/mac/...
		} else {
			if(directoryExists(path)){
				return path;
			} else{
				var expandedPath=expandPath(arguments.path);
				if(directoryExists(expandedPath)){
					return expandedPath;
				} else {
					return arguments.path;
				}
			}
		}
	}

	function isPathLegal(resourcePath,path,siteid){
		var expandedPath = conditionalExpandPath(getBaseFileDir( arguments.siteid,arguments.resourcePath));
		var rootPath=replaceNoCase(conditionalExpandPath(getBaseFileDir(arguments.siteid,arguments.resourcePath)),"\", "/","ALL");

		if(!hasPermission(arguments.resourcePath)) {
			return false;
		}

		arguments.path=replace(conditionalExpandPath(arguments.path), "\", "/", "ALL");

		var pathcheck = len(arguments.path) >= len(expandedPath) && lcase(left(arguments.path,len(expandedPath))) == lcase(expandedPath);

		// different root than murawrm
		if(!pathcheck) {
			var realroot = rereplacenocase(arguments.path,"^\/([a-zA-Z]{1,})\/.*","\1");
			rootPath = replaceNoCase(rootPath, 'murawrm', realroot);
			pathcheck = len(arguments.path) >= len(rootPath) && lcase(left(arguments.path,len(rootPath))) == lcase(rootPath);
		}

		if(!pathcheck) {
			writeDump("Path Error");
			writeDump(arguments);
			writeDump(expandedPath);
			writeDump(rootPath);
			writeDump(pathcheck);
			writeDump(result);
			abort;
		}


		return true;
	}

	function hasPermission(resourcePath) {
		var sessionData=getSession();
		if(arguments.resourcePath != 'User_Assets' && (!isdefined('sessionData.mura.memberships') || !listFind(sessionData.mura.memberships,'S2'))){
			return false;
		}

		return true;
	}

}
