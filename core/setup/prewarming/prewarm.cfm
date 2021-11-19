<cfscript>
    compileDirectory(expandPath('/mura'),"mura");
    compileDirectory(expandPath('/muraWRM')&"/core/modules/v1","muraWRM.core.modules.v1");
    compileDirectory(expandPath('/muraWRM/modules'),"muraWRM.modules");
    compileDirectory(expandPath('/muraWRM/themes'),"muraWRM.themes");
    compileDirectory(expandPath('/muraWRM/plugins'),"plugins");
    compileDirectory(expandPath('/admin'),"admin");
</cfscript>