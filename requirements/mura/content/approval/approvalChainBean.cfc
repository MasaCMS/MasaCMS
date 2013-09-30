component extends="mura.bean.beanORM"  table="tapprovalchains" entityname="approvalChain" bundleable=true {

	property name="chainID" fieldtype="id";
    property name="name" type="string" length="100";
    property name="description" type="text";
    property name="created" type="timestamp";
    property name="lastupdate" type="timestamp";
    property name="lastupdateby" type="string" length=50;
    property name="lastupdatebyid" type="string" dataType="char" length=35;
    property name="memberships" singularname="membership" fieldtype="one-to-many" cfc="approvalChainMembership" orderby="orderno asc" cascade="delete";
    property name="requests" singularname="request" fieldtype="one-to-many" cfc="approvalRequest" orderby="created asc" cascade="delete";
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID";


    function getAvailableGroupsIterator(){
        var site=getBean('settingsManager').getSite(getValue('siteID'));
        var qs = new Query();
        var sql="
            select * from tusers 
            where type=1 and (isPublic=1 and siteid = :publicPoolID or isPublic=0 and siteid = :privatePoolID )
            and inactive=0 
            and userID not in (select groupID from tapprovalmemberships where chainid = :chainID)
            order by tusers.groupname
            ";
        qs.addParam(name="publicPoolID", value=site.getPublicUserPoolID(), cfsqltype='cf_sql_varchar');
        qs.addParam(name="privatePoolID", value=site.getPrivateUserPoolID(), cfsqltype='cf_sql_varchar');
        qs.addParam(name="chainID", value=getValue('chainID'), cfsqltype='cf_sql_varchar');
        qs.setSQL(sql);

        var it=getBean('userIterator');
        it.setQuery(qs.execute().getResult());
        return it;

    }


    function save(){

        //writeDump(var=getValue('groupID'),abort=true);
        if(valueExists('groupID')){
            var groupID=getValue('groupID');
            var deleteID='';
            var memberships=getBean('approvalChain')
                .loadBy(chainID=getValue('chainID'))
                .getMembershipsIterator();
            var membership='';
            var firstid=listFirst(groupid);

            while(memberships.hasNext()){
                membership=memberships.next();

                if(not listFindNoCase(groupID,membership.getGroupID())){
                    deleteID=listAppend(deleteID,membership.getMembershipID());
                }
            }

            //writeDump(var=groupID);
            for(var i=1; i lte listLen(groupID); i=i+1){
                membership=getBean('approvalChainMembership')
                    .loadBy(chainID=getValue('chainID'), groupID=listGetAt(groupID,i))
                    .setOrderNo(i)
                    .save();
            }
            //abort;
            //writeDump(var=deleteID,abort=true);

            if(len(deleteID)){
                for(i=1; i lte listLen(deleteID); i=i+1){
                    getBean('approvalChainMembership').loadBy(membershipID=listGetAt(deleteID,i)).delete();
                }
            }

            var qs = new Query();
            var sql="
                    update tapprovalrequests set groupID= :firstID
                    where chainid = :chainID
                    and groupID not in ( :groupID )
                    ";
            qs.addParam(name="groupID", value=groupid, cfsqltype='cf_sql_varchar');
            qs.addParam(name="firstID", value=firstid, cfsqltype='cf_sql_varchar');
            qs.addParam(name="chainID", value=getValue('chainID'), cfsqltype='cf_sql_varchar');
            qs.setSQL(sql);
            qs.execute();

            qs = new Query();
            sql="
                update tapprovalrequests set groupID= :firstID
                where chainid = :chainID
                and (groupID is null or groupID='')
                ";

            qs.addParam(name="firstID", value=firstID, cfsqltype='cf_sql_varchar');
            qs.addParam(name="chainID", value=getValue('chainID'), cfsqltype='cf_sql_varchar');
            qs.setSQL(sql);
            qs.execute();

        }

        return super.save();
    }
    
}