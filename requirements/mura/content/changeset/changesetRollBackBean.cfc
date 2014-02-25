component extends="mura.bean.beanORM" table="tchangesetrollback" entityname="changesetRollBack" {
	property name="rollbackID" fieldtype="id";
    property name="changeset" fieldtype="many-to-one" cfc="changsetBean" fkcolumn="changesetID";
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID";   
    property name="changesetVersion" fieldtype="one-to-one" cfc="content" fkcolumn="changesetHistID"; 
    property name="previousVersion" fieldtype="one-to-one" cfc="content" fkcolumn="previousHistID";   

    function rollback(){
        var previousContent=getBean('content').loadBy(contenthistID=getValue('previousHistID'));

        if(not previousContent.getIsNew()){
             previousContent
                .setApprovalChainOverride(true)
                .setApproved(1)
                .save();
        } else {
            previousContent=getBean('content').loadBy(contenthistID=getValue('changesetHistID'));

            if(not previousContent.getIsNew()){
                previousContent
                    .setApprovalChainOverride(true)
                    .setApproved(1)
                    .setDisplay(0)
                    .save();
            }
        }

        return this;
    }
}