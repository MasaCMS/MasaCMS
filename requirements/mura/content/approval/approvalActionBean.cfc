component extends="mura.bean.beanORM" table="tapprovalactions" entityname="approvalAction" bundleable=true {

	property name="actiontID" fieldtype="id";
    property name="actionType" ormtype="varchar" length="50" default="";
    property name="created" ormtype="timestamp";
    property name="comments" ormtype="text";
    property name="approvalChain" fieldtype="many-to-one" cfc="approvalChain" fkcolumn="chainID";   
    property name="request" fieldtype="many-to-one" cfc="approvalRequest" fkcolumn="requestID";    
    property name="parent" fieldtype="one-to-one" cfc="approvalAction" fkcolumn="parentID" required=false nullable=true;
   // property name="kids" singularname='kid' fieldtype="one-to-many" cfc="approvalActionBean" fkcolumn="parentID";
    property name="group" fieldtype="many-to-one" cfc="user" fkcolumn="groupID";
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="userID";
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID";

}