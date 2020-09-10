package time.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class copyFileUtil {

	
	public static void copyFile(String srcPathStr, String desPathStr) {
        //1.获取源文件的名称
        String newFileName = srcPathStr.substring(srcPathStr.lastIndexOf("\\")+1); //目标文件地址  window   
		/*String newFileName = srcPathStr.substring(srcPathStr.lastIndexOf("/")+1); //目标文件地址  linux
*/        //System.out.println(newFileName);
        desPathStr = desPathStr + File.separator + newFileName; //目标文件地址
        //System.out.println(desPathStr);

        try{
            //2.创建输入输出流对象
            FileInputStream fis = new FileInputStream(srcPathStr);
            @SuppressWarnings("resource")
			FileOutputStream fos = new FileOutputStream(desPathStr);                

            //创建搬运工具
            byte datas[] = new byte[1024*8];
            //创建长度
            int len = 0;
            //循环读取数据
            while((len = fis.read(datas))!=-1){
                fos.write(datas,0,len);
            }
            //3.释放资源
            fos.close();
            fis.close();
        }catch (Exception e){
            e.printStackTrace();
        }
    }
	//将文件复制到指定目录  并返回文件所在的全路径
    public static String copyFileWithName(String srcPathStr, String desPathDirStr, String filename) {

        //在复制文件之前，需将desPathStr目录下的文件删除
        //dirdel(new File(desPathDirStr));
        String newFileName =filename;

        desPathDirStr = desPathDirStr + File.separator + newFileName; //目标文件地址
        System.out.println("目的路径："+desPathDirStr);

        try{
            //2.创建输入输出流对象
            FileInputStream fis = new FileInputStream(srcPathStr);
            @SuppressWarnings("resource")
            FileOutputStream fos = new FileOutputStream(desPathDirStr);

            //创建搬运工具
            byte datas[] = new byte[1024*8];
            //创建长度
            int len = 0;
            //循环读取数据
            while((len = fis.read(datas))!=-1){
                fos.write(datas,0,len);
            }
            //3.释放资源
            fos.close();
            fis.close();
        }catch (Exception e){
            e.printStackTrace();
        }
        return newFileName;
    }
  //输入一个目录，删除目录下的文件
    public static void dirdel(File dir){
        File[] files = dir.listFiles();
        for(File file :files){
            file.delete();
            System.out.println("已删除"+dir.getName()+"中的全部数据："+file.getAbsolutePath());
        }
    }
} 