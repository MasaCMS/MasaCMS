<cfscript>
if(server.coldfusion.productname == 'lucee'){
    this.datasources[getSystemEnvironmentSetting('MURA_DATASOURCE')] =  {
        type = getSystemEnvironmentSetting('MURA_DBTYPE')
       , host = getSystemEnvironmentSetting('MURA_DBHOST')
       , database = getSystemEnvironmentSetting('MURA_DATABASE')
       , port = getSystemEnvironmentSetting('MURA_DBPORT')
       , username = getSystemEnvironmentSetting('MURA_DBUSERNAME')
       , password = getSystemEnvironmentSetting('MURA_DBPASSWORD')
    };
} else {
    this.datasources[getSystemEnvironmentSetting('MURA_DATASOURCE')] =  {
        database = getSystemEnvironmentSetting('MURA_DATABASE')
        , driver = 'other'
        , url = 'jdbc:mysql://mysql:#getSystemEnvironmentSetting('MURA_DBPORT')#/#getSystemEnvironmentSetting('MURA_DATABASE')#'
        , class = 'com.mysql.jdbc.Driver'
        , username = getSystemEnvironmentSetting('MURA_DBUSERNAME')
        , password = getSystemEnvironmentSetting('MURA_DBPASSWORD')
    };
}
</cfscript>
