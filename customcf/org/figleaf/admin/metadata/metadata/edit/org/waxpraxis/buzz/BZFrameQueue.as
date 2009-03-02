import org.waxpraxis.buzz.BZFrameController;

class org.waxpraxis.buzz.BZFrameQueue {
	var queueList:Array;
	
	function BZFrameQueue(){
		queueList = new Array();
	}
	
	function addItem(obj, method, args) {
		queueList.push({obj:obj, method:method, args:args});
		if (queueList.length == 1) {
			nextItem();
		}
	}
	
	function nextItem() {
		var item:Object = queueList[0];
		BZFrameController.addFrameListener(item.obj, item.method, item.args, this, "doneItem", null);
	}
	
	function doneItem() {
		delete queueList.shift();
		nextItem();
	}
	
}
