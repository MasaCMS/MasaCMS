function addObject(availableList,publicList,privateList){
   if(document.getElementById(availableList)==null
	|| document.getElementById(availableList).selectedIndex ==-1){
	   alert("Please select a field."); return false;}
   var selectedObjects =document.getElementById(publicList);
   var addIndex = document.getElementById(availableList).selectedIndex;
   
   if(addIndex < 0)return;
   
   var addoption =document.getElementById(availableList).options[addIndex]; 
 
	if(selectedObjects.options.length){
		
		for (var i=0;i < selectedObjects.options.length;i++){ 
		
			if(selectedObjects.options[i].value == addoption.value) {
			selectedObjects.selectedIndex=i;
			return;
			}
		}
	}
	
	var myoption = document.createElement("option");
	document.getElementById(publicList).appendChild(myoption);
	myoption.text     = addoption.text;
	myoption.value    = addoption.value;
	myoption.selected = "selected"
	
	updateList(publicList,privateList);
	
}

function deleteObject(publicList,privateList){
   var selectedObjects =document.getElementById(publicList);
   var deleteIndex =selectedObjects.selectedIndex;
   var len = (selectedObjects.options.length > 1)?selectedObjects.options.length-1:0;
   if(deleteIndex < 0) return;
	
	selectedObjects.options[deleteIndex]=null; 
	updateList(publicList,privateList);
	if(selectedObjects.options.length){
		selectedObjects.options[selectedObjects.options.length-1].selected=true;
	}
	 
}

function updateList(publicList,privateList){
	var selectedObjects =document.getElementById(publicList);
	 var objectList=document.getElementById(privateList)
	 objectList.value=""; 
	for (var i=0;i<selectedObjects.options.length;i++){ 
		if(objectList.value!=""){
			objectList.value += "^" + selectedObjects.options[i].value; 
		}
		else
		{
			objectList.value = selectedObjects.options[i].value; 
		}
	}

}

function moveUp(publicList,privateList){
var selectedObjects=document.getElementById(publicList);
var moverIndex=selectedObjects.selectedIndex;
if(moverIndex<1)return;

var moveroption = document.createElement("option");
var movedoption = document.createElement("option");

moveroption.text = selectedObjects.options[moverIndex].text; 
moveroption.value = selectedObjects.value;
moveroption.selected = "selected"

movedoption.text = selectedObjects.options[moverIndex-1].text;
movedoption.value = selectedObjects.options[moverIndex-1].value;

selectedObjects[moverIndex-1]=moveroption;
selectedObjects[moverIndex]=movedoption;

updateList(publicList,privateList);
}

function moveDown(publicList,privateList){
var selectedObjects=document.getElementById(publicList);
var moverIndex=selectedObjects.selectedIndex;
if(moverIndex ==selectedObjects.length-1)return;

var moveroption = document.createElement("option");
var movedoption = document.createElement("option");

moveroption.text =selectedObjects.options[moverIndex].text; 
moveroption.value = selectedObjects.options[moverIndex].value;
moveroption.selected = "selected"

movedoption.text =  selectedObjects.options[moverIndex+1].text;
movedoption.value = selectedObjects.options[moverIndex+1].value;


selectedObjects.options[moverIndex+1]=moveroption;
selectedObjects.options[moverIndex]=movedoption;

updateList(publicList,privateList);

}