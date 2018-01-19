component entityName="testWidget" table="testwidget" extends="mura.bean.beanORM" {
    property name="widgetid" fieldtype="id";
    property name="name" datatype="varchar" length="100" required=true;
    property name="email" datatype="varchar" validate="email" length="100" required=true;
    property name="description" datatype="text" required=true;
    property name="intVar" datatype="int" required=true;
    property name="dateVar" datatype="datetime"required=true;
    property name="smallintVar" datatype="smallint"required=true;
    property name="floatVar" datatype="float" required=true;
    property name="doubleVar" datatype="double" required=true;
    property name="options" singularname="option" fieldtype="one-to-many" cascade="delete" cfc="testOption";

}
