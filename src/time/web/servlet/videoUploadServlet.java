package time.web.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

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

/**
 * Servlet implementation class videoUpload
 */
@WebServlet("/videoUploadServlet")

public class videoUploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String userDir = "D://lzl//diagnose//upload";
 
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("????");
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
			
				DiskFileItemFactory fac = new DiskFileItemFactory();
				ServletFileUpload upload = new ServletFileUpload(fac); 
				String uuid = UUID.randomUUID().toString().replaceAll("-", "");
				List<FileItem> fileList = null; 
				try {      
		            fileList = upload.parseRequest(request);      
		        } catch (FileUploadException ex) {      
		            ex.printStackTrace();  
		            System.out.println("deleteIf");
		                 
		        } 
				Iterator<FileItem> it = fileList.iterator(); 
				if(it.hasNext()) {
					FileItem item =  it.next(); 
					System.out.println(item.getName());

					if(!item.isFormField()) {
						BufferedInputStream in = new BufferedInputStream(item.getInputStream()); 
						BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(new File(userDir+"/"+ uuid + item.getName())));
						request.getSession().setAttribute("dcmDirWithUser", uuid + item.getName());
						Streams.copy(in, out, true);
						System.out.println("上传成功");
					}
					//return uuid + item.getName();
				}
	}

}
