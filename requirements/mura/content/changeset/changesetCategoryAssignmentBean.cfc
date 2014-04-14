component extends="mura.bean.beanORM" 
	entityName='changesetCategoryAssignment' table="tchangesetcategoryassign" bundleable=true {

	property name="assignmentid" fieldtype="id";
	property name="changeset" fieldtype="many-to-one" cfc="changeset" fkcolumn="changesetid";
	property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid";
	property name="category" fieldtype="many-to-one" cfc="category" fkcolumn="categoryid";
}