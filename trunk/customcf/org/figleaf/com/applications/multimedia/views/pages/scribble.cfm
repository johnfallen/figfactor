<script type="text/javascript" language="javascript" src="/jquery/jquery-1.2.6.js"></script>
<link rel="stylesheet" href="http://ui.jquery.com/latest/themes/flora/flora.all.css" type="text/css" media="screen" title="Flora (Default)">
<script type="text/javascript" src="http://ui.jquery.com/latest/ui/ui.core.js"></script>
<script type="text/javascript" src="http://ui.jquery.com/latest/ui/ui.tabs.js"></script>
<script>
  $(document).ready(function(){
    $("#mediaFormDisplayTabs > ul").tabs();
  });
  </script>



<div id="mediaFormDisplayTabs" class="flora">
	<ul>
		<li><a href="#media-form-fields-panel"><span>tab 1</span></a></li>
		<li><a href="#media-metadata-panel"><span>tab 2</span></a></li>
	</ul>
	
	<div id="media-form-fields-panel">
		<p>this iscool</p>
	</div>
	<div id="media-metadata-panel">
		<p>even cooler</p>
	</div>
</div>




