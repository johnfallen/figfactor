class org.waxpraxis.buzz.BZFrameController {
	static var clip:MovieClip = _level0.createEmptyMovieClip("__BZFrameQueue", 16001);	
    static var frameTable:Object = new Object();
	static var nextTable:Object = new Object();
	static var num:Number = 0;
	static var topID:Number = 0;

	static function frameLoop() {
		var data:Object;
		for (var p in nextTable) {
			frameTable[p] = nextTable[p];
			delete nextTable[p];
		}
		
		for (var p in frameTable) {
			data = frameTable[p];
			if (data.obj[data.method].apply(data.obj, data.args) == false){
				data.doneObj[data.doneMethod].apply(data.doneObj, data.doneArgs);
				delete frameTable[p];
				--num;
				if (num == 0){
					delete clip.onEnterFrame;
				}
			}
		}
	}	
	
	static function addFrameListener(obj, method, args, doneObj, doneMethod, doneArgs){
		var id = ++topID;
		var info:Object = new Object();
	    
		++num;
		info.obj = obj;
		info.method = method;
		info.args = args;
		info.doneObj = doneObj;
		info.doneMethod = doneMethod;
		info.doneArgs = doneArgs;
	    
		nextTable[id] = info;
	    
		if (num == 1) {
	    	clip.onEnterFrame = function(){
				BZFrameController.frameLoop();	
			}
		}
	}
}
