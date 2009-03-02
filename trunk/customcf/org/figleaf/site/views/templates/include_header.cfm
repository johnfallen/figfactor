<cfoutput>	
<cfset config = Application.BeanFactory.getBean("ConfigBean") />
<!-- Authentication version: #config.getAuthenticationVersion()# -->
<!-- DataService version: #config.getDataserviceVersion()# -->
<!-- FigLeafSystem version: #config.getFigLeafSystemVersion()# -->
<!-- FLEET version: #config.getFleetVersion()# -->
<!-- ViewFramework version: #config.getViewFrameworkVersion()# -->
<link href="#config.getCSSDirectory()#/style.css" rel="stylesheet" type="text/css" media="screen" />
<link href="#config.getCSSDirectory()#/style-subsite-overrides.css" rel="stylesheet" type="text/css" media="screen" />
<link href="#config.getCSSDirectory()#/live.css" rel="stylesheet" type="text/css" media="screen" />
</cfoutput>