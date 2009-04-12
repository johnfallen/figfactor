<cfcomponent output="false" hint="Decorator for $$state.object.getClassName()$$" alias="$$state.object.getDecorator()$$"
			 transferAlias="$$state.object.getClassName()$$" extends="transfer.com.TransferDecorator">

{{gen:block name="cfproperty"}}
{{gen:compact}}

{{cfset local.primaryKey = state.object.getPrimaryKey()}}
{{cfif NOT local.primaryKey.getIsComposite()}}
	<!--- primary key --->
	<cfproperty name="$$local.primaryKey.getName()$$" type="$$local.primaryKey.getType()$$">
{{/cfif}}

	<!--- properties --->
{{cfset local.iterator = state.object.getPropertyIterator() /}}
{{cfloop condition="$$local.iterator.hasNext()$$"}}
	{{cfset local.property = local.iterator.next() /}}
	<cfproperty name="$$local.property.getName()$$" type="$$local.property.getType()$$">
{{/cfloop}}

{{cfif state.object.hasManyToOne()}}
	<!--- manytooone --->
	{{cfset local.iterator = state.object.getManyToOneIterator() /}}

	{{cfloop condition="$$local.iterator.hasNext()$$"}}
		{{cfset local.manytoone = local.iterator.next() /}}
		{{cfset local.composite = local.manytoone.getLink().getToObject() /}}
		{{cfif local.composite.hasDecorator()}}
	<cfproperty name="$$local.manytoone.getName()$$" type="$$local.composite.getDecorator()$$">
		{{/cfif}}
	{{/cfloop}}
{{/cfif}}

{{cfif state.object.hasParentOneToMany()}}
	{{cfset local.iterator = state.object.getParentOneToManyIterator() /}}
	<!--- parent one to many --->
	{{cfloop condition="$$local.iterator.hasNext()$$"}}
		{{cfset local.parent = local.iterator.next()}}
		{{cfset local.composite = local.parent.getLink().getToObject()}}

		{{cfif local.composite.hasDecorator()}}
	<cfproperty name="parent$$local.composite.getObjectName()$$" type="$$local.composite.getDecorator()$$">
		{{/cfif}}
	{{/cfloop}}

{{/cfif}}

{{cfif state.object.hasOneToMany()}}
	{{cfset local.iterator = state.object.getOneToManyIterator() /}}
	<!--- one to many --->
	{{cfloop condition="$$local.iterator.hasNext()$$"}}
		{{cfset local.onetomany = local.iterator.next()}}
		{{cfset local.composite = local.onetomany.getLink().getToObject()}}

		{{cfif local.composite.hasDecorator()}}
			{{cfif 	local.onetomany.getCollection().getType() eq "array"}}
	<cfproperty name="$$local.onetomany.getName()$$Array" type="$$local.composite.getDecorator()$$[]">
			{{cfelse}}
	<cfproperty name="$$local.onetomany.getName()$$Struct" type="struct">
			{{/cfif}}
		{{/cfif}}
	{{/cfloop}}

{{/cfif}}

{{/gen:compact}}
{{/gen:block}}

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>