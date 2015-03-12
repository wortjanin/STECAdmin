--	rem -----------------------------------------------------------------------
--	rem Filename: oscmd.sql
--	rem Purpose:  Execute operating system commands from PL/SQL
--	rem Notes:    Specify full paths to commands, for example, 
--	rem           specify /usr/bin/ps instead of ps.
--	rem Date:     09-Apr-2005
--	rem Author:   Frank Naude, Oracle FAQ
--	rem -----------------------------------------------------------------------
--	
--	rem -----------------------------------------------------------------------
--	rem Grant Java Access to user SCOTT
--	rem -----------------------------------------------------------------------
--	
--	conn / as sysdba
--	
--	EXEC dbms_java.grant_permission('SCOTT', 'SYS:java.lang.RuntimePermission', 'writeFileDescriptor', '');
--	EXEC dbms_java.grant_permission('SCOTT', 'SYS:java.lang.RuntimePermission', 'readFileDescriptor', '');
--	EXEC dbms_java.grant_permission('SCOTT', 'SYS:java.io.FilePermission', '/bin/sh', 'execute');
--	-- Other read ,write or execute permission may be requried
--	
--	rem -----------------------------------------------------------------------
--	rem Create Java class to execute OS commands...
--	rem -----------------------------------------------------------------------
--	
--	conn scott/tiger

CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED "Host" AS
import java.io.*;
public class Host {
  public static void executeCommand(String command) {
    try {
      String[] finalCommand;
      if (System.getProperty("os.name").toLowerCase().indexOf("windows") != -1) {
        finalCommand = new String[4];
        finalCommand[0] = "C:\\winnt\\system32\\cmd.exe";
        finalCommand[1] = "/y";
        finalCommand[2] = "/c";
        finalCommand[3] = command;
      } else { // Linux or Unix System
        finalCommand = new String[3];
        finalCommand[0] = "/bin/sh";
        finalCommand[1] = "-c";
        finalCommand[2] = command;
      }
  
      // Execute the command...
      final Process pr = Runtime.getRuntime().exec(finalCommand);

      // Capture output from STDOUT...
      BufferedReader br_in = null;
      try {
        br_in = new BufferedReader(new InputStreamReader(pr.getInputStream()));
        String buff = null;
        while ((buff = br_in.readLine()) != null) {
          System.out.println("stdout: " + buff);
          try {Thread.sleep(100); } catch(Exception e) {}
        }
        br_in.close();
      } catch (IOException ioe) {
        System.out.println("Error printing process output.");
        ioe.printStackTrace();
      } finally {
        try {
          br_in.close();
        } catch (Exception ex) {}
      }
  
      // Capture output from STDERR...
      BufferedReader br_err = null;
      try {
        br_err = new BufferedReader(new InputStreamReader(pr.getErrorStream()));
        String buff = null;
        while ((buff = br_err.readLine()) != null) {
          System.out.println("stderr: " + buff);
          try {Thread.sleep(100); } catch(Exception e) {}
        }
        br_err.close();
      } catch (IOException ioe) {
        System.out.println("Error printing execution errors.");
        ioe.printStackTrace();
      } finally {
        try {
          br_err.close();
        } catch (Exception ex) {}
      }
    }
    catch (Exception ex) {
      System.out.println(ex.getLocalizedMessage());
    }
  }

};
/
--	show errors
--	
--	rem -----------------------------------------------------------------------
--	rem Publish the Java call to PL/SQL...
--	rem -----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE host (p_command IN VARCHAR2)
   AS LANGUAGE JAVA
   NAME 'Host.executeCommand (java.lang.String)';
   ;
/
--	show errors
--	
--	rem -----------------------------------------------------------------------
--	rem Let's test it...
--	rem -----------------------------------------------------------------------
--	
--	CALL DBMS_JAVA.SET_OUTPUT(1000000);
--	SET SERVEROUTPUT ON SIZE 1000000
--	exec host('/usr/bin/ls');

