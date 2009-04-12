<cfparam name="url.log" default="" />
<cfset logService = createObject("component", "com.logreader.LogReaderService") />
<cfset logDir = logService.getLogDir() />

<cfheader name="Content-Disposition" value="attachment;filename=#url.log#">
<cfheader name="Content-Description" value="This is a comma-delimited file.">
<cfcontent file="#LogDir#/#url.log#" type="application/x-unknown">