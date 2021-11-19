/* license goes here */
component output="false" {
	public function onRequestStart() {
		writeOutput("Access Restricted.");
		abort;
	}

}
