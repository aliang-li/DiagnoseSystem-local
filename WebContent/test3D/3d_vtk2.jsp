<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@ page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<script src="../VTK/src/js/jquery.js" type="text/javascript"></script>
<script src="../VTK/src/js/ax.js" type="text/javascript"></script>
<link rel="stylesheet" href="../VTK/src/plugins/rangeSlider/css/ion.rangeSlider.min.css"/>
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script> -->
<script src="../VTK/src/plugins/rangeSlider/js/ion.rangeSlider.min.js"></script> 
<style>
	.ax-panel-body{
		padding:5px 5px 5px 14px;
	}
</style>
</head>
<body>

<%!File file = null;%>
	<%String path=(String)session.getAttribute("path"); //dcm文件的父目录
	  String maskPath = path + "_mask"; //后端存储标注图片的目录
	  
	  File maskFile = new File(maskPath);
	  String[] maskFiles = maskFile.list();
	  List<String> list=Arrays.asList(maskFiles);
	  List<String> arrayList= new  ArrayList<String>(list); //arrayList就是最后筛选出来的mask图片 路径的列表
	  for(int i = 0; i < arrayList.size(); i++){
		  String suffix = arrayList.get(i).substring(arrayList.get(i).lastIndexOf(".")+1);
		  if(!suffix.equals("jpg")  || arrayList.get(i).contains("mask")){
			  arrayList.remove(i);
			  i--;
		  }
	  }
	  String[] maskFiles2 = new String[arrayList.size()];  //maskFiles2 这个数组存mask.jpg路径的数组
	  arrayList.toArray(maskFiles2);
	  
	  
		file = new File(path);
   
    	String[] files = file.list();
    	
    	String path1;
        path1=path.substring(path.lastIndexOf('/')+1);
        String prePath =  path.substring(0, path.lastIndexOf('/'));
        String prePath1 = prePath.substring(0, prePath.lastIndexOf('/'));
        
        
        String lastPath = path.substring(prePath1.lastIndexOf('/')+1);
        
        for (int i = 0;i<files.length;i++){
            files[i]="\"http://localhost:8080/test/"+lastPath+"/"+files[i]+"\""; 
        }
        for(int i =0; i < maskFiles2.length;i++){
        	maskFiles2[i] = "\"http://localhost:8080/test/"+lastPath+"_mask"+"/"+maskFiles2[i]+"\""; 
        }
        
        String str="[";
        for (int i=0; i<files.length; i++){ 
     	   if(i!= files.length-1){
           		str= str+files[i]+",";
     	   }
     	   else {
     		   str= str+files[i]+"]";
     	   }
         }
        
        String strMask="[";
        for (int i=0; i<maskFiles2.length; i++){ 
     	   if(i!= maskFiles2.length-1){
     		  strMask= strMask+maskFiles2[i]+",";
     	   }
     	   else {
     		  strMask= strMask+maskFiles2[i]+"]";
     	   }
         }
        System.out.println(strMask);
         //System.out.println(str);
    %>
    

