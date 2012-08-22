/**
 * @author Bilal Soylu
 * Libary of JS functions to be used during setup of Mura
 */


function fHandleAutoCreateChange() {
	//assists the setup and determines which options to display
	//for some databases we can create the db and ds automatically
	
	var fldDB = document.getElementById("production_dbtype");
	var blnAutoCreate = false; //determine display options
	var autoCreateRB = document.getElementById("auto_create_on");
	var sDBName=fldDB[fldDB.selectedIndex].value;
	//alert ("click " + selectedDB[selectedDB.selectedIndex].value);
	
	if (sDBName == "mysql"){
		//turn on options
		
	}
	switch(sDBName) {
	case "mysql": case "mssql": 
		blnAutoCreate=true;
		//enable radio button
		document.getElementById("auto_create_on").disabled=false;
		document.getElementById("auto_create_off").disabled=false;
		document.getElementById("oracle-only").style.display='none';		
		break;
	case "oracle": case "h2":
		//disable auto create for oracle		
		blnAutoCreate=false;
		document.getElementById("auto_create_on").disabled=true;
		document.getElementById("auto_create_off").disabled=true;
		document.getElementById("auto_create_off").checked=true;
		document.getElementById("oracle-only").style.display='';
		break;
	}

	//toggle visibility
	if (autoCreateRB.checked && blnAutoCreate) {
		document.getElementById("ac_dsn_span").style.display = "none";
		document.getElementById("ac_cfpass_span").style.display = "block";
		document.frm.production_dbusername.focus();
	} else {
		document.getElementById("ac_dsn_span").style.display = "block";
		document.getElementById("ac_cfpass_span").style.display = "none";
		document.frm.production_dbusername.focus();
		
	}

}

