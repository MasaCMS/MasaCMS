<!---
 ### CKFinder : Configuration File - Basic Instructions

 In a generic usage case, the following tasks must be done to configure
 CKFinder:
   1. Check the baseUrl and baseDir variables.
   2. If available, paste your license key in the "licenseKey" setting.
   3. Create the CheckAuthentication() function that enables CKFinder for authenticated users.

 Other settings may be left with their default values, or used to control
 advanced features of CKFinder.
--->

<cfscript>
config = structNew();
currentUser=application.usermanager.read(session.mura.userID);
// This function must check the user session to be sure that he/she is
// authorized to upload and access files in the File Browser. '
function CheckAuthentication()
{
  
  if (isDefined('session.siteid') and application.permUtility.getModulePerm("00000000000000000000000000000000000",session.siteid)) {
    return true;
  } else {
    return false;
  }
}

config.licenseName	= 'Mura CMS';
config.licenseKey = 'VJ42-3FHF-3FVT-9FH2-TU71-G6D1-XDXF';

/* To make it easy to configure CKFinder, the config.baseUrl and config.baseDir can be used.
 * Those are helper variables used later in this config file.
 *
 * config.baseUrl : the base path used to build the final URL for the resources handled
 * in CKFinder. If empty, the default value (/userfiles/) is used.
 *
 * Examples:
 *   config.baseUrl = 'http://example.com/ckfinder/files/';
 *   config.baseUrl = '/userfiles/';
 */

currentSite=application.settingsManager.getSite(session.siteid);


config.defaultAlledExtensions='7z,aiff,asf,avi,bmp,csv,doc,docx,fla,flv,gif,gz,gzip,ics,jpeg,jpg,mid,mov,mp3,mp4,mpc,mpeg,mpg,ods,odt,pdf,png,ppt,pptx,ppsx,pxd,qt,ram,rar,rm,rmi,rmvb,rtf,sdc,sitd,swf,sxc,sxw,tar,tgz,tif,tiff,txt,vsd,wav,wma,wmv,xls,xlsx,zip,m4v,less';

//ATTENTION: The trailing slash is required.
config.baseUrl = application.configBean.getAssetPath() & '/' & currentSite.getFilePoolID() & '/assets/';
config.baseDir = "#application.configBean.getAssetDir()##application.configBean.getFileDelim()##currentSite.getFilePoolID()##application.configBean.getFileDelim()#assets/";
/*
 * Thumbnails : thumbnails settings. All thumbnails will end up in the same
 * directory, no matter the resource type.
 */
config.thumbnails = structNew();
config.thumbnails.url = config.baseUrl & 'Thumbs';
config.thumbnails.baseDir = config.baseDir & 'Thumbs';
config.thumbnails.enabled = true;
config.thumbnails.directAccess = true;
config.thumbnails.maxWidth = 100;
config.thumbnails.maxHeight = 100;
config.thumbnails.quality = 80;
config.thumbnailDelay = 100;

/*
 * set the maximum size of uploaded images
 * if uploaded image is larger, it gets scaled down
 * Set to 0 to disable this feature
 */
config.images.maxWidth = 3000;
config.images.maxHeight = 3000;
config.images.quality = 80;

/*
 * config.roleSessionVar : the session variable name that CKFinder must use to retrieve
 * the "role" of the current user. The "role", can be used in the "AccessControl"
 * settings (bellow in this page).
 *
 * Note: to use session variables, session management must be enabled in Application.cfc.
 * In "core/connector/cfm" there is another Application.cfc file.
 * Assign the correct name of your application there.
 */
config.roleSessionVar = 'CKFinder_UserRole';

/*
 * config.accessControl : used to restrict access or features to specific folders.
 *
 * Many "config.accessControl" entries can be added. All attributes are optional.
 * Subfolders inherit their default settings from their parents' definitions.
 *
 *   - The "role" attribute accepts the special '*' value, which means
 *     "everybody".
 *   - The "resourceType" attribute accepts the special value '*', which
 *     means "all resource types".
 */
config.accessControl = arrayNew(1);

config.accessControl[1] = structNew();
config.accessControl[1].role = '*';
config.accessControl[1].resourceType = '*';
config.accessControl[1].folder = '/';
config.accessControl[1].folderView = true;
config.accessControl[1].folderCreate = true;
config.accessControl[1].folderRename = true;
config.accessControl[1].folderDelete = true;
config.accessControl[1].fileView = true;
config.accessControl[1].fileUpload = true;
config.accessControl[1].fileRename = true;
config.accessControl[1].fileDelete = true;

