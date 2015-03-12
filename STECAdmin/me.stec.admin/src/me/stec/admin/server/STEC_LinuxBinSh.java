package me.stec.admin.server;

import java.io.*;

public class STEC_LinuxBinSh {
	
	public static String executeCommand(String command) {
		int				returnCode	= 1;
		
		Process			process		= null;

		StringBuffer	sbOut		= null;

		BufferedReader	stdOut		= null;
		BufferedReader	stdErr		= null;
		
		try {
        	sbOut = new StringBuffer("");
        	
        	final String[] finalCommand = new String[3];
        	finalCommand[0] = "/bin/sh";
        	finalCommand[1] = "-c";
        	finalCommand[2] = command;
          
        	// Execute the command...
        	process = Runtime.getRuntime().exec(finalCommand); 
        	stdOut = new BufferedReader(new InputStreamReader(process.getInputStream()));
        	stdErr = new BufferedReader(new InputStreamReader(process.getErrorStream()));
        	returnCode = process.waitFor();
	        
        	// Read stdout [and? stderr]
        	String line;
			while (null != (line = stdOut.readLine()) ) 
				sbOut.append(line);
			if(0 != returnCode)
				while (null != (line = stdErr.readLine())) 
					sbOut.append(line);
        }
        catch (Exception ex) {
        	try {
        		StringWriter sw = new StringWriter();
        		ex.printStackTrace(new PrintWriter(sw));
        		sbOut.append("\n\n").append(sw.toString());
        	}
        	catch(Exception e2) {
        		try{sbOut.append("\n\nSome errors on reading an error");}catch (Exception _){}
        	}
        }
        return (null != sbOut) ? sbOut.toString().trim() : "sbOut is null";
	}
}
