/* This file is part of Mura CMS. */

/*    Mura CMS is free software: you can redistribute it and/or modify */
/*    it under the terms of the GNU General Public License as published by */
/*    the Free Software Foundation, Version 2 of the License. */

/*    Mura CMS is distributed in the hope that it will be useful, */
/*    but WITHOUT ANY WARRANTY; without even the implied warranty of */
/*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
/*    GNU General Public License for more details. */

/*    You should have received a copy of the GNU General Public License */
/*    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. */


// to allow tabbing to objects in mac mozilla enter the following
// about:config
// edit accessibility.tabfocus set the value 7

/*function init(){
  initRatings('rater1');
}
*/
var agt   = navigator.userAgent.toLowerCase();
var mac   = agt.indexOf("mac") != -1;
var macIe = mac && document.all;

var gYOUR_RATING ='';
//var gYOUR_RATING ='Your Rating: ';
var gDEFAULT_TEXT ='Recommend It: ';

if (!document.getElementById && document.all)
	document.getElementById = function(id)
	{
		return document.all[id];
	}

function starImg(val)
{
  return themepath + "/images/rater/star_" + starString(val) + ".gif";
}

function starString(val)
{

       if (val <=  0) num = "zero";
  else if (val <   1) num = "half";
  else if (val < 1.5) num = "one";
  else if (val <   2) num = "onehalf";
  else if (val < 2.5) num = "two";
  else if (val <   3) num = "twohalf";
  else if (val < 3.5) num = "three";
  else if (val <   4) num = "threehalf";
  else if (val < 4.5) num = "four";  
  else if (val <   5) num = "fourhalf";
  else if (val >=  5) num = "five";  

  return num;
}

String.prototype.pluralize = function(count, plural)
{
  if (plural == null)
    plural = this + 's';
	
  return (count == 1 ? this : plural)
}

function setRating(rating, votes, avg)
{
  vt = document.getElementById("numvotes");
  vt.innerHTML = votes + String(" vote").pluralize(votes);

  // round to one digit
  avg = Math.round(avg * 10) / 10;

  stars = document.getElementById("ratestars");
  stars.alt = avg + String(" star").pluralize(avg);
  stars.src = starImg(avg);

  for (i = 1; i <= 5; i++)
  {
    radio = document.getElementById("rater1_rater_input0radio" + i);

    if (i == rating)
      radio.checked = true;
    else
      radio.checked = false;
  }
}


function initRatings(formName)
{
	if (!document.getElementById) return;
	//if (document.styleSheets) 
	//{
		//if (document.styleSheets[0].disabled) return;
	//}
	
	
	var i=0; 
	var forms = document.getElementsByName(formName);
	var form = (forms) ? forms[0] : null;

	if (!form) return false;
	
	while (i >=0)
	{
		var sInputName = formName + '_rater_input' + i;
		var oInputs = document.getElementsByName(sInputName);
		if (oInputs[0])
		{
			if (oInputs[0].nodeName =='SELECT')	gatherSelectAttributes(oInputs[0], formName);
			else if (oInputs[0].nodeName =='INPUT' && oInputs[0].type == 'radio') gatherRadioAttributes(oInputs, formName);
			i++;
		}
		else i = -1;
	}
}

