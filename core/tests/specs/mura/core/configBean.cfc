component extends="testbox.system.BaseSpec" {

    function run(){
        describe("configBean.getReadOnlyQRYAttrs blockfactor logic", function(){
            var configBean = application.serviceFactory.getBean('configBean');

            it(
                title="should return default value 1 if blockfactor not in range 1-100",
                body=function(){
                    var args = { blockfactor = 0 };
                    var result = configBean.getReadOnlyQRYAttrs(argumentCollection=args);
                    expect(structKeyExists(result, "blockfactor")).toBeTrue();
                    expect(result.blockfactor).toBe(1);

                    args = { blockfactor = 101 };
                    result = configBean.getReadOnlyQRYAttrs(argumentCollection=args);
                    expect(structKeyExists(result, "blockfactor")).toBeTrue();
                    expect(result.blockfactor).toBe(1);
                }
            );

            it(
                title="should keep blockfactor if in range 1-100",
                body=function(){
                    var args = { blockfactor = 1 };
                    var result = configBean.getReadOnlyQRYAttrs(argumentCollection=args);
                    expect(structKeyExists(result, "blockfactor")).toBeTrue();
                    expect(result.blockfactor).toBe(1);

                    args = { blockfactor = 100 };
                    result = configBean.getReadOnlyQRYAttrs(argumentCollection=args);
                    expect(structKeyExists(result, "blockfactor")).toBeTrue();
                    expect(result.blockfactor).toBe(100);
                }
            );

            it(
                title="should not error if blockfactor is missing",
                body=function(){
                    var args = {};
                    var result = configBean.getReadOnlyQRYAttrs(argumentCollection=args);
                    expect(structKeyExists(result, "blockfactor")).toBeFalse();
                }
            );
        });
    }
}