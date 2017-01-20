component extends="mura.bean.beanORM" entityName='oauthClient' table="toauthclients" bundleable="true" hint="This provides OAuth Client Crendential CRUD functionality" {
    property name="clientid" fieldtype="id";
    property name="clientsecret" datatype="varchar" length=100;
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid" required=true;
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="userid";
    property name="tokens" fieldtype="one-to-many" cfc="oauthToken" cascade="delete";
    property name="name" datatype="varchar" required=true;
    property name="description" datatype="text";
    property name="created" ormtype="timestamp";
    property name="lastupdate" datatype="timestamp";
    property name="lastupdateby" datatype="varchar" length=50;
    property name="lastupdatebidy" datatype="varchar" length=35;

    function save(){
        if(!len(get('clientsecret'))){
            set('clientsecret',hash(encrypt(get('clientid'),generateSecretKey('AES'))));
        }
        super.save(argumentCollection=arguments);
        return this;
    }

    function generateToken(granttype='client_credentials'){
        var token=getBean('oauthToken');

        var existingTokens=token.getFeed()
            .where('clientid').isEQ(get('clientid'))
            .andProp('granttype').isEQ(arguments.granttype)
            .andProp('expires').isGT(now())
            .getIterator();

        if(existingTokens.hasNext()){
            return existingTokens.next();
        } else {


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
        }

        return token;
    }

}
