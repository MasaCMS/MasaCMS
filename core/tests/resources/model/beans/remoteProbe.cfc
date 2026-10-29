component entityName="testRemoteProbe" extends="mura.bean.bean" {

	remote any function returnsJSONObjectString(method,entityname,fieldnames,siteid) {
		return serializeJSON({"probe": 1});
	}

	remote any function returnsBooleanString(method,entityname,fieldnames,siteid) {
		return "true";
	}

}
