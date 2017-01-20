component extends="mura.bean.beanORM" entityName='oauthToken' table="toauthtokens" hint="This provides OAuth Token functionality" {
    property name="token" fieldtype="id";
    property name="granttype" datatype="varchar" default="client_credentials";
    property name="client" fieldtype="many-to-one" cfc="oauthClient" fkcolumn="clientid" required=true;
    property name="expires" datatype="datetime" required=true;
    property name="data" datatype="text";

    function save(){
        if(isValid('uuid',get('token'))){
            set('token',"000" & hash(encrypt(get('token'),generateSecretKey('AES'))));
        }

        if(!isDate(get('expires'))){
            if(get('granttype')=='client_credentials'){
                set('expires',dateAdd('n',60,now()));
            } else {
                set('expires',dateAdd('yyyy',100,now()));
            }
        }

        super.save(argumentCollection=arguments);
        return this;
    }

    function getExpiresIn(){
        return dateDiff('s',now(),get('expires'));
    }

    function getExpiresAt(){
        return getBean('utility').getEpochTime(get('expires'));
    }

    function isExpired(){
        return (getExpiresIn() <= 0);
    }

}
