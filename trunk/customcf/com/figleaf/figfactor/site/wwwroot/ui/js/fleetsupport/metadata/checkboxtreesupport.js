
// You can find general instructions for this file here:
// http://www.treeview.net
// Intructions on how to add checkboxes to a tree are only provided in this file.


USETEXTLINKS = 0 
STARTALLOPEN = 0
HIGHLIGHT = 0
PERSERVESTATE = 0
USEICONS = 0

// In this case we want the whole tree to be built,
// even those branches that are closed. The reason is that
// otherwise some form elements might not be built at all
// before the user presses "Get Values"
BUILDALL = 0


// This configuration file is used to demonstrate how to add checkboxes to your tree.
// If your site will not display checkboxes, pick a different configuration file as 
// the example to follow and adapt.

// Notes:
// If you are going to set USEICONS = 1, then you will want to edit the gif files and 
// remove the white space on the right


// Auxiliary functions for the contruction of the tree
// You will mcertainly want to change these functions for your own purposes

// If you want to add checkboxes to the folder you will have to create a function 
// similar to this one to do that and call it below in the tree construction section

// These functions are directly related with the additional JavaScript in the 
// page holding the tree (demoCheckbox.html), where the form handling code
// resides
function gCB(parentfolderObject,itemLabel,checkBoxDOMId,metaID,bchecked) {
	var newObj;

	// Read the online documentation for an explanation of insDoc and gLnk,
    // they are the base of the simplest Treeview trees
	newObj = insDoc(parentfolderObject, gLnk("R", itemLabel, "javascript:op()"))

    // The trick to show checkboxes in a tree that was made to display links is to 
	// use the prependHTML. There are general instructions about this member
    // in the online documentation
	if (bchecked) {
		newObj.prependHTML = '<td valign=middle><input type="checkbox" id="' + checkBoxDOMId + '"' + ' onClick="fnCheckbox(this,' + metaID + ')" checked></td>';
	} else {
		newObj.prependHTML = '<td valign=middle><input type="checkbox" id="' + checkBoxDOMId + '"' + ' onClick="fnCheckbox(this,' + metaID + ')"></td>';
	}
}
 
function gCB2(a,b,c,checkBoxDOMId,metaID,bchecked) {
		
	var newObj;
	newObj =  insFld(a, gFld(b, c));
	if (bchecked) {
		newObj.prependHTML = '<td valign="middle"><input type="checkbox" id="' + checkBoxDOMId + '"' + ' onClick="fnCheckbox(this,' + metaID + ')" checked></td>';
	} else {
		newObj.prependHTML = '<td valign="middle"><input type="checkbox" id="' + checkBoxDOMId + '"' + ' onClick="fnCheckbox(this,' + metaID + ')"></td>';
	}
	return newObj;
}


function op() { //This function is used with folders that do not open pages themselves. See online docs.
}

function addToList(fieldname,idata) {
	for (var i=0; i<document.forms.length; i++) {
		if (document.forms[i][fieldname]) {
			var obj = document.forms[i][fieldname];
			break;
		}
	}
	var aData = obj.value.split(',');
	for (var i=0; i<aData.length; i++) {
		if (aData[i] == idata) {
			return;
		}
	}
	aData[aData.length] = idata;
	obj.value = aData.join(',');
	if (obj.value.charAt(0) == ',') {
		obj.value = '0' + obj.value;	
	}
}

function delFromList(fieldname,idata) {
	var obj = document.forms[0][fieldname];
	var nData = new Array();
	var aData = obj.value.split(',');
	for (var i=0; i<aData.length; i++) {
		if (aData[i] != idata) {
			nData[nData.length] = aData[i];
		}
	}
	obj.value = nData.join(',');
	if (obj.value.charAt(0) == ',') {
		obj.value = '0' + obj.value;	
	}
}

function prefillcheckboxes(ldefault,sprefix) {
	var aDefaults = ldefault.split(',');
	for (var i=0; i<aDefaults.length; i++) {
		if (aDefaults[i] != '' && aDefaults[i] != 0) {
			document.all[sprefix + aDefaults[i]].checked = true;
		}
	}
}
