component extends="mura.bean.beanORM" entityName='oauthClient' table="toauthclients" bundleable="true" hint="This provides OAuth Client Crendential CRUD functionality" {
    property name="clientid" fieldtype="id";
    property name="clientsecret" datatype="varchar" length=100;
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid" required=true;
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="userid";
    property name="tokens" fieldtype="one-to-many" cfc="oauthToken" cascade="delete";
    property name="name" datatype="varchar" required=true;
    property name="description" datatype="text";
    property name="granttype" datatype="varchar" default="basic";
    property name="created" ormtype="timestamp";
    property name="lastupdate" datatype="timestamp";
    property name="lastupdateby" datatype="varchar" length=50;
    property name="lastupdatebidy" datatype="varchar" length=35;
    property name="redirecturl" datatype="text";

    function save(){
        if(!len(get('clientsecret'))){
            set('clientsecret',hash(encrypt(get('clientid'),generateSecretKey('AES'))));
        }
        super.save(argumentCollection=arguments);
        return this;
    }

    function generateToken(granttype='client_credentials',userid='',redirecturl=''){
        var token=getBean('oauthToken');

        if(!len(arguments.userid)){
            arguments.userid=get('userid');
        }

        var existingTokens=token.getFeed()
            .where()
						.prop('clientid').isEQ(get('clientid'))
            .andProp('granttype').isEQ(arguments.granttype)
            .andProp('userid').isEQ(arguments.userid)
            .andProp('expires').isGT(now())
            .getIterator();

        if(existingTokens.hasNext()){
            return existingTokens.next();
        } else {

            token.set({
                clientid=get('clientid'),
                granttype=arguments.granttype,
                userid=arguments.userid
            });

            if(granttype=='authorization_code'){
                token.setAccessCode(createUUID());
            }

            token.save();

            if(listFind('authorization_code,client_credentials',arguments.granttype)){
                var expiredTokens=token.getFeed()
                    .where('clientid').isEQ(get('clientid'))
                    .andProp('granttype').isEQ(arguments.granttype)
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

    function getGrantType(){
        if(!len(variables.instance.granttype)){
            variables.instance.granttype='client_credentials';
        }

        return variables.instance.granttype;
    }

    function isValidRedirectURI(redirect_uri){
        if(!len(variables.instance.redirecturl)){
            return true;
        }

        for(var i in listToArray(replace(variables.instance.redirecturl,chr(13)&chr(10),"|"),"|")){
            if(i==arguments.redirect_uri){
                return true;
            }
        }

        return false;
    }

}
