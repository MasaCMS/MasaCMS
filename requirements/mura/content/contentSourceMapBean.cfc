component extends="mura.bean.beanORM" table="tcontentsourcemaps" entityname="contentSourceMap"{

    property name="mapid" fieldtype="id";
    property name="activeContent" fieldtype="one-to-one" cfc="content" fkcolumn="contentid";
	property name="content" fieldtype="one-to-one" cfc="content" fkcolumn="contenthistid";
    property name="source" fieldtype="one-to-one" cfc="content" fkcolumn="sourceid";
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid";
    property name="created" ormtype="timestamp";

}