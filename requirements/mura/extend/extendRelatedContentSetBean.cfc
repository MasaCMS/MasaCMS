component extends="mura.bean.beanORM" table="tclassextendrcsets" entityname="relatedContentSet" {

	property name="relatedContentSetID" fieldtype="id";
    property name="name" ormtype="varchar" length="50" default="" required="true";
    property name="availableSubTypes" ormtype="text";
    property name="orderNo" ormtype="int";
	property name="siteID" ormtype="varchar" length="25" default="";
	property name="subTypeID" ormtype="varchar" length="35" default="";
	
	function getRelatedContentQuery(contentHistID){
        var rcSetID = getValue('relatedContentSetID');
		var rs = getBean('contentManager').getRelatedContent(siteID=getValue('siteID'), contentHistID=arguments.contenthistID, relatedContentSetID=rcSetID);

        return rs;
    }
}
