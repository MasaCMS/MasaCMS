component extends="testbox.system.BaseSpec" {

    function beforeAll() {
        variables.configBean = application.serviceFactory.getBean("configBean");
        variables.dbUtility = application.serviceFactory.getBean("dbUtility");
        variables.configBean.applyDbUpdates();
        variables.dbUtility.purgeCache();
    }

    function run() {
        describe("Remember-me token schema", function() {
            it("creates the token table with required fields and lookup indexes", function() {
                var table = "tremembertokens";
                var requiredColumns = [
                    "tokenid",
                    "userid",
                    "siteid",
                    "selector",
                    "validatorhash",
                    "expires",
                    "created",
                    "lastused"
                ];

                expect(variables.dbUtility.tableExists(table)).toBeTrue();

                for (var column in requiredColumns) {
                    expect(variables.dbUtility.columnExists(column=column, table=table))
                        .toBeTrue("Expected #column# in #table#");
                }

                expect(variables.dbUtility.indexExists(column="selector", table=table)).toBeTrue();
                expect(variables.dbUtility.indexExists(column="userid", table=table)).toBeTrue();
                expect(variables.dbUtility.indexExists(column="siteid", table=table)).toBeTrue();
            });
        });
    }
}