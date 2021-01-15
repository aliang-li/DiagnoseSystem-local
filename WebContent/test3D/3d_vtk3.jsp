<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="java.util.List"%> 
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@ page import="java.io.File"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="apple-touch-fullscreen" content="yes"/>
<meta name="format-detection" content="email=no" />
<meta name="wap-font-scale"  content="no" />
<meta name="viewport" content="user-scalable=no, width=device-width" />
<meta content="telephone=no" name="format-detection" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>三维重建</title>
<link href="http://at.alicdn.com/t/font_1551254_rxrrzgz2kjc.css" rel="stylesheet" type="text/css" /><!--地址不定时更新，引用时请注意-->
<link href="../VTK/src/css/ax.css" rel="stylesheet" type="text/css" >
<link href="../VTK/src/plugins/qtip2/jquery.qtip.css" rel="stylesheet" type="text/css" >
<script src="../VTK/src/js/jquery.js" type="text/javascript"></script>
<script src="../VTK/src/js/ax.js" type="text/javascript"></script>
<script src="../VTK/src/js/colorpicker.js" type="text/javascript"></script>
<link rel="stylesheet" href="../VTK/src/plugins/rangeSlider/css/ion.rangeSlider.min.css"/>
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script> -->
<script src="../VTK/src/plugins/rangeSlider/js/ion.rangeSlider.min.js"></script> 
<script src="../VTK/src/plugins/qtip2/jquery.qtip.min.js"></script>
<style>
	.ax-panel-body{
		padding:5px 5px 5px 14px;
	}
	.showOrgan{
		position:relative;
	}
	.showOrgan input{
		width: 10px;
	    height: 10px;
	    background-color: #fff;
		position:absolute;
		left: 0;
		 -webkit-apearance : none;   
		 appearance:none;
    	-o-appearance:none;
    	-moz-appearance:none; 
    }
	.showOrgan i{
		display:inline-block;
	}
	.ax-form-input {
	    width: 235px;
	}
	#color-picker{
	    display: flex;
	    flex-flow: row;
	    flex-wrap: nowrap;
	    flex-wrap: wrap;
	}
	#color-picker div{
	    position: relative;
	    box-shadow: inset 0 0 0 1px rgba(0, 0, 0, 0.3);
	    border-radius: 25%;
	    margin: 4px;
	    cursor: pointer;
	    transition: border 50ms;
	    width:24px;
	    height:24px;
	}
	#color-picker div:hover {
    	border: 1px solid rgba(0, 0, 0, 0.8);
	}
	
	.floatToolbar {
	    position: absolute;
	    z-index: 1;
	    right: 10px;
	    top: 10px;
	    background-color: rgba(0, 0, 0, 0.4);
	    border-radius: 16px;
	}
	.floatToolbar .ax-iconfont{
		font-size:20px;
	}
	.layout {
	    display: flex;
	    flex: 1 1 auto;
	    flex-wrap: nowrap;
	    min-width: 0;
	}
	.layout.column {
	    flex-direction: column;
	}
	.floatToolbar button{
		height: 36px;
		width: 36px;
		color: #fff;
		background:rgba(0,0,0,0);
		border-radius:50%;
		border-color:rgba(0,0,0,0);
	}
	.floatToolbar button:hover{
		background:rgba(0,0,0,0.1);
		border-color:rgba(0,0,0,0);
	}
	.ax-padding {
	    padding: 14px 14px 14px 0;
	    box-sizing: border-box;
	}
	.text-left{
		text-align:left;
		color:rgba(0,0,0,.6)
	}
</style>
</head>
<body>
<%!File file = null; //声明全局%> 
<%
 	String organListC[] = {"骨骼", "肝", "胃", "胰腺", "肠道","标注显示"};
 	String organListE[] = {"bone", "liver", "stomach", "pancreas", "bowel","label"};
 	String path=(String)session.getAttribute("path"); //dcm文件的父目录
 	String maskPath = path + "_mask"; //后端存储标注图片的目录
 	  
 	File maskFile = new File(maskPath);
 	String[] maskFiles = maskFile.list();
 	String[] maskFiles2;
 	
 	if (maskFiles == null){
 		maskFiles2 = new String[0];
 	
 	}else if (maskFiles.length != 0){//有标注
 		List<String> list=Arrays.asList(maskFiles);
 		List<String> arrayList= new  ArrayList<String>(list); //arrayList就是最后筛选出来的mask图片 路径的列表
 	 	for(int i = 0; i < arrayList.size(); i++){
 	 		String suffix = arrayList.get(i).substring(arrayList.get(i).lastIndexOf(".")+1);
 	 		if(!suffix.equals("jpg")  || arrayList.get(i).contains("mask")){
 			 	arrayList.remove(i);
 			 	i--;
 	 		}
 	 	}
 	 	String[] temp= new String[arrayList.size()]; //maskFiles2 这个数组存mask.jpg路径的数组
 	 	arrayList.toArray(temp);
 	 	maskFiles2 = temp;
 	} else{
 		maskFiles2 = new String[0];
 	}
 	file = new File(path);

 	String[] files = file.list();

 	String path1;
 	path1 = path.substring(path.lastIndexOf('/') + 1);
 	String prePath = path.substring(0, path.lastIndexOf('/'));
 	String prePath1 = prePath.substring(0, prePath.lastIndexOf('/'));

 	String lastPath = path.substring(prePath1.lastIndexOf('/') + 1);

 	for (int i = 0; i < files.length; i++) {
 		files[i] = "\"http://localhost:8080/test/" + lastPath + "/" + files[i] + "\"";
 	}
 	for (int i = 0; i < maskFiles2.length; i++) {
 		maskFiles2[i] = "\"http://localhost:8080/test/" + lastPath + "_mask" + "/" + maskFiles2[i] + "\"";
 	}

 	String str = "[";
 	for (int i = 0; i < files.length; i++) {
 		if (i != files.length - 1) {
 			str = str + files[i] + ",";
 		} else {
 			str = str + files[i] + "]";
 		}
 	}

 	String strMask = "[";
 	for (int i = 0; i < maskFiles2.length; i++) {
 		if (i != maskFiles2.length - 1) {
 			strMask = strMask + maskFiles2[i] + ",";
 		} else {
 			strMask = strMask + maskFiles2[i] + "]";
 		}
 	}
 	if (maskFiles2.length == 0){
 		strMask = strMask + "]";
 	}
 %>

