component extends="mura.bean.beanORM"
    table="tcontentremotepointer"
    entityname="remotecontentpointer"
    orderby="remoteurl asc"
    bundleable=true
    hint="This provides mappings from multiple remote urls to a single content node" {
    property name="pointerid" fieldtype="id";
    property name="content" fieldtype="many-to-one" cfc="content" fkcolumn="contentid";
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID";
    property name="remoteid" fieldtype="index";
    property name="remoteurl" datatype="varchar" length="250";
    property name="created" dataype="timestamp";

}
