<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="java.util.List"%> 
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@ page import="java.io.File"%>
<%@page import="time.domain.User"%>
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
<link type="text/css" rel="stylesheet" href="../DWV/ext/jquery-mobile/jquery.mobile-1.4.5.min.css" />
<script src="../VTK/src/js/jquery.js" type="text/javascript"></script>
<script src="../VTK/src/js/ax.js" type="text/javascript"></script>
<script src="../VTK/src/js/colorpicker.js" type="text/javascript"></script>
<link rel="stylesheet" href="../VTK/src/plugins/rangeSlider/css/ion.rangeSlider.min.css"/>
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script> -->
<script src="../VTK/src/plugins/rangeSlider/js/ion.rangeSlider.min.js"></script> 
<script src="../VTK/src/plugins/qtip2/jquery.qtip.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<style>
body{
    background-color: #252525;
    border-color: #454545;
    color:#fff;
}
.ax-panel-body{
	padding:5px 10px 5px 10px;
	font-size:12px;
}
.ax-panel-header{
	font-size:14px;
}
.ax-item {
	font-size:14px;
	line-height:24px
}
.ax-item .ax-iconfont {
    font-size: 14px;
}
.showOrgan{
	position:relative;
}
.showOrgan input{
	width: 10px;
    height: 10px;
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
.showOrgan .ax-iconfont {
    font-size: 17px;
}
.ax-form-input {
    width: 160px;
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
    padding: 0px 14px 2px 0;
    box-sizing: border-box;
}
.text-left{
	text-align:left;
	color:rgba(0,0,0,.6)
}
.ui-header .ui-title{
	padding:0;
}
.ax-break-line{
	background-color: rgb(55, 55, 55);
}
.container .ax-border {
    border-color:#282424;
}
.container .ax-panel{
	background-color:#252525;
}
.text-left {
    color: #fff;
}
.ax-menu-tab .ax-item::after{
	width: 100px;
}

</style>
</head>
<body>
<%!File file = null; //声明全局%> 
<%
 	String organListC[] = {"骨骼", "分割"};
 	String organListE[] = {"bone", "seg"};
 %>
<div class="ui-page-theme-b" style=""><!-- 头部  -->
	<div id="pageHeader" class="ui-header ui-bar-inherit" role="banner" style="">
		<h1 class="ui-title" role="heading" aria-level="1">
		大智慧医疗在线标注系统 <span class="dwv-version">-三维重建</span>
		</h1>
		<%-- <a href="javascript:" class="ui-btn ui-btn-left ui-shadow" 
			onclick="window.location.href='http://localhost:8080/BB/DWV/index.jsp?param0=<%=request.getParameter("param0")%>';"
			data-icon="carat-l" data-transition="slide"
			data-i18n="basics.back">返回</a>  --%>
	
		<a href="#help_page"
			data-icon="carat-r" class="ui-btn ui-btn-right" data-transition="slide"
			data-i18n="basics.help">帮助</a>
	</div>
</div>
<div class = "container" style="height:95%">
	<div class = "ax-flex-row" style="height:100%"> 
		<div class = "ax-scroll" id="scroll01" style="padding:0;width:310px;height:100%;overflow-y: scroll;outline: currentcolor none medium;"> <!-- 布局中自由的部分 -->
			<div class="ax-tab">
			    <div class="ax-grid">
			        <ul class="ax-grid-inner ax-tab-nav ax-menu-tab">
			            <li class="ax-grid-block ax-col-8 ax-item">器官</li>
			            <li class="ax-grid-block ax-col-8 ax-item">设置</li>
			            <div class="ax-clear"></div>
			        </ul>
			    </div>
			    <ul class="ax-tab-content">
			        <li>
			        	<div class="ax-accordion ax-border ax-radius">
						 <% for (int i = 0; i < organListC.length; i++){ %>
							<div class="ax-item">
				                <div class="ax-panel-header ax-row">
				                	<i class="ax-adorn ax-panel-close ax-iconfont ax-icon-right"></i>
				                	<div class="ax-col"><b class="ax-title"><%=organListC[i] %></b></div>
				                	<a href="javascript:;" class="ax-operate showOrgan show">
				                		<input id="<%=organListE[i] %>" name="" value="" type="checkbox" checked>
					                	<i class="ax-iconfont ax-icon-eye-off-fill close" style="display: none;"></i>
					                	<i class="ax-iconfont ax-icon-eye-fill open"></i>
				                	</a>
				                </div>
				                <div class="ax-panel-body">
				                    <div class="ax-padding">
			                    		<div class="ax-panel ax-border ax-radius">
								    	<div class="ax-panel-header"><i class="ax-iconfont ax-icon-bulb-fill"></i> 阴影/边缘</div>
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
				                <div class="ax-break-line" style=""></div>
				                <div class="ax-panel-body colorPanel">
				                    <div class="ax-padding">
			                    		<div class="ax-panel ax-border ax-radius">
								    	<div class="ax-panel-header"><i class="ax-iconfont ax-icon-theme-fill"></i> 颜色控制</div>
									    <div class="ax-panel-body">
									    	<div class="ax-form-group">
							                     <div class="ax-flex-row" id="color-controller-<%=organListE[i] %>">
							                         
							                         
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
			        </li>
			        <li>
				        <div class="ax-panel ax-border ax-radius">
					    	<div class="ax-panel-header" >背景颜色</div>
						    <div class="ax-panel-body"><!-- 颜色选择器  -->
								<div id="color-picker"></div>
						    </div>
						</div>
			        </li>
			    </ul>
			</div>
			
			
			<div class="ax-break"></div>
			
			
			
		</div>
		
		<div class= "ax-flex-block" style="height:100%;background:rgba(0, 0, 0, 0) linear-gradient(rgb(51, 51, 51), rgb(153, 153, 153)) repeat scroll 0% 0%;position:relative;"> <!-- 布局中撑满的部分 -->
			<div id="vr-showPanel" class="" style="height:100%;"> 
				<div class="floatToolbar layout column">
					<button class="ax-btn" type="button" id="tool01" onClick="updateOrientation('x')">
						<span><i class="ax-iconfont ax-icon-bigger"></i></span>
					</button>
					<button class="ax-btn" type="button" onClick="">
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
	//$("#scroll01").axScroll();
</script>
 
 <%
 User user =(User)session.getAttribute("user");
 System.out.println(user.getLoginname());
	//String niiName= request.getParameter("niiName");
//System.out.println(niiName);
String niiPath="http://localhost:8090//vtk//240a.nii.gz";
String niiSegPath="http://localhost:8090//vtk//test_test.nii.gz";
 %>
 
<!-- <script type="text/javascript" src="../ITK/node_modules/itk/umd/itk.js"></script> -->

        <script type="text/javascript">
        var currentUrl = document.location.href;
    	var pathname = window.location.pathname;
    	var pre_url = currentUrl.split(pathname)[0];
        var maskCount = 0;
        
        
        //url_liver = 'http://localhost:8090//vtk//liver-seg.nii.gz';
        //url_bowel = 'http://localhost:8090//vtk//bowel-seg.nii.gz';
        //url_stomach = 'http://localhost:8090//vtk//stomach-seg.nii.gz';
        //url_pancreas = 'http://localhost:8090//vtk//pancreas-seg.nii.gz';
        url_bone = '<%=niiPath%>' + "?random=" + Math.random();
        url_seg = '<%=niiSegPath%>'+ "?random=" +Math.random();
        
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
       	
       	function getSeg() {
       	 	return axios.get(url_seg, { responseType: 'arraybuffer' }).then(function(response) {
              return itk.readArrayBuffer(null, response.data, 'data.nii.gz')
          	})
       	}
       	
       	//console.log(vtk)
       	const rootContainer = document.querySelector('#vr-showPanel');
		rootContainer.style.width =$(window).width()-420;
		//rootContainer.style.margin = '0 10px 0 0';
   		var screenRenderer = vtk.Rendering.Misc.vtkRenderWindowWithControlBar.newInstance({
   		  controlSize: 50,
   		});

        screenRenderer.setContainer(rootContainer);
        
        screenRenderer.getControlContainer().style.background = '#1d1d1d';
        screenRenderer.getControlContainer().style.display = 'flex';
        screenRenderer.getControlContainer().style.alignItems = 'stretch';
        screenRenderer.getControlContainer().style.justifyContent = 'stretch';
        screenRenderer.getControlContainer().innerHTML = `
            <div style= "color:white;width:100%;line-height:50px;text-align:center">控制台(待开发)</div>
        `;
        screenRenderer.setControlPosition("bottom");
         
        var renderWindow = screenRenderer.getRenderWindow();
        var renderer = screenRenderer.getRenderer();
        renderer.setBackground(0,0,0,0)
        screenRenderer.resize();
        var camera = vtk.Rendering.Core.vtkCamera.newInstance();
        const vtkITKHelper = vtk.Common.DataModel.vtkITKHelper

  	    const globalDataRange = [0, 255] //colorwidget所用
  	  	var resImageData = []
        var volumes = new Map();
        
       	axios.all([getBone(), getSeg()]).then(axios.spread(function (bone, seg) {
       	    // 请求现在都执行完成
       	    Swal.close() 
		 	Swal.fire({
		        icon: 'success',
		        toast:true,
		        //toast:true,
		        title: '已获取数据，开始渲染',
		        timer:3000,
		        timerProgressBar: true,
		        showConfirmButton:false
   			}); 
        	
       	    var res = [bone, seg]
       	    
       	    for(let organ of res) {  
       	    	organ.webWorker.terminate()
       	    	resImageData.push(generateImageData(organ.image))
       	    }
       	    var origin_image = vtkITKHelper.convertItkToVtkImage(res[0].image)
   		    var spacing = origin_image.getSpacing() 
   		
       	 	boneVR = volumeRendering(resImageData[0], getVolumeProperty('bone', resImageData[0]), spacing)
       	    segVR = volumeRendering(resImageData[1], getVolumeProperty('seg', resImageData[1]), spacing)
       	    
       	    
       	    volumes.set("bone",boneVR)
       	    volumes.set("seg",segVR)
       	    
       	    
            var values = volumes.values()
            for(var value of values){
      			renderer.addVolume(value) //先都加入 0 1 
      		}
            
            
            $(".showOrgan").click(function(){
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
			 renderWindow.render();
			
			//sampleDistance滑动条变化
			$d1.on("change", function() {
				var id = $(this).attr("id").split("_")[2]
				var organ =  $(this).attr("id").split("_")[0]
				var imageData = resImageData[id]
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
			
	       	
			//edgeGradient滑动条变化
			 $d2.on("change", function () {
				 var id = $(this).attr("id").split("_")[2]
				 var organ =  $(this).attr("id").split("_")[0]
				 var edgeGradient = $(this).data("from")
				 var volume = volumes.get(organ)
				 var imageData = resImageData[id]
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
        
        function generateImageData(image){
        	var imageData = vtkITKHelper.convertItkToVtkImage(image)
        	return imageData
        }
        
       
       	function render() {
   
			var values = renderer.getVolumes()
            
			if($("#bone").is(":checked")){
  				values[0].setVisibility(true)
			}else{
				values[0].setVisibility(false)
			}
			if($("#seg").is(":checked")){
  				values[1].setVisibility(true)
			}else{
				values[1].setVisibility(false)
			}
			
			
            renderWindow.render();
       	}
       	
      	function volumeRendering(imageData, property, spacing) {
      		var vol = vtk.Rendering.Core.vtkVolume.newInstance()
            var volumeMapper = vtk.Rendering.Core.vtkVolumeMapper.newInstance()  //A volume mapper that performs ray casting on the GPU using fragment programs.
            
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
      	
      	/* 创建color控制器 */
      	function createColorWidget(organ){
	        const vtkColorMaps = vtk.Rendering.Core.vtkColorTransferFunction.vtkColorMaps
	        const element = "#color-controller-" + organ
	        const colorContainer = document.querySelector(element);
	     	// Create Widget container
	        const widgetContainer = document.createElement('div');
	        widgetContainer.style.background = 'rgba(255, 255, 255, 0.3)';
	        colorContainer.appendChild(widgetContainer);
	        
	        let presetIndex = 1;
	        const globalDataRange = [0, 255];
	        const lookupTable = vtk.Rendering.Core.vtkColorTransferFunction.newInstance();
	        
	        const widget = vtk.Interaction.Widgets.vtkPiecewiseGaussianWidget.newInstance({
	        	  numberOfBins: 256,
	        	  size: [270, 150],
	        });
	       	widget.updateStyle({
	       	  backgroundColor: 'rgba(255, 255, 255, 0.6)',
	       	  histogramColor: 'rgba(100, 100, 100, 0.5)',
	       	  strokeColor: 'rgb(0, 0, 0)',
	       	  activeColor: 'rgb(255, 255, 255)',
	       	  handleColor: 'rgb(50, 150, 50)',
	       	  buttonDisableFillColor: 'rgba(255, 255, 255, 0.5)',
	       	  buttonDisableStrokeColor: 'rgba(0, 0, 0, 0.5)',
	       	  buttonStrokeColor: 'rgba(0, 0, 0, 1)',
	       	  buttonFillColor: 'rgba(255, 255, 255, 1)',
	       	  strokeWidth: 2,
	       	  activeStrokeWidth: 3,
	       	  buttonStrokeWidth: 1.5,
	       	  handleWidth: 3,
	       	  iconSize: 20, // Can be 0 if you want to remove buttons (dblClick for (+) / rightClick for (-))
	       	  padding: 10,
	       	});
	       	
	       	if(organ == 'seg'){
	       		widget.addGaussian(0.425, 0.5, 0.2, 0.3, 0.2);
		        widget.addGaussian(0.75, 1, 0.5, 0, 0);
	       	}else{
		        widget.addGaussian(0.75, 0.5, 0.15, 0, 0);
	       	}
	        
	
	        widget.setContainer(widgetContainer);
	      
	       	return widget
      	}
      	
      	
      	function getVolumeProperty(organ, imageData) {
      		var property = vtk.Rendering.Core.vtkVolumeProperty.newInstance()
      		var color_function = vtk.Rendering.Core.vtkColorTransferFunction.newInstance()
            var composite_opacity = vtk.Common.DataModel.vtkPiecewiseFunction.newInstance()
            
            var widget = createColorWidget(organ)
            const dataArray = imageData.getPointData().getScalars();
   	        const dataRange = dataArray.getRange();
   	        /* const piecewiseFunction = vtk.Common.DataModel.vtkPiecewiseFunction.newInstance();
   	        const lookupTable = vtk.Rendering.Core.vtkColorTransferFunction.newInstance(); */
   	        globalDataRange[0] = dataRange[0];
   	        globalDataRange[1] = dataRange[1];
   	        widget.setDataArray(dataArray.getData());
   	        widget.applyOpacity(composite_opacity);
   	        widget.setColorTransferFunction(color_function);
   	        //changePreset(1, 1, color_function);
   	     	widget.bindMouseListeners();
	        widget.onAnimation((start) => {//这个是干啥的？？？？
	       	  if (start) {
	       	    renderWindow.getInteractor().requestAnimation(widget);
	       	  } else {
	       	    renderWindow.getInteractor().cancelAnimation(widget);
	       	  }
	        });
	
	       	widget.onOpacityChange(() => {
	       	  widget.applyOpacity(composite_opacity);
	       	  if (!renderWindow.getInteractor().isAnimating()) {
	       	    renderWindow.render();
	       	  }
	       	});
            
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
            }else if (organ == "seg"){
            	color_function.addRGBPoint(0.0, 1, 0, 0)
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
            }
            else{//bone
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
      	  	render();
      	    
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
    		"rgba(0, 0, 0, 0) linear-gradient(rgb(51, 51, 51), rgb(153, 153, 153)) repeat scroll 0% 0%"]
    	
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
      	
    	
    	Swal.fire({
	        icon: 'info',
	        //toast:true,
	        title: '获取数据中，请等待...',
	        backdrop:true,
	        showConfirmButton:false,
	        allowOutsideClick:false,
	        heightAuto:false,
	        willOpen:() => {
	        	rootContainer.style.width =$(window).width()-420;
	        	/* var header = document.getElementById('pageHeader');
	        	rootContainer.style.height = $(window).height() - header.offsetHeight; */
	        },
	        didOpen:() => {
	        	
	        }
   		});
    	
    	function changePreset(delta = 1,presetIndex = 1,lookupTable) {
    	  const vtkColorMaps = vtk.Rendering.Core.vtkColorTransferFunction.vtkColorMaps
   		  presetIndex = (presetIndex + delta + vtkColorMaps.rgbPresetNames.length) % vtkColorMaps.rgbPresetNames.length;
   		  lookupTable.applyColorMap(vtkColorMaps.getPresetByName(vtkColorMaps.rgbPresetNames[presetIndex]));
   		  lookupTable.setMappingRange(...globalDataRange);
   		  lookupTable.updateRange();
   		}
          
	</script>
</body>
</html>