component extends="mura.bean.beanORM" 
	entityName='changesetTagAssignment' table="tchangesettagassign" bundleable=true {

	property name="assignmentid" fieldtype="id";
	property name="changeset" fieldtype="many-to-one" cfc="changeset" fkcolumn="changesetid";
	property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid";
	property name="tag" datatype="varchar" fieldtype="index" length="100";
}