<div class = "">
	<div class = "ax-flex-row"> 
		<div class = "" style="padding:10px;"> <!-- 布局中自由的部分 -->
			<div class="ax-panel ax-border ax-radius">
			    <div class="ax-panel-header ax-row">
			        <div class="ax-col">选择器官</div>
			        <a class="ax-panel-close"></a>
			        <div class="ax-break-line"></div>
			    </div>
		    	<div class="ax-panel-body">
		    		<div class = "organ-checkbox">
		    			<label class="ax-checkbox"><input id="all" name="" value="" type="checkbox"><span>全部</span></label>
						<label class="ax-checkbox"><input id="bone" name="" value="" type="checkbox" disabled><span>骨骼</span></label>
						<label class="ax-checkbox"><input id="liver" name="" value="" type="checkbox"><span>肝</span></label>
						<label class="ax-checkbox"><input id="stomach" name="" value="" type="checkbox"><span>胃</span></label>
						<label class="ax-checkbox"><input id="pancreas" name="" value="" type="checkbox"><span>胰腺</span></label>
						<label class="ax-checkbox"><input id="bowel" name="" value="" type="checkbox"><span>肠道</span></label>
						<label class="ax-checkbox"><input id="label" name="" value="" type="checkbox" disabled><span>标注信息</span></label>
					</div>
		    	</div>
			</div>
			
			<div class="ax-break"></div>
			
			<div class="ax-panel ax-border ax-radius">
		    	<div class="ax-panel-header">颜色</div>
		    	<div class="ax-panel-header"><button id="loadLabel" disabled>加载标注信息</button></div>
		    	<div class="ax-break-line"></div>
			    <div class="ax-panel-body"><!-- 颜色选择器  -->
			    	
			    </div>
			</div>
			
		
			
			<div class="ax-break"></div>
			
			<div class="ax-panel ax-border ax-radius">
		    	<div class="ax-panel-header">阴影和边缘</div>
		    	<div class="ax-break-line"></div>
			    <div class="ax-panel-body">
			    	<div class="ax-form-group">
	                     <div class="ax-flex-row">
	                         <div class="ax-form-label" style="width:126px;">Sample Distance：</div>
	                         <div class="ax-form-con">
	                             <div class="ax-form-input"><input name="sample distance" placeholder="" id="slider01" value="0.5" type="text"></div>
	                         </div>
	                     </div>
	                 </div>
	                 <div class="ax-form-group">
	                     <div class="ax-flex-row">
	                         <div class="ax-form-label" style="width:126px;">Edge Gradient：</div>
	                         <div class="ax-form-con">
	                             <div class="ax-form-input"><input name="edge gradient" placeholder="" id="slider02" value="0.5" type="text"></div>
	                         </div>
	                     </div>
	                 </div>
			    </div>
			</div>
			
			<div class="ax-break"></div>
			
		</div>
		
		<div class= "ax-flex-block" style="margin-left:10px;background-color:#b3b3b3;background-image: url(src/images/loading-white.svg);background-position: center;background-repeat: no-repeat;"> <!-- 布局中撑满的部分 -->
			<div id="vr-showPanel" class="" > 
				
			</div>
		</div>
	</div>
	
</div>
<script type="text/javascript" src="./js/polyfill.js"></script>
<script type="text/javascript" src="./js/vtk.js"></script>
<script src="./js/itk.js"></script> 
<script src="./js/axios.min.js"></script>
<script type="text/javascript">
	$("#slider01, #slider02").ionRangeSlider({
		skin: "ax",
		min: 0,
		max: 1, 
	  	step: 0.1
	});
	$("#liver, #pancreas, #bowel, #stomach").attr("checked",false); 
</script>
 
<script type="text/javascript">
	var currentUrl = document.location.href;
	var pathname = window.location.pathname;
	var pre_url = currentUrl.split(pathname)[0];
