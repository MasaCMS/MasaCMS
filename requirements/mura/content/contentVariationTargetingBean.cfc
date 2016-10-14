component extends="mura.bean.beanORM"
	table="tcontentvariationtargeting"
	entityName="variationTargeting"
	bundleable=true  {

	property name="targetingid" fieldType="id";
	property name="content" fieldtype="one-to-one" cfc="content" fkcolumn="contentid";
	property name="site" fieldType="many-to-one" cfc="site" fkcolumn="siteid";
	property name="initjs" datatype="text";

}
