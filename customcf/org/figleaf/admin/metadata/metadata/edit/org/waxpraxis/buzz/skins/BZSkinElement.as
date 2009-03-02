//------------------------------------------------------------------------------
// org.waxpraxis.buzz.skins.BZSkinElement
//------------------------------------------------------------------------------
// Information
//==================================
// Author: Branden J. Hall
// Created: January 14, 2004
// Last Modified: April 2, 2004
// License: See LICENSE.TXT
//------------------------------------------------------------------------------
// Overview
//==================================
// Provides a class for all elements of a skin to inherit from in order to
// allow events to propagate up through the skin the the component.
//------------------------------------------------------------------------------
// Public Methods
//==================================
// setID(id):Void
// --
// Sets the ID of the element
//
// addResponder(obj, method, event):Void
// --
// Adds a responder for an event
//
// setState(state):Void
// --
// Sets the state of the element (changes frames)
//------------------------------------------------------------------------------ 


class org.waxpraxis.buzz.skins.BZSkinElement extends MovieClip {
	var _id:String;
	var _responders:Object;
	var _timer:Number;
	var _dblClickTime:Number = 500;
	var onDoubleClick:Function;
	
	// Constructor
	function BZSkinElement () {
		stop();
		useHandCursor = false;
	}
	
	// sets the ID of the element
	public function setID(id):Void {
		_id = id;
	}
	
	// adds a new responder for an event
	public function addResponder (obj, method, event):Void {
		switch (event) {
		
			case "onRelease":
				this[event] = function() {
					if (processDbl()) {
						obj[method](_id);
					}
				}
				break;
				
			case "onDoubleClick":
				if (onRelease == null) {
					onRelease = function() {
						processDbl();
					}
				}
				
			default:
				this[event] = function() {
					obj[method](_id);
				}
				break;	
		}
	}
	
	// sets the state of the element
	public function setState(state):Void {
		gotoAndStop(state);
	}
	
	// code to process double clicks
	private function processDbl() {
		var result:Boolean = true;
		if (getTimer() - _timer < _dblClickTime) {
			onDoubleClick();
			result = false;
		}
		
		_timer = getTimer();
		return result;
	}
}
