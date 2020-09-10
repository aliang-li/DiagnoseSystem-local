/**
 * 面瘫上传js
 */
$(function(){
	var btn = $(".sclzbtn").find("button");
	btn.attr('disabled',true);
//	if(btn.prop("disabled")==true){
//    	btn.hover(function () {
//        	tips =layer.tips("<span style='color:#dd0606f0;'>请先选择动作哦!</span>",this,{tips:[1,'#fbfafa'],time:0,area: 'auto'});
//    	},function () {//不用再单独写鼠标离开事件了 sb
//    			layer.closeAll('tips');
//    	})
//    }
    $(".choose").click(function(){
    	var ch = $(this).find(".checkboxall label");
    	if(!ch.hasClass("chosen")){//进行选择
    		ch.find("span").text("已选");
    		ch.find("span").css("color","white");
    		ch.css("background","#087d0a");
    		ch.addClass("chosen");
    		var other=$(this).siblings().find(".checkboxall label");
    		other.removeClass("chosen");
    		other.find("span").text("选择");
    		other.find("span").css("color","#343733");
    		other.css("background","#f9f8f8");
    		var res = $(this).find(".videotip span").text(); 
    		$("#choose_res").text(res);
    		btn.attr('disabled',false);
//    		if(!$("#scbtn").prop("disabled")){
//    	    	$("#lzbtn").attr('disabled',true);
//    	    }
    		if($("#scbtn").text() == "取消上传"){
    	    	$("#lzbtn").attr('disabled',true);
    	    }
    	}else{//取消选择
    		ch.find("span").text("选择");
    	    ch.find("span").css("color","#343733");
    		ch.css("background","#f9f8f8");
    		ch.removeClass("chosen");
    		$("#choose_res").text("未选");
    		btn.attr('disabled',true);
    		if($("#sc").css("display") == "block"){
        		$("#lzbtn").attr('disabled',false);
        		$("#scbtn").attr('disabled',false);
        		$("#scbtn").text("点击进行上传");
        		$("#sc").css("display","none");
        	}
    		
    	}
      //alert("hhhhh");
    })
		
    //$("#scbtn").text("点击进行上传");
    $("#scbtn").click(function(){//直接上传
    	if($("#sc").css("display")){
    		$("#lzbtn").attr('disabled',true);
    		$(this).text("取消上传");
    	}
    	if($("#sc").css("display") == "block"){
    		$("#lzbtn").attr('disabled',false);
    		$(this).text("点击进行上传");
    	}
    	$("#sc").toggle();
    })
   
    if(!$("#scbtn").prop("disabled")){
    	$("#lzbtn").attr('disabled',true);
    }
})