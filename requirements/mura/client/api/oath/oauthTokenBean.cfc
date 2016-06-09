component extends="mura.bean.beanORM" entityName='oauthToken' table="toauthtokens"{
    property name="token" fieldtype="id";
    property name="granttype" datatype="varchar" default="client_credentials";
    property name="client" fieldtype="many-to-one" cfc="oauthClient" fkcolumn="clientid" required=true;
    property name="expires" datatype="datetime" required=true;

    function save(){
        if(isValid('uuid',get('token'))){
            set('token',hash(encrypt(get('token'),generateSecretKey('AES'))));
        }
        if(get('granttype')=='client_credentials'){
            set('expires',dateAdd('n',30,now()));
        } else {
            set('expires',dateAdd('yyyy',100,now()));
        }
        super.save(argumentCollection=arguments);
        return this;
    }

}