config.accessControl[2] = structNew();
config.accessControl[2].role = '*';
config.accessControl[2].resourceType = 'Files';
config.accessControl[2].folder = '/';
config.accessControl[2].folderView = true;
config.accessControl[2].folderCreate = true;
config.accessControl[2].folderRename = true;
config.accessControl[2].folderDelete = true;
config.accessControl[2].fileView = true;
config.accessControl[2].fileUpload = true;
config.accessControl[2].fileRename = true;
config.accessControl[2].fileDelete = true;

/*
 * For example, if you want to restrict the upload, rename or delete of files in
 * the "Logos" folder of the resource type "Images", you may uncomment the
 * following definition, leaving the above one:
 *
 * config.accessControl[3] = structNew();
 * config.accessControl[3].role = '*';
 * config.accessControl[3].resourceType = 'Images';
 * config.accessControl[3].folder = '/Logos';
 * config.accessControl[3].fileUpload = false;
 * config.accessControl[3].fileRename = false;
 * config.accessControl[3].fileDelete = false;
 *
 * ResourceType : defines the "resource types" handled in CKFinder. A resource
 * type is nothing more than a way to group files under different paths, each one
 * having different configuration settings.
 *
 * Each resource type name must be unique.
 *
 * When loading CKFinder, the "type" querystring parameter can be used to display
 * a specific type only. If "type" is omitted in the URL, the
 * "DefaultResourceTypes" settings is used (may contain the resource type names
 * separated by a comma). If left empty, all types are loaded.
 *
 * maxSize is defined in bytes, but shorthand notation may be also used.
 * Available options are: G, M, K (case insensitive).
 * 1M equals 1048576 bytes (one Megabyte), 1K equals 1024 bytes (one Kilobyte), 1G equals one Gigabyte.
 * Example:
 *   config.resourceType[1].maxSize = "2M";
 */
config.defaultResourceTypes = '';

config.resourceType = arrayNew(1);

config.resourceType[1] = structNew();
config.resourceType[1].name = 'Files';
config.resourceType[1].url = config.baseUrl & 'File';
config.resourceType[1].directory = config.baseDir & 'File';
config.resourceType[1].maxSize = 0;
config.resourceType[1].allowedExtensions = config.defaultAlledExtensions;
config.resourceType[1].deniedExtensions = '';
application.serviceFactory.getBean("fileWriter").touchDir(config.resourceType[1].directory);

config.resourceType[2] = structNew();
config.resourceType[2].name = 'Images';
config.resourceType[2].url = config.baseUrl & 'Image';
config.resourceType[2].directory = config.baseDir & 'Image';
config.resourceType[2].maxSize = 0;
config.resourceType[2].allowedExtensions = 'bmp,gif,jpeg,jpg,png';
config.resourceType[2].deniedExtensions = '';
application.serviceFactory.getBean("fileWriter").touchDir(config.resourceType[2].directory);

config.resourceType[3] = structNew();
config.resourceType[3].name = 'Flash';
config.resourceType[3].url = config.baseUrl & 'Flash';
config.resourceType[3].directory = config.baseDir & 'Flash';
config.resourceType[3].maxSize = 0;
config.resourceType[3].allowedExtensions = 'swf,flv';
config.resourceType[3].deniedExtensions = '';
application.serviceFactory.getBean("fileWriter").touchDir(config.resourceType[3].directory);


