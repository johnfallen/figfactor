<!---
Build:      		@@@revision-number@@@

Memory-sensitive cache implementation for CF.

For those of you haven't read my blog entry, this is a memory-sensitive
cache implementation for CF that makes liberal use of a couple of Java
classes, SoftReference and ReferenceQueue. Details aside, this cache
will keep storing data as long as there's enough memory available. When
memory becomes constrained, either because the cache is too large, or
because some other objects in the JVM need memory, the cache will automatically
shrink.

So, don't assume that just because you put something in here, it'll stay in!
It's entirely possible that an entry that you put into the cache will be gone
when you look in on it the next time, so build logic around this so that if an
entry is not available, it's retrieved from underlying storage, or wherever,
and stuck in the cache again.

In theory the cache will shrink only when the garbage collector decides that
the JVM needs memory; however, I have seen cases where items are cleaned out
of the cache a few minutes after they're put in, so watch out for that. Your
mileage may vary... The cache is instrumented to tell you its hit ratio, so
watch that, and if it drops too low, you might want to think about adopting
alternate, or supplementary, caching strategies.

I have not tested this extensively; which is not to say that I haven't tested it!
If you do find any bugs, leave a comment on the blog entry below, and I'll
see what I can do about it.

Usage: 

Set the cache into a shared scope, probably server or application:
<cfset server.mycache = createObject("component", "softcache")>
Then get/set/delete entries as you will. When you get an entry, be sure to make the
comparison against server.mycache.notfound, which could vary based on what you choose 
to stick in there, simple type, CFC, whatever. 

An optional add-on is to specify the onRemoveHandler for this object, which if available 
will be invoked when a key is  being removed from the cache due to memory constraints; note 
that the value may already have been cleared by the garbage collector. The onRemoveHandler 
must have a public function named onRemove which takes the key string as an argument. Here's 
how to add it on:
<cfset server.cache.onRemoveHandler = createObject("component", "myOnRemoveHandler")>

