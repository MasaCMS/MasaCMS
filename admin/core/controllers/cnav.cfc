component extends="controller" output="false" {

	public function setSettingsManager(settingsManager) output=false {
		variables.settingsManager=arguments.settingsManager;
	}

	/**
	 * @ouput false
	 */
	public function searchsitedata(rc) {
		arguments.rc.rsList=variables.settingsManager.getUserSites(
		session.siteArray,
		listFind(session.mura.memberships,'S2'),
		rc.searchString,
		-1
	);
		//  // unlimited maxRows because of minLength trigger of autocomplete set to 2
	}

}