function gatherRadioAttributes(pRadios, pForm)
{
	var curSelectedIndex = -1;
	var nRadioLength = pRadios.length;
	var oRadioContainer = pRadios[0].parentNode.parentNode;
	
	var oLegend = oRadioContainer.getElementsByTagName('LEGEND');
	var defaultText =  (oLegend[0]) ? oLegend[0].innerHTML : '';
	var oRadioValuesLabels = new Array();
	var inputName = pRadios[0].name;
	var className = pRadios[0].className;	
	for (var i = 0 ; i < nRadioLength ; i++)
	{
		var oCurRadio = pRadios[i];
		var radioValueLength =oRadioValuesLabels.length;
		oRadioValuesLabels[radioValueLength] = new Array();
		var curRadioValues =oRadioValuesLabels[radioValueLength] 
		curRadioValues['value'] =  (oCurRadio.value) ? oCurRadio.value : i;
		if (!macIe)	curRadioValues['label'] =  (oCurRadio.nextSibling.data) ? oCurRadio.nextSibling.data : gDEFAULT_TEXT;
		else curRadioValues['label'] =  (oCurRadio.parentNode.innerText) ? oCurRadio.parentNode.innerText : gDEFAULT_TEXT;
		if (oCurRadio.checked) curSelectedIndex = i;
	}
	var appendTo = oRadioContainer.parentNode;
	appendTo.removeChild(oRadioContainer);
	createRater(inputName,appendTo, oRadioValuesLabels, curSelectedIndex, className, defaultText , pForm);	
}


function gatherSelectAttributes(pInput , pForm)
{	
	var oInputOptions = pInput.getElementsByTagName('OPTION');
	var curSelectedIndex = -1;
	var defaultText = '';
	var nInputOptionLength = oInputOptions.length;
	var oOptionValuesLabels = new Array();
	var inputName = pInput.name;
	var className = pInput.className;
	for (var i = 0 ; i < nInputOptionLength ; i++)
	{

		var oCurOption = oInputOptions[i];
		if (oCurOption.value != -1)
		{
			var optionValueLength =oOptionValuesLabels.length;
			oOptionValuesLabels[optionValueLength] = new Array();
			var curOptionValues =oOptionValuesLabels[optionValueLength] 
			curOptionValues['value'] =  (oCurOption.value) ? oCurOption.value : i;
			curOptionValues['label'] =  (oCurOption.innerHTML) ? oCurOption.innerHTML : "";
			if (oCurOption.selected) curSelectedIndex = i-1;
		}
		else defaultText = (oCurOption.innerHTML) ? oCurOption.innerHTML : gDEFAULT_TEXT;
	}
	var appendTo = pInput.parentNode;
	appendTo.removeChild(pInput);
	createRater(inputName,appendTo, oOptionValuesLabels, curSelectedIndex, className, defaultText , pForm);
}

function createRater(pName, pAppendTo, pOptionValuesLabels, pCurSelectedIndex, pClassName, pDefaultText , pForm)
{
	
	var oContainer = document.createElement('DIV');
	oContainer.className = pClassName;
	oContainer.id = pName+'_container';
	oContainer.labelsValues = pOptionValuesLabels;
	oContainer.selectedIndex = pCurSelectedIndex;
	oContainer.formId = pForm;
	var nElemsToAdd = pOptionValuesLabels.length;
	var textP = document.createElement('P');
	textP.id = pName+ '_text';
	/*var	hiddenField;
	if (!macIe) 
	{
		hiddenField = document.createElement('INPUT');
		hiddenField.type = 'hidden';
	}
	else hiddenField = document.createElement('<INPUT type="hidden">');
	
	hiddenField.name = pName;
	hiddenField.id = pName;*/
	
	//textP.innerHTML = ( pCurSelectedIndex >=0 ) ? gYOUR_RATING : pDefaultText;
	
	oContainer.textElemId = textP.id;
	oContainer.appendChild(textP);
	oContainer.defaultText = pDefaultText;
	var oElements = new Array();
	
	for ( var i = 0; i < nElemsToAdd; i++ )
	{
		var oElem = document.createElement('A');
		oElem.href="#";
		
		oElem.onmouseover = raterMouseOver;
		oElem.onfocus = raterMouseOver;
		oElem.onmouseout = raterMouseOut;
		oElem.onblur = raterMouseOut;		
		oElem.onclick = raterClick;
		oElem.containerId = oContainer.id;		
		oElem.index = i;
		var className = ''
		if (pCurSelectedIndex != -1 && i <= pCurSelectedIndex)
		{
				className = 'selected';
				
		}
		var separator = (className != '') ? ' ' : '';
		var classNamePrefix = (i%2) ? 'odd'+separator : 'even'+separator;

		oElem.className = classNamePrefix + className;
		oContainer.appendChild(oElem);
		oElements[oElements.length] = oElem;
	}
	
		
	//hiddenField.value = pCurSelectedIndex;
	
	//oContainer.hiddenFieldId = hiddenField.id ;
	oContainer.ratingElements = oElements;
	//oContainer.appendChild(hiddenField);

	var clearDiv = document.createElement('DIV');
	clearDiv.className = 'clr';

	oContainer.appendChild(clearDiv);
	pAppendTo.appendChild(oContainer);
	
}