The reap() function clears out keys for garbage collected entries. Under normal usage, you'll
never need to call this function, since it is invoked when the get() function is called and a 
cache miss occurs. However, this means that callers pay the cost of reaping the cache; if you
want to (typically you won't need to), you can call this function manually, perhaps as a scheduled
task.

Ashwin Mathew - for more see http://blogs.sanmathi.org/ashwin/

History:
==================================================================================
07-01-2006		Ashwin Mathew		Created
06-15-2008		John Allen				1. Added History documentation.
												2. Changed the component from using the 'this' scope
													to using the 'variables' scope.
												4. Formatted and added some attributes.
												5. Added init() method.
												6. Moved the 'constructor' code into the init() 
													method.
												7. Scoped all the variables.
08-13-2008		John Allen				Added KeyExistsCheck argument and logic to the get method.
==================================================================================
--->
<cfcomponent 
	name="softcache" 
	output="false" 
	displayname="Soft Cache" 
	implements="ICache"
	hint="I am a memory-sensitive cache implementation for CF.">



<!--- init --->
<cffunction name="init" output="false">
	
	<cfargument name="dataNotFound" required="false" default="no" />
	
	
	<!--- 
	Just a constant to indicate a key is not found. 
	If you need to, you can change this to something you can be sure
	will not be a value set by your apps. It could even be a CFC, if
	CFCs are what you're storing in the cache. Your "notfound" CFC
	could implement a function that tells you that it's "not found".
	Not that I've tried it yet - just an idea...
	--->
	<cfset variables.notfound = arguments.dataNotFound />
	
	<!---
	The Struct containing mappings of keys to values wrapped
	in soft references.
	--->
	<cfset variables.cache = StructNew() />
	
	<!---
	A Struct mapping soft reference objects to keys. We need
	variables to clean out keys from the cache - you'll see why later.
	--->
	<cfset variables.refKeyMap = StructNew() />
	
	<!---
	The reference queue that gets garbage collected soft references.
	--->
	<cfset variables.refq = createObject("java", "java.lang.ref.ReferenceQueue") />
	
	<!---
	Stats for calculating the hit ratio.
	--->
	<cfset variables.hits = 0 />
	<cfset variables.misses = 0 />
	
	<cfreturn this />
</cffunction>



<!--- get --->
<cffunction name="get" output="false" 
	description="Returns the value for the specified key, or the string specified by configureation if unavailable.">
	
	<cfargument name="key" />
	
	<!---  
	Added by John Allen 08-13-2008
	--->
	<cfargument name="KeyExistsCheck" default="0" />
	
	
	<cfset var value = variables.notfound />

	<cfif StructKeyExists(variables.cache, arguments.key)>
		<cfset value = variables.cache['#key#'].get() />
		
		<!---
		value may be null if it's been garbage collected,
		so check for variables here.
		--->
		<cfif isDefined("value")>
			
			<!---  
			Added by John Allen 08-13-2008
			Wanted to provide a way to NOT increase the hit
			count if one was just checking for existsance before
			reacting and adding to the cache as per the authors
			notes. 
			--->
			<cfif arguments.KeyExistsCheck neq 0>
				<cfset variables.hits = variables.hits + 1 />
			</cfif>

		<cfelse>
			
			<!---
			If value is null, we need to reap() to
			ensure that garbage collected references
			and keys pointing to them are cleaned out
			of the cache.
			--->
			<cfset variables.misses = variables.misses + 1 />
			<cfset value = variables.notfound />
			<cfset reap() />
		</cfif>

	<cfelse>
		<cfset variables.misses = variables.misses + 1 />
	</cfif>

	<cfreturn value />
</cffunction>



<!--- put --->
<cffunction name="put" access="public" hint="Puts content into the cache.">
	<cfargument name="key" hint="Key for the content." />
	<cfargument name="Value" hint="The content to cache." />
	
	<!---
	variables is where the magic starts happening - wrap the value
	in a soft reference.
	--->
	<cfset var softRef = createObject("java", "java.lang.ref.SoftReference").init(value, variables.refq) />
	
	<cfset variables.cache['#arguments.key#'] = softRef />
	
	<!---
	We also maintain a reverse mapping from the soft reference
	to the key - as noted earlier, you'll see why in a minute...
	--->
	<cfset variables.refKeyMap['#softRef#'] = arguments.key />

</cffunction>



<!--- delete --->
<cffunction name="delete" access="public" returntype="void" hint="Purges content from the cache.">
	<cfargument name="key" />
	
	<cfset var softRef = "" />
	
	<cfif StructKeyExists(variables.cache, arguments.key)>
		
		<cfset softRef = variables.cache['#arguments.key#'] />
		
		<!--- clean it out from the main cache --->
		<cfset structDelete(variables.cache, arguments.key) />
		
		<!--- and then from the soft reference to key map --->
		<cfset structDelete(variables.refKeyMap, softRef) />
	</cfif>

</cffunction>




<!--- reap --->
<cffunction name="reap" output="false" 
	description="Reaps garbage collected values and keys from the cache. variables is called automatically 
	by the cache, but you may call it yourself if you really need to.">
	
	<cfset var more = true />
	<cfset var softRef = "" />
	<cfset var key = "" />

	<!--- 
	Check if a onRemoveHandler is defined. variables is a CFC which is expected
	to implement an onRemove(key) function, which will be notified whenever
	a key is removed.
	--->
	<cfset var callHandler = isDefined("variables.onRemoveHandler") />
	
	<cfloop condition="#more#">
		
		<!--- Poll the reference queue for garbage collected references --->
		<cfset softRef = variables.refq.poll() />
		
		<!--- If we have a reference try to clean it up from the cache --->
		<cfif isDefined("softRef")>
			
			<!--- 
			We need to check whether it exists, since another thread
			may have already cleared it up. I think polling the queue
			is supposed to be atomic, but I've been running into a 
			little trouble here - in theory variables check is not necessary.
			In practice... well...
			--->
			<cfif StructKeyExists(variables.refKeyMap, softRef)>
				
				<!---
				Now you get to see why we need to refKeyMap - we need
				to get the key that the soft reference was mapped to.
				The value that the reference contained may be gone by
				now, so there's no way we could've stored the key
				in there along with the value. 
				--->
				<cfset key = variables.refKeyMap['#softRef#'] />
				
				<cfif callHandler>
					<!--- Call out to the onRemoveHandler, if we have one --->
					<cfset variables.onRemoveHandler.onRemove(key) />
				</cfif>
				
				<!--- And last, but not least, clean up the cache! --->
				<cfset StructDelete(variables.cache, key) />
				<cfset StructDelete(variables.refKeyMap, softRef) />
			</cfif>
	
		<cfelse>
			<cfset more = false />
		</cfif>
	</cfloop>
	
</cffunction>



<!--- getHitRatio --->
<cffunction name="getHitRatio" output="false" description="Returns the hit ratio for the cache.">
	
	<cfset var requests = variables.hits + variables.misses />
	
	<cfif requests eq 0>
		<cfreturn 0 />
	<cfelse>
		<cfreturn (variables.hits/requests) />
	</cfif>
</cffunction>



<!--- getSize --->
<cffunction name="getSize" output="false" description="Returns the size of the cache.">
	
	<!--- Reap first so we get dead keys out of the cache --->
	<cfset reap() />
	
	<cfreturn StructCount(variables.cache) />
</cffunction>



<!--- 
08/11/2008: ADDED by John Allen
A good way to dump out hte cache to impress your friends.
--->
<!--- viewCache --->
<cffunction name="viewCache" output="false" access="public" 
	displayname="View Cache" hint="Returns cache information." 
	description="Returns all of the information in the cache. Size, Hit/Miss Ratio and even the cach data itself.">
	
	<cfset var cacheInfo = structNew() />
	<cfset cacheInfo.size = getSize() />
	<cfset cacheInfo.HitRatio = getHitRatio() />
	<cfset cacheInfo.cache = variables.cache />
	<cfset cacheInfo.hits = variables.hits />
	<cfset cacheInfo.misses = variables.misses />
	
	<cfreturn cacheInfo />
</cffunction>
</cfcomponent>