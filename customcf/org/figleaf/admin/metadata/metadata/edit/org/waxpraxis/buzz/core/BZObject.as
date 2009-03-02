class org.waxpraxis.buzz.BZObject {
	private var _keys_:Object;
	private var _delegate_:Object;
	
	public function BZObject(){
		
	}

	public function setDelegate(delegate:Object):Void {
		_delegate_ = delegate;
	}
	
	public function addObserverForKey(observer:Object, key:String):Boolean {
		var id = observer.getUID();
		if (_keys_[key] == null) {
			_keys_[key] = new Object();
		}
		_keys_[key][id] = observer;
		
		return true;
	}
	
	public function removeObserverForKey(observer:Object, key:String):Boolean {
		var id = observer.getUID();
		if (_keys_[key][id] == null) {
			return false;
		} else {
			delete _keys_[key][id];
			return true;
		}
	}

	public function setValueForKey(value, key:String) {
		var oldValue = this[key];
		var observers = _keys_[key];
		_delegate_.willSetValueForKey(this, key, oldValue, value);
		this[key] = value;
		for (var p in observers) {
			observers[p].onSetValueForKey(this, key, oldValue, value);
		}
		_delegate_.didSetValueForKey(this, key, oldValue, value);
	}
	
	
}