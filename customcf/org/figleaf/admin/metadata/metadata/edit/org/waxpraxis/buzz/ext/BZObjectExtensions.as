class org.waxpraxis.buzz.ext.BZObjectExtensions {
	static var setPropFlags = eval("ASSetPropFlags"+"");
	static var objectClass = eval("Object"+"");
    
	static function addObjectUID():Boolean {
		
		// top most UID
		objectClass._topUID_ = 0;
		
		// table of object UIDs
		objectClass._objTable_ = new Object();
		
		// method to get/add UID
		Object.prototype.getUID = function() {
			if (this._UID_ == null) {
				this._UID_ = objectClass._topUID_++;
				objectClass._objTable_[this._UID_] = this;
				setPropFlags(this, ["_UID_"], 7);
			}
			return this._UID_;
		}
		setPropFlags(objectClass.prototype, ["getUID"], 7);
		
		// method to find object based on ID
		_global.getObjectByUID = function(UID):Object {
			return objectClass._objTable_[UID];
		}
		setPropFlags(_global, ["getObjectByUID"], 7);
		
		// method to remove an object that has a UID
		_global.deleteObject = function(obj:Object):Void {
			var UID = obj.getUID();
			delete objectClass._objTable_[UID];
			delete obj;
		}
		setPropFlags(_global, ["deleteObject"], 7);
		
		return true;
	}
	
	static var doneUID:Boolean = addObjectUID();
}