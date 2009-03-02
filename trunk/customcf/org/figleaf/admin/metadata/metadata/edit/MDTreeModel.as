import org.waxpraxis.buzz.BZNoteCenter;
import mx.remoting.NetServices;

class MDTreeModel {
	
	// PRIVATE MEMBERS
	
	private var metadata:Array; 		// flat array of reference to XML Nodes in dataProvider (for access)
	private var dataProvider:XML;		// dataProvider for tree
	private var nc:NetConnection;		// netConnection to remoting gateway
	private var service:Object;			// reference to remote java object
	private var savedMetadata:Array;	// array of objects reflecting the metadata tree to be saved
	private var gateway:String;			// Flash Services gateway path
	private var servicePath:String;		// CFC path
	private var datasource:String; 		// datasource to be passed to CFC calls
	private var changeArray:Array;		// array of change objects for data synchronization
	private var treeID:Number;			// the metadata tree that we are working with in this model
	private var lastKeyword:String;		// the metadata keyword that was last edited, deleted, or added
	
	// CONSTRUCTOR
	
	public function MDTreeModel (sp:String,g:String,d:String) {
		
		gateway = g;
		servicePath = sp;
		datasource = d;
		
		changeArray = new Array();
		
		// initialize flash remoting
		nc = NetServices.createGatewayConnection(gateway);
		service = nc.getService(servicePath);
	}
	
	// PUBLIC METHODS
	
	// getData - 	get the array of references to XML nodes of tree; if XML doesn't exist yet, method 
	//				retrieves it from remote java object; return always occurs through event handler
	public function getData (treeId:Number):Void {
		treeID = treeId;
		// 1/16/08 - Lisa Backer - always reload the data when called to allow for new ids, etc.
		// if metadata array doesn't exist
		//if (metadata == null) {
			
			// instantiate metadata array
			metadata = new Array();
			
			// instantiate dataProvider
			dataProvider = new XML("<node />");
			
			// call remote method to retrieve tree data
			service.treeGet(this, treeId, datasource);
		//}
		
		// otherwise, model already has metadata from remote java object
		//else {
			
			// broadcast getTreeDataResult event
			//BZNoteCenter.postNamedNote("getTreeDataResult", this, metadata);
		//}
	}
	
	// addNew -	takes label of new node to add as well as id of parent to which it should be added;
	//			adds new node to chosen parent
	public function addNew (label:String, parentId:Number):Void {
		// local variable to hold new id of new node; if new node has no parent, give new node id of 1
		var newId:Number = ((parentId == null)||(isNaN(parentId))) ? 1 : (parentId + 1);
		var translation:String = label; // set translation to be the same as the label for first-time creation
		
		lastKeyword = label;
		
		// find available id for new node to keep ids unique
		while (metadata[newId] != null) {newId++;}

		var node:XMLNode = createNode(newId, parentId, label, translation, '');
		// add new node to tree
		addNewNode(node);
		
		// broadcast getTreeDataResult event
		BZNoteCenter.postNamedNote("getTreeDataResult", this, {dp:dataProvider, md:metadata, sn:node});
		
		var changeObj:MDChangeObject = new MDChangeObject();
		changeObj.action = MDChangeObject.ADD;
		changeObj.id = String(newId);
		changeObj.label = label;
		changeObj.translation = translation;
		if (!isNaN(parentId)) {
			changeObj.parentId = String(parentId);
		}
		changeArray.push(changeObj);
	}
	
	public function editNode(nodeId:Number,label:String,translation:String,url:String,parentId):Void {
		lastKeyword = label;
		
		// synchronization with database
		var changeObj:MDChangeObject = new MDChangeObject();
		changeObj.action = MDChangeObject.EDIT;
		changeObj.label = label;
		changeObj.translation = translation;
		changeObj.url = url;
		changeObj.id = String(nodeId);
		if (!isNaN(parentId)) {
			changeObj.parentId = parentId;
		}
		changeArray.push(changeObj);
		
		// set attributes in metadata (parent and id should remain unchanged)
		var node:XMLNode = metadata[nodeId];
		node.attributes.label = label;
		node.attributes.translation = translation;
		node.attributes.url = url;

		BZNoteCenter.postNamedNote("getTreeDataResult", this, {dp:dataProvider, md:metadata});
	}
	
	// deleteNode - takes id of the node to remove; removes a given node from tree
	public function deleteNode (nodeId:Number):Void {
		lastKeyword = null;
		// remove node from dataProvider & metadata array
		metadata[nodeId].removeNode();	
		delete metadata[nodeId];
		
		// broadcast getTreeDataResult event
		BZNoteCenter.postNamedNote("getTreeDataResult", this, {dp:dataProvider, md:metadata});
		
		var changeObj:MDChangeObject = new MDChangeObject();
		changeObj.action = MDChangeObject.DELETE;
		changeObj.id = String(nodeId);
		changeArray.push(changeObj);
	}
	
