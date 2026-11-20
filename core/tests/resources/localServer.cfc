component {

	/**
	 * The port the current request was accepted on inside the container.
	 *
	 * Specs that call the server over HTTP must connect to this port, not to
	 * cgi.server_port: the latter reports the externally mapped Docker port
	 * (e.g. 18181 or 18280), which nothing inside the container can reach.
	 *
	 * Lucee and ACF expose the servlet request through getPageContext();
	 * BoxLang has no servlet request there, but its exchange reports the
	 * same local port.
	 */
	public numeric function port() {
		if (structKeyExists(server, "boxlang")) {
			return getPageContext().getExchange().getRequestLocalPort();
		}
		return getPageContext().getRequest().getLocalPort();
	}

}