<div class = "container" style="height:100%">
	<div class = "ax-flex-row" style="height:100%"> 
		<div class = "" style="padding:10px 0 0 10px;width:400px"> <!-- 布局中自由的部分 -->
			
			
			<div class="ax-break-line"></div>
			
			<div class="ax-accordion ax-border ax-radius">
			 <% for (int i = 0; i < organListC.length; i++){ %>
				<div class="ax-item">
	                <div class="ax-panel-header ax-row">
	                	<i class="ax-adorn ax-panel-close ax-iconfont ax-icon-right"></i>
	                	<div class="ax-col"><b class="ax-title"><%=organListC[i] %></b></div>
	                	<a href="javascript:;" class="ax-operate showOrgan">
	                		<input id="<%=organListE[i] %>" name="" value="" type="checkbox" >
		                	<i class="ax-iconfont ax-icon-eye-off-fill close"></i>
		                	<i class="ax-iconfont ax-icon-eye-fill open" style="display: none;"></i>
	                	</a>
	                </div>
	                <div class="ax-panel-body">
	                    <div class="ax-break-line"></div>
	                    <div class="ax-padding">
                    		<div class="ax-panel ax-border ax-radius">
					    	<div class="ax-panel-header">阴影和边缘</div>
					    	<div class="ax-break-line"></div>
						    <div class="ax-panel-body">
						    	<div class="ax-form-group">
				                     <div class="ax-flex-row">
				                         <div class="ax-form-label text-left" style="width:75px;">Sample Distance</div>
				                         <div class="ax-form-con">
				                             <div class="ax-form-input"><input name="sample distance" placeholder="" class="sdSlider"  id="<%=organListE[i] %>_sd_<%=i %>" value="" type="text"></div>
				                         </div>
				                     </div>
				                 </div>
				                 <div class="ax-form-group">
				                     <div class="ax-flex-row">
				                         <div class="ax-form-label text-left" style="width:75px;">Edge Gradient</div>
				                         <div class="ax-form-con">
				                             <div class="ax-form-input"><input name="edge gradient" placeholder="" class="egSlider" id="<%=organListE[i] %>_eg_<%=i %>" value="0.5" type="text"></div>
				                         </div>
				                     </div>
				                 </div>
						    </div>
							</div>
	                    </div>
	                </div>
	            </div>
	            <div class="ax-break-line"></div>
	         <% }%>
            </div>
			
			<div class="ax-break"></div>
			
			<div class="ax-panel ax-border ax-radius">
		    	<div class="ax-panel-header" >背景颜色</div>
		    	<div class="ax-break-line"></div>
			    <div class="ax-panel-body"><!-- 颜色选择器  -->
					<div id="color-picker"></div>
			    </div>
			</div>
			
			<div class="ax-break"></div>
			
			<div class="ax-panel ax-border ax-radius">
		    	<div class="ax-panel-header" >标注</div>
		    	<div class="ax-break-line"></div>
			    <div class="ax-panel-body">
					<button id="loadLabel" class="ax-btn" type="button" disabled>加载/重载标注信息</button>
			    </div>
			</div>
			
			<div class="ax-break"></div>
			
			
			
		</div>
		
		<div class= "ax-flex-block" style="background-color:;background-image: url(src/images/loading-white.svg);background-position: center;background-repeat: no-repeat;"> <!-- 布局中撑满的部分 -->
			<div id="vr-showPanel" class="" > 
				<div class="floatToolbar layout column">
					<button class="ax-btn" type="button" id="tool01" onClick="updateOrientation('x')">
						<span><i class="ax-iconfont ax-icon-bigger"></i></span>
					</button>
					<button class="ax-btn" type="button">
						<span><i class="ax-iconfont ax-icon-refresh"></i></span>
					</button>
					<button class="ax-btn" type="button" onClick="updateOrientation('x')">
						<span><i class="ax-iconfont">X</i></span>
					</button>
					<button class="ax-btn" type="button" onClick="updateOrientation('y')">
						<span><i class="ax-iconfont">Y</i></span>
					</button>
					<button class="ax-btn" type="button" onClick="updateOrientation('z')">
						<span><i class="ax-iconfont">Z</i></span>
					</button>
				</div>
			</div>
		</div>
	</div>
	
