<cfscript>
	logs = arrayNew(1);
	logs[1] = createObject("component","logger").init("index:1");
	logs[2] = createObject("component","logger").init("index:2");
	
	// create a sequence of event handlers and explicitly invoke:
	twoLogs = application.edmund.getWorkflow().seq(logs);
	twoLogs.handleEvent( application.edmund.new().name("seq-event") );
	
	data = arrayNew(1);
	for (i = 1; i lte 10; i = i + 1) data[i] = i;
	
	// create an event handler that iterates over some data (and explicitly invoke it):
	loopLogger = application.edmund.getWorkflow().foreach("iter","x",createObject("component","logger").init("index:loop"));
	loopLogger.handleEvent( application.edmund.new().name("foreach-event").values(iter=data.iterator()) );

	// show parent/child with and without bubbling:
	application.edmund.register("one",createObject("component","logger").init("child:1"));	
	application.edmund.register("two",createObject("component","logger").init("child:2"));
	// in reality you would have different event contexts in different parts of your application:
	parent = application.edmund.newParent();
	parent.register("two",createObject("component","logger").init("parent:2"));
	parent.register("three",createObject("component","logger").init("parent:3"));
	
	// now test some events without bubbling:
	application.edmund.dispatch("one");
	application.edmund.dispatch("two");
	application.edmund.dispatch("three");
	
	// now test some events with bubbling:
	application.edmund.dispatchEvent( application.edmund.new().name("one").bubble(true) );
	application.edmund.dispatchEvent( application.edmund.new().name("two").bubble(true) );
	application.edmund.dispatchEvent( application.edmund.new().name("three").bubble(true) );
	
</cfscript>