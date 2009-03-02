class MDChangeObject {
	public var id:String;
	public var bitmask:String;
	public var parentId:String;
	public var translation:String;
	public var url:String;
	public var label:String;
	public var action:String;
	public static var ADD:String;
	public static var EDIT:String;
	public static var DELETE:String;
	
	public function MDChangeObject() {
		ADD = 'n';
		EDIT = 'e';
		DELETE = 'd';
		id = '';
		bitmask = '';
		parentId = '';
		translation = '';
		url = '';
		label = '';
	}
}