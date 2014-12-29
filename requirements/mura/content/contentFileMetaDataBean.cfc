component extends="mura.bean.beanORMVersioned" 
	table="tcontentfilemetadata" 
	entityName="fileMetaData" 
	bundleable=true 
	versioned=true {
	
	property name="metaID" fieldType="id";
	property name="file" fieldType="many-to-one" cfc="file" fkcolumn="fileid";
	property name="altText" dataType="varchar" length="255";
	property name="caption" datatype="text";
	property name="credits" datatype="text";
	property name="filename" type="string" default="" persistent=false;
	property name="filesize" type="integer" default="0" persistent=false;
	property name="contentType" type="string" default="" persistent=false;
	property name="contentSubType" type="string" default="" persistent=false;
	property name="fileExt" type="string" default="" persistent=false;
	property name="created" type="datetime" persistent=false;
	property name="directImages" type="boolean" default=true persistent=false;
	property name="remoteID" type="varchar" length=255 fieldtype="index";
	property name="remoteURL" type="varchar" length=255;
	property name="remotePubDate" type="datetime" ;
	property name="remoteSource" type="varchar" length=255;
	property name="remoteSourceURL" type="varchar" length=255;
	/*
	property name="gpsaltitude" type="varchar" length=50;
	property name="gpsaltituderef" type="varchar" length=50;
	property name="gpslatitude" type="varchar" length=50;
	property name="gpslatituderef" type="varchar" length=50;
	property name="gpslongitude" type="varchar" length=50;
	property name="gpslongituderef" type="varchar" length=50;
	property name="gpsimgdirection" type="varchar" length=50;
	property name="gpstimestamp" type="varchar" length=50;
	*/
	property name="exif" datatype="text";
	
	function loadBy(returnFormat="self"){
		var result=super.loadBy(argumentCollection=arguments);

		switch(arguments.returnFormat){
			case 'self': 
				if(variables.instance.isnew && len(variables.instance.fileid)){
					set(getBean('file').loadBy(fileID=variables.instance.fileid,returnFormat='query'));
				}

				return this;
				break;
			case 'query':
			case 'iterator':
				return result;
		}

	}

	private function getLoadSQL(){
		return "select tcontentfilemetadata.*, tfiles.filename, tfiles.fileSize, tfiles.contentType, tfiles.contentSubType, tfiles.fileExt, tfiles.created
			 from tcontentfilemetadata
			 inner join tfiles on (tcontentfilemetadata.fileid=tfiles.fileid)
			 ";
	}

	function persistToVersion(previousBean,newBean,$){
		var properties=arguments.newBean.getAllValues();

		param name="request.handledfilemetas" default={};

		//writeDump(var=properties,abort=true);

		for(var prop in properties){
			if(isSimpleValue(properties[prop]) && properties[prop] == getValue('fileid')
				&& !structKeyExists(request.handledfilemetas,hash(getValue('fileid') & arguments.newBean.getContentHistID()))
			){
				return true;
			}
		}

		return false;
	}

	function setSiteID(siteid){
		if(len(arguments.siteid)){
			variables.instance.siteid=arguments.siteid;
			variables.instance.directImages=getBean('settingsManager').getSite(variables.instance.siteid).getContentRenderer().getDirectImages();
		}
	}

	function getURLForFile(method='inline'){
		if ( not getValue('isNew') ) {
			return '';
		} else {
			return '#application.configBean.getContext()#/index.cfm/_api/render/file/?method=#arguments.method#&amp;fileID=#getValue('fileid')#';
		}
	}

	function hasImageFileExt(){

		return listFindNoCase("png,jpg,jpeg",getValue('fileExt'));
	}

	function getURLForImage(
		size='large',
		direct=false,
		complete=false,
		height='AUTO',
		width='AUTO',
		siteid=variables.instance.siteid,
		fileid= variables.instance.fileid
	)
	{
	
		var imageURL = getBean('fileManager').createHREFForImage(argumentCollection=arguments);
		if ( IsSimpleValue(imageURL) ) {
			return imageURL;
		} else {
			return '';
		};
	}

	function setRemotePubDate(remotePubDate){
		variables.remotepubdate=parseDateArg(arguments.remotePubDate);
		return this;
	}

	function save(setAsDefault=false){
		serializeExif();
		super.save();

		if(arguments.setAsDefault){
			getBean('file').loadBy(fileid=getValue('fileid'))
			.setCaption(getValue('caption'))
			.setAltText(getValue('alttext'))
			.setCredits(getValue('credits'))
			.setRemoteID(getValue('remoteID'))
			.setRemoteURL(getValue('remoteURL'))
			.setRemotePubDate(getValue('remotePubDate'))
			.setRemoteSource(getValue('remoteSource'))
			.setRemoteSourceURL(getValue('remoteSourceURL'))
			.setExif(getValue('exif'))
			.save(processFile=false);
		}

		return this;
	}

	function setExifPartial(exif){
		deserializeExif();

		if(isJSON(arguments.exif)){
			arguments.exif=deserializeJSON(arguments.exif);
		}

		structAppend(variables.instance.exif,arguments.exif);

		return this;
	}

	function serializeExif(){
		if(!isJSON(getValue('exif'))){
			if(isStruct(getValue('exif'))){
				setValue('exif',serializeJSON(getValue('exif')));
			} else {
				setValue('exif','{}');
			}
		}
		return getValue('exif');
	}

	function deserializeExif(){
		if(!isStruct(getValue('exif'))){
			if(len(getValue('exif'))){
				setValue('exif',deserializeJSON(getValue('exif')));
			} else {
				setValue('exif',{});
			}
		}
		return getValue('exif');
	}

	function getExifTag(tag){
		deserializeExif();
		if(structKeyExists(variables.instance.exif,arguments.tag)){
			return variables.instance.exif['#arguments.tag#'];
		} else {
			return '';
		}
	}

	function getExifAsJSON(){
		return serializeExif();
	}

	function getExifAsStruct(){
		return deserializeExif();
	}

	function setExifTag(tag,value){
		deserializeExif();
		variables.instance.exif['#arguments.tag#']=arguments.value;
		return this;
	}


}