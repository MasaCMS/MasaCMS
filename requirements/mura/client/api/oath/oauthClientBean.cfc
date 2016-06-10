component extends="mura.bean.beanORM" entityName='oauthClient' table="toauthclients" bundleable="true"{
    property name="clientid" fieldtype="id";
    property name="clientsecret" datatype="varchar" length=100;
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid" required=true;
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="userid" required=true;
    property name="name" datatype="varchar" required=true;

    function save(){
        if(!len(get('clientsecret'))){
            set('clientsecret',"000" & hash(encrypt(get('clientid'),generateSecretKey('AES'))));
        }
        super.save(argumentCollection=arguments);
        return this;
    }

    function generateToken(granttype='client_credentials'){
        var token=getBean('oauthToken');

        token.set({
            clientid=get('clientid'),
            granttype=arguments.granttype
        }).save();

        if(arguments.granttype =='client_credentials'){
            var expiredTokens=token.getFeed()
                .where('clientid').isEQ(get('clientid'))
                .andProp('granttype').isEQ('client_credentials')
                .andProp('expires').isLT(dateAdd('d',-1,now()))
                .getIterator();

            if(expiredTokens.hasNext()){
                while(expiredTokens.hasNext()){
                    expiredTokens.next().delete();
                }
            }
        }

        return token;
    }

}
