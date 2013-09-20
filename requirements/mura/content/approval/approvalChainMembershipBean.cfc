component extends="mura.bean.beanORM"  table="tapprovalmemberships" entityname="approvalChainMembership" bundlealbe=true {

	property name="membershipID" fieldtype="id";
    property name="orderno" type="int" default="1";
    property name="created" type="timestamp";
    property name="approvalChain" fieldtype="many-to-one" cfc="approvalChain" fkcolumn="chainID";   
    property name="group" fieldtype="many-to-one" cfc="user" fkcolumn="groupID";
    property name="site" fieldtype="one-to-one" cfc="site" fkcolumn="siteID";

    function getPendingContentIterator(){
        var qs = new Query();
        var sql="
            select tcontent.title,tcontent.menutitle,tcontent.summary,tcontent.contentID,
            tcontent.siteID,tcontent.moduleID,tcontent.contenthistID,tcontent.changesetID,tcontent.fileid,
            tcontent.lastupdate,tcontent.parentID,tapprovalrequests.created, tcontent.type, tcontent.subtype,
            tcontent.lastupdateby, tcontent.lastupdatebyid,
            tchangesets.name AS changesetName, tchangesets.publishDate AS changesetPublishDate, tcontent.filename
            from  tcontent 
            inner join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
            left join tchangesets on tcontent.changesetID=tchangesets.changesetID
            where 
       			tapprovalrequests.groupid = :groupid
           		and tapprovalrequests.chainid = :chainid
           		and tapprovalrequests.status='Pending'
           	 	order by tapprovalrequests.created
            ";
    
        qs.addParam(name="groupid", value=getValue('groupid'), cfsqltype='cf_sql_varchar');
        qs.addParam(name="chainid", value=getValue('chainid'), cfsqltype='cf_sql_varchar');
        qs.setSQL(sql);

        var it=getBean('contentIterator');
        it.setQuery(qs.execute().getResult());
        return it;

    }

}