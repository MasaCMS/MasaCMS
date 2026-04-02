<!---
CSRF Security Test Suite Runner
Purpose: Run all CSRF-related tests for CVE-2025-55040 through CVE-2025-55046
--->
<cfscript>
	// TestBox Setup
	testbox = new testbox.system.TestBox({
		bundles = [
			// Unit Tests
			"core.tests.specs.mura.admin.controllers.cformTest",
			"core.tests.specs.mura.admin.controllers.cusersTest",
			"core.tests.specs.mura.admin.controllers.csettingsTest",
			"core.tests.specs.mura.admin.controllers.ctrashTest",

			// Security Tests
			"core.tests.specs.mura.admin.security.csrfAttackPreventionTest",

			// Integration Tests
			// "core.tests.specs.mura.admin.integration.csrfIntegrationTest"
		],
		reporter = url.reporter ?: "simple",
		labels = url.labels ?: ""
	});

	// Run tests
	results = testbox.run();

	// Output results
	writeOutput(results);
</cfscript>
