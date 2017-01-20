component extends="mura.bean.beanORM" displayName="fieldOptionBean" orderby="val" hint="This provides fieldOptionBean functionality" {

	property name="site" fieldtype="one-to-one" cfc="site" fkcolumn="siteid";

	property name="label" datatype="varchar" length="250" fieldtype="index" type="textfield" displayname="Label";
	property name="val" datatype="varchar" length="250" fieldtype="index" type="textfield" displayname="Value";
	property name="orderno" datatype="int" fieldtype="index" type="none" default="0";
	property name="isdefault" datatype="int" type="none" default="0";
	property name="created" datatype="timestamp" fieldtype="index" type="none";

}