</div>
<script type="text/javascript" src="https://unpkg.com/@babel/polyfill@7.0.0/dist/polyfill.js"></script>
<script type="text/javascript" src="https://unpkg.com/vtk.js"></script>
<script src="https://unpkg.com/itk@12.4.0/umd/itk.js"></script> 
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script type="text/javascript">
	var $d1 = $(".sdSlider");
	var $d2 = $(".egSlider");
	$d1.ionRangeSlider({
		skin: "ax",
		min: 0,
		max: 1, 
	  	step: 0.01,
	  	from: 0
	});
	$d2.ionRangeSlider({
		skin: "ax",
		min: 0,
		max: 1, 
	  	step: 0.01,
	  	from: 0
	});
	$('#tool01').qtip({
		content: {
            text: '重置相机'
        },
	    position: {
            at: 'left center',
            my: 'right center',
        },
        show:{
        	event: 'hover'
        }
    });
	
</script>
 
<script type="text/javascript">
	var currentUrl = document.location.href;
	var pathname = window.location.pathname;
	var pre_url = currentUrl.split(pathname)[0];
</script>
 
<!-- <script type="text/javascript" src="../ITK/node_modules/itk/umd/itk.js"></script> -->

        <script type="text/javascript">
        var maskCount = 0;	
        var files_array = new Array(); //用于存储file的数组  不需要排序
		var maskJpgs_array = new Array();
		var image_itk = null; //加载dcm序列后生成的itk的image类型
		var labelItkImage = new itk.Image();  //在加载dcm序列后将labelItkImage初始化
	
		var volDCM = vtk.Rendering.Core.vtkVolume.newInstance();
		var volMask = vtk.Rendering.Core.vtkVolume.newInstance();
	
		var urls = <%=str%>
		var urlMasks = <%=strMask%>
        
		
        url_liver = 'http://localhost:8080//vtk//liver-seg.nii.gz';
        url_bowel = 'http://localhost:8080//vtk//bowel-seg.nii.gz';
        url_stomach = 'http://localhost:8080//vtk//stomach-seg.nii.gz';
        url_pancreas = 'http://localhost:8080//vtk//pancreas-seg.nii.gz';
        url_bone = 'http://localhost:8080//vtk//bone.nii.gz';
        
        function getLiverSeg() {
        	return axios.get(url_liver, { responseType: 'arraybuffer' }).then(function(response) {
               return itk.readArrayBuffer(null, response.data, 'data.nii.gz')
             })
        }

       	function getBowelSeg() {
       	 	return axios.get(url_bowel, { responseType: 'arraybuffer' }).then(function(response) {
              return itk.readArrayBuffer(null, response.data, 'data.nii.gz')
          	})
       	}
       	
       	function getStomachSeg() {
       	 	return axios.get(url_stomach, { responseType: 'arraybuffer' }).then(function(response) {
              return itk.readArrayBuffer(null, response.data, 'data.nii.gz')
          	})
       	}
       	
       	function getPancreasSeg() {
       	 	return axios.get(url_pancreas, { responseType: 'arraybuffer' }).then(function(response) {
              return itk.readArrayBuffer(null, response.data, 'data.nii.gz')
          	})
       	}
       	
       	function getBone() {
       	 	return axios.get(url_bone, { responseType: 'arraybuffer' }).then(function(response) {
              return itk.readArrayBuffer(null, response.data, 'data.nii.gz')
          	})
       	}
       	
       	
       	const rootContainer = document.querySelector('#vr-showPanel');
		rootContainer.style.position = 'relative';
		rootContainer.style.width =$(window).width()-420;
		//rootContainer.style.height = '800px';
		rootContainer.style.height = '100%';
		rootContainer.style.background = 'rgba(0, 0, 0, 0) linear-gradient(rgb(51, 51, 51), rgb(153, 153, 153)) repeat scroll 0% 0%'
		rootContainer.style.margin = '10px 10px 0 0';
   		var screenRenderer = vtk.Rendering.Misc.vtkRenderWindowWithControlBar.newInstance({
   		  controlSize: 50,
   		});

        screenRenderer.setContainer(rootContainer);
        
        screenRenderer.getControlContainer().style.background = '#272727';
        screenRenderer.getControlContainer().style.display = 'flex';
        screenRenderer.getControlContainer().style.alignItems = 'stretch';
        screenRenderer.getControlContainer().style.justifyContent = 'stretch';
        screenRenderer.getControlContainer().innerHTML = `
            <div style= "color:white;width:100%;line-height:50px;text-align:center">控制台</div>
        `;
        screenRenderer.setControlPosition("bottom");
         
        var renderWindow = screenRenderer.getRenderWindow();
        var renderer = screenRenderer.getRenderer();
        renderer.setBackground(0,0,0,0)
        
        screenRenderer.resize();
        var camera = vtk.Rendering.Core.vtkCamera.newInstance();
       	//console.log(vtk)
       	
       	axios.all([getLiverSeg(), getBowelSeg(), getStomachSeg(), getPancreasSeg(), getBone()]).then(axios.spread(function (liver, bowel, stomach, pancreas, bone) {
       	    // 请求现在都执行完成
       	    
       	    var res = [bone, liver, stomach, pancreas, bowel]
       	    var volumes = new Map();
       		
       	    for(let organ of res) {  
       	    	organ.webWorker.terminate()
       	    }
       	    var origin_image = vtk.Common.DataModel.vtkITKHelper.convertItkToVtkImage(res[0].image)
   		    var spacing = origin_image.getSpacing() 
   		
       	 	boneVR = volumeRendering(res[0].image, getVolumeProperty('bone'), spacing)
       	    liverVR = volumeRendering(res[1].image, getVolumeProperty('liver'), spacing)
       	    stomachVR = volumeRendering(res[2].image, getVolumeProperty('stomach'), spacing)
       	    pancreasVR = volumeRendering(res[3].image, getVolumeProperty('pancreas'), spacing)
       	    bowelVR = volumeRendering(res[4].image, getVolumeProperty('bowel'), spacing)
       	    
       	//加载骨骼
       		//将boneVR换了   换成volDCM 并设为全局变量     lzl
       	 	for(let i = 0; i < urls.length; i++){
     			getImageFileFromUrl(urls[i],urls[i].substring(urls[i].lastIndexOf('/')+1),"dcm",files_array);
     		}
       	    
       	    
       	    //volumes.set("bone",boneVR)
       	    volumes.set("liver",liverVR)
       	    volumes.set("stomach",stomachVR)
       	    volumes.set("pancreas",pancreasVR)
       	    volumes.set("bowel",bowelVR)
       	    
            var values = volumes.values()
            
            for(var value of values){
      			renderer.addVolume(value) //先都加入 0 1 2 3 
      		}
            
            
            $(".showOrgan").click(function(){
            	debugger;
            	if (!$(this).hasClass("show")) {
            		$(this).children(".close").css("display","none")
                    $(this).children(".open").css("display","");
            		$(this).addClass("show")
            		$(this).children("input").attr("checked",true);
            	} else{
            		$(this).children(".close").css("display","")
                    $(this).children(".open").css("display","none");
            		$(this).removeClass("show")
            		$(this).children("input").attr("checked",false);
            	}
            	render()
			})
			camera.setViewUp(0, 0, 1)  //设置成像y正方向。是否有负号取决于原始的相机坐标系中，y是朝向相机上方（正）还是下方（负） 即哪个方向为相机朝上的方向
			camera.setPosition(0, -1, 0) //光心 相机所在的位置
			camera.setFocalPoint(0, 0, 0) //焦点
			renderer.setActiveCamera(camera)
			renderer.resetCamera();
			//render()
			
			
			//sampleDistance滑动条变化-----------------当前仅支持小肠
			$d1.on("change", function() {
				var id = $(this).attr("id").split("_")[2]
				var organ =  $(this).attr("id").split("_")[0]
				var imageData = vtk.Common.DataModel.vtkITKHelper.convertItkToVtkImage(res[id].image)
				var sampleDistance = $(this).data("from")
				var distance = 1
				var model = volumes.get(organ)
				if (sampleDistance !== distance) {
					distance = sampleDistance
				    const sourceDS = imageData;
				    sampleDistance = 0.7 * Math.sqrt( sourceDS.getSpacing().map((v) => v * v).reduce((a, b) => a + b, 0));
				    model.getMapper().setSampleDistance(sampleDistance * 2 ** (distance * 3.0 - 1.5));
				    render()
			     }
			})
			
	       	
			//edgeGradient滑动条变化-----------------当前仅支持小肠
			 $d2.on("change", function () {
				 var id = $(this).attr("id").split("_")[2]
				 var organ =  $(this).attr("id").split("_")[0]
				 var edgeGradient = $(this).data("from")
				 var volume = volumes.get(organ)
				 var imageData = vtk.Common.DataModel.vtkITKHelper.convertItkToVtkImage(res[id].image)
	         	 const dataArray = imageData.getPointData().getScalars() || imageData.getPointData().getArrays()[0];
	   			 const dataRange = dataArray.getRange();
    	       	 const numberOfComponents = dataArray.getNumberOfComponents();
    	      	 if (edgeGradient === 0) {
    	        	 for (let component = 0; component < numberOfComponents; component++) {
    	          		 volume.getProperty().setUseGradientOpacity(component, false);
    	        	 }
    	      	 } else {
    	        	 for (let component = 0; component < numberOfComponents; component++) {
    	          		 const dataRange = dataArray.getRange(component);
    	          		 volume.getProperty().setUseGradientOpacity(component, true);
    	          		 const minV = Math.max(0.0, edgeGradient - 0.3) / 0.7;
	 	   	          	 if (minV > 0.0) {
	 	   	            	 volume.getProperty().setGradientOpacityMinimumValue(component,Math.exp(
	 	   	                     Math.log((dataRange[1] - dataRange[0]) * 0.2) * minV * minV)
	 	   	              	 );
	 	   	          	 } else {
	 	   	            	 volume.getProperty().setGradientOpacityMinimumValue(component, 0.0);
	 	   	          	 }
	 	   	          	 volume.getProperty().setGradientOpacityMaximumValue(component,Math.exp(
	 	   	                 Math.log((dataRange[1] - dataRange[0]) * 1.0) * edgeGradient * edgeGradient)
	 	   	             );
    	        	 }
    	      	 }
    	      	render()
			});
			
       	    
			
			
	 			
       	    
       	 }));
       
       	function render() {
   
			var values = renderer.getVolumes()
            
  			if($("#bone").is(":checked")){
  				values[4].setVisibility(true)
			}else{
				values[4].setVisibility(false)
			}
			if($("#liver").is(":checked")){
  				values[0].setVisibility(true)
			}else{
				values[0].setVisibility(false)
			}
			if($("#stomach").is(":checked")){
  				values[1].setVisibility(true)
			}else{
				values[1].setVisibility(false)
			}
			if($("#pancreas").is(":checked")){
  				values[2].setVisibility(true)
			}else{
				values[2].setVisibility(false)
			}
			if($("#bowel").is(":checked")){
  				values[3].setVisibility(true)
			}else{
				values[3].setVisibility(false)
			}
			if(values[5]){
				if($("#label").is(":checked")){
	  				values[5].setVisibility(true)
				}else{
					values[5].setVisibility(false)
				}
			}
            renderWindow.render();
       	}
       	
      	function volumeRendering(image, property, spacing) {
      		var vol = vtk.Rendering.Core.vtkVolume.newInstance()
            var volumeMapper = vtk.Rendering.Core.vtkVolumeMapper.newInstance()  //A volume mapper that performs ray casting on the GPU using fragment programs.
            
      		var imageData = vtk.Common.DataModel.vtkITKHelper.convertItkToVtkImage(image)
      		imageData.setSpacing(spacing)
      		
   	    	volumeMapper.setInputData(imageData)
   	    	//const sampleDistance = Math.sqrt(imageData.getSpacing().map((v) => v * v).reduce((a, b) => a + b, 0))
   	    	//console.log(sampleDistance) //5.125428716824574
  			//volumeMapper.setSampleDistance(sampleDistance * 2 ** -1.5) //步长越小，采样点就越多，但是体绘制效果提高的同时计算量也会增加    到-3次方旋转会变得很慢变模糊
  			
        	vol.setMapper(volumeMapper)
        	
        	const dataArray = imageData.getPointData().getScalars() || imageData.getPointData().getArrays()[0];
  			const dataRange = dataArray.getRange();
        	
        	////为了更好地渲染体积-世界距离标量不透明度为1.0
      		property.setScalarOpacityUnitDistance(0, vtk.Common.DataModel.vtkBoundingBox.getDiagonalLength(imageData.getBounds()) / Math.max(...imageData.getDimensions()))
      		
      		//-控制我们如何强调表面边界=> max应该在平均梯度幅度附近体积或平均值，再加上一个梯度大小的标准差（根据间距进行调整，这是世界坐标渐变，而不是像素渐变）
   			// =>最大hack：（dataRange [1]-dataRange [0]）* 0.05
   			property.setUseGradientOpacity(0, true); 
   			property.setGradientOpacityMinimumValue(0, 0);
   			property.setGradientOpacityMaximumValue(0, (dataRange[1] - dataRange[0]) * 0.05)
		    // - generic good default
		    //property.setGradientOpacityMinimumOpacity(0, 0.0);
		    //property.setGradientOpacityMaximumOpacity(0, 1.0);
   			
        	vol.setProperty(property)
        	
        	return vol
      	}
      	
      	function getVolumeProperty(organ) {
      		var property = vtk.Rendering.Core.vtkVolumeProperty.newInstance()
      		var color_function = vtk.Rendering.Core.vtkColorTransferFunction.newInstance()
            var composite_opacity = vtk.Common.DataModel.vtkPiecewiseFunction.newInstance()
            
            if (organ == "liver"){
            	color_function.addRGBPoint(0.0, 1, 1, 1)
                color_function.addRGBPoint(20.0, 0.9, 0.8, 0.50)
                color_function.addRGBPoint(75.0, 0.7, 0.00, 0.00)
                color_function.addRGBPoint(100.0, 0.7, 0.00, 0.00)
                color_function.addRGBPoint(120.0, 0.7, 0.00, 0.00)
                color_function.addRGBPoint(500.0, 1, 1, 1)

                composite_opacity.addPoint(0, 0.00)
                composite_opacity.addPoint(20, 0.20)
                composite_opacity.addPoint(75, 0.30)
                composite_opacity.addPoint(100, 0.30)
                composite_opacity.addPoint(120, 0.10)
            }else if (organ == "stomach"){
            	composite_opacity.addPoint(-100, 0.0)
                composite_opacity.addPoint(20, 1)
                composite_opacity.addPoint(75, 1)
                composite_opacity.addPoint(100, 1)
                composite_opacity.addPoint(120, 1)
                
                color_function.addRGBPoint(-100.0, 1, 1, 1)
                color_function.addRGBPoint(75.0, 0.6, 0, 0)
                color_function.addRGBPoint(100.0, 0.6, 0, 0)
                color_function.addRGBPoint(120.0, 0.6, 0, 0)
                color_function.addRGBPoint(500.0, 1, 1, 1)
            }else if (organ == "pancreas"){
            	composite_opacity.addPoint(0, 0.00)
                composite_opacity.addPoint(20, 0.20)
                composite_opacity.addPoint(75, 0.30)
                composite_opacity.addPoint(100, 0.30)
                composite_opacity.addPoint(120, 0.10)
                
                color_function.addRGBPoint(0.0, 1, 1, 1)
                color_function.addRGBPoint(20.0, 1, 1, 0)
                color_function.addRGBPoint(75.0, 1, 1, 0.00)
                color_function.addRGBPoint(100.0, 0.7, 0.7, 0.00)
                color_function.addRGBPoint(120.0, 0.7, 0.7, 0.00)
                color_function.addRGBPoint(500.0, 1, 1, 1)
            }else if (organ == "bowel"){ //再修改一下
            	color_function.addRGBPoint(-200.0, 1, 1, 1)
            	color_function.addRGBPoint(-50.0, 0.65, 0, 0)
                color_function.addRGBPoint(20.0, 0.7, 0, 0)
                color_function.addRGBPoint(75.0, 0.96, 0.00, 0.00)
                color_function.addRGBPoint(100.0, 1, 1, 1)

                composite_opacity.addPoint(-200, 0.00)  
		        composite_opacity.addPoint(20, 0.5)
		        composite_opacity.addPoint(30, 0.5)
		        composite_opacity.addPoint(35, 0)
		        
		        property.setShade(true) //显式调用ShadeOn()函数来打开阴影效果
		        // 在这三个系数中，当环境光系数占主导时，阴影效果不明显。当散射光系数占主导时，显示效果会比较粗燥；但反射光系数占主导时，显示效果会比较光滑。
				//当阴影效果关闭时，等同于环境光系数为1.0，其他两个系数为零。 
		        property.setAmbient(0.2); //环境光系数
    		    property.setDiffuse(0.7); //散射光系数
    		    property.setSpecular(0.3); //反射光系数
    		    property.setSpecularPower(8.0);
            }else{
            	composite_opacity.addPoint(-15, 0.00)
                composite_opacity.addPoint(75, 0.00)
                composite_opacity.addPoint(100, 0.40)
                composite_opacity.addPoint(500, 0.60)
                color_function.addRGBPoint(-400.000, 0.9, 0.8, 0.50)
                color_function.addRGBPoint(-90.00, 0.9, 0.8, 0.50)
                color_function.addRGBPoint(0.00, 8.00, 0.00, 0.00)
                color_function.addRGBPoint(190.0, 1.00, 1.00, 1.00)
                color_function.addRGBPoint(500.0, 1.00, 1.00, 1.00)
                property.setScalarOpacityUnitDistance(0, 3.0);
            	property.setInterpolationTypeToFastLinear();
            	property.setAmbient(0.2);
            	property.setDiffuse(0.7);
            	property.setSpecular(0.3);
            }
      		
      		property.setRGBTransferFunction(0, color_function)
      		property.setScalarOpacity(0, composite_opacity)
      		property.setInterpolationTypeToFastLinear()  //采用线性插值
      	
      		return property
            
      	}
      	
      	const VIEW_ORIENTATIONS = {
	        default: {
	          axis: 1,
	          orientation: -1,
	          viewUp: [0, 0, 1],
	        },
	        y: {
	          axis: 0,
	          orientation: 1,
	          viewUp: [0, 0, 1],
	        },
	        x: {
	          axis: 1,
	          orientation: -1,
	          viewUp: [0, 0, 1],
	        },
	        z: {
	          axis: 2,
	          orientation: -1,
	          viewUp: [0, -1, 0],
	        },
        };
      	
      	function updateOrientation(mode){
	      	const originalPosition = camera.getPosition();
	        const originalViewUp = camera.getViewUp();
	        const originalFocalPoint = camera.getFocalPoint();
	       
      		const { axis, orientation, viewUp } = VIEW_ORIENTATIONS[mode];
      	    const position = camera.getFocalPoint();
      	    position[axis] += orientation;
      	    camera.setPosition(...position);
      	    camera.setViewUp(...viewUp);
      	    renderer.resetCamera();
      	  	render()
      	    
      	  	const destFocalPoint = camera.getFocalPoint();
    		const destPosition = camera.getPosition();
   		    const destViewUp = camera.getViewUp();
   		    
      	    // Reset to original to prevent initial render flash
      	    /* camera.setFocalPoint(...originalFocalPoint);
      	    camera.setPosition(...originalPosition);
      	    camera.setViewUp(...originalViewUp); */
      	    
      	  	//const animateSteps = 0
      	    //return moveCamera(destFocalPoint,destPosition,destViewUp,animateSteps);
      	    
      	}
      	
      	const palette = ["rgb(0, 0, 0) none repeat scroll 0% 0%", "rgb(255, 255, 255) none repeat scroll 0% 0%", "rgb(158, 1, 66) none repeat scroll 0% 0%", 
    		"rgb(213, 62, 79) none repeat scroll 0% 0%", "rgb(244, 109, 67) none repeat scroll 0% 0%", "rgb(253, 174, 97) none repeat scroll 0% 0%;",
    		"rgb(254, 224, 139) none repeat scroll 0% 0%", "rgb(255, 255, 191) none repeat scroll 0% 0%", "rgb(230, 245, 152) none repeat scroll 0% 0%", 
    		"rgb(171, 221, 164) none repeat scroll 0% 0%", "rgb(102, 194, 165) none repeat scroll 0% 0%", "rgb(50, 136, 189) none repeat scroll 0% 0%",
    		"rgb(94, 79, 162) none repeat scroll 0% 0%", "rgba(0, 0, 0, 0) linear-gradient(rgb(116, 120, 190), rgb(193, 195, 202)) repeat scroll 0% 0%",
    		"rgba(0, 0, 0, 0) linear-gradient(rgb(0, 0, 42), rgb(82, 87, 110)) repeat scroll 0% 0%", 
    		"rgba(0, 0, 0, 0) linear-gradient(rgb(51, 51, 51), rgb(153, 153, 153)) repeat scroll 0% 0%", "rgb(230, 184, 175)", "rgb(244, 204, 204)",
    		"rgb(252, 229, 205)", "rgb(255, 242, 204)", "rgb(217, 234, 211)", "rgb(208, 224, 227)"]
    	
        function generatePaletteColorsItem() {
    		let str = '';
    		palette.forEach(item => str += '<div style="background:' + item + '"></div>')
    		var picker = $("#color-picker")
    		picker.append(str);
    	}
        generatePaletteColorsItem()
      	
      	$("#color-picker div").click(function(){
      		var click_index = $("#color-picker div").index(this)
      		rootContainer.style.background = palette[click_index]
      	})
      	
      	
      	
      	//这个函数只负责生成相关的file数组
    	function getImageFileFromUrl(url, imageName, fileType, array) {
        	// imageName一定要带上后缀
        		var blob = null;
        		var xhr = new XMLHttpRequest(); 
        		xhr.open("GET", url+"?"+Math.random()); //防止请求从缓存中拿
        		xhr.setRequestHeader('Accept', fileType);
        		xhr.responseType = "blob";
        		xhr.onload = () => {
        		if (xhr.status == 200) {
        			blob = xhr.response;
        			let imgFile = new File([blob], imageName, {type: fileType});
        			array.push(imgFile);
        			if(array == files_array){
        				if(urls.length == array.length){
            				generateDCMVolume(volDCM);
            			}
        			}
        			if(array == maskJpgs_array){
        				if(array.length == urlMasks.length){
        					console.log(labelItkImage)
        					parseMaskJPG();
        				}
        			}
        		}};
        		xhr.send();
        }

    	function parseMaskJPG(){
        		console.log(maskJpgs_array);
        		//遍历maskJpgs_array
        		let flag = 0;
        		for(let p=0; p<maskJpgs_array.length; p++){
        			let numString = maskJpgs_array[p].name.substring(0,maskJpgs_array[p].name.lastIndexOf("."));
            		let num = parseInt(numString); //表示第几个切片的mask
                	itk.readImageFile(null, maskJpgs_array[p]).then(function(image){
                		flag++;
                		let maskData = image.image.data;
                		//then()不是异步吗？为什么每一个then（）方法中都能拿到此循环中的num  为什么？？    如何前面的for循环不行了  可以换成then(itk.readImageFile()),并设置一个计数的
                		//console.log("num::"+num+"---------"+p);
                		for(let i = 0, j = (labelItkImage.size[2] -1 - num) * labelItkImage.size[0] * labelItkImage.size[1]; i < labelItkImage.size[0] * labelItkImage.size[1] *3;i+=3,j++){
                			if(maskData[i] != 0 ||maskData[i+1] != 0 || maskData[i+2] != 0){
                				//console.log(maskData[i]+"--"+maskData[i+1]+"--"+maskData[i+2]+"____"+i)
                				labelItkImage.data[j] = Math.random() * 100;
                			}
                		}
                		if(flag == maskJpgs_array.length){
                    		generateMaskVolume(labelItkImage,volMask);
                		}
                		
                		})
        		}

        		//generateMaskVolume(labelItkImage,volMask);
    	}
    	
    	/* 
    		labelItkImage:标注信息的itk image
    		image_itk：原始dcm序列生成的itk image
    	*/
    	function initLabelItkImage(labelItkImage,imageitk){
    		labelItkImage.direction = imageitk.direction;
    		labelItkImage.imageType = imageitk.imageType;
    		labelItkImage.imageType.componentType =  "uint8_t";
    		labelItkImage.origin = imageitk.origin;
    		labelItkImage.size = imageitk.size;
    		labelItkImage.spacing = imageitk.spacing;
    		labelItkImage.data = new Uint8Array(imageitk.size[0] * imageitk.size[1] * imageitk.size[2]);
    	}
    	
    	/**
    		image_itk：标注信息所对应的itk的image对象
    		vol:准备生成的标注信息的vtk的volume对象
    	*/
    	function generateMaskVolume(image_itk, vol){
    		let itkTovtk = vtk.Common.DataModel.vtkITKHelper;
  			let image_vtk = itkTovtk.convertItkToVtkImage(image_itk);
  			
  			//绘制vtk
  			//var vol = vtk.Rendering.Core.vtkVolume.newInstance();
  			var volumeMapper = vtk.Rendering.Core.vtkVolumeMapper.newInstance();
  			volumeMapper.setInputData(image_vtk);
  			vol.setMapper(volumeMapper);
  			
  			const color_function = vtk.Rendering.Core.vtkColorTransferFunction.newInstance();
			color_function.addRGBPoint(1.00, 0, 1, 1)
			color_function.addRGBPoint(100.0, 0, 1, 1)
  			
  			const composite_opacity = vtk.Common.DataModel.vtkPiecewiseFunction.newInstance();
			composite_opacity.addPoint(10, 0.0)
			composite_opacity.addPoint(30, 0.3)
			composite_opacity.addPoint(70, 0.6)
			composite_opacity.addPoint(100, 0.9)
			
  			vol.getProperty().setRGBTransferFunction(0, color_function);
  			vol.getProperty().setScalarOpacity(0, composite_opacity);
  			vol.getProperty().setScalarOpacityUnitDistance(0, 3.0);
  			//vol.getProperty().setInterpolationTypeToFastLinear();
  			vol.getProperty().setAmbient(0.7);
  			vol.getProperty().setDiffuse(0.2);
  			vol.getProperty().setSpecular(0.1);

  			if(maskCount == 0){
  				renderer.addVolume(vol);
  				maskCount++;
  			}
  		    //renderer.addVolume(vol);
  			renderWindow.render(); 
  			
  			$("#label").prop("checked",true);
  			$("#label").parent().addClass("show");
  			$("#label").nextAll(".close").css("display","none");
  			$("#label").nextAll(".open").css("display","");
  			
    	}
    	
    	function generateDCMVolume(vol){
    		//if(urls.length == files_array.length){
                itk.readImageDICOMFileSeries(files_array).then(function( image ){
	      			image_itk = image.image;
	      			image_itk.origin = [0,0,0];
	      			console.log(image_itk);
	      			//初始化mask的itk image对象
	      			initLabelItkImage(labelItkImage, image_itk)
	      			
	      			let itkTovtk = vtk.Common.DataModel.vtkITKHelper;
	      			let image_vtk = itkTovtk.convertItkToVtkImage(image_itk);
	      			//绘制vtk
	      			//var vol = vtk.Rendering.Core.vtkVolume.newInstance();
	      			var volumeMapper = vtk.Rendering.Core.vtkVolumeMapper.newInstance();
	      			volumeMapper.setInputData(image_vtk);
	      			vol.setMapper(volumeMapper);
	      			
	      			const color_function = vtk.Rendering.Core.vtkColorTransferFunction.newInstance(); 
	      			color_function.addRGBPoint(-400.000, 0.9, 0.8, 0.50)
	                color_function.addRGBPoint(-90.00, 0.9, 0.8, 0.50)
	                color_function.addRGBPoint(0.00, 8.00, 0.00, 0.00)
	                color_function.addRGBPoint(190.0, 1.00, 1.00, 1.00)
	                color_function.addRGBPoint(500.0, 1.00, 1.00, 1.00)
	      			const composite_opacity = vtk.Common.DataModel.vtkPiecewiseFunction.newInstance();
	      			composite_opacity.addPoint(-15, 0.00)
	                composite_opacity.addPoint(75, 0.00)
	                composite_opacity.addPoint(100, 0.40)
	                composite_opacity.addPoint(500, 0.60)
	      			vol.getProperty().setRGBTransferFunction(0, color_function);
	      			vol.getProperty().setScalarOpacity(0, composite_opacity);
	      			vol.getProperty().setScalarOpacityUnitDistance(0, 3.0);
	      			vol.getProperty().setInterpolationTypeToFastLinear();
	      			vol.getProperty().setAmbient(0.2);
	      			vol.getProperty().setDiffuse(0.7);
	      			vol.getProperty().setSpecular(0.3);
	      			
	      			var values = renderer.getVolumes();
	      			
	      			for(var value of values ){
	      				value.setVisibility(false);
	      			}
	      			
	      			renderer.addVolume(vol); //向renderer加入骨骼
	      			renderWindow.render();
	      			

	      			$("#loadLabel").removeAttr("disabled");
	      			$("#bone").prop("checked",true);
	      			$("#bone").parent().addClass("show");
	      			$("#bone").nextAll(".close").css("display","none");
	      			$("#bone").nextAll(".open").css("display","");
	      			
	      			//标注添加
	      			//activeLoadMaskJpg(); //改了位置，因为需要等初始化mask的image对象之后
      			
      			
      		})
    	}
    	
    	function activeLoadMaskJpg(){
    		maskJpgs_array = [];
    		initLabelItkImage(labelItkImage, image_itk)
    		for(let i = 0; i < urlMasks.length; i++){
    			getImageFileFromUrl(urlMasks[i],urlMasks[i].substring(urlMasks[i].lastIndexOf('/')+1),"image/JPEG",maskJpgs_array);
    		}
    	}	
        
    	//异步请求  获取标注图片的路径
        function getMaskPathsByAXAJ(){
        	$.ajax({
        		type: "GET",
				url: pre_url + "/BB/maskPathServlet",
				dataType: 'json',	
				success:function(data){
					if(data.maskPath){
						urlMasks = data.maskPath;
						activeLoadMaskJpg();
					}else{
						console.log("get maskJpg path fail!!");
					}
				}
        	})
        }
    	
        
    	$("#loadLabel").click(function(){ 
    		getMaskPathsByAXAJ();
    	
    	})
          
        </script>
</body>
</html>