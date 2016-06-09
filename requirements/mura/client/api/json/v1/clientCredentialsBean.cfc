component extends="mura.bean.beanORM" entityName='clientCredentials' table="tclientcredentials" bundleable="true"{
    property name="clientid" fieldtype="id";
    property name="clientsecret" datatype="varchar" length=100;
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid" required=true;
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="userid" required=true;
    property name="name" datatype="varchar" required=true;

    function save(){
        if(!len(get('clientsecret'))){
            set('clientsecret',GenerateSecretKey('AES'));
        }
        super.save(argumentCollection=arguments);
        return this;
    }

}
