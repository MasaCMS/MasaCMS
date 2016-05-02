component extends="mura.bean.beanORM" table="tremotepointer" bundleable=true {
    property name="pointerid" fieldtype="id";
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID";
    property name="entityType" datatype="varchar" length="50";
    property name="remoteid" fieldtype="index";
    property name="localid" fieldtype="index";

    function getLocalObject(){
        var localObject= getBean(get('entityType'));
        var loadArgs={'#localObject.getPrimaryKey()#'=get('localid')}
        localObject.loadBy(argumentCollection);
        return localObject;
    }

}
