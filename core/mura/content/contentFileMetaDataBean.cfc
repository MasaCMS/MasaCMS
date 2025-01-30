/*

This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the
same licensing model. It is, therefore, licensed under the Gnu General Public License
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing
notice set out below. That exception is also granted by the copyright holders of Masa CMS
also applies to this file and Masa CMS in general.

This file has been modified from the original version received from Mura CMS. The
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained
only to ensure software compatibility, and compliance with the terms of the GPLv2 and
the exception set out below. That use is not intended to suggest any commercial relationship
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa.

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com

Masa CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.
Masa CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>.

The original complete licensing notice from the Mura CMS version of this file is as
follows:

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
component extends="mura.bean.beanORMVersioned"
	table="tcontentfilemetadata"
	entityName="fileMetaData"
	bundleable=true
	versioned=true
	hint="This provides content file metadata functionalityss" {

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
					set(getBean('file').loadBy(fileID=variables.instance.fileid,siteid=getBean('settingsManager').getSite(getValue('siteid')).getFilePoolID(),returnFormat='query'));
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
				&& !structKeyExists(request.handledfilemetas,hash(getValue('fileid') & arguments.newBean.getContentHistID(),'CFMX_COMPAT'))
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
		if ( getValue('isNew') ) {
			return '';
		} else {
			return '#application.configBean.getContext()#/index.cfm/_api/render/file/?method=#arguments.method#&amp;fileID=#getValue('fileid')#';
		}
	}

	function hasImageFileExt(){

		return listFindNoCase("png,jpg,jpeg,svg,gif",getValue('fileExt'));
	}

	function hasCroppableImageFileExt(){

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
