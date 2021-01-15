package time.web.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;


import com.itextpdf.text.DocumentException;
import com.mysql.cj.Session;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import time.domain.User;
import time.service.DiagnoseService;
import time.serviceImp.DiagnoseServiceImp;
import time.utils.FileUtils;
import time.utils.ReadTxtFile;
import time.utils.copyFileUtil;

public class DiagnoseAction extends ActionSupport implements ServletRequestAware,ServletResponseAware{
	
	private HttpServletRequest request;
	private HttpServletResponse response;
	
	private String path;
	// pdf模板
	private String templatePDF;
	// 获取标注图片
	private String image;
	// 算法输入路径
	private String jpgDir;
	// 算法输出路径
	private String resultDir;
	
	public String getJpgDir() {
		return jpgDir;
	}
	public void setJpgDir(String jpgDir) {
		this.jpgDir = jpgDir;
	}
	public String getResultDir() {
		return resultDir;
	}
	public void setResultDir(String resultDir) {
		this.resultDir = resultDir;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getTemplatePDF() {
		return templatePDF;
	}
	public void setTemplatePDF(String templatePDF) {
		this.templatePDF = templatePDF;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}	
	
	public String diagnose() throws DocumentException, IOException, InterruptedException {
		DiagnoseService diagnose = new DiagnoseServiceImp();
		HttpSession session = request.getSession();
		User user = (User) request.getSession().getAttribute("user");
//修改的
		String typeName =(String) request.getSession().getAttribute("typeName");
		// 判断后台算法是否调用成功
		String jpgDir = getJpgDir() + typeName + File.separator + user.getLoginname()+ "/" ;
		String resultDir = getResultDir() + typeName + File.separator + user.getLoginname()+ "/" ;
		
		if(typeName.equals("intestineDetection")) {
			// 诊断之前删除上次的诊断结果的文件夹以及诊断结果的压缩包
			//FileUtils.delete(resultDir);
			//FileUtils.delete(getResultDir() + typeName + "/" + user.getLoginname() + ".zip");
			//FileUtils.delete(getResultDir() + typeName + "/" + user.getLoginname() + ".jpg");
			String result = diagnose.diagnose(typeName,jpgDir, resultDir);
			System.out.println("result   "+result);
			// 选出前三个概率最高的切片路径	
			if(result != null) {
				//说明算法执行结束  读取json文件
				String[] imagePath = diagnose.getImagePath(result);
				// 将两张切片合并成一张切片
				String pdfImage = diagnose.getpdfImage(imagePath,getResultDir() + typeName + "/",user.getLoginname());
				diagnose.producePDF(getTemplatePDF(), result, pdfImage, user);
				//将诊断结果压缩  供用户下载
				FileUtils.fileToZip(resultDir, getResultDir() + typeName + "/", user.getLoginname());
			}
			System.out.println("间质瘤辅助诊断");
			return SUCCESS;
		}else if(typeName.equals("intestineSegment")) {
			// 需要删除上次中的imageTr中的456文件夹，删除上次结果
			String imageTr = "D:\\lzl\\diagnose\\testSe\\process\\imageTs\\"+user.getLoginname();
			String se_result = "D:\\lzl\\diagnose\\testSe\\result\\"+user.getLoginname();
			FileUtils.delete(imageTr);
			FileUtils.delete(se_result);
			//在这里直接传入用户名，就不需要和其他两个算法一样传入路径
			String result = diagnose.diagnose(typeName, user.getLoginname(),  user.getLoginname());
			System.out.println("间质瘤辅助分割");
			return "success01";//跳转到间质瘤辅助分割的结果页面
		}else if(typeName.equals("facialDetection")) {
			//诊断之前删除上次的结果
			FileUtils.delete(resultDir);
			String result = diagnose.diagnose(typeName,jpgDir, resultDir);//返回的是结果目录
			//本地上演示使用(对应于服务器上运行算法生成的结果)
			copyFileUtil.copyFile("D:\\lzl\\diagnose\\result\\facialDetection\\a.txt", resultDir);
			
			String[] rs = ReadTxtFile.readTxt(result+"a.txt");
			String level = rs[0];
			//request.setAttribute("level", level);//没想到怎么传，就先用request了
			session.setAttribute("level", level);
			
			//System.out.println("???");
			System.out.println(request.getSession());
			System.out.println("面瘫辅助诊断等级:"+ level + "级");
			return "success02";//跳转到面瘫辅助诊断的结果页面
		}else if(typeName.equals("lymphomaDetection")) {
			// 诊断之前删除上次的诊断结果的文件夹以及诊断结果的压缩包
			//FileUtils.delete(resultDir);
			//FileUtils.delete(getResultDir() + typeName + "/" + user.getLoginname() + ".zip");
			//FileUtils.delete(getResultDir() + typeName + "/" + user.getLoginname() + ".jpg");
			String result = diagnose.diagnose(typeName,jpgDir, resultDir);
			System.out.println("result   "+result);
			if(result != null) {
				//将诊断结果压缩  供用户下载
				FileUtils.fileToZip(resultDir, getResultDir() + typeName + "/", user.getLoginname());
			}
			System.out.println("淋巴瘤辅助诊断");
			return "success03";
		}
		return SUCCESS;
		
	}
	
//修改结束
	public String getResult() {
		User user = (User) request.getSession().getAttribute("user");
		String typeName = (String) request.getSession().getAttribute("typeName");
		String pdfName = user.getLoginname() + "/" + user.getLoginname() + ".pdf";
		response.setContentType(ServletActionContext.getServletContext().getMimeType(pdfName));		
		response.setHeader("Content-Disposition", "attachment;filename="+ pdfName);
		DiagnoseService diagnose = new DiagnoseServiceImp();
		diagnose.getPDF(getPath()+typeName+"/" + pdfName,response);
		return null;
	}
	
	public String getResultzip() {
		User user = (User) request.getSession().getAttribute("user");
		String typeName = (String) request.getSession().getAttribute("typeName");
		String zipName = user.getLoginname() + ".zip";
		response.setContentType(ServletActionContext.getServletContext().getMimeType(zipName));		
		response.setHeader("Content-Disposition", "attachment;filename="+ zipName);
		DiagnoseService diagnose = new DiagnoseServiceImp();
		diagnose.getPDF(getPath()+typeName+"/" + zipName,response);
		return null;
	}
	
	public String getResultNii() {
		User user = (User) request.getSession().getAttribute("user");
		String typeName = (String) request.getSession().getAttribute("typeName");
		System.out.println("niiName::"+typeName);
		String zipName = "test_435a.nii.gz";
		response.setContentType(ServletActionContext.getServletContext().getMimeType(zipName));		
		response.setHeader("Content-Disposition", "attachment;filename="+ zipName);
		DiagnoseService diagnose = new DiagnoseServiceImp();
		
		diagnose.getPDF(getPath()+typeName+"/"+ user.getLoginname()+"/"+ zipName,response);
		return null;
	}
	
	public String scanDcm() throws ServletException, IOException {	
		User user = (User) request.getSession().getAttribute("user");
		String typeName = (String) request.getSession().getAttribute("typeName");
		String resultDir = "D:/lzl/diagnose/result/"+typeName+"/"+ user.getLoginname();
		
		if(typeName.equalsIgnoreCase("intestineSegment")) {
			resultDir = "D:/nii/nii2jpg/merge/jpgImage";
		}
		
		DiagnoseService diagnose = new DiagnoseServiceImp();
		diagnose.scanDcm(resultDir,request,response);
		return null;
	}
	public String pictureTransport() throws IOException {
		User user = (User) request.getSession().getAttribute("user");
		String typeName = (String) request.getSession().getAttribute("typeName");
		String pictureName = request.getParameter("name");
		
		System.out.println(pictureName + "in pcitureTransport()");
		
		
		FileInputStream fileInputStream = null;
		if(typeName.equalsIgnoreCase("intestineSegment")) {
			fileInputStream = new FileInputStream("D:/nii/nii2jpg/merge/jpgImage"+ "/" + pictureName);
		}else {
			fileInputStream = new FileInputStream("D:/lzl/diagnose/result/"+typeName+"/"+ user.getLoginname()+ "/" + pictureName);
		}
		
		int size = fileInputStream.available();
		byte[] data = new byte[size];
		fileInputStream.read(data);
		response.setContentType("image/*");
		OutputStream outputStream = response.getOutputStream();
		outputStream.write(data);
		outputStream.flush();
		outputStream.close();
		fileInputStream.close();
		return null;
	}
	
	@Override
	public void setServletResponse(HttpServletResponse response) {
		// TODO Auto-generated method stub
		this.response = response;
	}
	@Override
	public void setServletRequest(HttpServletRequest request) {
		// TODO Auto-generated method stub
		this.request = request;
	}
}
