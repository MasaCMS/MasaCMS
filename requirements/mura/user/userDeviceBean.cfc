component extends="mura.bean.beanORM" table="tuserdevice" entityname="userDevice" bundleable=false hint="This provide User Device Entity"{

	property name="deviceid" fieldtype="id";
    property name="created" ormtype="timestamp";
    property name="lastLogin" ormtype="timestamp";
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="userID";
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID";

}
