component extends="mura.cfobject" output="false" {

    variables.modulename = "Masa Passkey";

    function init() {
        var thispath = RemoveChars(GetDirectoryFromPath(GetCurrentTemplatePath()), 1, Len(application.configBean.get('webroot')));
        var modulepath = Left(thispath, Len(thispath)-Len('/model/handlers/'));
        set('modulepath', modulepath);
        return this;
    }

    function onAdminMFAChallengeRender(m) {
        var utility = arguments.m.getBean("UserUtility");
        var rsPasskeys = utility.getPasskeys(session.mfa.userid);
        if(rsPasskeys.recordcount IS 0) {
            return '';
        }
        var userManager = arguments.m.getBean("UserManager");
        session.challenge = userManager.loginStep1(m);
        var executor = new mura.executor();
        arguments.m.event('isadminlogin', true);
        return executor.execute(filepath='#get('modulepath')#/inc/challenge.cfm', m=arguments.m);
    }

/*
    function onUserEdit(m) {
        if (arguments.m.globalConfig('mfa') && (arguments.m.currentUser().isSuperUser() || arguments.m.currentUser().isInGroup('Admin'))) {
            var executor = new mura.executor();
            return executor.execute(filepath='#get('modulepath')#/inc/on-user-edit.cfm', m=arguments.m);
        }
    }
*/
    function onMFAAttemptChallenge(m) {
        var utility = arguments.m.getBean("UserUtility");
        var rsPasskeys = utility.getPasskeys(session.mfa.userid);
        if(rsPasskeys.recordcount IS 0) {
            return '';
        }
        var authcode = arguments.m.event('authcode');
        var userManager = arguments.m.getBean("UserManager");
        userManager.loginStep2(authcode);
        return true;
    }

    function onAdminHTMLHeadRender(m) {
        return this.getHeadQueue(arguments.m);
    }

    function onAdminHTMLFootRender(m) {
        return this.getFootQueue(arguments.m);
    }

    function getHeadQueue(m) {
        return '<link href="#get('modulepath')#/assets/masapasskey.css" rel="stylesheet" type="text/css" />';
    }

    function getFootQueue(m) {
        return '<script src="#get('modulepath')#/assets/masapasskey.js" type="text/javascript"></script>';
    }

}