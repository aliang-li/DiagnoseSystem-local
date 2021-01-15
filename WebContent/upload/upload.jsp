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
<link rel="stylesheet" type="text/css" href="plugin/sweetalert2/dist/sweetalert2.min.css">
<link href="http://at.alicdn.com/t/font_1551254_sk7y2quxfyq.css" rel="stylesheet" type="text/css" />
<script src="plugin/sweetalert2/dist/sweetalert2.min.js"></script>
<!-- for IE support -->
<!-- <script src="path/to/es6-promise/promise.min.js"></script>    -->
<style>
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
}
.STYLE1 {	font-size: 26px;
	font-family: Microsoft YaHei;
	color: rgb( 251, 247, 247 );
	line-height: 1.0;
	position: absolute;
	left: 153px;
	top: 18px;
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
	width: 750px;
}
.swal2-container{
	position:absolute;
}
body.swal2-toast-shown .swal2-container.swal2-bottom {
    top: auto;
    right: auto;
    bottom: 30px;
    left: 50%;
    transform: translateX(-50%);
}
</style>
<script src="jquery-1.11.3.js" type="text/javascript"></script>
<script src="jquery.js" type="text/javascript"></script>
<!-- <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script> -->
<script src="plugin/jszip.js"></script>
<script src="plugin/jszip-utils.js"></script>
<script src="jquery.Huploadify.js" type="text/javascript"></script>
</head>

<body>
<!--  <form action="uploads" method="post" enctype="multipart/form-data"> -->
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="85" colspan="3" bordercolor="#000000" bgcolor="#000000"><table width="408" height="85" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="66" align="center">&nbsp;</td>
        <td width="91" align="center"><img src="../images/logo.png" width="80" height="80" /></td>
        <td width="251" align="center"><span class="STYLE1">大智慧医疗辅助诊断平台<span class="STYLE2" style="font-size:12px"> Great Wisdom Medical Aided Diagnosis Platform</span></span></td>
      </tr>
      
    </table></td>
  </tr>
  <tr>
    <td width="100" height="72">&nbsp;</td>
    <td width="85%" height="72"><table width="100%" height="60" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="1075"><span class="STYLE4"><a  href="javascript:parent.window.location.href='../main/main.jsp'"
					onclick="ChangeCss(this)"
						target="_parent"
						style="color:#3EAA42">首页</a></span> <span id="typeName" class="STYLE4">&gt; ${param.name }</span></td>
       	<td width="204"><div align="right" class="STYLE4"><a href="#"></a>${sessionScope.user.loginname },欢迎您!</div>
        <td width="36"><div align="right"><img src="../images/user1.png" width="35" height="35" /></div></td>
      </tr>
    </table> </td>
    <td width="100" height="72">&nbsp;</td>
  </tr>
  <tr>

    <td width="100" height="100%">&nbsp;</td>
    <td width="80%" height="720" bgcolor="#F0F1F5"><table width="800" height="500" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
        <div class="width_auto">
    	<div id="container">
        <!--头部，相册选择和格式选择-->
        <div id="uploader" style="position:relative">
            <div class="item_container">                             
               <div id="" class="queueList" >
                  <div style="position:relative; font:normal 14px/24px 'MicroSoft YaHei';">
                       <p>${param.typeName=="facialDetection"?"说明：仅支持.mp4文件的上传，文件大小不超过300M":param.typeName=="intestineSegment"?"说明：仅支持.nii.gz压缩文件的上传，文件大小不超过300M":"说明：仅支持.zip压缩文件的上传，文件大小不超过300M" }</p>                  
                  		<div id="dndArea" class="placeholder" style="background: url(../images/image2.png) center 30px no-repeat">
                        	<div id="upload" style="text-align:middle"></div>     					
     					</div>
     			  </div>
     		   </div>
      		</div>
      	</div>  
      </div>
    <div style="text-align:center;margin-top:17px;">
    	<button id="repalce"  name="uploadImage" class="upload-button" >01:点击检查文件</button>
    	<button id="btn2"     class="upload-button" >02:点击上传文件</button>	
    	<button id="diagnose" name="diagnose"  class="upload-button" style="visibility: hidden" onclick="window.location.href='diagnose.action'">03:进行辅助诊断</button>	
    	<button id="3d"     class="upload-button" style="visibility: hidden"><a href="../test3D/test3D.jsp?niiName=test.nii.gz" target="_blank">查看原数据的3D效果</a></button>	
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
</div>
</table>
<script type="text/javascript">
function ChangeCss(obj){
	var alist = document.getElementsByTagName('a');
	for(var i=0;i<alist.length;i++){
		alist[i].style.color="green";
	}
	obj.style.color="white"
}
</script>
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
    		fileTypeExts:'${param.typeName=="facialDetection"?"*.mp4":param.typeName=="intestineSegment"?"*.nii.gz":"*.zip" }',
    		multi:false,
    		fileSizeLimit:5120000,//允许上传的文件大小，单位KB
    		showUploadedPercent:true,
    		showUploadedSize:true,
    		removeTimeout:10000000,
    		uploader:"http://localhost:8090/SH/UploadServlet",
    		onUploadStart:function(file){
    			console.log(file.name+'开始上传');
    			$("#repalce, #btn2").attr('disabled',"true");
    		},
    		onInit:function(obj){
    			console.log('初始化');
    			console.log(obj);
    		},
    		onUploadComplete:function(file){
    			$("#diagnose").attr("style","visibility: show");
    			console.log(file.name+'上传完成');
    			var typeName = $("#typeName").text();
    			var flag = typeName.search("小肠癌AI辅助分割");
    			if(flag != -1){
    				$("#3d").attr("style","visibility: show");
    			}
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

