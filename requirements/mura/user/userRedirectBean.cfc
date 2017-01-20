component extends="mura.bean.beanORM" table="tredirects" entityName="userRedirect" hint="This provides user redirect entity" {
    property name="redirectid" fieldtype="id";
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="userid";
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid";
    property name="url" datatype="mediumtext";
    property name="created" datatype="datetime";

    function apply(){
        location(url=get('url'),addtoken=false);
    }
}