if (isdefined("url.type")){
	if(currentUser.getS2() && (!isBoolean(application.configBean.getValue('fmShowApplicationRoot')) || application.configBean.getValue('fmShowApplicationRoot'))){
	  config.resourceType[4] = structNew();
	  config.resourceType[4].name = 'Application_Root';
	  config.resourceType[4].url =  application.configBean.getContext();
	  config.resourceType[4].directory =  application.configBean.getWebRoot();
	  config.resourceType[4].maxSize = 0;
	  config.resourceType[4].allowedExtensions = '';
	  config.resourceType[4].deniedExtensions = '';
	}
	
	if (not isdefined('application.CKFinderResources')){
	  application.CKFinderResources=arrayNew(1);
	  rsSites=application.settingsManager.getList();
	  
	  for (i=1; i lte rsSites.recordcount; i=(i+1)){
	    temp = structNew();
	    temp.name = '#rsSites.siteID[i]#_User_Assets';
	    temp.url =  application.configBean.getAssetPath() & '/' & rsSites.siteID[i] & '/assets/';
	    temp.directory ="#application.configBean.getAssetDir()##application.configBean.getFileDelim()##rsSites.siteID[i]##application.configBean.getFileDelim()#assets/";
	    temp.maxSize = 0;
	    if(application.configBean.getValue('fmAllowedExtensions') eq ''){
	      temp.allowedExtensions = config.defaultAlledExtensions;
	    } else {
	      temp.allowedExtensions = application.configBean.getValue('fmAllowedExtensions');    
	    }
	    temp.deniedExtensions = '';
	    
	    arrayAppend(application.CKFinderResources,temp);
	    
	    if(!isBoolean(application.configBean.getValue('fmShowSiteFiles')) || application.configBean.getValue('fmShowSiteFiles')){
	      temp = structNew();
	      temp.name = '#rsSites.siteID[i]#_Site_Files';
	      temp.url =  application.configBean.getContext() & '/' & rsSites.siteID[i] & '/' ;
	      temp.directory =  application.configBean.getWebRoot() & '/' & rsSites.siteID[i] & '/';
	      temp.maxSize = 0;
	      temp.allowedExtensions = '';
	      temp.deniedExtensions = '';
	      arrayAppend(application.CKFinderResources,temp);
	    }
	    
	  }

	}


	config.resourceType.addAll(application.CKFinderResources);
}
/*
 Due to security issues with Apache modules, it is recommended to leave the
 following setting enabled.

 How does it work? Suppose the following:

  - If "cfm" is on the denied extensions list, a file named foo.cfm cannot be
    uploaded.
  - If "rar" (or any other) extension is allowed, one can upload a file named
    foo.rar.
  - The file foo.cfm.rar has "rar" extension so, in theory, it can be also
    uploaded.

In some conditions Apache can treat the foo.cfm.rar file just like any ColdFusion
script and execute it.

If checkDoubleExtension is enabled, each part of the file name after a dot is
checked, not only the last part. In this way, uploading foo.cfm.rar would be
denied, because "cfm" is on the denied extensions list.
*/

config.checkDoubleExtension = true ;

/*
 * Perform additional checks for image files
 * if set to true, validate image size
 */
config.secureImageUploads = true ;

/*
Indicates that the file size (maxSize) for images must be checked only
after scaling them. Otherwise, it is checked right after uploading.
*/
config.checkSizeAfterScaling = true ;

/* For security, HTML is allowed in the first Kb of data for files having the
 * following extensions only.
 */
config.htmlExtensions = 'html,htm,xml,js,cfm,cfc' ;

/*
Folders to not display in CKFinder, no matter their location.
No paths are accepted, only the folder name.
The * and ? wildcards are accepted.
*/
config.hideFolders = arrayNew(1);
config.hideFolders[1] = ".svn" ;
config.hideFolders[2] = "CVS" ;

/*
Files to not display in CKFinder, no matter their location.
No paths are accepted, only the file name, including extension.
The * and ? wildcards are accepted.
*/
config.hideFiles = arrayNew(1);
config.hideFiles[1] = ".*" ;

/* Set it to false to disable uploading of the dot files
 * e.g. .htaccess, .ftpquota
 */
config.allowDotFiles = true;

/* Due to known issues with GetTempDirectory function, it is
 * recommended to set this vairiable to a valid directory
 * instead of using the GetTempDirectory function
 */
config.tempDirectory = application.configBean.getTempDir();

/*
 * After file is uploaded, sometimes it is required to change its permissions
 * so that it was possible to access it at the later time.
 * If possible, it is recommended to set more restrictive permissions, like 0755.
 * Set to 0 to disable this feature.
 * Note: not needed on Windows-based servers.
 *
 */
if (application.configBean.getValue("usefilemode") eq "" or yesNoFormat(application.configBean.getValue("usefilemode"))){
	config.chmodFiles = 644;
	config.chmodFolders = 755;
} else {
	config.chmodFiles = 0;
	config.chmodFolders = 0;		
}


config.hooks = arrayNew(1);
config.plugins = arrayNew(1);

if (APPLICATION.CFVersion gte 8 or StructKeyExists(SERVER,"bluedragon")) {
  include "plugins/fileeditor/plugin.cfm";
  include "plugins/imageresize/plugin.cfm";
  include "plugins/permissions/plugin.cfm";
  include "plugins/csrf/plugin.cfm";
}

$ = application.serviceFactory.getBean("MuraScope").init(session.siteid);

if ( fileExists(expandPath($.siteConfig("includePath") & '/js/finder/config.cfm') ) ) {
  include "#$.siteConfig('includePath')#/js/finder/config.cfm";
}

if ( fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/finder/config.cfm') ) ) {
  include "#$.siteConfig('themeIncludePath')#/js/finder/config.cfm";
}

$.event("config",config);
$.announceEvent("onSiteCKFinderConfig");
</cfscript>