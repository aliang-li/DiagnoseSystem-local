<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>文件上传</title>
<link rel="stylesheet" type="text/css" href="Huploadify.css"/>
<link rel="stylesheet" type="text/css" href="webuploader.css" />
<link rel="stylesheet" type="text/css" href="style.css" />
<link href="../bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
}
.STYLE1 {	font-size: 26px;
	font-family: Microsoft YaHei;
	color: rgb( 251, 247, 247 );
	line-height: 1.278;
	position: absolute;
	left: 153px;
	top: 25px;
	z-index: 15;
	width: 293px;
	height: 55px;
}
.STYLE2 {font-size: 10px}
.STYLE4 {
	color: #3EAA42;
	font-size: 16px;
}
a:link{text-decoration:none; color:#504c4c;}
a:visited{text-decoration:none; color:#504c4c;}
a:hover{text-decoration:underline; color:#3EAA42;}
.STYLE5 {
	font-size: 18px;
	font-weight: bold;
}
.width_auto{
	width: 1000px;
}
#uploader .placeholder {
    border: 3px dashed #e6e6e6;
    min-height: 120px;
    padding-top: 90px;
    text-align: center;
    background: url(../images/image2.png) center 30px no-repeat;
    color: #cccccc;
    font-size: 18px;
    position: relative;
}
li{
position:relative;
}
.videotip{
	position:absolute;
	z-index:1;
    top:-27px;
	left:30px;
	color:white;
	background:#71ac69;
	opacity:0.9;
	font-size:15px;
	border-radius:3px;
	width: 60px;
	text-align: center;
}
video{
cursor:pointer;
}
.checkboxall span{
position: absolute;
right: 47px;
top: -3px;
}
.clear{
     clear: both;
}

.checkboxall{
	
	positive:relative;
	
}
.checkboxall label{
	display:block;
	width:114px;
	height:18px;
	background:#f9f8f8;
	cursor:pointer;
	position:absolute;
	bottom:2px;
	left:3px;
	z-index:1;
	font-size: 12px;
	text-align: center;
	color: #343733;
	opacity: 0.7;
}
.checkboxall input[type="checkbox"]{
display:none;
}
.sclzbtn button{
	/* background-color:#71ac69;
	color:white; */ 
	background-color:#f9f8f8;
	color:#393434f0; 
}
.uploadify-queue-item{
background-color: white;
padding:0px;
}
.uploadify-queue{
margin-bottom: 0;
}
</style>
<script src="jquery-1.11.3.js" type="text/javascript"></script>
<script src="layer.js" type="text/javascript"></script>
<script src="plugin/jszip.js"></script>
<script src="plugin/jszip-utils.js"></script>
<script src="jquery.Huploadify.js" type="text/javascript"></script>
<script type="text/javascript" src="uploadmt.js"></script>
<script type="text/javascript" src="../bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script type="text/javascript" src="video.js"></script>
<!-- <link href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css" rel="stylesheet"> -->
<link href="https://cdn.bootcss.com/sweetalert/1.1.3/sweetalert.min.css" rel="stylesheet">
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script> -->
<script src="https://cdn.bootcss.com/sweetalert/1.1.3/sweetalert.min.js"></script>
</head>

<body>
<!--  <form action="uploads" method="post" enctype="multipart/form-data"> -->
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="101" colspan="3" bordercolor="#000000" bgcolor="#000000"><table width="408" height="100" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="66" align="center">&nbsp;</td>
        <td width="91" align="center"><img src="../images/logo.png" width="80" height="82" /></td>
        <td width="251" align="center"><span class="STYLE1">大智慧医疗辅助诊断平台<span class="STYLE2"> Great Wisdom Medical Aided Diagnosis Platform</span></span></td>
      </tr>
      
    </table></td>
  </tr>
  <tr>
    <td width="100" height="72">&nbsp;</td>
    <td width="85%" height="72"><table width="100%" height="60" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="1075"><span class="STYLE4">首页</span> <span class="STYLE4">&gt; ${param.name }</span></td>
        <td width="204"><div align="right" class="STYLE4"><a href="#"></a>${sessionScope.user.loginname },欢迎您!</div>
			<div align="right" class="STYLE4"><a  href="javascript:parent.window.location.href='../main/main.jsp'"
						onclick="ChangeCss(this)"
							target="_parent"
							style="color:green">返回首页</a></div></td>
        <td width="36"><div align="right"><img src="../images/user1.png" width="35" height="35" /></div></td>
      </tr>
    </table> </td>
    <td width="100" height="72">&nbsp;</td>
  </tr>
  <tr>

    <td width="100" height="100%">&nbsp;</td>
    <td width="80%" height="670" bgcolor="#F0F1F5"><table width="1000" height="500" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
        <div class="width_auto">
    	<div id="container">
        <!--头部，相册选择和格式选择-->
        <div id="uploader" >
            <div class="item_container">                             
               <div id="" class="queueList" >
                  <div style="position:relative; font:normal 14px/24px 'MicroSoft YaHei';">
                  <span style="color:#838383;">【1.请从以下七个动作中选择一种进行录制/上传】</span>
                 	<ul style="margin-top: 35px;">
                 	<li class="choose" style="float:left;list-style:none;">
                 	<video width="120" height="200"  autoplay="autoplay" muted="muted" loop="loop">
        			<source src="../images/taimei.mp4" type="video/mp4">
                  </video> 
                  <div class="videotip">
                  <span>抬眉</span>
                  </div>
                  <div class="checkboxall">
                  <input id="taimei" type="checkbox" value="" /><label for="taimei"><span>选择</span></label>
                  </div>
                 	</li>
                 	<li class="choose" style="float:left;list-style:none;margin-left:5px;">
                 	<video width="120" height="200" autoplay="autoplay" muted="muted" loop="loop">
       				 <source src="../images/zhoumei.mp4" type="video/mp4">
                  </video> 
                   <div class="videotip">
                  <span>皱眉</span>
                  </div>
                  <div class="checkboxall">
                  <input id="zhoumei" type="checkbox" value="" /><label for="zhoumei" ><span>选择</span></label>
                  </div>
                 	</li>
                 	<li class="choose" style="float:left;list-style:none;margin-left:5px;">
                 	<video width="120" height="200" autoplay="autoplay" muted="muted" loop="loop">
      				  <source src="../images/biyan.mp4" type="video/mp4">
                  </video> 
                   <div class="videotip">
                  <span>闭眼</span>
                  </div>
                  <div class="checkboxall">
                  <input id="biyan" type="checkbox" value="" /><label for="biyan" ><span>选择</span></label>
                  </div>
                 	</li>
                 	<li class="choose" style="float:left;list-style:none;margin-left:5px;">
                 	<video width="120" height="200" autoplay="autoplay" muted="muted" loop="loop">
       				 <source src="../images/songbi.mp4" type="video/mp4">
                  </video> 
                   <div class="videotip">
                  <span>耸鼻</span>
                  </div>
                  <div class="checkboxall">
                  <input id="songbi" type="checkbox" value="" /><label for="songbi" ><span>选择</span></label>
                  </div>
                 	</li>
                 	<li class="choose" style="float:left;list-style:none;margin-left:5px;">
                 	<video width="120" height="200" autoplay="autoplay" muted="muted" loop="loop">
       				 <source src="../images/gusai.mp4" type="video/mp4">
                  </video> 
                   <div class="videotip">
                  <span>鼓腮</span>
                  </div>
                  <div class="checkboxall">
                  <input id="gusai" type="checkbox" value="" /><label for="gusai" ><span>选择</span></label>
                  </div>
                 	</li>
                 	<li class="choose" style="float:left;list-style:none;margin-left:5px;">
                 	<video width="120" height="200" autoplay="autoplay" muted="muted" loop="loop">
      				  <source src="../images/shichi.mp4" type="video/mp4">
                  </video> 
                   <div class="videotip">
                  <span>示齿</span>
                  </div>
                  <div class="checkboxall">
                  <input id="shichi" type="checkbox" value="" /><label for="shichi" ><span>选择</span></label>
                  </div>
                 	</li>
                 	<li class="choose" style="float:left;list-style:none;margin-left:5px;">
                 	<video width="120" height="200" autoplay="autoplay" muted="muted" loop="loop">
     				   <source src="../images/weixiao.mp4" type="video/mp4">
                  </video> 
                   <div class="videotip">
                  <span>微笑</span>
                  </div>
                  <div class="checkboxall">
                  <input id="weixiao" type="checkbox" value="" /><label for="weixiao" ><span>选择</span></label>
                  </div>
                 	</li>
                 	<li class="clear" style="list-style:none;"></li>
                 	</ul>
                   <p style="text-align:center;">您当前选择的动作是——<span id="choose_res">未选</span></p>
                  <HR style="height:0.8px;" width="100%" color="#71ac69" SIZE=1>
                   <p>【2.请选择录制或上传】</p>
					<div class="sclzbtn" style="text-align:center">
                 		<button id="scbtn"  name="" class="btn btn-default" >点击进行上传</button>
                 		<button id="lzbtn"  name="" class="btn btn-default" data-toggle="modal" data-target="#myModal" >点击进行录制</button>
                 	</div>
                 	 <HR style="height:0.8px;" width="100%" color="#71ac69" SIZE=1>
                 	<div id="lz" style="display:none;">
                 	<button id=""  name="" class="" >开始录制</button>
                 	</div>
                 	<div id="sc" style="display:none;">
                     <p>${param.typeName=="facialDetection"?"说明：仅支持.mp4文件的上传，文件大小不超过300M":param.typeName=="intestineSegment"?"说明：仅支持.nii.gz压缩文件的上传，文件大小不超过300M":"说明：仅支持.zip压缩文件的上传，文件大小不超过300M" }</p>                  
                      <div id="dndArea" class="placeholder" style="background: url(../images/mp4.png) center 30px no-repeat">
                      	<div id="upload" style="text-align:middle"></div>     					
   					  </div>
					  <div class="upbtn" style="text-align:center">
					    <button id="repalce"  name="uploadImage" class="btn upload-button" >01:点击检查文件</button>
					    <button id="btn2"     class="btn upload-button" >02:点击上传文件</button>	
					    <button id="diagnose" name="diagnose"  class="btn upload-button" style="visibility: hidden" onclick="window.location.href='diagnose.action'">03:进行辅助诊断</button>	
					   </div> 
     				</div>
     			  </div>
     		   </div>
      		</div>
      	</div>  
      </div>
    </td>
      </tr>
    </table></td>
  </tr>
<% String typeName =request.getParameter("typeName");
String name = request.getParameter("name");
	request.getSession().setAttribute("typeName", typeName);
	request.getSession().setAttribute("name", name);
%>   

</table>
<!-- 模态框（Modal） -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h4 class="modal-title" id="myModalLabel">
					请开始录制
				</h4>
			</div>
			<div class="modal-body">
				<table>
        		<tr>
        			<td style="width:30px;"></td>
        			<td> <video id="gum" autoplay muted style="width:400px;height:400px;background-color:black;"></video></td>
        			<td style="width:100px;"></td>
        			<td> <video id="play" autoplay muted  controls="controls" autoplay="autoplay" style="width:300px;height:300px;"></video></td>
        		</tr>
        	</table>
			</div>
			<div class="modal-footer">
				
				<!-- <button id="openCamera" class="btn btn-default">开启摄像头</button> -->
    			<button id="record" class="btn btn-default" >开始录制</button>
    			<button id="upload"  class="btn btn-default" >上传</button>
    			<button id="close" type="button" class="btn btn-default" data-dismiss="modal">取消录制
				</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal -->
</div>
<script type="text/javascript">
	$(function(){
		var flag = ${param.typeName=="facialDetection"};
		if(flag==true){
			$("#dndArea").css({"background":"url(../images/mp4.png) center 30px no-repeat"});
		}
		
	});
</script>
<script type="text/javascript">  
	//用来存放服务器端传过来文件库的数据
	var patientName ;
	var a;
	//用来存放不符合规定的文件条目
    var btn = document.getElementById("repalce");  
    btn.onclick =function(){  
    	/* $.get("PacientFileNameServlet",function(data,status)
    	{
   			patientName = data;
   			a = patientName;
   		}); */
    	document.getElementById("file_upload_1-button").click();    	
    };
   
</script> 
<script type="text/javascript">

    $(function(){
    	var up = $('#upload').Huploadify({
    		auto:false,
    		fileTypeExts:'*.mp4',
    		multi:false,
    		fileSizeLimit:5120000,//允许上传的文件大小，单位KB
    		showUploadedPercent:true,
    		showUploadedSize:true,
    		removeTimeout:10000000,
    		uploader:"http://localhost:8090/SH/UploadServlet",
    		onUploadStart:function(file){
    			console.log(file.name+'开始上传');
    		},
    		onInit:function(obj){
    			console.log('初始化');
    			console.log(obj);
    		},
    		onUploadComplete:function(file){
    			console.log(file.name+'上传完成');
    			$("#diagnose").attr("style","visibility: show")
    		},
    		onCancel:function(file){
    			
    		},
    		onClearQueue:function(queueItemCount){
    			console.log('有'+queueItemCount+'个文件被删除了');
    		},
    		onDestroy:function(){
    			console.log('destroyed!');
    		},
    		onSelect:function(files){
    	  		
    			console.log(files.name+'加入上传队列');
    		},
    		onQueueComplete:function(queueData){
    			console.log('队列中的文件全部上传完成',queueData);
    		}
    	});

    	$('#btn2').click(function(){
    		up.upload('*');
    	});
    	$('#btn3').click(function(){
    		up.cancel('*');
    	});
    	$('#btn4').click(function(){
    		//up.disable();
    		up.Huploadify('disable');
    	});
    	$('#btn5').click(function(){
    		up.ennable();
    	});
    	$('#btn6').click(function(){
    		up.destroy();
    	});
    	
    });
</script> 



</body>
</html>

