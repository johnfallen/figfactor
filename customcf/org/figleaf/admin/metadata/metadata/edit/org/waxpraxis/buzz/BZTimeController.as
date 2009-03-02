class org.waxpraxis.buzz.BZTimeController {
	static var timeTable:Object = new Object();
	
	static function timeLoop(info){
		if (info.obj[info.method].apply(info.obj, info.args) == false){
			clearInterval(info.id);
			info.doneObj[info.doneMethod].apply(info.doneObj, info.doneArgs);
		}
	}
	
	static function addTimeListener(interval, obj, method, args, doneObj, doneMethod, doneArgs) {
		var info = {obj:obj, method:method, args:args, doneObj:doneObj, doneMethod:doneMethod, doneArgs:doneArgs};
		info.id = setInterval(timeLoop, interval, info);
	}
}
