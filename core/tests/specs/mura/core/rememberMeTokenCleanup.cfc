component extends="testbox.system.BaseSpec" {

    function beforeAll() {
        variables.userDAO = application.serviceFactory.getBean("userDAO");
        variables.contentServer = new mura.content.contentServer();
        variables.selectors = {
            expired = left(hash(createUUID()), 43),
            stale = left(hash(createUUID()), 43),
            fresh = left(hash(createUUID()), 43),
            routeExpired = left(hash(createUUID()), 43),
            routeActive = left(hash(createUUID()), 43)
        };
    }

    function afterAll() {
        for (var selector in variables.selectors) {
            variables.userDAO.deleteRememberMeToken(variables.selectors[selector]);
        }
    }

    function run() {
        describe("Remember-me token cleanup", function() {
            it("removes expired and stale tokens but retains recently used tokens", function() {
                var currentTime = now();
                var cutoff = dateAdd("d", -30, currentTime);
                var userID = createUUID();
                var tokenDAO = variables.userDAO;

                tokenDAO.createRememberMeToken(
                    tokenID=createUUID(),
                    userID=userID,
                    siteID="default",
                    selector=variables.selectors.expired,
                    validatorHash=hash(createUUID(), "SHA-256"),
                    expires=dateAdd("d", -1, currentTime),
                    created=dateAdd("d", -31, currentTime),
                    lastused=dateAdd("d", -31, currentTime)
                );
                tokenDAO.createRememberMeToken(
                    tokenID=createUUID(),
                    userID=userID,
                    siteID="default",
                    selector=variables.selectors.stale,
                    validatorHash=hash(createUUID(), "SHA-256"),
                    expires=dateAdd("d", 10, currentTime),
                    created=dateAdd("d", -31, currentTime),
                    lastused=dateAdd("d", -31, currentTime)
                );
                tokenDAO.createRememberMeToken(
                    tokenID=createUUID(),
                    userID=userID,
                    siteID="default",
                    selector=variables.selectors.fresh,
                    validatorHash=hash(createUUID(), "SHA-256"),
                    expires=dateAdd("d", 10, currentTime),
                    created=currentTime,
                    lastused=currentTime
                );

                tokenDAO.deleteExpiredRememberMeTokens(lastUsedBefore=cutoff);

                expect(tokenDAO.readRememberMeToken(variables.selectors.expired).recordCount).toBe(0);
                expect(tokenDAO.readRememberMeToken(variables.selectors.stale).recordCount).toBe(0);
                expect(tokenDAO.readRememberMeToken(variables.selectors.fresh).recordCount).toBe(1);
            });

            it("cleanup route removes expired tokens and keeps active ones", function() {
                var currentTime = now();

                variables.userDAO.createRememberMeToken(
                    tokenID=createUUID(),
                    userID=createUUID(),
                    siteID="default",
                    selector=variables.selectors.routeExpired,
                    validatorHash=hash(createUUID(), "SHA-256"),
                    expires=dateAdd("d", -1, currentTime),
                    created=dateAdd("d", -31, currentTime),
                    lastused=dateAdd("d", -31, currentTime)
                );
                variables.userDAO.createRememberMeToken(
                    tokenID=createUUID(),
                    userID=createUUID(),
                    siteID="default",
                    selector=variables.selectors.routeActive,
                    validatorHash=hash(createUUID(), "SHA-256"),
                    expires=dateAdd("d", 30, currentTime),
                    created=currentTime,
                    lastused=currentTime
                );

                variables.contentServer.handleAPIRequest(path="/_api/internal/rememberme-cleanup");

                expect(variables.userDAO.readRememberMeToken(variables.selectors.routeExpired).recordCount).toBe(0);
                expect(variables.userDAO.readRememberMeToken(variables.selectors.routeActive).recordCount).toBe(1);
            });
        });
    }
}