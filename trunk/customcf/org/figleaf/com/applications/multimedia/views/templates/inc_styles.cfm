<style>
	
/* normalize */
#pageWrapper, #pageContainer , 
#headerWrapper , #headerContainer , 
#bodyWrapper , #boddyContainer, 
#footerWrapper, #footerContainer, .mm_galleryFrame,
body,div,span,table,tr,td,form,input,select,option,h1,h2,h3,h4,h5,ul,li {
	margin:0; padding:0;
}
/* html */
body {
	font-family: "Trebuchet MS", verdana, arial, sans-serif; 
	}
/* wrapper borders */
#pageWrapper, #headerWrapper, #footerWrapper, #bodyWrapper {
	border-top:solid 1px gray;
	border-right:solid 2px black;
	border-bottom:solid 2px black;
	border-left:solid 1px gray;
	margin-bottom:3px;
	background-color:white;
	padding:3px;
	}
/* wrappers */
#pageWrapper {
	background-color:#efefef;
	margin:2px;
	width:715px;
	padding-right:3px;
	}
#headerWrapper, #footerWrapper {
	font-size:.90em;
}
#headerWrapper {
	background-color:#003366;
	height:34px;
	margin-bottom:-5px;
}
#bodyWrapper {
	height:550px;
	}
/* Containers */
#boddyContainer li {
	margin-left:18px;
	}
/* Media Browser styles */
.disabledFormField {
	border:none;
	background-color:#fff;
	}
.smaller-font {
	font-size:.95em;
	}
.bold {
	font-weight:bold;
	}
.public-form {
	font-size:.95em;
	}
.public-form select {
	border:solid 2px #c1ccd0;
	width:100%;
	}
.select-list-current {
	background-color:#cdcdcd;
	color:#000;
	}
#metadatatree {font-size:.85em; font-family:verdana;}


#mm_admin_headerLinks {
	padding-top:1px;
	}
#mm_admin_headerLinks a {
	display:table-cell;
	background-color:#fff;
	padding:5px 20px 5px 20px;
	width:auto;
	float:left;
	margin-right:3px;
	text-decoration:none;
	color:#666;
	}
#mm_admin_headerLinks a:hover {
	background-color:#eef;
	color:#000;
	text-decoration:underline;
	}

#mm_deleteMediaButton {
	float:right;
	clear:all;
}




/* sortable list and caraousel container */
#gallerBuilderContainer {
	font-family:verdana;
	}
/* top gallery */

#currentGallery {
	min-width: 500px; 
	min-height:230px;
	height:auto !important;
	background-color:transparent;
	z-index:-5px;

}

/* bottom gallery */
#mediaPoolContainer {
	margin:0;
}
#mediaPoolContainer h4 {
	margin-top:0;
	padding:0;
}
#newGallery {
	min-width: 500px;
	min-height:120px; 
	height:auto !important;
}

#mm_trashGallery  {
	min-width: 500px;
	min-height:120px; 
	height:auto !important;
	background-color:#fcc;
	padding-bottom:50px;
	}
#galleryTrash .galleryItemText {
	display:none;
	}

#galleryTrash .galleryItemTextDeleteWarning {
	color:#f00;
	font-weight:bold;
	}

#galleryTrash .galleryItemTitle {
	display:block;
	}

#currentGallery .galleryItemTextDeleteWarning {
	display:none;
	}



/*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***/
/* Gallery item styles */
/* These styles need to be in seperate definitions */
/* for some reason i cant figure out. */
/*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***/

#currentGallery li {
	list-style:none;
	border:solid 1px gray;
	border-bottom:solid 1px black;
	border-right:solid 1px black; 
	float:left;
	background-color: #727EA3; 
	color: #fff; 
	width: 100px; 
	font-size: .65em;
	line-height:1em;
	padding: 3px;
	margin:3px;
	height:100px;
	}
#newGallery li img {
	margin:0px 4px 1px 0px;
	border:solid 1px black;
	}
#currentGallery li img {
	margin:0px 4px 1px 0px;
	border:solid 1px black;
	}
.galleryItemTitle {
	font-weight:bold;
	}
.galleryItemTitle:hover {
	font-weight:bold;
	color:#f0f;
	cursor:move;
	text-decoration:underline;
}

#mm_trashGallery li {
	list-style:none;
	font-size: .65em;
	line-height:1em;
	padding: 3px;
	margin:3px;
	}

#mm_trashGallery li .hidden {
	backckground-color:#fcc;
	}



/*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***/
/************** Public Layouts for the custom tag **************/
/*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***/
#mm_galleryContainer {
text-align:left;
	padding:3px;
	}
#mm_galleryContainer p {
	font-size:.80em;
	padding:0;
	margin:0;
	text-align:left;
	}
.mm_galleryContainerSmall {
	width:125px;
		border:solid 1px black;
	}
.mm_galleryContainerLarg {
	width:285px;
		border:solid 1px black;
	}

/* Single Image with text into gallery */
.mm_galleryFrame {
	width:120px;
	border:solid 1px black;
	font-size:.78em;
	padding:5px 10px 10px 10px;
	}
.mm_galleryFrame  p {
	padding:0;
	margin:0;
	text-align:left;
	}

/* image controll for the SINGLE imag to gallery layout */
.mm_imageAlignRight {
	margin:0px 3px 3px 0px;
	}
.mm_imageAlignLeft {
	margin:0px 3px 3px 0px;
	}

/* view more link */
.mm_clickToViewContainer   {
	text-align:right;
	}

/*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***/
/****** Carousels *****/
/* previous and next buttons */
.prev, .next {
	border:none;
	background-color:#efefef;
	font-weight:bold;
	border-top:solid 1px #666;
	border-right:solid 2px black;
	border-bottom:solid 2px black;
	border-left:solid 1px #666;
	font-size:1em;
	padding:1px 6px;
	margin:0;
	line-height:1em;
	}
.prev:hover, .next:hover {
	background-color:#090;
	color:#fff;
	border-top:solid 1px #ccc;
	border-right:solid 2px #666;
	border-bottom:solid 2px #666;
	border-left:solid 1px #ccc;
	cursor:pointer;
	}

/* thumbnains in scrollers */
#mm_smallVerticalImageContainer ul li img, #mm_smallHoriziontallImageContainer ul li img {
	border:solid 1px black;
	width:50px;
	height:50px;
	}

/* Horiziontal Images */
#mm_smallHoriziontallImageContainer ul {
	width:50px;
	}
#mm_smallHoriziontallImageContainer ul li {
	width:53px;
	margin:0;
	}

/* Vertical Images */
#mm_smallVerticalImageContainer ul {
	width:52px;
	margin:0;
	padding:0;
	}
#mm_smallVerticalImageContainer ul li {
	width:53px;
	margin:0px 0px 0px 0px;
	padding:0px;
	}

/* Inlie Image Gallery */
.mm_inlineGallery {
	width:400px;
	text-align:left;
	}









.display-none {
	display:none;
	}
</style>