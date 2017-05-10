/**
 * Trash item bean
 */
component extends="mura.cfobject" output="false" hint="Trash item bean" {
	variables.trashManager="";

	public function setTrashManager(trashManager) output=false {
		variables.trashManager=arguments.trashManager;
		return this;
	}

	public function setAllValues(instance) output=false {
		variables.instance=arguments.instance;
		return this;
	}

	public function getAllValues() output=false {
		return variables.instance;
	}

	public function getObjectID() output=false {
		return variables.instance.objectID;
	}

	public function getSiteID() output=false {
		return variables.instance.siteID;
	}

	public function getParentID() output=false {
		return variables.instance.parentID;
	}

	public function getObjectClass() output=false {
		return variables.instance.objectClass;
	}

	public function getObjectLabel() output=false {
		return variables.instance.objectLabel;
	}

	public function getObjectType() output=false {
		return variables.instance.objectType;
	}

	public function getObjectSubType() output=false {
		return variables.instance.objectSubType;
	}

	public function getDeletedDate() output=false {
		return variables.instance.deletedDate;
	}

	public function getDeletedBy() output=false {
		return variables.instance.deletedBy;
	}

	public function getDeleteID() output=false {
		return variables.instance.deleteID;
	}

	public function getOrderNO() output=false {
		return variables.instance.orderno;
	}

	public function getObject() output=false {
		return variables.trashManager.getObject(variables.instance.objectID);
	}

}