	// saveTree - serializes tree and sends to remove java object
	public function saveTree ():Void {
		
		// get local copy of tree dataProvider
		var dpTree:XML = dataProvider;
		
		// instantiate array to hold serialized data
		savedMetadata = new Array();
		
		// get a local copy of the first child of the root node of the tree
		var node:XMLNode = dpTree.firstChild.firstChild
		
		//trace("Save Tree");
		// save tree data
		saveNode(node);
		
		service.treeSave(this, datasource, treeID, changeArray);
		changeArray = new Array(); // clear out the change list for the next round of changes
		
		// TESTING
		/*
		for (var i = 0; i < savedMetadata.length; ++i) {
			trace("SAVEDMETADATA[" + i + "] = ");
			trace("    label = " + savedMetadata[i].metadataKeyword);
			trace("    id = " + savedMetadata[i].metadataDataId);
			trace("    parentId = " + savedMetadata[i].metadataParentId);
		}
		*/
		// broadcast saveDone event
		BZNoteCenter.postNamedNote("saveDone", this, null);
		
		getData(treeID); // reload data to synch up new id values
	}
	
	// PRIVATE METHODS
	
	// onResult - flash remoting call result event handler
	private function onResult (results:Array):Void {
		var sn:XMLNode;
		
		// broadcast updateProgress event
		BZNoteCenter.postNamedNote("updateProgress", this, "Parsing tree data...");
		
		// loop through results and extract tree data
		var resultsLength:Number = results.length;
		for (var i = 0; i < resultsLength; ++i) {
			var newNode = createNode(results[i].METADATADATAID, results[i].METADATAPARENTID, results[i].METADATAKEYWORD, results[i].TRANSLATION, results[i].URL);
			if (results[i].METADATAKEYWORD == lastKeyword) {
				sn = newNode;
			}
			
			// add new node to tree
			//trace(newNode);
			addNewNode(newNode);
		}
		
		// broadcast getTreeDataReult event
		//trace(metadata[1]);
		//trace(dataProvider.firstChild.firstChild.firstChild);
		BZNoteCenter.postNamedNote("getTreeDataResult", this, {dp:dataProvider, md:metadata, sn:sn});
	}
	
	// addNewNode -	takes the new XMLNode to be added; adds node to metadata array and dataprovider
	private function addNewNode (node:XMLNode):Void {
		//trace("ADDING " + node.attributes.id + "|" + node.attributes.label + ' parent: ' + node.attributes.parentId);
		// add node to array, keyed on its id
		metadata[node.attributes.id] = node;
		
		// add node to its parent if its parent id exists
		if (node.attributes.parentId != null) {
			//trace("    a child of " + metadata[node.attributes.parentId].attributes.label);
			metadata[node.attributes.parentId].appendChild(node);
		} else {
			// otherwise, add it to the dataProvider
			//trace("    a parent node");
			dataProvider.firstChild.appendChild(node);
		}
	}
		
	// saveNode - recursive method to help save the tree data
	private function saveNode (node:XMLNode):Void {
		
		// create a locally scoped object
		var obj:Object = new Object();
		
		// add node attributes to object
		obj.metadataKeyword = node.attributes.label;
		obj.metadataDataId = Number(node.attributes.id);
		obj.url = node.attributes.url;
		obj.translation = node.attributes.translation;
		
		// only add parentId attribute if node has a parent
		if (node.attributes.parentId != undefined) {
			obj.metadataParentId = Number(node.attributes.parentId);
		}
		
		// add object to saved data array
		savedMetadata.push(obj);
		
		// if firstChild exists, travel to first child
		if (node.firstChild != null) {
			saveNode(node.firstChild);
		}
		
		// else, if nextSibling exists, travel to next sibling
		if (node.nextSibling != null) {
			saveNode(node.nextSibling);
		}
	}
	
	private function createNode(id, parentId, label, translation, url):XMLNode {
		var str:String = "<node";
		str += " label='" + label + "'";
		str += " id='" + id + "'";
		str += " translation='" + translation + "'";
		str += " url='" + url + "'";
		if ((parentId != null)&&(!(isNaN(parentId)))) {
			str += " parentId='" + parentId + "'";
		}
		str += "/>";
		
		var node = new XML(str);
		node.ignoreWhite = true;
		return node.firstChild;
	}
}