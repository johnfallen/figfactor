//------------------------------------------------------------------------------
// org.waxpraxis.buzz.BZNoteCenter
//------------------------------------------------------------------------------
// Information
//==================================
// Author: Branden J. Hall
// Created: January 14, 2004
// Last Modified: March 2, 2004
// License: See LICENSE.TXT
//------------------------------------------------------------------------------
// Overview
//==================================
// Provides a centralized system for event broadcast (the observer pattern).
// Class should not be instantiated - instead just used as a static object. 
//------------------------------------------------------------------------------
// Methods
//==================================
// addObserver(observerObj:Object, sourceObj:Object, eventName:String):Boolean
// --
// Both sourceObj and eventName are optional, but you must include at least one.
// If sourceObj is null, any object sending the desired event will notify the 
// observer.
// If eventName is null, any event from the sourceObject will notify the 
// observer.
// Returns true if observer was added, false otherwise
//
// removeObserver(observerObj:Object, sourceObj:Object, eventName:String):Void
// --
// Both sourceObj and eventName are optional.
// If both are null, all references to observerObj are removed for all 
// sources and events.
// If just sourceObj is null, the observer is removed from the event from any 
// object.
// If just eventName is null, the observer is removed from all events from the 
// sourceObj.
// If all arguments exist, the observer is only removed from the event from the 
// sourceObj.
//
// postNote(note:BZNote):Void
// --
// Notifies all relevant observers - passes them a single argument, note
//
// postNamedNote(name:String, source:Object, info:Object):Void
// --
// Creates a BZNote based on the arguments and then calls postNote with note
//
//------------------------------------------------------------------------------
import org.waxpraxis.buzz.BZNote;

class org.waxpraxis.buzz.BZNoteCenter {
	static var objTable:Object = new Object();
	static var eventTable:Object = new Object();
	static var fullTable:Object = new Object();
	static var debugFunction:Function = null;
	static var _postNote:Function;
	
	static function addObserver(observerObj:Object, sourceObj:Object, eventName:String):Boolean {
		var observerID = observerObj.getUID();
		var sourceID;
		
		// bad arguments - sourceObj -or- eventName may be null, not both
		if (sourceObj == null && eventName == null) {
			return false;	
		}
		
		if (eventName == null) {
			sourceID = sourceObj.getUID();
			if (objTable[sourceID] == null) {
				objTable[sourceID] = new Object();
			}
			objTable[sourceID][observerID] = observerObj;
			
		} else if (sourceObj == null) {
			if (eventTable[eventName] == null) {
				eventTable[eventName] = new Object();
			}
			eventTable[eventName][observerID] = observerObj;
			
		} else {
			sourceID = sourceObj.getUID();
			
			if (fullTable[sourceID] == null) {
				fullTable[sourceID] = new Object();
			}
			if (fullTable[sourceID][eventName] == null) {
				fullTable[sourceID][eventName] = new Object();
			}
			fullTable[sourceID][eventName][observerID] = observerObj;
		}
		return true;
	}
	
	static function removeObserver(observerObj:Object, sourceObj:Object, eventName:String):Void {
		var observerID = observerObj.getUID();
		var sourceID;
		var p, q;
		
		if (eventName == null && sourceObj == null) {
			for (p in fullTable) {
				for (q in fullTable[p]) {
					delete fullTable[p][q][observerID];
				}
			}
			
			for (p in objTable) {
				delete objTable[p][observerID];
			}
			
			for (p in eventTable) {
				delete eventTable[p][observerID];
			}
		} else if (eventName == null) {
			sourceID = sourceObj.getUID();
			
			for (p in fullTable[sourceID]){
				delete fullTable[sourceID][p][observerID];
			}
			delete objTable[sourceID][observerID];
				
		} else if (sourceObj == null) {
			for (p in fullTable) {
				delete fullTable[p][eventName][observerID];
			}
			delete eventTable[eventName][observerID];
			
		} else {
			sourceID = sourceObj.getUID();
			
			delete fullTable[sourceID][eventName][observerID];
		}
	}
	
	static function postNote(note:BZNote):Void {
		var p;
		var id = note.source.getUID();
		var eTable = eventTable[note.name];
		var oTable = objTable[id];
		var fTable = fullTable[id][note.name];
		
		for (p in eTable) {
			eTable[p][note.name](note);	
		}

		for (p in oTable) {
			oTable[p][note.name](note);	
		}
		
		for (p in fTable) {
			fTable[p][note.name](note);	
		}
		
		debugFunction(note);
	}
	
	static function postNamedNote(name:String, source:Object, data:Object):Void {
		var note:BZNote = new BZNote(name, source, data);
		postNote(note);
	}
	
	static function setDebugFunction(func:Function):Void {
		_postNote = postNote;
		postNote = function(note) {
			_postNote(note);
			func(note);
		}
	}
}