</script>

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

		
		var volumes = new Map();
		const rootContainer = document.querySelector('#vr-showPanel');
		rootContainer.style.position = 'relative';
		rootContainer.style.width = '800px';
		rootContainer.style.height = '800px';
		
		rootContainer.style.margin = '10px';
		var screenRenderer = vtk.Rendering.Misc.vtkRenderWindowWithControlBar.newInstance({
		  controlSize: 25,
		});

     	screenRenderer.setContainer(rootContainer);
     	var renderWindow = screenRenderer.getRenderWindow();
     	var renderer = screenRenderer.getRenderer();
     
        
        //url = 'http://localhost:8080//vtk//t.dcm';
        url_liver = 'http://localhost:8080//vtk//liver-seg.nii.gz';
        url_bowel = 'http://localhost:8080//vtk//bowel-seg.nii.gz';
        url_stomach = 'http://localhost:8080//vtk//stomach-seg.nii.gz';
        url_pancreas = 'http://localhost:8080//vtk//pancreas-seg.nii.gz';
        url_bone = 'http://localhost:8080//vtk//bone.nii.gz';
        
        //防止刷新页面  dom原有的disabled属性丢失
        $("#loadLabel").prop("disabled", true);
        $("#label").prop("disabled", true);
        
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
		
       	//console.log(vtk)
       	
       	axios.all([getLiverSeg(), getBowelSeg(), getStomachSeg(), getPancreasSeg(), getBone()]).then(axios.spread(function (liver, bowel, stomach, pancreas, bone) {
       	    // 请求现在都执行完成
       	    
       	    var res = [liver, bowel, stomach, pancreas, bone]
       	    //var volumes = new Map();
       		
       	    for(let organ of res) {  
       	    	organ.webWorker.terminate()
       	    }
       	 	boneVR = volumeRendering(res[4].image, getVolumeProperty('bone'))
       	    liverVR = volumeRendering(res[0].image, getVolumeProperty('liver'))
       	    stomachVR = volumeRendering(res[2].image, getVolumeProperty('stomach'))
       	    pancreasVR = volumeRendering(res[3].image, getVolumeProperty('pancreas'))
       	    bowelVR = volumeRendering(res[1].image, getVolumeProperty('bowel'))
       	    
       	    //加载骨骼
       		//将boneVR换了   换成volDCM 并设为全局变量     lzl
       	 	for(let i = 0; i < urls.length; i++){
     			getImageFileFromUrl(urls[i],urls[i].substring(urls[i].lastIndexOf('/')+1),"dcm",files_array);
     		}
       	    
       	    //volumes.set("bone",boneVR) //bone骨骼这个用dcm序列生成  不由后端nii数据生成
       	    volumes.set("liver",liverVR)
       	    volumes.set("stomach",stomachVR)
       	    volumes.set("pancreas",pancreasVR)
       	    volumes.set("bowel",bowelVR)
       	    
       	    //窗口、渲染器啥的 变成了全局变量
       	    /* const rootContainer = document.querySelector('#vr-showPanel');
			rootContainer.style.position = 'relative';
			rootContainer.style.width = '800px';
			rootContainer.style.height = '800px';
			
			rootContainer.style.margin = '10px';
       		var screenRenderer = vtk.Rendering.Misc.vtkRenderWindowWithControlBar.newInstance({
       		  controlSize: 25,
       		});

            screenRenderer.setContainer(rootContainer);
            var renderWindow = screenRenderer.getRenderWindow();
            var renderer = screenRenderer.getRenderer(); */
            
            var values = volumes.values()
            
            for(var value of values){
            	console.log("hhh")
      			renderer.addVolume(value) //先都加入 0 1 2 3
      		}
            
            
            
            $(".ax-checkbox").click(function(){
            	debugger;
	       	    if($("#all").is(":checked")){
			    	$("#liver, #pancreas, #bowel, #stomach, #bone").attr("checked",true); 
					 
				}
       	     
				render(renderWindow, renderer)
			})
			renderer.resetCamera();
			//render(renderWindow, renderer)
       	    
       	 }));
       
       	function render(renderWindow, renderer) {
   			debugger;
           
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
       	
      	function volumeRendering(image, property) {
      		var vol = vtk.Rendering.Core.vtkVolume.newInstance()
            var volumeMapper = vtk.Rendering.Core.vtkVolumeMapper.newInstance()
            
      		var imageData = vtk.Common.DataModel.vtkITKHelper.convertItkToVtkImage(image)
   	    	volumeMapper.setInputData(imageData)
   	    	const sampleDistance = Math.sqrt(imageData.getSpacing().map((v) => v * v).reduce((a, b) => a + b, 0))
  			//volumeMapper.setSampleDistance(sampleDistance * 2 ** -1.5) //步长越小，采样点就越多，但是体绘制效果提高的同时计算量也会增加 
        	vol.setMapper(volumeMapper)
        	
        	const dataArray = imageData.getPointData().getScalars() || imageData.getPointData().getArrays()[0];
  			const dataRange = dataArray.getRange();
        	
        	////为了更好地渲染体积-世界距离标量不透明度为1.0
      		property.setScalarOpacityUnitDistance(0, vtk.Common.DataModel.vtkBoundingBox.getDiagonalLength(imageData.getBounds()) / Math.max(...imageData.getDimensions()))
      		
      		//-控制我们如何强调表面边界=> max应该在平均梯度幅度附近体积或平均值，再加上一个梯度大小的标准差（根据间距进行调整，这是世界坐标渐变，而不是像素渐变）
   			// =>最大hack：（dataRange [1]-dataRange [0]）* 0.05
   			property.setGradientOpacityMinimumValue(0, 0);
   			property.setGradientOpacityMaximumValue(0, (dataRange[1] - dataRange[0]) * 0.05);
		    // - Use shading based on gradient
		    //property.setShade(true);
		    property.setUseGradientOpacity(0, true); 
		    // - generic good default
		    //property.setGradientOpacityMinimumOpacity(0, 0.0);
		    //property.setGradientOpacityMaximumOpacity(0, 1.0);
		    property.setAmbient(0.2);
		    property.setDiffuse(0.7);
		    property.setSpecular(0.3);
		    //property.setSpecularPower(8.0);
   			
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
            }else if (organ == "bowel"){
            	color_function.addRGBPoint(-200.0, 1, 1, 1)
                color_function.addRGBPoint(20.0, 0.9, 0, 0)
                color_function.addRGBPoint(75.0, 0.8, 0.00, 0.00)
                color_function.addRGBPoint(500.0, 1, 1, 1)

                composite_opacity.addPoint(-200, 0.00)  
		        composite_opacity.addPoint(20, 1)
		        composite_opacity.addPoint(75, 1)
		        composite_opacity.addPoint(500, 1)
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
            }
      		
      		property.setRGBTransferFunction(0, color_function)
      		property.setScalarOpacity(0, composite_opacity)
      		property.setInterpolationTypeToFastLinear()  //采用线性插值
      	
      		return property
            
      	}
      	
      //这个函数只负责生成相关的file数组
    	function getImageFileFromUrl(url, imageName, fileType, array) {
        	// imageName一定要带上后缀
        		var blob = null;
        		var xhr = new XMLHttpRequest(); 
        		xhr.open("GET", url);
        		xhr.setRequestHeader('Accept', fileType);
        		xhr.responseType = "blob";
        		xhr.onload = () => {
        		if (xhr.status == 200) {
        			blob = xhr.response;
        			let imgFile = new File([blob], imageName, {type: fileType});
        			array.push(imgFile);
        			if(array == files_array){
        				if(urls.length == array.length){
        					debugger;
            				generateDCMVolume(volDCM);
            			}
        			}
        			if(array == maskJpgs_array){
        				if(array.length == urlMasks.length){
        					debugger;
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
                		debugger;
                		flag++;
                		let maskData = image.image.data;
                		//then()不是异步吗？为什么每一个then（）方法中都能拿到此循环中的num  为什么？？    如何前面的for循环不行了  可以换成then(itk.readImageFile()),并设置一个计数的
                		//console.log("num::"+num+"---------"+p);
                		for(let i = 0, j = (labelItkImage.size[2] -1 - num) * labelItkImage.size[0] * labelItkImage.size[1]; i < labelItkImage.size[0] * labelItkImage.size[1] *3;i+=3,j++){
                			if(maskData[i] != 0 ||maskData[i+1] != 0 || maskData[i+2] != 0){
                				//console.log(maskData[i]+"--"+maskData[i+1]+"--"+maskData[i+2]+"____"+i)
                				labelItkImage.data[j] =  Math.random() * 100;
                			}
                		}
                		debugger;
                		if(flag == maskJpgs_array.length){
                			debugger;
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
    			debugger;
    		let itkTovtk = vtk.Common.DataModel.vtkITKHelper;
  			let image_vtk = itkTovtk.convertItkToVtkImage(image_itk);
  			
  			//绘制vtk
  			//var vol = vtk.Rendering.Core.vtkVolume.newInstance();
  			var volumeMapper = vtk.Rendering.Core.vtkVolumeMapper.newInstance();
      			volumeMapper.setInputData(image_vtk);
      			volumeMapper.setSampleDistance(5);
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
      			renderWindow.render(); 
      			
  		  		$("#label").removeAttr("disabled");
  		  		$("#label").prop("checked",true);
    	}
    	
    	function generateDCMVolume(vol){
    		//if(urls.length == files_array.length){
    			debugger;
                itk.readImageDICOMFileSeries(files_array).then(function( image ){
      			image_itk = image.image;
      			image_itk.origin = [0,0,0]; //这个是需要删除的
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
      			composite_opacity.addPoint(120, 0.60)
      			vol.getProperty().setRGBTransferFunction(0, color_function);
      			vol.getProperty().setScalarOpacity(0, composite_opacity);
      			vol.getProperty().setScalarOpacityUnitDistance(0, 3.0);
      			vol.getProperty().setInterpolationTypeToFastLinear();
      			vol.getProperty().setAmbient(0.2);
      			vol.getProperty().setDiffuse(0.7);
      			vol.getProperty().setSpecular(0.3);
      			vol.getProperty().setShade(1);
      			
      			var values = renderer.getVolumes();
      			for(var value of values ){
      				value.setVisibility(false);
      			}
      			
      			renderer.addVolume(vol); //向renderer加入骨骼
      			renderWindow.render();
      			
      			$("#bone").prop("checked",true);
      			$("#bone").removeAttr("disabled");
      			$("#loadLabel").removeAttr("disabled");
      			//activeLoadMaskJpg();
      			
      		})
    	}
    	
    	function activeLoadMaskJpg(){
    		maskJpgs_array = [];
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