component extends="mura.bean.beanORM" table="tclassextendrcsets" entityname="relatedContentSet" hint="Provides extended object related content sets bean functionality"{

	property name="relatedContentSetID" fieldtype="id";
  property name="name" ormtype="varchar" length="50" default="" required="true";
  property name="availableSubTypes" ormtype="text";
  property name="orderNo" ormtype="int";
	property name="siteID" ormtype="varchar" length="25" default="";
	property name="subTypeID" ormtype="varchar" length="35" default="";

	function getRelatedContentQuery(contentHistID){
        var rcSetID = getValue('relatedContentSetID');
				var rs = getBean('contentManager').getRelatedContent(siteID=getValue('siteID'), contentHistID=arguments.contenthistID, relatedContentSetID=rcSetID,liveOnly=false);

        return rs;
    }


		/**
		 * @ouput false
		 */
		xml function getAsXML(documentXML, boolean includeIDs="false") {
			var extensionData = {};
			var item = "";
			var i = 0;
			var xmlAttributeSet = XmlElemNew( documentXML, "", "relatedcontentset" );
			var xmlAttributes = "";
			extensionData = duplicate(variables.instance);
			structDelete(extensionData,"errors");
			if ( not(arguments.includeIDs) ) {
				structDelete(extensionData,"relatedContentSetID");
				structDelete(extensionData,"subTypeID");
			}
			structDelete(extensionData,"isNew");
			structDelete(extensionData,"isActive");
			structDelete(extensionData,"siteid");
			structDelete(extensionData,"fromMuraCache");
			structDelete(extensionData,"saveerrors");

			for ( item in extensionData ) {
				if ( isSimpleValue(extensionData[item]) ) {
					xmlAttributeSet.XmlAttributes[lcase(item)] = extensionData[item];
				}
			}
			return xmlAttributeSet;
		}
}
