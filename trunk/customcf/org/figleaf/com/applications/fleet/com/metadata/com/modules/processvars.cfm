<CFPARAM NAME="Attributes.parentitemid">
<CFPARAM NAME="attributes.itemid"> 

<CFSCRIPT>
	if (trim(attributes.parentitemid) is "") { 
		caller.mycounter = caller.mycounter + 1;
		mystub = repeatstring("0",3-len(caller.mycounter)) & caller.mycounter;
		myrc = mystub & repeatstring("0",30-len(mystub));
		caller.myehdata[trim(attributes.itemid)] = myrc;		
		caller.myehcount[trim(attributes.itemid)] = 0;
		caller.myrc = variables.myrc;
		caller.processedrecords = caller.processedrecords + 1;
   } else {
		if (structkeyexists(caller.myehdata,trim(attributes.parentitemid))) {
			myparentrc = caller.myehdata[trim(attributes.parentitemid)];
			caller.myehcount[trim(attributes.parentitemid)] = caller.myehcount[trim(attributes.parentitemid)] + 1;
			pos = find("000",myparentrc);
			if (pos gt 1) {
				token=left(myparentrc,pos - 1);
			} else {
				token="";
			}
			
			myaddon = repeatstring("0",3-len(caller.myehcount[trim(attributes.parentitemid)])) & caller.myehcount[trim(attributes.parentitemid)];
			
			myrc = token & myaddon;
	
			if (len(myrc) lt 30) {
				myrc = variables.myrc & repeatstring("0",30-len(variables.myrc));
			}
			caller.myehdata[trim(attributes.itemid)] = variables.myrc;		
			caller.myehcount[trim(attributes.itemid)] = 0;	
			caller.myrc = variables.myrc;
			caller.processedrecords = caller.processedrecords + 1;
		  }  else { /* structkeyexists */	
		  	caller.myrc = "";
		  }
   }
</CFSCRIPT>