function raterMouseOver()
{
	var container = document.getElementById(this.containerId);
	var elements = container.getElementsByTagName('A');
	var numElements = elements.length;
	for (var i = 0; i < numElements; i++)
	{
		var curElem = elements[i];
		var selectedIndex  =  container.selectedIndex;
		var className = '';
		if ( selectedIndex > -1)
		{
			if (i <= selectedIndex && i <= this.index ) className = 'selectedover';
			else if (i <= selectedIndex &&  i > this.index) className = 'selectedless';
			else if (i > selectedIndex && i <= this.index) className = 'over';
			else if ( i > selectedIndex && i > this.index ) className = '';
		}
		else 
		{
			if (i <= this.index) className ='over'
		}
		var separator = (className != '') ? ' ' : '';
		var classNamePrefix = (i%2) ? 'odd'+separator : 'even'+separator;
		curElem.className = classNamePrefix + className;
	}
	//var textElem = document.getElementById(container.textElemId);
	//textElem.innerHTML = container.labelsValues[this.index]['label'];
}

function raterMouseOut()
{
	var container = document.getElementById(this.containerId);
	var elements = container.getElementsByTagName('A');
	var numElements = elements.length;
	for (var i = 0; i < numElements; i++)
	{
		var curElem = elements[i];
		var selectedIndex  =  container.selectedIndex;
		var className = (selectedIndex != -1 && selectedIndex >= i) ? 'selected' : '';
		var separator = (className != '') ? ' ' : '';
		var classNamePrefix = (i%2) ? 'odd'+separator : 'even'+separator;
		curElem.className = classNamePrefix + className;
	}
	//var textElem = document.getElementById(container.textElemId);
	//textElem.innerHTML = (container.selectedIndex > -1) ? gYOUR_RATING  : container.defaultText;
}

function raterClick()
{

	var container = document.getElementById(this.containerId);
	
	var elements = container.getElementsByTagName('A');
	var numElements = elements.length;
	for (var i = 0; i < numElements; i++)
	{
		var curElem = elements[i];
		var className = (i <= this.index) ? 'selectedover' : '';
		var separator = (className != '') ? ' ' : '';
		var classNamePrefix = (i%2) ? 'odd'+separator : 'even'+separator;
		curElem.className = classNamePrefix + className;
		container.selectedIndex =this.index;		
	}
	var textElem = document.getElementById(container.textElemId);
	
	//textElem.innerHTML = (container.selectedIndex != -1) ? gYOUR_RATING : container.defaultText;		
	var hiddenField = document.getElementById('rate');
	hiddenField.value = container.labelsValues[container.selectedIndex]['value'];
	
	
	if(document.getElementById(container.formId).userID.value != ''){
		
		saveRate(container.formId);
	
	} else {
		
		location.href=document.getElementById(container.formId).loginURL.value + document.getElementById(container.formId).rate.value;
		
	}
	return false;
}

function showRatingResponse(resp)
{
	var r= eval( '(' + resp + ')' );
	document.getElementById("numvotes").innerHTML=r.data.THECOUNT + String(" vote").pluralize(r.data.THECOUNT);
	document.getElementById("avgratingstars").setAttribute("class","ratestars " + starString(r.data.THEAVG));

	return false;
}