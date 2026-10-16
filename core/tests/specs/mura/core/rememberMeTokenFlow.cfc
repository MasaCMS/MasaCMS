component extends="testbox.system.BaseSpec" {

    function beforeAll() {
        variables.siteID = "default";
        variables.username = "rememberMeTest#left(hash(createUUID()), 12)#";
        variables.password = "TestPassword-#left(hash(createUUID()), 12)#";
        variables.$ = application.serviceFactory.getBean("$").init(variables.siteID);
        variables.user = variables.$.getBean("user").set({
            userID = createUUID(),
            siteID = variables.siteID,
            username = variables.username,
            password = variables.password,
            fname = "Remember Me",
            lname = "Test",
            email = "#variables.username#@example.test",
            type = 2,
            isPublic = 0,
            inactive = 0
        }).save();
    }

    function afterAll() {
        var userDAO = application.serviceFactory.getBean("userDAO");
        for (var selector in (variables.tokenSelectors ?: [])) {
            userDAO.deleteRememberMeToken(selector);
        }
        if (isObject(variables.user) && variables.user.exists()) {
            variables.user.delete();
        }
    }

    function run() {
        variables.tokenSelectors=[];
        describe("Remember-me token login flow", function() {
            it("issues a selector and validator cookie after a remembered login", function() {
                var loginManager = variables.$.getBean("loginManager");
                var sessionData = application.mura.getSession();
                var httpResult = "";
                var sessionTokens = {};
                var requestUrl = "http://localhost:" & getPageContext().getRequest().getLocalPort()
                    & application.configBean.getContext()
                    & "/index.cfm";
                var setCookieHeaders = "";
                var rememberCookie = "";

                for (var sessionToken in listToArray(sessionData.urlToken ?: "", "&")) {
                    sessionTokens[listFirst(sessionToken, "=")] = listRest(sessionToken, "=");
                }

                request.muraAPIRequestMode = "json";
                request.muraAPIRequest = true;
                expect(loginManager.login(data={
                    username = variables.username,
                    password = variables.password,
                    siteid = variables.siteID,
                    rememberMe = 1
                })).toBeTrue();
                expect(sessionData.mura.isLoggedIn).toBeTrue();

                cfhttp(url=requestUrl, method="get", result="httpResult", timeout=30, throwonerror=false, redirect=false) {
                    cfhttpparam(type="cookie", name="CFID", value=sessionTokens.CFID ?: cookie.CFID ?: "");
                    cfhttpparam(type="cookie", name="CFTOKEN", value=sessionTokens.CFTOKEN ?: cookie.CFTOKEN ?: "");
                    cfhttpparam(type="cookie", name="JSESSIONID", value=sessionTokens.JSESSIONID ?: cookie.JSESSIONID ?: "");
                }

                for (var headerName in httpResult.responseHeader) {
                    if (compareNoCase(headerName, "Set-Cookie") == 0) {
                        var headerValue = httpResult.responseHeader[headerName];

                        if (isStruct(headerValue)) {
                            for (var key in headerValue) {
                                setCookieHeaders = listAppend(setCookieHeaders, headerValue[key], chr(10));
                            }
                        } else if (isArray(headerValue)) {
                            setCookieHeaders = arrayToList(headerValue, chr(10));
                        } else {
                            setCookieHeaders = headerValue;
                        }
                    }
                }

                var matchedCookie = reMatchNoCase("rememberme=[^;]+", setCookieHeaders);
                if (arrayLen(matchedCookie)) {
                    // cfcookie URL-encodes values; browsers send them back as-is and CFML decodes on read.
                    rememberCookie = urlDecode(listRest(matchedCookie[1], "="));
                }

                expect(reFind("^[A-Za-z0-9_-]{43}:[A-Za-z0-9_-]{43}$", rememberCookie))
                    .toBe(1, serializeJSON({
                        statusCode=httpResult.statusCode,
                        hasSessionUrlToken=len(sessionData.urlToken ?: "") > 0,
                        sessionTokenNames=structKeyArray(sessionTokens),
                        rememberMeFlag=sessionData.rememberMe ?: 0,
                        rememberMeTokenIssued=structKeyExists(sessionData,"rememberMeTokenIssued"),
                        responseHeaderNames=structKeyArray(httpResult.responseHeader),
                        responseHeader=httpResult.responseHeader,
                        body=left(httpResult.fileContent, 500)
                    }));
            });

                it("restores a session and rotates a valid token", function() {
                    var loginManager = variables.$.getBean("loginManager");
                    var userDAO = variables.$.getBean("userDAO");
                    var token = loginManager.createRememberMeToken(
                        userID=variables.user.getUserID(),
                        siteID=variables.siteID
                    );
                    var originalToken = userDAO.readRememberMeToken(token.selector);
                    var sessionData = application.mura.getSession();

                    expect(loginManager.rememberMe(selector=token.selector, validator=token.validator)).toBeTrue();
                    expect(sessionData.mura.isLoggedIn).toBeTrue();
                    expect(userDAO.readRememberMeToken(token.selector).validatorHash)
                        .notToBe(originalToken.validatorHash);
                });

                it("revokes the current token on logout", function() {
                    var loginManager = variables.$.getBean("loginManager");
                    var userDAO = variables.$.getBean("userDAO");
                    var token = loginManager.createRememberMeToken(
                        userID=variables.user.getUserID(),
                        siteID=variables.siteID
                    );
                    arrayAppend(variables.tokenSelectors,token.selector);
                    cookie.rememberme=token.selector & ":" & token.validator;

                    expect(userDAO.readRememberMeToken(token.selector).recordCount).toBe(1);
                    loginManager.logout();
                    expect(userDAO.readRememberMeToken(token.selector).recordCount).toBe(0);
                });
        });
    }
}