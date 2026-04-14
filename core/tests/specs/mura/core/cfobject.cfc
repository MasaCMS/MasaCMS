component extends="testbox.system.BaseSpec" {

	function run(){
		describe("cfobject.getQueryAttrs blockfactor logic", function(){
			var cfobject = createObject("component", "mura.cfobject");

			it(
				title="should return default value 1 if blockfactor not in range 1-100 (no custom datasource, readOnly=false)",
				body=function(){
					var args = { blockfactor = 0, readOnly = false };
					var result = cfobject.getQueryAttrs(argumentCollection=args);
					expect(structKeyExists(result, "blockfactor")).toBeTrue();
					expect(result.blockfactor).toBe(1);

					args = { blockfactor = 101, readOnly = false };
					result = cfobject.getQueryAttrs(argumentCollection=args);
					expect(structKeyExists(result, "blockfactor")).toBeTrue();
					expect(result.blockfactor).toBe(1);
				}
			);

			it(
				title="should keep blockfactor if in range 1-100 (no custom datasource, readOnly=false)",
				body=function(){
					var args = { blockfactor = 1, readOnly = false };
					var result = cfobject.getQueryAttrs(argumentCollection=args);
					expect(structKeyExists(result, "blockfactor")).toBeTrue();
					expect(result.blockfactor).toBe(1);

					args = { blockfactor = 100, readOnly = false };
					result = cfobject.getQueryAttrs(argumentCollection=args);
					expect(structKeyExists(result, "blockfactor")).toBeTrue();
					expect(result.blockfactor).toBe(100);
				}
			);

			it(
				title="should not error if blockfactor is missing (no custom datasource, readOnly=false)",
				body=function(){
					var args = { readOnly = false };
					var result = cfobject.getQueryAttrs(argumentCollection=args);
					expect(structKeyExists(result, "blockfactor")).toBeFalse();
				}
			);
		});
	}
}
