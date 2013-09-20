component extends="mura.bean.beanORM" table='tfiles' entityName="file" {

	property name="fileid" fieldtype="id";
	property name="content" fieldtype="one-to-one" fkcolumn="contentid" cfc="content" required=false nullable=true;
	property name="site" fieldtype="many-to-one" fkcolumn="siteid" cfc="site";
	property name="filename" datatype="varchar" length=200;
	property name="contentType" datatype="varchar" length=100;
	property name="contentSubType" datatype="varchar" length=200;
	property name="fileSize" datatype="int" default=0;
	property name="fileExt" datatype="varchar" length=50;
	property name="moduleid" datatype="varchar" default="00000000000000000000000000000000000" length=35;
	property name="created" datatype="datetime";
	property name="deleted" datatype="int" default=0;
	property name="caption" datatype="text";
	property name="credits" datatype="varchar" length=255;
	property name="alttext" datatype="varchar" length=255;
	property name="fileField" default="newfile" persistent=false;
	property name="remoteID" type="varchar" length=255 fieldtype="index";
	property name="remoteURL" type="varchar" length=255;
	property name="remotePubDate" type="datetime" ;
	property name="remoteSource" type="varchar" length=255;
	property name="remoteSourceURL" type="varchar" length=255;

	function setSummary(summary){
		setValue('caption',arguments.summary);
		return this;
	}

	function setFileField(fileField){
		variables.instance.fileField=arguments.fileField;
		if(isdefined('form') and structKeyExists(form,variables.instance.fileField)){
			setValue(variables.instance.fileField,form['#variables.instance.fileField#']);
		}
	}

	function save(processFile=true){

		//writeDump(var=getValue('fileField'));
		//writeDump(var=getValue(getValue('fileField')));
		//abort;

		//(var=getProperties(),abort=true);

		if(arguments.processFile && len(getValue('fileField')) && len(getValue(getValue('fileField')))){
			setValue('fileID',createUUID());
		
			var fileManager=getBean('fileManager');

			if(fileManager.isPostedFile(getValue('fileField'))){
				local.tempFile=fileManager.upload(getValue('fileField'));
			} else {
				local.tempFile=fileManager.emulateUpload(getValue(getValue('fileField')));
			}

			structAppend(variables.instance, local.tempFile);
			structAppend(variables.instance, fileManager.process(local.tempFile,getValue('siteid')));
			variables.instance.fileExt=local.tempFile.serverFileExt;
			variables.instance.filename=local.tempFile.ClientFile;

			//writeDump(var=variables.instance,abort=true);

			param name='variables.instance.content' default='';
			
			fileManager.create(argumentCollection=variables.instance);
		
			setAllValues(getBean('file').loadBy(fileID=getValue('fileID')).getAllValues());
		} else {

			super.save();
		}
		return this;

	}

	function setRemotePubDate(remotePubDate){
		variables.remotepubdate=parseDateArg(arguments.remotePubDate);
		return this;
	}
}