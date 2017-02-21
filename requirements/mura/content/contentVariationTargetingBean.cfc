component extends="mura.bean.beanORM"
	table="tcontentvariationtargeting"
	entityName="variationTargeting"
	bundleable=true
	hint="This provides content variation targeting functionality"{

	property name="targetingid" fieldType="id";
	property name="content" fieldtype="one-to-one" cfc="content" fkcolumn="contentid";
	property name="site" fieldType="many-to-one" cfc="site" fkcolumn="siteid";
	property name="initjs" datatype="text";
	property name="targetingjs" datatype="text";

}
