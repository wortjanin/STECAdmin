/**
 * 
 */
package me.stec.admin.logic;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;

/**
 * @author chernoivanov
 *
 */
public final class Utils {

	  public static String getStackTrace(Throwable aThrowable) {
		  try{
			  final Writer result = new StringWriter();
			  final PrintWriter printWriter = new PrintWriter(result);
			  aThrowable.printStackTrace(printWriter);
			  return result.toString();
		  }catch(Exception e){
			  return "";
		  }
	  }
	  
      public static boolean IsNullOrEmpty(String s){
      	return (null == s || s.isEmpty());
      }

      public static String Format(String _s)
      {
          String res = "";
          String[] split = _s.trim().split("\\s+");//new char[] { ' ', '\t', '\n', '\r' });
          for (int i = 0; i < split.length; i++)
              if (IsNullOrEmpty(split[i])) continue;
              else res += split[i] + " ";
          return res.replaceAll(" +$", "");//(new char[] { ' ' });
      }

}
