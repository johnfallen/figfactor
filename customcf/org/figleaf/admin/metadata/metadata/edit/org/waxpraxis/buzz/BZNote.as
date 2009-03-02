//--------------------------------------------------------------------------------------------------
// org.waxpraxis.buzz.BZNote
//--------------------------------------------------------------------------------------------------
// Information
//==================================
// Author: Branden J. Hall
// Created: January 14, 2004
// Last Modified: March 2, 2004
// License: See LICENSE.TXT
//--------------------------------------------------------------------------------------------------
// Overview
//==================================
// Provides a simple structure for note(event) objects
//--------------------------------------------------------------------------------------------------
// Methods
//==================================
// new BZNote(noteName:String, noteSource:Object, noteData:Object):Void
// --
// Constructor - noteData is optional.
// noteName is the name of the note - this will be the name of the method called in observers
// noteSource is a reference to the object that is sending this note
//
//--------------------------------------------------------------------------------------------------
import org.waxpraxis.buzz.ext.BZObjectExtensions;

class org.waxpraxis.buzz.BZNote {
	public var name:String;
	public var source:Object;
	public var data:Object;
	
	// no idea why this works... 
	// if excluded the static method that extends the Object class is never run
	static var objectExtender:Object = BZObjectExtensions;
	
	public function BZNote(noteName:String, noteSource:Object, noteData:Object){
		name = noteName;
		source = noteSource;
		data = noteData;
	}
}
