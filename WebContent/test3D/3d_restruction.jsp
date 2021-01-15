<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@ page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Insert title here</title>
</head>
<body>
<script type="text/javascript" src="https://unpkg.com/@babel/polyfill@7.0.0/dist/polyfill.js"></script>
<script type="text/javascript" src="./js/vtk.js"></script>
<script src="./js/itk.js"></script> 
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script src="../jquery.js"></script>

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
    	

<script type="text/javascript">
			var files_array = new Array(); //用于存储file的数组  不需要排序
			var maskJpgs_array = new Array();
			var image_itk = null; //加载dcm序列后生成的itk的image类型
        	var labelItkImage = new itk.Image();  //在加载dcm序列后将labelItkImage初始化
        	
        	
        	var fullScreenRenderer = vtk.Rendering.Misc.vtkFullScreenRenderWindow.newInstance();
  			var renderWindow = fullScreenRenderer.getRenderWindow();
  			var renderer = fullScreenRenderer.getRenderer();
  			var volDCM = vtk.Rendering.Core.vtkVolume.newInstance();
  			var volMask = vtk.Rendering.Core.vtkVolume.newInstance();
  			
        	var urls = <%=str%>
			var urlMasks = <%=strMask%>
        	for(let i = 0; i < urls.length; i++){
        		getImageFileFromUrl(urls[i],urls[i].substring(urls[i].lastIndexOf('/')+1),"dcm",files_array);
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
      			
      			/* var actor = vtk.Rendering.Core.vtkActor.newInstance();
      			var mapper = vtk.Rendering.Core.vtkMapper.newInstance();
      			mapper.setInterpolateScalarsBeforeMapping(1);
      			actor.setMapper(mapper);
      			
      			actor.getProperty().setAmbient(0.2);
      			actor.getProperty().setDiffuse(0.1);
      			actor.getProperty().setSpecular(0.7);
      			actor.getProperty().setColor(1, 0, 0);
      			
      			//console.log(vtk.Filters.General)
      			var MC = vtk.Filters.General.vtkImageMarchingCubes.newInstance({ contourValue: 1 });
      			MC.setInputData(image_vtk)
      			
      		    var filter = vtk.Filters.General.vtkImageOutlineFilter.newInstance();
      			filter.setInputConnection(MC.getOutputPort())

      			mapper.setInputConnection(MC.getOutputPort()); */
      			//绘制vtk
      			//var vol = vtk.Rendering.Core.vtkVolume.newInstance();
      			var volumeMapper = vtk.Rendering.Core.vtkVolumeMapper.newInstance();
      			volumeMapper.setInputData(image_vtk);
      			volumeMapper.setSampleDistance(5);
      			vol.setMapper(volumeMapper);
      			
      			const color_function = vtk.Rendering.Core.vtkColorTransferFunction.newInstance();
				color_function.addRGBPoint(1.00, 1, 1, 0)
				color_function.addRGBPoint(100.0, 1, 1, 0)
      			
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
      			//vol.getProperty().setSpecularPower(0.9);
      			//vol.getProperty().setShade(1); 
      			//console.log(vol.getProperty());
      			
      			
      			renderer.addVolume(volDCM);
      			renderer.addVolume(vol);
      			
      		    //renderer.addActor(actor);
      			renderer.resetCamera();
      			renderWindow.render(); 
        	}
        	
        	function generateDCMVolume(vol){
        		//if(urls.length == files_array.length){
        			
                    itk.readImageDICOMFileSeries(files_array).then(function( image ){
          			image_itk = image.image;
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
          			vol.getProperty().setGradientOpacityMinimumValue(0, 2);
          			vol.getProperty().setGradientOpacityMinimumOpacity(0, 0.0);
          			vol.getProperty().setGradientOpacityMaximumValue(0, 20);
          			vol.getProperty().setGradientOpacityMaximumOpacity(0, 1.0);
          			vol.getProperty().setAmbient(0.2);
          			vol.getProperty().setDiffuse(0.7);
          			vol.getProperty().setSpecular(0.3);
          			vol.getProperty().setShade(1);
                 
          			
          			activeLoadMaskJpg();
          			
          		})
        	}
        	
        function activeLoadMaskJpg(){
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
					console.log(data);
				}
        	})
        }
        
        
        
        
        function render(){
        	renderer.addVolume(vol);
  			//renderer.addVolume(volMask);
  			renderer.resetCamera();
  			renderWindow.render();
        }
        	
   
          
        </script>
</body>
</html>