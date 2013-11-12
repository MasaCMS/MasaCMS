component extends="mura.bean.beanORM" 
	table="tcontentfilenamearchive" 
	entityName="contentFilenameArchive" 
	bundleable=true {
	
	property name="archiveid" fieldtype="id";
	property name="content" fieldtype="many-to-one" cfc="content" fkcolumn="contentID"; 
	property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID";
	property name="filename" fieltype="index" type="varchar" length=255;

}