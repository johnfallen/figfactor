<cfoutput>	
<cfset config = Application.BeanFactory.getBean("ConfigBean") />
<link href="#config.getCSSDirectory()#/style.css" rel="stylesheet" type="text/css" media="screen" />
<link href="#config.getCSSDirectory()#/style-subsite-overrides.css" rel="stylesheet" type="text/css" media="screen" />
<link href="#config.getCSSDirectory()#/live.css" rel="stylesheet" type="text/css" media="screen" />
</cfoutput>