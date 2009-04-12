<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			BaseTransport.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the Base Transport object which all other Transport objects extend
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		18/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Base Transport" output="false"
	hint="I am the Base Transport object which all other Transport objects extend">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="any" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



<!--- RockEnRoll --->
<cffunction name="RockEnRoll" returntype="any" access="public" output="false"
    displayname="Rock En Roll" hint="I rock...."
    description="...and I Role!.">
    
    <cfreturn  />
</cffunction>


<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>