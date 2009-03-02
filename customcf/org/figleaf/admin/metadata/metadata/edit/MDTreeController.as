import org.waxpraxis.buzz.BZNoteCenter;
import MDTreeModel;

class MDTreeController {
	
	// PRIVATE MEMBERS
	
	private var view:MovieClip;
	private var model:MDTreeModel;
	
	// CONSTRUCTOR
	
	public function MDTreeController (v:MovieClip,sp:String,g:String,d:String) {
		var test:Boolean;
		// initialize central event dispatcher
		BZNoteCenter.addObserver(this, null, "getTreeDataResult")
		BZNoteCenter.addObserver(this, null, "updateProgress")
		BZNoteCenter.addObserver(this, null, "saveDone")
		BZNoteCenter.addObserver(this, null, "treeChanged");
		
		// initialize view
		view = v;
		
		// view add button event handler
		view.btnAdd._owner = this;
		view.btnAdd.clickHandler = function () {
			if (this._parent.add_txt.text != "") {
				this._owner.addNode(this._parent.add_txt.text, Number(this._parent.myTree.getSelectedNode().attributes.id));
				this._parent.add_txt.text = "";
			}
		}
		
		// edit button event handler
		view.editForm.btnEdit._owner = this;
		view.editForm.btnEdit._tree = view.myTree;
		view.editForm.btnEdit.clickHandler = function() {
			this._owner.editNode(this._parent.editLabel.text,this._parent.translateLabel.text, this._parent.urlLabel.text,this._tree.getSelectedNode());
			this._parent.editLabel.text = this._parent.translateLabel.text = this._parent.urlLabel.text = '';
		}
		
		// view delete button event handler
		view.btnDelete._owner = this;
		view.btnDelete.clickHandler = function ()  {
			this._owner.deleteNode(this._parent.myTree.getSelectedNode().attributes.id);
		}
		
		// view save button event handler
		view.btnSave._owner = this;
		view.btnSave.clickHandler = function () {
			this._owner.saveTree();
		}
		
		// view deselect button event handler
		view.btnDeselect.useHandCursor = false;
		view.btnDeselect._owner = this;
		view.btnDeselect.onRelease = function () {
			
			// deselect all from tree
			this._owner.deselectAll();
		}
		
		// component styles
		_global.style.setStyle("themeColor", "haloBlue");
		_global.style.setStyle("embedFonts", true);
		_global.style.setStyle("fontFamily", "FFF Alias");
		_global.style.setStyle("fontSize", 10);
		
		// initialize model
		model = new MDTreeModel(sp,g,d);
		
		// initialize progress bar
		view.pBar._visible = true;
		view.pBar.message.autoSize = true;
		view.pBar.message.text = "Loading Tree Data...";
		
		model.getData(1);
	}
	
	// EVENT HANDLERS
	
	public function getTreeDataResult (eventObj:Object):Void {
		view.pBar.stop();
		view.pBar._visible = false;
		view.myTree.setDataProvider(eventObj.data.dp, eventObj.data.md);
		if (typeof(eventObj.data.sn) != 'undefined') {
			view.myTree.setSelectedNode(eventObj.data.sn);
			treeChanged(null);
		}
	}
	
	public function updateProgress (eventObj:Object):Void {
		trace("UpdateProgress with '" + eventObj.data + "'");
		view.pBar._visible = true;
		view.pBar.message.text = eventObj.data;
		view.pBar.gotoAndPlay(1);
	}
	
	public function saveDone (eventObj:Object):Void {
		view.pBar._visible = false;
		view.pBar.stop();
		trace("savedone");
	}
	
	function treeChanged(eventObj:Object):Void {
		var editNode = view.myTree.getSelectedNode();

		view.editForm.editLabel.text = editNode.attributes.label;
		view.editForm.translateLabel.text = editNode.attributes.translation;
		view.editForm.urlLabel.text = editNode.attributes.url;
		view.editForm.enabled = true;
	}
	
	// PUBLIC METHODS
	
	public function addNode (label:String, parentId:Number):Void {
		// add node to model
		model.addNew(label, parentId);
	}
	
	public function editNode (label:String, translation:String, url:String, origNode:XMLNode):Void {
		model.editNode(Number(origNode.attributes.id),label,translation,url,Number(origNode.attributes.parentId));
	}
	
	public function deleteNode (nodeId:Number):Void {
		model.deleteNode(nodeId);
		view.myTree.setSelectedNode(view.myTree.getSelectedNode());
	}
	
	public function saveTree ():Void {
		trace("Saving tree data...");
		BZNoteCenter.postNamedNote("updateProgress", this, "Serializing tree data...");
		model.saveTree();
	}
	
	public function deselectAll ():Void {
		view.myTree.setSelectedNode(null);
		clearEditForm();
	}
	
	public function clearEditForm():Void {
		view.editForm.editLabel.text = '';
		view.editForm.translateLabel.text = '';
		view.editForm.urlLabel.text = '';
		view.editForm.enabled = false;
	}
}