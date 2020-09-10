<%@page import="time.domain.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>诊断结果</title>
<style type="text/css">
<!--
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
-->
</style>
</head>
<body>
<%	User user = (User) request.getSession().getAttribute("user");
	String level= (String)request.getSession().getAttribute("level");
	System.out.println("result_2中的"+level);%>
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
        <td width="1075"><span class="STYLE4">首页</span> <span class="STYLE4">&gt; 面瘫AI辅助诊断</span></td>
        <td width="204"><div align="right" class="STYLE4"><a href="#"></a>${sessionScope.user.loginname },欢迎您!</div>
        <div align="right" class="STYLE4"><a  href="javascript:parent.window.location.href='../main/main.jsp'"
					onclick=""
						target="_parent"
						style="color:green">返回首页</a></div></td>
        <td width="36"><div align="right"><img src="../images/user1.png" width="35" height="35" /></div></td>
      </tr>
    </table> </td>
    <td width="100" height="72">&nbsp;</td>
  </tr>
  <tr>
    <td width="100" height="100%">&nbsp;</td>
    <td width="80%" height="670" bgcolor="#F0F1F5">
    <table width="1000" height="314" border="0" align="center" cellpadding="0" cellspacing="0"style="border: solid 3px #3EAA42;">
      <tr>
        <td width="1000" height="100" bordercolor="#F0F0F0" bgcolor="#FFFFFF">
        <table width="1000" height="70" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr height="15" bgcolor="#F0F0F0">&nbsp;</tr>
        <tr>
           <td width="100" style="border-right:2px solid #3EAA42;">
           <div align="center" style="margin-bottom:30px;  "><img src="../images/zhenduan.png" width="80" height="96" /><div style="width: 20px; margin: 0 auto;line-height: 24px; font-size: 20px; color:#3EAA42;" >诊断结果</div></div>
           </td>
            <td width="500">

            <div align="center" class="STYLE5" >
	            <video width="500" height="500" controls="controls" autoplay="autoplay" muted="muted" loop="loop">
	  				<source src="/dia/jpgDir/facialDetection/<%=user.getLoginname() %>/test.mp4" type="video/mp4">
	                <!--  /dia是配的虚拟路径-->
	                <!--  <source src="movie.ogg" type="video/ogg">-->
	            </video> 
            </div>
	     
            </td>
          	<td width="350" >
           	<div align="" style="margin-bottom:30px;">面瘫级别:<span style="font-family:arial;color:red;font-size:20px;">${sessionScope.level }</span>级</div>
          		<div align=""><span style="font-family:arial;color:red;font-size:15px;">|诊断建议|</span>
          		<div align="">
          		 ${sessionScope.level ==0?"面部正常，各区面肌运动正常":
          			sessionScope.level==1?"Ⅰ级轻度功能异常，有轻度的面肌无力，面部对称，肌张力正常，额部正常，稍用力闭眼完全，口角轻度不对称"
          			:sessionScope.level==2?"Ⅱ级中度功能异常，明显的面肌无力和/或面部变形，面部对称，肌张力正常，额部无，闭眼不完全，口角用最大力后不对称"
          			:"Ⅲ级重度功能异常，仅有几乎不能察觉的面部运动，面部不对称，额部无，闭眼不完全，口角轻微运动"
          		}
          		</div>
         		 </div>
            </td>
            <td width="50" bgcolor="">&nbsp;</td>
            
           
  <!--          <tr height="33" bgcolor="#F0F0F0">&nbsp;</tr>
          <tr height="15" bgcolor="#F0F0F0">&nbsp;</tr>
          <tr height="33" bgcolor="#F0F0F0">&nbsp;</tr>  -->
           </tr>
            <tr height="33" bgcolor="#F0F0F0">&nbsp;</tr>
        </table>
        </td>
       </tr>
    </table></td>
    <td width="100" height="100%">&nbsp;</td>
  </tr>
</table>
</body>
</html>