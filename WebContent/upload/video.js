/**
 * 
 */
$(function(){
	$("#close").click(function(){
		$("#play").attr("src","");
	});
	//mediaSource没用到
	var mediaSource = new MediaSource();
	mediaSource.addEventListener('sourceopen', handleSourceOpen, false);

	var mediaRecorder;
	var recordedBlobs;
	var sourceBuffer;

	var gumVideo = document.querySelector('video#gum');
	var playVideo = document.querySelector('video#play');

	var recordButton = document.querySelector('button#record');
	var uploadButton = document.querySelector('button#upload');
	uploadButton.disabled = true;
//	var openButton = document.querySelector('button#openCamera');
	recordButton.onclick = toggleRecording;
	uploadButton.onclick = upload;
//	openButton.onclick = toggleOpening;
	// window.isSecureContext could be used for Chrome
	/* var isSecureOrigin = location.protocol === 'https:' || location.hostname === 'localhost';
	if (!isSecureOrigin) {
	    alert('getUserMedia() must be run from a secure origin: HTTPS or localhost.' + '\n\nChanging protocol to HTTPS');
	    location.protocol = 'HTTPS';
	} */

	var constraints = {
	    audio: true,
	    video: {
	      width:480,//视频宽度
	      height:480,//视频高度
	      frameRate:60,//每秒60帧
	  }
	};

	function handleSuccess(stream) {
	    recordButton.disabled = false;
	    console.log('getUserMedia() got stream: ', stream);
	    window.stream = stream;
	    gumVideo.srcObject = stream;
	}

	function handleError(error) {
	    console.log('navigator.getUserMedia error: ', error);
	}

	/* navigator.mediaDevices.getUserMedia(constraints).
	    then(handleSuccess).catch(handleError); */

	function handleSourceOpen(event) {
	    console.log('MediaSource opened');
	    sourceBuffer = mediaSource.addSourceBuffer('video/webm; codecs="vp8"');
	    console.log('Source buffer: ', sourceBuffer);
	}


	function handleDataAvailable(event) {
	    if (event.data && event.data.size > 0) {
	        recordedBlobs.push(event.data);
	    }
	}

	function handleStop(event) {
	    console.log('Recorder stopped: ', event);
	}

	function toggleRecording() {
	    if (recordButton.textContent === '开始录制') {
	        startRecording();
	    } else {
	        stopRecording();
	        recordButton.textContent = '开始录制';
	        uploadButton.disabled = false;
	    }
	}

	function startRecording() {
		recordedBlobs = [];
		var options = {mimeType: 'video/webm;codecs=h264'};
		
		mediaRecorder = new MediaRecorder(window.stream);
		
		console.log('Created MediaRecorder', mediaRecorder, 'with options', options);
		recordButton.textContent = '结束录制';
		uploadButton.disabled = true;
		mediaRecorder.onstop = handleStop;
		mediaRecorder.ondataavailable = handleDataAvailable;
		mediaRecorder.start(10); // collect 10ms of data
		console.log('MediaRecorder started', mediaRecorder);
	}

	function stopRecording() {
	    mediaRecorder.stop();
	    //closeStream(window.stream);
	    console.log('Recorded Blobs: ', recordedBlobs);
	    var superBuffer = new Blob(recordedBlobs, {type: 'video/mp4'});
	    //recordedVideo.src = window.URL.createObjectURL(superBuffer);
	    playVideo.src = window.URL.createObjectURL(superBuffer);
	    playVideo.play();
	}

//	function toggleOpening(){
//		if (openButton.textContent === '开启摄像头') {
//			openStream();
//	    } else {
//	    	closeStream(window.stream);
//	        openButton.textContent = '开启摄像头';
//	        recordButton.disabled = true;
//	    }
//	}
	
	
	 $("#lzbtn").click(function(){//录制
	    //$("#lz").css("display","block");
		 openStream();
	 })
	 $("#close").click(function(){//关闭
	    //$("#lz").css("display","block");
		 closeStream(window.stream);
		 recordButton.disabled = true;
	 })
	
	function openStream(){
		navigator.mediaDevices.getUserMedia(constraints).
	    then(handleSuccess).catch(handleError);
		//navigator.mozGetUserMedia(constraints,handleSuccess,handleError);
		//openButton.textContent = '关闭摄像头';
		recordButton.disabled = false;
	}

	function closeStream(stream) {
	    if (typeof stream.stop === 'function') {
	        stream.stop();
	    }
	    else {
	        let trackList = [stream.getAudioTracks(), stream.getVideoTracks()];

	        for (let i = 0; i < trackList.length; i++) {
	            let tracks = trackList[i];
	            if (tracks && tracks.length > 0) {
	                for (let j = 0; j < tracks.length; j++) {
	                    let track = tracks[j];
	                    if (typeof track.stop === 'function') {
	                        track.stop();
	                    }
	                }
	            }
	        }
	    }
	    
	}

	function upload(){
	    //保存在本地，通过post请求
	    //还可以用append方法添加一些附加信息参数为(name,value)，如下面的代码：
	    
	    var blob = new Blob(recordedBlobs, {type: 'video/mp4'});
	    var file = new File([blob], 'msr-' + (new Date).toISOString().replace(/:|\./g, '-') + '.mp4', {
	        type: 'video/mp4'
	    });
	    var formData = new FormData();
	    formData.append('video', file);
	    //console.log(formData);

	    /* $.ajax({
	        type: "POST",
	        url: "${req.contextPath }/videoUpload",
	        data: formData,
	        processData:false,   //  告诉jquery不要处理发送的数据
	        contentType:false,    // 告诉jquery不要设置content-Type请求头
	        success:function(res){
	            console.log(res);
	        }
	    }); */
	    var pathName = window.document.location.pathname;
	    var curRequestPath = window.document.location.href;
	    var ipAndPort = curRequestPath.indexOf(pathName); 
	    var localhostPath = curRequestPath.substring(0,ipAndPort);
	    var projectName = pathName.substring(0,pathName.substr(1).indexOf('/')+1);
	    var req = new XMLHttpRequest();
	    req.onreadystatechange=function()
	     {
	      if (req.readyState==4 && req.status==200){
	    	  swal({
	              title:"上传成功",
	              text:"",
	              type:"success",
	   
	              showConfirmButton:true,
	              confirmButtonText:'进行诊断',
	              confirmButtonColor:"#dd6b55",
	              
	              showCancelButton:true,//是否显示取消按钮
	              cancelButtonText:'取 消',//按钮内容
	              cancelButtonColor:'#b9b9b9',
	   
	              closeOnConfirm:false,//点击返回上一步操作
	              //closeOnCancel:true
	          },function(){//正确按钮进行的操作点
	        	  closeStream(window.stream);
	        	  window.location.href='diagnose.action';
	              console.log("uploadsuccess!");
	          });
	      }
	     }
	    req.open("POST", localhostPath+projectName+"/UploadServlet");
	    console.log(localhostPath+projectName+"/UploadServlet");
	    req.send(formData);
	    //console.log(projectName);
	}
	
	//将面部表情的id存储到session中，为了防止以后用到
//	$(".face").click(function(){
//		//alert($(this).attr("id"));
//		var id = $(this).attr("id");
//		$.ajax({
//			   type: "get",
//			   url: "${req.contextPath }/faceToSession?id="+id,
//			   success: function(msg){
//			     //alert( "Data Saved: ");
//			   }
//			});
//	});
})