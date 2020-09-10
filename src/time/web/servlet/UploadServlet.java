package time.web.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;

import time.domain.User;
import time.service.UploadService;
import time.serviceImp.UploadServiceImp;
import time.utils.copyFileUtil;

/**
 * Servlet implementation class UploadServlet
 */
@WebServlet("/UploadServlet")
public class UploadServlet extends HttpServlet {
	//private String unzipDir = "D:\\upload\\";
	private String unzipDir = "D:\\lzl\\diagnose\\upload\\";
	//private String dcmDir = "D:\\dcmDir\\";
	private String dcmDir = "D:\\lzl\\diagnose\\dcmDir\\";
	//private String inputDir = "D:\\jpgDir\\";
	private String inputDir = "D:\\lzl\\diagnose\\jpgDir\\";
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setContentType("text/html; charset=UTF-8");
		User user = (User) request.getSession().getAttribute("user");
		request.getSession().setAttribute("user", user);
//下面就是修改的
		String typeName = (String) request.getSession().getAttribute("typeName");
		System.out.println("typeName:"+typeName);
		if(typeName.equals("intestineDetection") || typeName.equals("lymphomaDetection")) {
			//间质瘤检测 数据上传 
			// 实现上传压缩包
			UploadService uploadService = new UploadServiceImp();
			String uploadName = uploadService.upload(request,response);		
			// 进行解压
			String unzipFile = uploadService.unzip(unzipDir + uploadName, unzipDir + uploadName.substring(0, uploadName.lastIndexOf(".")));		
			System.out.println("解压完成");
			// 对文件进行整理  将所有的dcm文件放到同一个目录下面
			uploadService.copy(unzipDir + unzipFile, dcmDir + unzipFile);
			
			//转换之前删除上次遗留的文件夹
			uploadService.delete(inputDir +typeName+File.separator + user.getLoginname());
			// 将dcm文件转换为jpg文件
			uploadService.dcm2jpg(dcmDir + unzipFile, inputDir + typeName+File.separator + user.getLoginname());
		}else if(typeName.equals("intestineSegment")) {
			//间质瘤分割数据上传 上传的也是压缩包(.nii.gz)
			UploadService uploadService = new UploadServiceImp();
			String uploadName = uploadService.upload(request,response);		
			String se_input ="D:\\lzl\\diagnose\\testSe\\input\\";
			File copyFile = new File(se_input + user.getLoginname());
			if(copyFile.exists()) {
				uploadService.delete(se_input + user.getLoginname());
			}
			if(!copyFile.exists()){
		    	copyFile.mkdirs();
		    }
			copyFileUtil.copyFileWithName(unzipDir + uploadName ,se_input + user.getLoginname(),"test.nii.gz");
			
			
		}else if(typeName.equals("facialDetection")) {
			//面瘫检测的数据上传 上传MP4
			//不需要解压之类的操作，直接将数据上传到待处理的目录,也可以放在和dcm一样放在zip中
			UploadService uploadService = new UploadServiceImp();
			String uploadName = uploadService.upload(request,response);	
			System.out.println("uploadName::"+uploadName);
			
			File copyFile = new File(inputDir +typeName+File.separator + user.getLoginname());
			if(copyFile.exists()) {
				uploadService.delete(inputDir +typeName+File.separator + user.getLoginname());
			}
			if(!copyFile.exists()){
		    	copyFile.mkdirs();
		    }
			copyFileUtil.copyFileWithName(unzipDir + uploadName ,inputDir +typeName+File.separator + user.getLoginname(),"test.mp4");
			
		}else {
			System.out.println("诊断类型不对");
		}
		
				
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
