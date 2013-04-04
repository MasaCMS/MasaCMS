component extends="mura.bean.beanORM" table="tcontentsourcemaps" {

    property name="mapid" fieldtype="id";
    property name="activeContent" fieldtype="one-to-one" cfc="contentBean" fkcolumn="contentid";
	property name="content" fieldtype="one-to-one" cfc="contentBean" fkcolumn="contenthistid";
    property name="source" fieldtype="one-to-one" cfc="contentBean" fkcolumn="sourceid";
    property name="site" fieldtype="many-to-one" cfc="settingBean" fkcolumn="siteid";
    property name="created" ormtype="timestamp";

}