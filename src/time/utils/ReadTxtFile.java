package time.utils; 
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;

/**
* 
*/
public class ReadTxtFile {
  
/**
 * 
 * @param filePath:txt文本的路径
 * @return：返回一个string数组result，result[0]:几级面瘫；result[1]:0级面瘫的概率；result[1]:1级面瘫的概率；result[2]:2级面瘫的概率；result[3]:3级面瘫的概率；
 */
public static String[] readTxt(String filePath) {
  
  try {
    File file = new File(filePath);
    if(file.isFile() && file.exists()) {
      InputStreamReader isr = new InputStreamReader(new FileInputStream(file), "utf-8");
      BufferedReader br = new BufferedReader(isr);
      String[] result = new String[5];
      String lastLine=null;
      String lineTxt = null;
      while ((lineTxt = br.readLine()) != null) {
    	 if(lineTxt.charAt(0)=='(') {
    		 lastLine=lineTxt;
    	 }
    	 
      }
      br.close();
      System.out.println(lastLine);
      result[0]=lastLine.substring(1, 2);
      String[] str1 = lastLine.split(",");
     /* for(int i=0;i<str1.length;i++) {
    	  System.out.println(str1[i]);
      }*/
      result[1]=str1[1].substring(9, str1[1].length());
      result[2]=str1[2].substring(1, str1[2].length());
      result[3]=str1[3].substring(1, str1[3].length());
      result[4]=str1[4].substring(1, str1[4].length()-2);
      System.out.println(result[0]);
      return result;

    } else {	
      System.out.println("文件不存在!");
      return null;
    }
  } catch (Exception e) {
    System.out.println("文件读取错误!");
  }
return null;

}
  
  
  public static void main(String[] args) {
    
    String path ="D:\\a1.txt";
    File file = new File(path);
   
    readTxt(path);
  }
  
}
