component extends="mura.bean.beanORM" displayName="entityBean" orderby="val" hint="This provides form created entity functionality"{

	property name="site" fieldtype="one-to-one" cfc="site" fkcolumn="siteid";
	property name="created" displayName="created" rendertype="none" datatype="timestamp" fieldtype="none";
	property name="lastupdate" displayName="Last Update" rendertype="none" datatype="date" fieldtype="none";

}
