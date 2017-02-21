component entityName="testOption" table="testoption" extends="mura.bean.beanORM" {
    property name="optionid" fieldtype="id";
    property name="name" datatype="varchar" length="100" required=true;
    property name="description" datatype="text" required=true;
    property name="widget" fieldtype="many-to-one" cfc="testWidget" fkcolumn="widgetid";

}
