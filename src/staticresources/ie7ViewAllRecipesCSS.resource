body{  
	font-family:"Arial", "Arial", sans-serif;
	margin:0px!important;
	background:-webkit-gradient(linear, left top, left bottom, color-stop(1%,#CAC2BA), color-stop(100%,#B7ACA2));
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#CAC2BA', endColorstr='#B7ACA2',GradientType=0);
	background-repeat: no-repeat;
	background-attachment: fixed;
}

#bodyHeader {position: relative!important;top:-20px;left: 0px; background:-webkit-gradient(linear, left top, left bottom, from(#5985A3), to(#3E607F));filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#5985A3', endColorstr='#5985A3',GradientType=1);color: #ffffff; height: 40px; font-family:"Arial", "Arial", sans-serif; width:1150px!important; float: right;min-width:1120px;}

.outerDiv{
	width:1150px;
	margin:10px auto; 
	display:block;
	height:100%;
	background:#ffffff;
	background-image:url('/resource/1320196970000/dashboardBg');
	background-repeat:repeat;
}
.innerDiv{
	width:1120px;
	margin:-10px auto;
	overflow:hidden;
	position:relative;
	height:100%;
	top:-10px;
}

.sortResults{
	width:85px;
	margin-top:6px;
}
.fResults{
	margin-left:90px;
	margin-top:-40px;
}

select{
	background-color: #d5d5d5;
	color: black;
	height : 25px;
	-webkit-border-radius:6px;
	background: -webkit-gradient(linear, left top, right top, color-stop(88%,#d5d5d5), color-stop(89%,#717171));
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#d5d5d5', endColorstr='#717171',GradientType=1);
	background: -webkit-linear-gradient(left, #d5d5d5 85%,#717171 86%);
	font-family:"Arial","sans-seriff";
}

a{
   color:#000;
   text-decoration: none;
}

h1, h2, h3 {
    margin:.8em 0 .2em 0;
    padding:0;
}
p {
    margin:.4em 0 .8em 0;
    padding:0;
}

#ads img{
    display:block;
    padding-top:10px;
}



.whiteText{ 
	color: #ffffff;
    font-style:italic; 
    padding: 10px;
    background: #5a87a5;
    -webkit-border-top-left-radius:6px;
    -webkit-border-top-right-radius:6px;
    font-size:12px;
}


#layoutdims{
    clear:both;
    background:#eee;
    border-top:4px solid #000;
    margin:0;
    padding:6px 15px !important;
    text-align:right;
}
.rowmask {
    border:2px solid #eeeeee; 
    height: 50px;
    padding: 10px;
    float: left;
    width: 100%;
}
.mainRow {
    -moz-border-radius:4px;
    -webkit-border-radius:4px;
    border-radius:4px;
    height: 55px;
    float: left;
    width: 820px;
    font-size: 13px;
    padding-top: 3px;
    padding-bottom:2px;
    margin-left:7px;
}
.mainRow:hover{
    background-color: #c4bfbf;
}

.headerDiv{
    height: 45px;
    float: left;
    width: 14%;
    margin-top:5px;
    min-width:185px;
    font-size:14px;
}

.imgCol {
    width: 51px;
    float: left;
    vertical-align: middle;
    display: inline;  
    -moz-border-radius:6x;
    -webkit-border-radius:6px;
    border-radius:6px;
    border-color:black;
    border-width:1px;
    border-style:solid;
    text-align:center;
    background-color:white;
}

.imageInline{
 	-moz-border-radius:6x;
    -webkit-border-radius:6px;
    border-radius:6px;
    max-width:40px;
    height:51px;
}

.imagecontainer{
-moz-border-radius:12x;
    -webkit-border-radius:12px;
    border-radius:12px;
    border-style:solid;
    border-width:1px;
    border-color:black;
}

.textCol {
    width: 47%;
    float: left;
    vertical-align: middle;
    text-decoration: none !important;
    font-weight: bold;
    display: inline;
    padding-left: 20px;
    padding-top:9px;
    word-wrap:break-word;
}

.statusCol {
    width: 20%;
    height: 50px;
    float: left;
    vertical-align: middle;
    margin-top: 16px;
    margin-left: 1px;
    display: inline; 
    align:center;   
}

.actionCol {
    width: 37px;
    height: 50px;
    float: left;
    vertical-align: middle;
    padding-top: 18px;
    display: inline;   
    margin-left:2px; 
}

.actionColTop {
    width: 20px;
    height: 15px;
    float: left;
    vertical-align: middle;
    padding-top: 1px;
    padding-bottom:6px;
    display: inline;
    padding-left:1px;
    padding-right:2px;    
}

.textRowTop {
    width: 650px;
    height: 25px;
    float: left;   
}

.textRowBottom {
    width: 650px;
    height: 25px;
    float: left;   
}

.nameColumn {
    font-size: 18px;
}

.navPanel {
    height: 40px;
    float: left;
    width: 80%;
    font-size:14px;
    font-size: 14px;
    position: absolute;
    font-weight:bold;
    min-width:1000px;
    margin-top:52px;;
    
}

.navPanelTop{
	height: 40px;
    font-size: 16px;
    padding: 5px;
    font-weight:bold;
    min-width:540px;
}

.topHeaderDiv{
 	min-width:796px;
 	width:796px;
 	height:45px;
    margin-left: 6px;
}

.filterCriteria {
    font-size: 14px;
}

.recipeName {
    font-size: 17px;
}

/* column container */
.colmask {
    margin-top: 10px;
    float:left;
    height:600px;         /* width of whole page */
    overflow:hidden;        /* This chops off any overhanging divs */
    min-width:1120px;   
}
/* common column settings */
.colright,
.colmid,
.colleft {
    float:left;
    width:100%;
    height:100%;
    position:relative;
    margin-bottom:10px;
}

.col1 {
    float:left;
   	margin-left: 10px;
    overflow-y:hidden;
    overflow-x:hidden;
}

.col2 {
    float:left;
    overflow: auto;
    height: 540px;
    width: 380px;
}
/* 2 Column (left menu) settings */
.leftmenu {
            /* right column background colour */
}
.leftmenu .colleft {
    right:80%;          /* right column width */
        /* left column background colour */
}
.leftmenu .col1 {
	float: left;
    width:794px;  
}
.leftmenu .col2 {
	float: left;
    width:315px;          /* left column content width (column width minus left and right padding) */
    border-right: 1px solid #606060; 
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0%,#c4bfbf), color-stop(80%,#c4bfbf),color-stop(81%,#898585));
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#c4bfbf', endColorstr='#898585',GradientType=0);
    -webkit-border-radius:6px;
    margin-top:45px; 
}

.leftmenu .content {
	overflow-y:auto;
	overflow-x:hidden;
	height:55%;
    min-width : 315px;
    position: relative;
    background: -webkit-gradient(linear, left top, left bottom, from(#c4bfbf), to(#898585));
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#c4bfbf', endColorstr='#898585',GradientType=0);
    -webkit-border-radius:6px;
   
}
 
.saveButton {
    background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #7a757a), color-stop(1, #615d61) );
    background:-moz-linear-gradient( center top, #7a757a 5%, #615d61 100% );
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#7a757a', endColorstr='#615d61');
    background-color:#7a757a;
    -moz-border-radius:8px;
    -webkit-border-radius:8px;
    border-radius:8px;
    border:2px solid #ffffff;
    display:inline-block;
    color:#ffffff;
    font-family:"Arial", "Arial", sans-serif;
    font-size:18px;
    font-weight:normal;
    padding:3px 10px;
    text-decoration:none;
    behavior: url(border-radius.htc);
}
.saveButton:hover {
    background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #615d61), color-stop(1, #7a757a) );
    background:-moz-linear-gradient( center top, #615d61 5%, #7a757a 100% );
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#615d61', endColorstr='#7a757a');
    background-color:#615d61;
}
.saveButton:active {
    position:relative;
    top:1px; 
}

.status {
    background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #050505), color-stop(1, #0a0a0a) );
    background:-moz-linear-gradient( center top, #050505 5%, #0a0a0a 100% );
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#050505', endColorstr='#0a0a0a');
    background-color:#050505;
    -moz-border-radius:6px;
    -webkit-border-radius:6px;
    border-radius:6px;
    border:1px solid #000000;
    display:inline-block;
    color:#ffffff;
    font-family:"Arial", "Arial", sans-serif;
    font-size:12px;
    font-weight:bold;
    padding:2px 6px;
    text-decoration:none;
    behavior: url(border-radius.htc);
} 

.filterPanel {
    font-size: 12px;
    -moz-border-radius:6px;
    -webkit-border-radius:6px;
    border-radius: 6px;
    padding-left: 10px;
    margin-top:15px;
    margin-left:10px;
}

.textInput
{
    font-family: "Arial", "Arial", sans-serif;
    font-size: 20px;
    
    margin-top:10px;
    display: block;
    padding: 4px;
    border: solid 1px #85b1de;
    width: 265px;
    height: 30px;
    -webkit-border-radius: 6px;
    margin-bottom:15px;
    -moz-box-shadow: inset 0 0 5px #A5A5A5 !important;
  	-webkit-box-shadow: inset 0 3px 5px #A5A5A5 !important;
 	 box-shadow: inner 0 0 5px #A5A5A5 !important;
}

.actionButton {
	-moz-box-shadow: 0px 2px 2px 2px #888;
	-webkit-box-shadow:  0px 2px 2px 2px #888;
	box-shadow: 0px 2px 2px 2px #888;
	-moz-border-radius:16px;
	-webkit-border-radius:16px;
	border-radius:16px;
	border:2px solid #ffffff;
    -moz-box-shadow:inset 0px 1px 0px 0px #ffffff;
    -webkit-box-shadow:inset 0px 1px 0px 0px #ffffff;
    box-shadow:inset 0px 1px 0px 0px #ffffff;
    background-color:#a20644;
    -moz-border-radius:16px;
    -webkit-border-radius:16px;
    border-radius:16px;
    border:2px solid #ffffff;
    display:inline-block;
    color:#ffffff;
    font-family:"Arial", "Arial", sans-serif;
    font-size:10px;
    padding-top: 3px;
    padding-bottom:4px;
    padding-left:0px;
    padding-right:0px;  
    font-weight:bold;
    text-decoration:none;
    text-align:center;
    width:57%;
    behaviour:url(PIE.htc);
}

.actionButton:hover {
   background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#b4064c), color-stop(49%,#b4064c),color-stop(50%,#a20644));
   filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b4064c', endColorstr='#a20644',GradientType=0);
}
.actionButton:active {
   position:relative;
   top:1px;
}

.greenButton{
   background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#98BC55), color-stop(49%,#98BC55),color-stop(50%,#89A94C));
   filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#98BC55', endColorstr='#89A94C',GradientType=0);
}

.offGreenButton{
    background: -webkit-gradient(linear, left top, left bottom,color-stop(0%,#759140), color-stop(49%,#759140),color-stop(50%,#698239));
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#c4bfbf', endColorstr='#898585',GradientType=0);
}

.blueButton{
   background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#507994), color-stop(49%,#507994),color-stop(50%,#4a6F87)); 
   filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#507994', endColorstr='#4a6F87',GradientType=0);  
}

.pinkButton{
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#b4064c), color-stop(49%,#b4064c),color-stop(50%,#a20644));
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#c4bfbf', endColorstr='#898585',GradientType=0);
}

.redButton{
     background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ea0000), color-stop(49%,#ea0000),color-stop(50%,#d10000));
     filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ea0000', endColorstr='#ea0000',GradientType=0);
}

.greyButton{
  background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#c4bfbf), color-stop(49%,#bcbfc4), color-stop(50%,#9f9ca3));
  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#c4bfbf', endColorstr='#bcbfc4',GradientType=0);
}

.filterButton {
	-moz-box-shadow: 0px 2px 2px 2px #888;
	-webkit-box-shadow:  0px 2px 2px 2px #888;
	box-shadow: 0px 2px 2px 2px #888;
	-moz-border-radius:16px;
	-webkit-border-radius:16px;
	border-radius:16px;
	border:2px solid #ffffff;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0%,#98BC55), color-stop(49%,#98BC55),color-stop(50%,#89A94C));
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#98BC55', endColorstr='#89A94C',GradientType=0);
    display:inline-block;
    color:#ffffff;
    font-family:"Arial", "Arial", sans-serif;;
    font-size:13px;
    padding: 4px;
    font-weight:bold;
    text-decoration:none;
    behavior:url(border-radius.htc);
    
}
.filterButton:hover {
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#b4064c), color-stop(49%,#b4064c),color-stop(50%,#a20644));
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b4064c', endColorstr='#a20644',GradientType=0);
}
.filterButton:active {
    position:relative;
    top:1px;
}
.downloadButtonClass{
	width:70%;
	text-align:center;
	margin-left:10px;
}

.dlSearchComponent{
    padding-left:10px;
    margin-left:10px;
    padding-bottom:10px;
    background: -webkit-gradient(linear, left top, left bottom, from(#c4bfbf), to(#C4BFBF));
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#c4bfbf', endColorstr='#C4BFBF',GradientType=0);
}

.xclass{
	background: -webkit-gradient(linear, left top, left bottom, from(#c4bfbf), to(#C4BFBF));
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#C4BFBF', endColorstr='#C4BFBF',GradientType=0);
	min-height:50px;
	padding-top:20px;
}

.horizontalRuleClass{
    width:270px;
    size:3px;
    margin-left:20px;
    background: -webkit-gradient(linear, left top, left bottom, from(#c4bfbf), to(#C4BFBF));
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#C4BFBF', endColorstr='#C4BFBF',GradientType=0);
}  
.visitedClass1 {
	background-color:white;
	padding-top:5px;
	padding-bottom:5px;
	height:20px;
	padding-left:0px;
	padding-right:25px;
	border-radius:6px;
}
.visitedClass {color:black;}      /* unvisited link */
.visitedClass:hover {
	   /* background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #615d61), color-stop(1, #7a757a) );
	    background:-moz-linear-gradient( center top, #615d61 5%, #7a757a 100% );
	    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#615d61', endColorstr='#7a757a'); */
	    background-color:white;
}
.visitedClass:clicked {
	   /* background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #615d61), color-stop(1, #7a757a) );
	    background:-moz-linear-gradient( center top, #615d61 5%, #7a757a 100% );
	    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#615d61', endColorstr='#7a757a'); */
	    background-color:white;
}
.visitedClass:active {
	   /* background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #615d61), color-stop(1, #7a757a) );
	    background:-moz-linear-gradient( center top, #615d61 5%, #7a757a 100% );
	    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#615d61', endColorstr='#7a757a'); */
	    background-color:#ac0334;
}
   
.changeback{
    	background-color:#c5064c;
}

#nav { 
	font-family:Arial, sans-serif;
	margin-left:10px;
	margin-top:1px;
}
#nav a:hover {text-decoration:underline;}
#nav dt b, #nav dt a { 
	font-weight:bold; 
	font-size:15px; 
	color:#000; 
	height:50px; 
	line-height:35px;
	cursor:pointer;
}
/* #nav dt b {background:clear; } */
#nav dt a {color:#000; text-decoration:none;}
#nav dd {padding:0; margin:0;}
#nav dd ul {padding:0; margin:0; list-style:none;}
#nav dd ul li {padding-left:20px;}
#nav dd ul li a {font-size:12px; color:#000; text-decoration:none;}

.sortClass{
	float:left;
	padding-top:8px;
	padding-left:25px;
	width:30%;
	min-width:31px;
	font-size:14px;
	vertical-align:middle;
}

.dashboardRow {
	border-bottom: 1px solid #aaa;
	margin-right: 15px;
	width: 925px;
	
}
.sortClass1{
	float:left;
	margin-top:7px;
	margin-left:5px;
	min-width:33px;
	width:250px;
	font-size:14px;
	vertical-align:middle;
	height:45px;
}
.header{
	padding-left: 15px;
    padding-top: 7px;
 	float:left;
	text-decoration:none;
	color: white !important;
	font-size:14px;
}
.arrow{
    padding-top: 13px;
}
.arrow3{
    padding-top:12px;
}
.textTop{
    padding-top: 10px;
}
.arrow2{
    padding-top: 15px;
}
.pageClass{
     float:left;
     width:auto;
     min-width:40px;
     font-size: 14px;
     font-weight:bold;
      vertical-align:middle;
      height:45px;
      margin-top:7px;
}
.pageClass1{
      float:left;
      width:58%;
}  

#searchResultsList {
		min-width: 600px;
		float: left;
		display: block;
}
.nLinks{
	vertical-align:middle;
}
.nLinks:hover{
   color: #b4064c !important;
}
.red{
	color: red !important;
}
.black{
	color: black !important;
}	
.selectAllCheckBox{
		border-color:#898585;
		border-width:2px;
		border-style:solid;	
}



.filterButtonsClass{
	width:44%;
	padding-top:4px!important;
	padding-bottom:4px!important;
}
.brandStyle{
	padding-top:2px;
	padding-bottom:2px;
	padding-right:1px;
	margin-top:3px;
	margin-bottom:3px;"
}
.colorStyle{
	padding-top:2px;
	padding-bottom:2px;
	padding-right:1px;
	margin-top:3px;
	margin-bottom:3px;"
}
.flavorStyle{
	width:140px!important;
	padding-top:2px;
	padding-bottom:2px;
	margin-top:3px;
	margin-bottom:3px;"
}

.typeStyle{
	width:250px!important;
	padding-top:2px;
	padding-bottom:2px;
	margin-top:3px;
	margin-bottom:3px;"
}
.statusStyle{
	width:180px!important;
	padding-top:2px;
	padding-bottom:2px;
	margin-top:3px;
	margin-bottom:3px;"
}
.numberStyle{
	width:40px!important;
	padding-top:2px;
	padding-bottom:2px;
	margin-top:3px;
	margin-bottom:3px;"
}
.topHeaderDivStyle{
	z-index:1000;
	position:fixed!important; 
	background-image:url('/resource/1320196970000/dashboardBg');"
}

